#!/usr/bin/env python3
"""
DDynamics real-time master.

Owns the simulation loop for the man-in-the-loop vehicle model. Sits between the
input device program and the visualizer, both over UDP, so either can be swapped
without touching the others:

    FFBReceiver  --UDP 12344-->  THIS APP (FMU)  --UDP 12345..12349-->  Unity

Why the master integrates instead of the Modelica model simulating itself
(see notas-sesion-2026-08-18.md sections 5.11 and 5.12):

  * OpenModelica's CVODE stalls at t ~ 19 s if the model contains a periodic sample
    clock -- and any in-model UDP receive needs one. Here the sampling happens in
    this loop, outside the equation system, so there is nothing to trigger it.
  * OpenModelica's Co-Simulation FMUs die during stepping, so the FMU is Model
    Exchange and we drive the integrator ourselves (fmpy's CVode / SUNDIALS).
  * Frames.to_Q breaks OpenModelica's FMI code generator, so the FMU exports the
    rotation MATRIX and we convert to a quaternion here.

Threads
  input   blocking recvfrom, keeps only the newest datagram
  sim     the integration loop: set inputs -> step -> read outputs -> queue poses
  output  drains the pose queue and sends to the visualizer

Threads do not give CPU parallelism in CPython, but fmpy calls the FMU through
ctypes, which releases the GIL for the duration of the C call. The integration
therefore overlaps with the socket threads, and -- the main point -- blocking
socket reads can never stall the integrator.

Usage
    pip install fmpy
    python ddynamics_master.py                     # defaults below
    python ddynamics_master.py --step 0.1 --no-realtime --duration 30
"""

import argparse
import math
import queue
import socket
import struct
import sys
import threading
import time
from pathlib import Path

# ---------------------------------------------------------------- configuration

DEFAULT_FMU = Path(__file__).resolve().parent.parent / "CarME.fmu"

INPUT_PORT = 12344          # where the input program sends driver commands
VISUALIZER_HOST = "127.0.0.1"
# Body name -> visualizer port. Must match the listenPort of each Unity Test2.
VISUALIZER_PORTS = {
    "chassis": 12345,
    "FL": 12346,
    "FR": 12347,
    "RL": 12348,
    "RR": 12349,
}

# Wire formats. Both little-endian float32, matching FFBReceiver's UdpSender and
# the Unity Test2 receiver respectively -- neither program needs changing.
IN_STRUCT = struct.Struct("<4f")    # steer, throttle, brake, clutch
OUT_STRUCT = struct.Struct("<7f")   # x, y, z, qx, qy, qz, qw

# If no datagram arrives for this long, commands are zeroed. Without it a dead
# input program would leave the last throttle value applied forever.
INPUT_TIMEOUT = 0.5


# ------------------------------------------------------------------- utilities

class LatestInput:
    """Single-slot mailbox. Only the newest driver command matters."""

    def __init__(self):
        self._lock = threading.Lock()
        self._values = (0.0, 0.0, 0.0, 0.0)
        self._stamp = 0.0
        self.packets = 0

    def put(self, values):
        with self._lock:
            self._values = values
            self._stamp = time.perf_counter()
            self.packets += 1

    def get(self, timeout=INPUT_TIMEOUT):
        """Return (steer, throttle, brake, clutch), zeroed if the input is stale."""
        with self._lock:
            values, stamp = self._values, self._stamp
        if stamp == 0.0 or (time.perf_counter() - stamp) > timeout:
            return (0.0, 0.0, 0.0, 0.0), False
        return values, True


