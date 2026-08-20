# DDynamics real-time master

Standalone Python application that owns the simulation loop for the
man-in-the-loop vehicle model. It sits between the input program and the
visualizer, both over UDP, so either side can be replaced independently:

```
FFBReceiver (C++)  --UDP 12344-->  ddynamics_master.py  --UDP 12345..12349-->  Unity
   wheel + pedals                    CarME.fmu (FMI ME)                         Test2.cs
```

Neither `FFBReceiver` nor `Test2.cs` needs any change: the master consumes the
packet format one already sends and emits the packet format the other already
expects.

## Why the master integrates

This is not the obvious architecture — normally the Modelica model would simulate
itself and do its own UDP. It cannot, for three measured reasons (full evidence in
`../notas-sesion-2026-08-18.md`, sections 5.11 and 5.12):

| Problem | Consequence | Resolution here |
|---|---|---|
| OpenModelica's CVODE stalls at t ≈ 19 s if the model contains a periodic sample clock — three `Sampler` blocks passing constants is enough | any in-model UDP receive needs a clock, so the closed loop could never run past ~19 s | sampling happens in this loop, outside the equation system; the model has no clock |
| OpenModelica's Co-Simulation FMUs initialise, then die during stepping | `fmuType="cs"` is unusable | export Model Exchange; the master drives the integrator (fmpy/SUNDIALS CVode) |
| `Frames.to_Q` breaks OpenModelica's FMI code generator (`generic_array.c: 2 != 1`) | orientation cannot be exported as a quaternion | FMU exports the 3×3 rotation matrix; the master converts to a quaternion |

DASSL in OMEdit also avoids the first problem, but runs 3–4× *slower* than real
time. This runs ~12× *faster* than real time at 100 Hz.

## Build the FMU

From `..` (the `DDynamics` directory):

```
omc export_fmu.mos
```

That produces `CarME.fmu` from `CarFMU.mo`. Note `buildModelFMU`, **not**
`translateModelFMU` — the latter only translates and silently produces no file.

## Run

```
pip install fmpy
python ddynamics_master.py
```

Options:

| Flag | Default | Notes |
|---|---|---|
| `--step` | `0.01` | communication step; also the input hold and visualizer update period |
| `--rtol` | `1e-4` | solver relative tolerance |
| `--input-port` | `12344` | where the input program sends |
| `--host` | `127.0.0.1` | visualizer host |
| `--duration` | none | stop after N seconds of simulated time |
| `--no-realtime` | off | run as fast as possible; useful for soak tests |

`--step 0.1` works but is coarse: 10 Hz makes the visualizer choppy and discards 9
of every 10 input packets from a 100 Hz sender. 0.01 matches `FFBReceiver`'s rate.

## Wire formats

Input, port 12344 — 4 × float32 little-endian, matching `FFBReceiver`'s
`UdpSender::SendFloats` and `ChannelId` order:

```
steer [-1..1]   throttle [0..1]   brake [0..1]   clutch [0..1]
```

Output, one datagram per body — 7 × float32 little-endian, matching `Test2.cs`:

```
x   y   z   qx   qy   qz   qw
```

Positions are Modelica world coordinates (right-handed, Y-up; the road surface is
at Y = 1.0). The quaternion is `Frames.to_Q(frame_a.R)` convention: vector part
first, scalar last. `Test2.cs` performs the right-handed → left-handed conversion.

| Body | Port |
|---|---|
| chassis | 12345 |
| FL | 12346 |
| FR | 12347 |
| RL | 12348 |
| RR | 12349 |

## Design notes

**Threads.** Three: input receive, simulation, pose send. They do not give CPU
parallelism in CPython, but fmpy calls the FMU through `ctypes`, which releases the
GIL during the C call, so integration overlaps with the socket threads. The main
benefit is that a blocking socket read can never stall the integrator.

**Newest-value-wins.** The input thread keeps only the most recent datagram; for a
real-time loop a stale driver command is worthless. Likewise, if the send queue
backs up, poses are dropped rather than blocking the loop — the `dropped` counter
reports this.

**Input watchdog.** If no datagram arrives for 0.5 s, commands are zeroed and the
status line shows `STALE`. Without it, a crashed input program would leave the last
throttle value applied indefinitely.

**Zero-order hold.** Driver commands are held constant across a communication step.
This is the same sampling that broke CVODE in-model, but here it happens between
solver calls rather than as a time event inside the equations.

## Measured

100 Hz step, `rtol = 1e-4`, full throttle with sine steer:

| Mode | Result |
|---|---|
| paced | 20.00 s simulated in 20.01 s wall (1.00×), 2000 steps, 0 dropped |
| unpaced | 120.00 s simulated in 10.15 s wall (**11.8× realtime**), 12 000 steps |

Model: 12 232 equations, 30 continuous states, 8 event indicators. Zero state
events occurred in these runs. Quaternion output verified unit-norm to 1e-6.

## Caveats

- Not yet validated against real `FFBReceiver` hardware or a live Unity scene —
  tested with stand-in sender and receiver processes.
- `matrix_to_quaternion` reproduces MSL's `Quaternions.from_T` including its branch
  selection. Norm is verified, but if the car appears mirrored or rotated in Unity,
  this function is the first place to look.
- Windows-only insofar as the FMU binary is; the Python is portable.
- Event handling is implemented but untested — no state events occurred in any run
  so far. If the suspension bump stops engage, that path executes for the first
  time.