def matrix_to_quaternion(T, guess):
    """
    Convert a row-major 3x3 orientation matrix to a quaternion, reproducing
    Modelica.Mechanics.MultiBody.Frames.Quaternions.from_T so the packet is
    identical to what FrameToUDPOrientation used to send.

    Returns (qx, qy, qz, qw): vector part first, scalar last, which is the
    Modelica convention Q = [sin(angle/2)*axis; cos(angle/2)]. `guess` is the
    previous value, used only to pick a consistent sign (q and -q are the same
    rotation, but flipping between frames is ugly to look at).
    """
    t11, t12, t13, t21, t22, t23, t31, t32, t33 = T

    c1 = 1.0 + t11 - t22 - t33
    c2 = 1.0 - t11 + t22 - t33
    c3 = 1.0 - t11 - t22 + t33
    c4 = 1.0 + t11 + t22 + t33

    # 4 * 0.1**2, the same threshold Modelica uses to prefer the scalar branch.
    c4limit = 0.04

    if c4 > c4limit or (c4 > c1 and c4 > c2 and c4 > c3):
        p = math.sqrt(c4) / 2.0
        p4 = 4.0 * p
        q = ((t23 - t32) / p4, (t31 - t13) / p4, (t12 - t21) / p4, p)
    elif c1 > c2 and c1 > c3:
        p = math.sqrt(c1) / 2.0
        p4 = 4.0 * p
        q = (p, (t12 + t21) / p4, (t13 + t31) / p4, (t23 - t32) / p4)
    elif c2 > c3:
        p = math.sqrt(c2) / 2.0
        p4 = 4.0 * p
        q = ((t12 + t21) / p4, p, (t23 + t32) / p4, (t31 - t13) / p4)
    else:
        p = math.sqrt(c3) / 2.0
        p4 = 4.0 * p
        q = ((t13 + t31) / p4, (t23 + t32) / p4, p, (t12 - t21) / p4)

    if sum(a * b for a, b in zip(q, guess)) < 0.0:
        q = tuple(-a for a in q)
    return q


class _NoInput:
    """
    Stand-in for fmpy's Input object. The solver calls into this at intermediate
    times; we hold the driver commands constant across a communication interval
    (a zero-order hold), so there is nothing to apply and no input events.
    """

    def nextEvent(self, time_):
        return float("inf")

    def apply(self, time_, discrete=False, after_event=False):
        return None


# --------------------------------------------------------------------- threads

class InputReceiver(threading.Thread):
    """Receives driver commands and keeps only the newest."""

    daemon = True

    def __init__(self, port, mailbox, stop):
        super().__init__(name="input")
        self.mailbox, self.stop = mailbox, stop
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind(("", port))
        self.sock.settimeout(0.2)
        self.short = 0

    def run(self):
        while not self.stop.is_set():
            try:
                data, _ = self.sock.recvfrom(256)
            except socket.timeout:
                continue
            except OSError:
                break
            if len(data) >= IN_STRUCT.size:
                self.mailbox.put(IN_STRUCT.unpack_from(data, 0))
            else:
                self.short += 1
        self.sock.close()


class PoseSender(threading.Thread):
    """Sends one datagram per body to the visualizer."""

    daemon = True

    def __init__(self, host, ports, outbox, stop):
        super().__init__(name="output")
        self.outbox, self.stop = outbox, stop
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.targets = {name: (host, port) for name, port in ports.items()}
        self.sent = 0

    def run(self):
        while not self.stop.is_set():
            try:
                frame = self.outbox.get(timeout=0.2)
            except queue.Empty:
                continue
            if frame is None:
                break
            for name, pose in frame.items():
                target = self.targets.get(name)
                if target is not None:
                    self.sock.sendto(OUT_STRUCT.pack(*pose), target)
                    self.sent += 1
        self.sock.close()


# ------------------------------------------------------------------- simulator

class Simulator:
    """Owns the FMU and the integrator. Runs in the calling thread."""

    BODIES = ("chassis", "FL", "FR", "RL", "RR")

    def __init__(self, fmu_path, step, rtol):
        from fmpy import extract, read_model_description
        from fmpy.fmi2 import FMU2Model

        self.step_size = step
        self.description = read_model_description(str(fmu_path))
        if self.description.modelExchange is None:
            raise SystemExit(
                "%s is not a Model Exchange FMU. Re-export with fmuType=\"me\" "
                "(see export_fmu.mos)." % fmu_path
            )

        self.unzip_dir = extract(str(fmu_path))
        self.fmu = FMU2Model(
            guid=self.description.guid,
            unzipDirectory=self.unzip_dir,
            modelIdentifier=self.description.modelExchange.modelIdentifier,
            instanceName="ddynamics",
        )

        vrs = {v.name: v.valueReference for v in self.description.modelVariables}
        missing = [n for n in ("steer", "throttle", "brake") if n not in vrs]
        if missing:
            raise SystemExit("FMU is missing expected inputs: %s" % missing)

        self.vr_inputs = [vrs["steer"], vrs["throttle"], vrs["brake"]]
        # Per body: 3 position + 9 matrix references, read in one getReal call.
        self.vr_bodies = {}
        for body in self.BODIES:
            r = ["r_%s[%d]" % (body, i) for i in range(1, 4)]
            t = ["T_%s[%d]" % (body, i) for i in range(1, 10)]
            absent = [n for n in r + t if n not in vrs]
            if absent:
                raise SystemExit("FMU is missing expected outputs: %s" % absent[:4])
            self.vr_bodies[body] = [vrs[n] for n in r + t]

        self.quat_guess = {b: (0.0, 0.0, 0.0, 1.0) for b in self.BODIES}
        self.time = 0.0
        self.rtol = rtol
        self.steps = 0
        self.events = 0

    def initialize(self):
        """FMI 2.0 Model Exchange initialization, then build the integrator."""
        from fmpy.sundials import CVodeSolver

        fmu, d = self.fmu, self.description
        fmu.instantiate()
        fmu.setupExperiment(startTime=0.0)
        fmu.enterInitializationMode()
        fmu.exitInitializationMode()

        # Settle the initial discrete state before entering continuous time.
        needed, terminate = True, False
        while needed and not terminate:
            needed, terminate = fmu.newDiscreteStates()[:2]
        if terminate:
            raise SystemExit("FMU requested termination during initialization.")
        fmu.enterContinuousTimeMode()

        self.solver = CVodeSolver(
            nx=d.numberOfContinuousStates,
            nz=d.numberOfEventIndicators,
            get_x=fmu.getContinuousStates,
            set_x=fmu.setContinuousStates,
            get_dx=fmu.getDerivatives,
            get_z=fmu.getEventIndicators,
            get_nominals=fmu.getNominalsOfContinuousStates,
            set_time=fmu.setTime,
            input=_NoInput(),
            startTime=0.0,
            maxStep=self.step_size,
            relativeTolerance=self.rtol,
        )
        self.needs_completed_step = bool(
            getattr(d.modelExchange, "needsCompletedIntegratorStep", True)
        )

    def advance(self, commands):
        """Apply commands, integrate one communication step, return the poses."""
        steer, throttle, brake, _clutch = commands
        self.fmu.setReal(self.vr_inputs, [steer, throttle, brake])

        target = self.time + self.step_size
        state_event, _roots, self.time = self.solver.step(self.time, target)
        self.fmu.setTime(self.time)

        step_event = False
        if self.needs_completed_step:
            step_event, terminate = self.fmu.completedIntegratorStep()
            if terminate:
                raise RuntimeError("FMU requested termination at t=%.3f" % self.time)

        if state_event or step_event:
            self.events += 1
            self.fmu.enterEventMode()
            needed, terminate = True, False
            while needed and not terminate:
                needed, terminate = self.fmu.newDiscreteStates()[:2]
            if terminate:
                raise RuntimeError("FMU requested termination at t=%.3f" % self.time)
            self.fmu.enterContinuousTimeMode()
            self.solver.reset(self.time)

        self.steps += 1
        return self._read_poses()

    def _read_poses(self):
        frame = {}
        for body, refs in self.vr_bodies.items():
            values = self.fmu.getReal(refs)
            position = tuple(values[0:3])
            quat = matrix_to_quaternion(values[3:12], self.quat_guess[body])
            self.quat_guess[body] = quat
            frame[body] = position + quat
        return frame

    def close(self):
        try:
            self.fmu.terminate()
        except Exception:
            pass
        try:
            self.fmu.freeInstance()
        except Exception:
            pass


# ------------------------------------------------------------------------ main

def main(argv=None):
    ap = argparse.ArgumentParser(description="DDynamics real-time master")
    ap.add_argument("--fmu", type=Path, default=DEFAULT_FMU)
    ap.add_argument("--step", type=float, default=0.01,
                    help="communication step in seconds; also the input hold and "
                         "visualizer update period (default 0.01 = 100 Hz)")
    ap.add_argument("--rtol", type=float, default=1e-4, help="solver relative tolerance")
    ap.add_argument("--input-port", type=int, default=INPUT_PORT)
    ap.add_argument("--host", default=VISUALIZER_HOST)
    ap.add_argument("--duration", type=float, default=None,
                    help="stop after this much simulated time (default: run forever)")
    ap.add_argument("--no-realtime", action="store_true",
                    help="run as fast as possible instead of pacing to wall clock")
    args = ap.parse_args(argv)

    if not args.fmu.exists():
        raise SystemExit("FMU not found: %s\nRun: omc export_fmu.mos" % args.fmu)

    stop = threading.Event()
    mailbox = LatestInput()
    outbox = queue.Queue(maxsize=64)

    sim = Simulator(args.fmu, args.step, args.rtol)
    sim.initialize()

    receiver = InputReceiver(args.input_port, mailbox, stop)
    sender = PoseSender(args.host, VISUALIZER_PORTS, outbox, stop)
    receiver.start()
    sender.start()

    print("FMU        : %s" % args.fmu.name)
    print("states     : %d continuous, %d event indicators"
          % (sim.description.numberOfContinuousStates,
             sim.description.numberOfEventIndicators))
    print("step       : %.4f s (%.0f Hz)   realtime pacing: %s"
          % (args.step, 1.0 / args.step, "off" if args.no_realtime else "on"))
    print("input      : UDP :%d  (4x float32: steer, throttle, brake, clutch)"
          % args.input_port)
    print("visualizer : %s ports %s" % (args.host, sorted(VISUALIZER_PORTS.values())))
    print("Ctrl+C to stop.\n")

    wall_start = time.perf_counter()
    last_report = wall_start
    dropped = 0

    try:
        while not stop.is_set():
            if args.duration is not None and sim.time >= args.duration:
                break

            commands, fresh = mailbox.get()
            frame = sim.advance(commands)

            try:
                outbox.put_nowait(frame)
            except queue.Full:
                # The sender is behind; a stale pose is worthless, so drop it and
                # keep integrating rather than blocking the loop.
                dropped += 1

            if not args.no_realtime:
                slack = sim.time - (time.perf_counter() - wall_start)
                if slack > 0:
                    time.sleep(slack)

            now = time.perf_counter()
            if now - last_report >= 1.0:
                elapsed = now - wall_start
                print("t=%8.2fs  wall=%8.2fs  x%.2f realtime  steps=%-8d events=%-5d "
                      "pkts_in=%-7d pkts_out=%-8d dropped=%-5d input=%s"
                      % (sim.time, elapsed, (sim.time / elapsed) if elapsed else 0.0,
                         sim.steps, sim.events, mailbox.packets, sender.sent,
                         dropped, "live" if fresh else "STALE"))
                last_report = now
    except KeyboardInterrupt:
        print("\ninterrupted")
    except Exception as exc:
        print("\nsimulation error at t=%.3f s: %s" % (sim.time, exc))
        raise
    finally:
        stop.set()
        try:
            outbox.put_nowait(None)
        except queue.Full:
            pass
        sender.join(timeout=1.0)
        receiver.join(timeout=1.0)
        sim.close()
        elapsed = time.perf_counter() - wall_start
        print("\nsimulated %.2f s in %.2f s wall (%.2fx realtime), %d steps, %d events"
              % (sim.time, elapsed, (sim.time / elapsed) if elapsed else 0.0,
                 sim.steps, sim.events))

    return 0


if __name__ == "__main__":
    sys.exit(main())
