package DDynamics

  package Examples
    model CarExample
      inner parameter Real R_wheel = 0.25 "Tire radius (m) — propagated to tires and floor contact";
      Cars.Car car annotation(
        Placement(transformation(extent = {{-28, -28}, {28, 28}})));
      Modelica.Blocks.Sources.Constant speed(k = 1) annotation(
        Placement(transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Constant steer(k = 1)  annotation(
        Placement(transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Roads.Road road annotation(
        Placement(transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step brake_input(height = 1, startTime = 3)  annotation(
        Placement(transformation(origin = {-68, 58}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(speed.y, car.throttleInput) annotation(
        Line(points = {{-60, 0}, {-28, 0}}, color = {0, 1, 127}));
      connect(steer.y, car.steerInput) annotation(
        Line(points = {{52, 0}, {28, 0}}, color = {0, 0, 127}));
      connect(road.FL, car.frame_FL) annotation(
        Line(points = {{66, 70}, {66, 86}, {16, 86}, {16, 28}}, color = {95, 95, 95}));
      connect(road.RL, car.frame_RL) annotation(
        Line(points = {{54, 70}, {54, 80}, {-22, 80}, {-22, 28}}, color = {95, 95, 95}));
      connect(road.FR, car.frame_FR) annotation(
        Line(points = {{66, 50}, {80, 50}, {80, -50}, {16, -50}, {16, -28}}, color = {95, 95, 95}));
      connect(road.RR, car.frame_RR) annotation(
        Line(points = {{54, 50}, {54, 26}, {76, 26}, {76, -44}, {-22, -44}, {-22, -28}}, color = {95, 95, 95}));
      connect(brake_input.y, car.brakeInput) annotation(
        Line(points = {{-56, 58}, {0, 58}, {0, 28}}, color = {0, 0, 127}));
      annotation(
        Documentation(info = "<html>
<body>
<h4>CarExample</h4>
<p>Top-level simulation entry point. Instantiates a <code>Car</code> and a <code>Road</code>, drives them with constant throttle and steering signals. The example applies full throttle (throttle = 1) with a 0.2 steer command on a flat terrain at y = 1 m; the brake steps to 1 at t = 3 s.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Instance</th><th>Type</th><th>Value</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>R_wheel</code></td><td><code>inner parameter Real</code></td><td>0.25 m</td><td>Tire radius &mdash; propagated to all sub-models via <code>outer</code></td></tr>
<tr><td><code>car</code></td><td><code>Cars.Car</code></td><td>&mdash;</td><td>The vehicle</td></tr>
<tr><td><code>road</code></td><td><code>Roads.Road</code></td><td>&mdash;</td><td>The road environment (owns World and terrain)</td></tr>
<tr><td><code>speed</code></td><td><code>Modelica.Blocks.Sources.Constant</code></td><td>k = 1</td><td>Throttle command [0..1] &rarr; <code>car.throttleInput</code> (1 = full drive torque)</td></tr>
<tr><td><code>steer</code></td><td><code>Modelica.Blocks.Sources.Constant</code></td><td>k = 0.2</td><td>Steer command &rarr; <code>car.steerInput</code> (normalized [-1..1]; MockSteering maps it to rad)</td></tr>
</tbody>
</table>
<p><b>Connections:</b> speed.y &rarr; car.throttleInput &bull; steer.y &rarr; car.steerInput &bull; road.FL/FR/RL/RR &harr; car.frame_FL/FR/RL/RR</p>
</body>
</html>"));
    end CarExample;

    model CivicEKExample
      inner parameter Real R_wheel = 0.30 "Tire radius (m) — 185/65R14, propagated to tires and floor contact";
      Cars.CivicEKCar car annotation(
        Placement(transformation(extent = {{-28, -28}, {28, 28}})));
      Modelica.Blocks.Sources.Constant speed(k = 1) annotation(
        Placement(transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Constant steer(k = -1) annotation(
        Placement(transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Roads.Road road annotation(
        Placement(transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Step brake_input(height = 1, startTime = 5) annotation(
        Placement(transformation(origin = {-68, 58}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(speed.y, car.throttleInput) annotation(
        Line(points = {{-60, 0}, {-28, 0}}, color = {0, 0, 127}));
      connect(steer.y, car.steerInput) annotation(
        Line(points = {{52, 0}, {28, 0}}, color = {0, 0, 127}));
      connect(road.FL, car.frame_FL) annotation(
        Line(points = {{66, 70}, {66, 86}, {16, 86}, {16, 28}}, color = {95, 95, 95}));
      connect(road.RL, car.frame_RL) annotation(
        Line(points = {{54, 70}, {54, 80}, {-22, 80}, {-22, 28}}, color = {95, 95, 95}));
      connect(road.FR, car.frame_FR) annotation(
        Line(points = {{66, 50}, {80, 50}, {80, -50}, {16, -50}, {16, -28}}, color = {95, 95, 95}));
      connect(road.RR, car.frame_RR) annotation(
        Line(points = {{54, 50}, {54, 26}, {76, 26}, {76, -44}, {-22, -44}, {-22, -28}}, color = {95, 95, 95}));
      connect(brake_input.y, car.brakeInput) annotation(
        Line(points = {{-56, 58}, {0, 58}, {0, 28}}, color = {0, 0, 127}));
      annotation(
        Documentation(info = "<html>
<body>
<h4>CivicEKExample</h4>
<p>Top-level simulation for the Honda Civic EK hatchback. Front-wheel drive, 1130 kg, 185/65R14 tires (R = 0.30 m). Applies full throttle (throttle = 1) with a 0.1 steer command on a flat terrain. Brakes engage at t = 5 s.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Instance</th><th>Type</th><th>Value</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>R_wheel</code></td><td><code>inner parameter Real</code></td><td>0.30 m</td><td>Tire radius &mdash; 185/65R14</td></tr>
<tr><td><code>car</code></td><td><code>Cars.CivicEKCar</code></td><td>&mdash;</td><td>The Civic EK vehicle</td></tr>
<tr><td><code>road</code></td><td><code>Roads.Road</code></td><td>&mdash;</td><td>The road environment</td></tr>
<tr><td><code>speed</code></td><td><code>Modelica.Blocks.Sources.Constant</code></td><td>k = 1</td><td>Throttle command [0..1] &rarr; <code>car.throttleInput</code> (1 = full drive torque)</td></tr>
<tr><td><code>steer</code></td><td><code>Modelica.Blocks.Sources.Constant</code></td><td>k = 0.1</td><td>Steer command &rarr; <code>car.steerInput</code> (normalized [-1..1]; MockSteering maps it to rad)</td></tr>
</tbody>
</table>
</body>
</html>"));
    end CivicEKExample;

    model E36Example
      inner parameter Real R_wheel = 0.31 "Tire radius (m) — 195/65R15, propagated to tires and floor contact";
      Cars.E36Car car annotation(
        Placement(transformation(extent = {{-28, -28}, {28, 28}})));
      Modelica.Blocks.Sources.Constant speed(k = 1) annotation(
        Placement(transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Constant steer(k = 1) annotation(
        Placement(transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Roads.Road road annotation(
        Placement(transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Step brake_input(height = 1, startTime = 5) annotation(
        Placement(transformation(origin = {-68, 58}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(speed.y, car.throttleInput) annotation(
        Line(points = {{-60, 0}, {-28, 0}}, color = {0, 0, 127}));
      connect(steer.y, car.steerInput) annotation(
        Line(points = {{52, 0}, {28, 0}}, color = {0, 0, 127}));
      connect(road.FL, car.frame_FL) annotation(
        Line(points = {{66, 70}, {66, 86}, {16, 86}, {16, 28}}, color = {95, 95, 95}));
      connect(road.RL, car.frame_RL) annotation(
        Line(points = {{54, 70}, {54, 80}, {-22, 80}, {-22, 28}}, color = {95, 95, 95}));
      connect(road.FR, car.frame_FR) annotation(
        Line(points = {{66, 50}, {80, 50}, {80, -50}, {16, -50}, {16, -28}}, color = {95, 95, 95}));
      connect(road.RR, car.frame_RR) annotation(
        Line(points = {{54, 50}, {54, 26}, {76, 26}, {76, -44}, {-22, -44}, {-22, -28}}, color = {95, 95, 95}));
      connect(brake_input.y, car.brakeInput) annotation(
        Line(points = {{-56, 58}, {0, 58}, {0, 28}}, color = {0, 0, 127}));
      annotation(
        Documentation(info = "<html>
<body>
<h4>E36Example</h4>
<p>Top-level simulation for the BMW E36 318is. Rear-wheel drive, 1180 kg total, 195/65R15 tires (R = 0.31 m). Front MacPherson struts, rear multi-link Z-axle. Applies full throttle (throttle = 1) with a 0.1 steer command on a flat terrain. Brakes engage at t = 5 s.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Instance</th><th>Type</th><th>Value</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>R_wheel</code></td><td><code>inner parameter Real</code></td><td>0.31 m</td><td>Tire radius &mdash; 195/65R15</td></tr>
<tr><td><code>car</code></td><td><code>Cars.E36Car</code></td><td>&mdash;</td><td>The E36 vehicle</td></tr>
<tr><td><code>road</code></td><td><code>Roads.Road</code></td><td>&mdash;</td><td>The road environment</td></tr>
<tr><td><code>speed</code></td><td><code>Modelica.Blocks.Sources.Constant</code></td><td>k = 1</td><td>Throttle command [0..1] &rarr; <code>car.throttleInput</code> (1 = full drive torque)</td></tr>
<tr><td><code>steer</code></td><td><code>Modelica.Blocks.Sources.Constant</code></td><td>k = 0.1</td><td>Steer command &rarr; <code>car.steerInput</code> (normalized [-1..1]; MockSteering maps it to rad)</td></tr>
</tbody>
</table>
</body>
</html>"));
    end E36Example;

    model CarExampleUDP
      inner parameter Real R_wheel = 0.25 "Tire radius (m) — propagated to tires and floor contact";
      Cars.Car car annotation(
        Placement(transformation(extent = {{-28, -28}, {28, 28}})));
      Modelica.Blocks.Sources.Constant speed(k = 5) annotation(
        Placement(transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Sine steer(amplitude = 1, f = 0.2) annotation(
        Placement(transformation(origin = {62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Roads.Road road annotation(
        Placement(transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Sources.Constant brake_input(k = 0) annotation(
        Placement(transformation(origin = {-68, 58}, extent = {{-10, -10}, {10, 10}})));
      // One UDP streamer per rigid body. Each uses its own port so the Unity
      // receiver can bind one GameObject (chassis / wheel) per port.
      Interfaces.FrameToUDPOrientation udpChassis(port_send = 12345) annotation(
        Placement(transformation(origin = {-60, -54}, extent = {{-10, -10}, {10, 10}})));
      Interfaces.FrameToUDPOrientation udpFL(port_send = 12346) annotation(
        Placement(transformation(origin = {-18, -72}, extent = {{-10, -10}, {10, 10}})));
      Interfaces.FrameToUDPOrientation udpFR(port_send = 12347) annotation(
        Placement(transformation(origin = {24, -74}, extent = {{-10, -10}, {10, 10}})));
      Interfaces.FrameToUDPOrientation udpRL(port_send = 12348) annotation(
        Placement(transformation(origin = {60, -70}, extent = {{-10, -10}, {10, 10}})));
      Interfaces.FrameToUDPOrientation udpRR(port_send = 12349) annotation(
        Placement(transformation(origin = {100, -70}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(speed.y, car.throttleInput) annotation(
        Line(points = {{-60, 0}, {-28, 0}}, color = {0, 0, 127}));
      connect(steer.y, car.steerInput) annotation(
        Line(points = {{52, 0}, {28, 0}}, color = {0, 0, 127}));
      connect(road.FL, car.frame_FL) annotation(
        Line(points = {{66, 70}, {66, 86}, {16, 86}, {16, 28}}, color = {95, 95, 95}));
      connect(road.RL, car.frame_RL) annotation(
        Line(points = {{54, 70}, {54, 80}, {-22, 80}, {-22, 28}}, color = {95, 95, 95}));
      connect(road.FR, car.frame_FR) annotation(
        Line(points = {{66, 50}, {80, 50}, {80, -50}, {16, -50}, {16, -28}}, color = {95, 95, 95}));
      connect(road.RR, car.frame_RR) annotation(
        Line(points = {{54, 50}, {54, 26}, {76, 26}, {76, -44}, {-22, -44}, {-22, -28}}, color = {95, 95, 95}));
      connect(brake_input.y, car.brakeInput) annotation(
        Line(points = {{-56, 58}, {0, 58}, {0, 28}}, color = {0, 0, 127}));
// Tap chassis + each wheel frame for streaming. These are pure sensors
// (zero force/torque) so they do not alter the vehicle dynamics.
      connect(car.chassis_pos, udpChassis.frame_a) annotation(
        Line(points = {{0, -28}, {0, -54}, {-70, -54}}, color = {95, 95, 95}));
      connect(car.frame_FL, udpFL.frame_a) annotation(
        Line(points = {{16, 28}, {16, -72}, {-28, -72}}, color = {95, 95, 95}));
      connect(car.frame_FR, udpFR.frame_a) annotation(
        Line(points = {{16, -28}, {16, -50}, {14, -50}, {14, -74}}, color = {95, 95, 95}));
      connect(car.frame_RL, udpRL.frame_a) annotation(
        Line(points = {{-22, 28}, {60, 28}, {60, -60}}, color = {95, 95, 95}));
      connect(car.frame_RR, udpRR.frame_a) annotation(
        Line(points = {{-22, -28}, {100, -28}, {100, -60}}, color = {95, 95, 95}));
      annotation(
        Documentation(info = "<html>
<body>
<h4>CarExampleUDP</h4>
<p>Same vehicle as <code>CarExample</code>, but streams the pose (position + orientation) of the chassis and all four wheels to a Unity visualizer over UDP via <code>Interfaces.FrameToUDPOrientation</code>. A sinusoidal steer input makes the front wheels sweep so the steering can be verified visually in Unity.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Streamer</th><th>Frame</th><th>UDP port</th></tr></thead>
<tbody>
<tr><td><code>udpChassis</code></td><td><code>car.chassis_pos</code></td><td>12345</td></tr>
<tr><td><code>udpFL</code></td><td><code>car.frame_FL</code></td><td>12346</td></tr>
<tr><td><code>udpFR</code></td><td><code>car.frame_FR</code></td><td>12347</td></tr>
<tr><td><code>udpRL</code></td><td><code>car.frame_RL</code></td><td>12348</td></tr>
<tr><td><code>udpRR</code></td><td><code>car.frame_RR</code></td><td>12349</td></tr>
</tbody>
</table>
<p>The wheel frames sit on the spinning revolute output, so the transmitted orientation includes steer <b>and</b> spin. Attach the <code>Test2</code> script (<code>Assets/Scripts/Test2.cs</code>) to each Unity GameObject and set its <code>listenPort</code> to match.</p>
</body>
</html>"));
    end CarExampleUDP;

  end Examples;

  package Interfaces
    model FrameToReal
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      // Position is a real array
      Modelica.Blocks.Interfaces.RealOutput x_out annotation(
        Placement(transformation(origin = {107, 57}, extent = {{-19, -19}, {19, 19}}), iconTransformation(origin = {102, 38}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput y_out annotation(
        Placement(transformation(origin = {110, 0}, extent = {{-22, -22}, {22, 22}}), iconTransformation(origin = {98, -42}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput z_out annotation(
        Placement(transformation(origin = {111, -61}, extent = {{-21, -21}, {21, 21}}), iconTransformation(origin = {102, -84}, extent = {{-10, -10}, {10, 10}})));
    equation
      frame_a.r_0[1] = x_out;
      frame_a.r_0[2] = y_out;
      frame_a.r_0[3] = z_out;
      frame_a.f = {0, 0, 0};
      frame_a.t = {0, 0, 0};
      annotation(
        Documentation(info = "<html>
<body>
<h4>FrameToReal</h4>
<p>Reads the world-frame position of a multibody <code>Frame_a</code> and exposes it as three <code>RealOutput</code> signals. Sets zero force and torque (sensor only, no mechanical effect).</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Direction</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>frame_a</code></td><td>Frame_a</td><td>in</td><td>MultiBody frame to read position from</td></tr>
<tr><td><code>x_out</code></td><td>RealOutput</td><td>out</td><td>X position (m)</td></tr>
<tr><td><code>y_out</code></td><td>RealOutput</td><td>out</td><td>Y position (m)</td></tr>
<tr><td><code>z_out</code></td><td>RealOutput</td><td>out</td><td>Z position (m)</td></tr>
</tbody>
</table>
</body>
</html>"));
    end FrameToReal;

    model FrameToUDP
      //parameter Integer port = 12345;
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}})));
      FrameToReal frameToReal annotation(
        Placement(transformation(origin = {-44, 0}, extent = {{-26, -26}, {26, 26}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
        Placement(transformation(origin = {48, 60}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1) annotation(
        Placement(transformation(origin = {48, 12}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1) annotation(
        Placement(transformation(origin = {44, -22}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(port_send = 12345, sampleTime = 0.01) annotation(
        Placement(transformation(origin = {82, -62}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
        Placement(transformation(origin = {-72, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat11(nu = 1) annotation(
        Placement(transformation(origin = {46, -58}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(frame_a, frameToReal.frame_a) annotation(
        Line(points = {{-100, 0}, {-70, 0}}));
      connect(packager.pkgOut, addFloat.pkgIn) annotation(
        Line(points = {{48, 49.2}, {48, 21.2}}));
      connect(addFloat.pkgOut[1], addFloat1.pkgIn) annotation(
        Line(points = {{48, 1.2}, {48, -4.9}, {44, -4.9}, {44, -11}}));
      connect(frameToReal.x_out, addFloat.u[1]) annotation(
        Line(points = {{-18, 10}, {36, 10}, {36, 12}}, color = {0, 0, 127}));
      connect(frameToReal.y_out, addFloat1.u[1]) annotation(
        Line(points = {{-18, -10}, {-18, -8}, {32, -8}, {32, -22}}, color = {0, 0, 127}));
  connect(addFloat1.pkgOut[1], addFloat11.pkgIn) annotation(
        Line(points = {{44, -32}, {46, -32}, {46, -48}}));
  connect(addFloat11.pkgOut[1], uDPSend.pkgIn) annotation(
        Line(points = {{46, -68}, {46, -82}, {62, -82}, {62, -62}, {72, -62}}));
  connect(frameToReal.z_out, addFloat11.u[1]) annotation(
        Line(points = {{-18, -22}, {16, -22}, {16, -58}, {34, -58}}, color = {0, 0, 127}));
      annotation(
        Documentation(info = "<html>
<body>
<h4>FrameToUDP</h4>
<p>Sends the X, Y, and Z world-frame position of a <code>Frame_a</code> over UDP using <code>Modelica_DeviceDrivers</code>. Internally chains <code>FrameToReal &rarr; SerialPackager &rarr; AddFloat &times; 3 &rarr; UDPSend</code>.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>frame_a</code></td><td>Frame_a</td><td>Frame whose position is transmitted</td></tr>
</tbody>
</table>
<p><b>Packet format</b> &mdash; 12 bytes, sent to UDP port 12345 at 100 Hz (sample time 0.01 s):</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Bytes</th><th>Type</th><th>Value</th></tr></thead>
<tbody>
<tr><td>0&ndash;3</td><td>float (32-bit IEEE 754, little-endian)</td><td>X position (m)</td></tr>
<tr><td>4&ndash;7</td><td>float (32-bit IEEE 754, little-endian)</td><td>Y position (m)</td></tr>
<tr><td>8&ndash;11</td><td>float (32-bit IEEE 754, little-endian)</td><td>Z position (m)</td></tr>
</tbody>
</table>
<p><code>RealtimeSynchronize</code> locks simulation time to wall-clock time, so the 100 Hz sample rate corresponds to real seconds on the receiving end.</p>
</body>
</html>"));
    end FrameToUDP;

    model FrameToRealOrientation
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      // World-frame position (m)
      Modelica.Blocks.Interfaces.RealOutput x_out annotation(
        Placement(transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 80}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput y_out annotation(
        Placement(transformation(origin = {110, 55}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 53}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput z_out annotation(
        Placement(transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 26}, extent = {{-10, -10}, {10, 10}})));
      // Orientation of frame_a as a unit quaternion [x, y, z, w] (vector part first, scalar last),
      // in the Modelica convention Q = [sin(angle/2)*axis; cos(angle/2)].
      Modelica.Blocks.Interfaces.RealOutput q_out[4] annotation(
        Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, -40}, extent = {{-10, -10}, {10, 10}})));
    equation
      frame_a.r_0[1] = x_out;
      frame_a.r_0[2] = y_out;
      frame_a.r_0[3] = z_out;
// Quaternion of the orientation object R (world -> body coordinate transform).
      q_out = Modelica.Mechanics.MultiBody.Frames.to_Q(frame_a.R);
// Sensor only: no force, no torque.
      frame_a.f = zeros(3);
      frame_a.t = zeros(3);
      annotation(
        Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 127}), Text(extent = {{-90, 40}, {90, -40}}, textString = "R,q"), Text(textColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name")}),
        Documentation(info = "<html>
<body>
<h4>FrameToRealOrientation</h4>
<p>Reads both the world-frame <b>position</b> and <b>orientation</b> of a multibody <code>Frame_a</code> and exposes them as <code>RealOutput</code> signals. Extends the idea of <code>FrameToReal</code> (position only) with a 4-element unit quaternion taken directly from the frame's orientation object via <code>Frames.to_Q(frame_a.R)</code>. Sets zero force and torque (sensor only, no mechanical effect).</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Direction</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>frame_a</code></td><td>Frame_a</td><td>in</td><td>MultiBody frame to read</td></tr>
<tr><td><code>x_out</code>/<code>y_out</code>/<code>z_out</code></td><td>RealOutput</td><td>out</td><td>World position (m)</td></tr>
<tr><td><code>q_out[4]</code></td><td>RealOutput</td><td>out</td><td>Orientation quaternion [x, y, z, w] of <code>frame_a.R</code></td></tr>
</tbody>
</table>
<p><b>Note:</b> <code>q_out = Frames.to_Q(frame_a.R)</code> is, working through Modelica's <code>Frames.from_T</code>, the body&rarr;world rotation of the frame expressed as an active quaternion. The Unity receiver converts this right-handed rotation to Unity's left-handed frame with the same axis flip used for position (negating the x and y components of the vector part); see <code>FrameToUDPOrientation</code> and the Unity receiver.</p>
</body>
</html>"));
    end FrameToRealOrientation;

    model FrameToUDPOrientation
      parameter Integer port_send = 12345 "UDP destination port";
      parameter Modelica.Units.SI.Time sampleTime = 0.01 "Transmit period (s)";
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}})));
      FrameToRealOrientation frameToReal annotation(
        Placement(transformation(origin = {-44, 0}, extent = {{-26, -26}, {26, 26}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
        Placement(transformation(origin = {48, 60}, extent = {{-10, -10}, {10, 10}})));
      // One AddFloat per value, chained (mirrors the proven FrameToUDP structure).
      // NOTE: each AddFloat adds exactly one float (default n = 1). Do NOT set the
      // AddFloat "n" modifier — under OpenModelica 1.25.5 a modifier on n triggers an
      // instantiation internal error, so use the default and chain instead.
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1) annotation(
        Placement(transformation(origin = {48, 44}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1) annotation(
        Placement(transformation(origin = {48, 28}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat2(nu = 1) annotation(
        Placement(transformation(origin = {48, 12}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat3(nu = 1) annotation(
        Placement(transformation(origin = {48, -4}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat4(nu = 1) annotation(
        Placement(transformation(origin = {48, -20}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat5(nu = 1) annotation(
        Placement(transformation(origin = {48, -36}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat6(nu = 1) annotation(
        Placement(transformation(origin = {48, -52}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(port_send = port_send, sampleTime = sampleTime) annotation(
        Placement(transformation(origin = {48, -80}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
        Placement(transformation(origin = {-72, 82}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(frame_a, frameToReal.frame_a) annotation(
        Line(points = {{-100, 0}, {-70, 0}}));
      connect(packager.pkgOut, addFloat.pkgIn) annotation(
        Line(points = {{48, 49}, {48, 45}}));
      connect(addFloat.pkgOut[1], addFloat1.pkgIn) annotation(
        Line(points = {{48, 33}, {48, 29}}));
      connect(addFloat1.pkgOut[1], addFloat2.pkgIn) annotation(
        Line(points = {{48, 17}, {48, 13}}));
      connect(addFloat2.pkgOut[1], addFloat3.pkgIn) annotation(
        Line(points = {{48, 1}, {48, -3}}));
      connect(addFloat3.pkgOut[1], addFloat4.pkgIn) annotation(
        Line(points = {{48, -15}, {48, -19}}));
      connect(addFloat4.pkgOut[1], addFloat5.pkgIn) annotation(
        Line(points = {{48, -31}, {48, -35}}));
      connect(addFloat5.pkgOut[1], addFloat6.pkgIn) annotation(
        Line(points = {{48, -47}, {48, -51}}));
      connect(addFloat6.pkgOut[1], uDPSend.pkgIn) annotation(
        Line(points = {{48, -63}, {48, -70}}));
      connect(frameToReal.x_out, addFloat.u[1]) annotation(
        Line(points = {{-18, 8}, {36, 8}, {36, 44}}, color = {0, 0, 127}));
      connect(frameToReal.y_out, addFloat1.u[1]) annotation(
        Line(points = {{-18, 5}, {34, 5}, {34, 28}}, color = {0, 0, 127}));
      connect(frameToReal.z_out, addFloat2.u[1]) annotation(
        Line(points = {{-18, 3}, {32, 3}, {32, 12}}, color = {0, 0, 127}));
      connect(frameToReal.q_out[1], addFloat3.u[1]) annotation(
        Line(points = {{-18, -4}, {30, -4}}, color = {0, 0, 127}));
      connect(frameToReal.q_out[2], addFloat4.u[1]) annotation(
        Line(points = {{-18, -6}, {28, -6}, {28, -20}}, color = {0, 0, 127}));
      connect(frameToReal.q_out[3], addFloat5.u[1]) annotation(
        Line(points = {{-18, -8}, {26, -8}, {26, -36}}, color = {0, 0, 127}));
      connect(frameToReal.q_out[4], addFloat6.u[1]) annotation(
        Line(points = {{-18, -10}, {24, -10}, {24, -52}}, color = {0, 0, 127}));
      annotation(
        Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {95, 95, 95}), Text(extent = {{-80, 40}, {80, -40}}, textString = "UDP\npos+quat"), Text(textColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Text(extent = {{-90, -60}, {90, -90}}, textString = "port=%port_send")}),
        Documentation(info = "<html>
<body>
<h4>FrameToUDPOrientation</h4>
<p>Sends the world-frame <b>position and orientation</b> of a <code>Frame_a</code> over UDP using <code>Modelica_DeviceDrivers</code>. Internally chains <code>FrameToRealOrientation &rarr; Packager &rarr; 7 &times; AddFloat &rarr; UDPSend</code>. Unlike <code>FrameToUDP</code>, the destination <code>port_send</code> is a parameter, so several instances (chassis + each wheel) can stream to distinct ports simultaneously.</p>
<p><b>Packet format</b> &mdash; 28 bytes, 7 &times; float32 (little-endian), sent at <code>1/sampleTime</code> Hz:</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Bytes</th><th>Value</th></tr></thead>
<tbody>
<tr><td>0&ndash;3</td><td>X position (m)</td></tr>
<tr><td>4&ndash;7</td><td>Y position (m)</td></tr>
<tr><td>8&ndash;11</td><td>Z position (m)</td></tr>
<tr><td>12&ndash;15</td><td>quaternion x (vector part)</td></tr>
<tr><td>16&ndash;19</td><td>quaternion y (vector part)</td></tr>
<tr><td>20&ndash;23</td><td>quaternion z (vector part)</td></tr>
<tr><td>24&ndash;27</td><td>quaternion w (scalar part)</td></tr>
</tbody>
</table>
<p>All values are raw Modelica world-frame quantities (right-handed, Y-up in the <code>Cars</code>/<code>Roads</code> package). The Unity receiver performs the right-handed&rarr;left-handed conversion.</p>
</body>
</html>"));
    end FrameToUDPOrientation;

    model UDPInput
    parameter Integer udpPort = 12347;
    parameter Real sampleFreq = 0.1;
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive uDPReceive(sampleTime = sampleFreq, port_recv = udpPort)  annotation(
        Placement(transformation(origin = {-74, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetFloat getFloat(nu = 1)  annotation(
        Placement(transformation(origin = {-30, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetFloat getFloat1(nu = 1)  annotation(
        Placement(transformation(origin = {8, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetFloat getFloat2(nu = 1)  annotation(
        Placement(transformation(origin = {42, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetFloat getFloat3 annotation(
        Placement(transformation(origin = {74, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput steer annotation(
        Placement(transformation(origin = {-30, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {104, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
        Placement(transformation(origin = {-82, 78}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput throttle annotation(
        Placement(transformation(origin = {8, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {104, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput brake annotation(
        Placement(transformation(origin = {42, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {104, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput clutch annotation(
        Placement(transformation(origin = {74, 106}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {104, 20}, extent = {{-10, -10}, {10, 10}})));
    equation
  connect(uDPReceive.pkgOut, getFloat.pkgIn) annotation(
        Line(points = {{-63.2, -24}, {-39.2, -24}}));
  connect(getFloat.pkgOut[1], getFloat1.pkgIn) annotation(
        Line(points = {{-19.2, -24}, {-1.2, -24}}));
  connect(getFloat1.pkgOut[1], getFloat2.pkgIn) annotation(
        Line(points = {{18.8, -24}, {32.8, -24}}));
  connect(getFloat2.pkgOut[1], getFloat3.pkgIn) annotation(
        Line(points = {{52.8, -24}, {63.8, -24}}));
  connect(getFloat.y[1], steer) annotation(
        Line(points = {{-30, -12}, {-30, 106}}, color = {0, 0, 127}));
  connect(getFloat1.y[1], throttle) annotation(
        Line(points = {{8, -12}, {8, 106}}, color = {0, 0, 127}));
  connect(getFloat2.y[1], brake) annotation(
        Line(points = {{42, -12}, {42, 106}}, color = {0, 0, 127}));
  connect(getFloat3.y[1], clutch) annotation(
        Line(points = {{74, -12}, {74, 106}}, color = {0, 0, 127}));
    annotation(
        Icon(graphics = {Ellipse(origin = {65, 61}, extent = {{-17, 17}, {17, -17}}), Line(origin = {65, 53}, points = {{-17, 9}, {15, 9}, {17, 9}, {17, 9}, {17, 5}, {-17, 5}, {-17, 9}, {-17, 5}, {-1, 5}, {-1, -9}, {3, -9}, {3, 5}, {5, 5}}), Rectangle(origin = {66, 19}, lineColor = {111, 255, 1}, fillColor = {111, 255, 1}, fillPattern = FillPattern.Solid, extent = {{-6, 15}, {6, -15}}), Rectangle(origin = {66, -19}, lineColor = {255, 0, 4}, fillColor = {255, 0, 4}, fillPattern = FillPattern.Solid, extent = {{-6, 15}, {6, -15}}), Rectangle(origin = {66, -61}, lineColor = {3, 20, 255}, fillColor = {3, 20, 255}, fillPattern = FillPattern.Solid, extent = {{-6, 15}, {6, -15}}), Text(origin = {-17, -2}, extent = {{-69, 28}, {69, -28}}, textString = "UDP")}),
  Diagram(graphics));
end UDPInput;

  end Interfaces;

  package Roads

    model Road
      inner DDynamics.Roads.Terrains.TerrainMap terrain annotation(
        Placement(transformation(origin = {-58, 34}, extent = {{-10, -10}, {10, 10}})));
      DDynamics.Roads.Floors.Floor4Corners floor4Corners annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}})));
      DDynamics.Roads.Terrains.Components.TerrainVisualizer terrainViz annotation(
        Placement(transformation(origin = {-36, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      inner Modelica.Mechanics.MultiBody.World world annotation(
        Placement(transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a FL annotation(
        Placement(transformation(origin = {70, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {62, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a FR annotation(
        Placement(transformation(origin = {70, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {60, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a RL annotation(
        Placement(transformation(origin = {-70, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-60, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a RR annotation(
        Placement(transformation(origin = {-70, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-60, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
    equation
      connect(world.frame_b, terrainViz.frame_a) annotation(
        Line(points = {{10, -40}, {-3, -40}, {-3, -74}, {-26, -74}}, color = {95, 95, 95}));
      connect(RL, floor4Corners.wheelContactRL) annotation(
        Line(points = {{-70, 100}, {-70, 20}, {-6, 20}, {-6, 10}}));
      connect(floor4Corners.wheelContactFL, FL) annotation(
        Line(points = {{6, 10}, {6, 20}, {70, 20}, {70, 100}}, color = {95, 95, 95}));
      connect(floor4Corners.wheelContactRR, RR) annotation(
        Line(points = {{-6, -10}, {-6, -20}, {-70, -20}, {-70, -100}}, color = {95, 95, 95}));
      connect(floor4Corners.wheelContactFR, FR) annotation(
        Line(points = {{6, -10}, {6, -20}, {70, -20}, {70, -100}}, color = {95, 95, 95}));
      annotation(
        Icon(graphics = {Polygon(fillPattern = FillPattern.Solid, points = {{-80, 80}, {-80, -80}, {80, -80}, {80, -20}, {48, -12}, {80, 20}, {80, 80}, {4, 80}, {4, 80}, {-80, 80}}), Polygon(fillColor = {76, 157, 0}, fillPattern = FillPattern.Solid, points = {{-60, 60}, {-60, -60}, {60, -60}, {60, -40}, {12, -20}, {42, 20}, {60, 60}, {4, 60}, {0, 60}, {-60, 60}}), Rectangle(origin = {-69, 48}, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-69, 18}, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-69, -12}, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-69, -40}, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-69, -66}, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-43, -70}, rotation = -90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-17, -70}, rotation = -90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {9, -70}, rotation = -90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {35, -70}, rotation = -90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {61, -70}, rotation = -90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {71, -48}, rotation = 180, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {55, -26}, rotation = 90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {37, -12}, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {53, 12}, rotation = -90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {69, 38}, rotation = 180, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {69, 66}, rotation = 180, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {45, 70}, rotation = 90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {19, 70}, rotation = 90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-7, 70}, rotation = 90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-33, 70}, rotation = 90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}}), Rectangle(origin = {-59, 70}, rotation = 90, fillColor = {255, 221, 28}, fillPattern = FillPattern.Solid, extent = {{-3, 10}, {3, -10}})}),
        Diagram(graphics),
        Documentation(info = "<html>
<body>
<h4>Road</h4>
<p>Self-contained road environment. Owns the Modelica <code>World</code>, the terrain height map, and the four ground-contact floor models. Exposes four <code>Frame_a</code> connectors that attach to the vehicle&apos;s wheel support frames.</p>
<p><b>Inner objects</b> (accessible via <code>outer</code>):</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Name</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>terrain</code></td><td>DDynamics.Roads.Terrains.TerrainMap</td><td>Terrain height lookup</td></tr>
<tr><td><code>world</code></td><td>Modelica.Mechanics.MultiBody.World</td><td>Gravity and animation root</td></tr>
</tbody>
</table>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>FL</code></td><td>Frame_a</td><td>Front-left wheel contact point</td></tr>
<tr><td><code>FR</code></td><td>Frame_a</td><td>Front-right wheel contact point</td></tr>
<tr><td><code>RL</code></td><td>Frame_a</td><td>Rear-left wheel contact point</td></tr>
<tr><td><code>RR</code></td><td>Frame_a</td><td>Rear-right wheel contact point</td></tr>
</tbody>
</table>
</body>
</html>"));
    end Road;

    package Floors
      model Floor4Corners "Ground contact for all 4 car corners. Connect each tire.wheelSupport to the matching frame."
        import MultiBody = Modelica.Mechanics.MultiBody;
        parameter Real ground_c  = 1e5    "Floor stiffness (N/m)";
        parameter Real ground_d  = 5000   "Floor damping (N.s/m)";
        parameter Real ground_mu = 10000  "Longitudinal viscous friction coefficient (N.s/m)";
        parameter Real mu_lat    = 100000 "Lateral viscous friction coefficient (N.s/m)";
        parameter Real mu_peak   = 1.0    "Peak friction coefficient (friction-circle limit): |F| <= mu_peak*normalLoad. Lower to reduce grip.";
        outer parameter Real R_wheel   "Wheel radius (m)";
        MultiBody.Interfaces.Frame_b wheelContactFL annotation(
          Placement(transformation(origin = {100, 60}, extent = {{-16, -16}, {16, 16}}),
          iconTransformation(origin = {60, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
        MultiBody.Interfaces.Frame_b wheelContactFR annotation(
          Placement(transformation(origin = {100, 20}, extent = {{-16, -16}, {16, 16}}),
          iconTransformation(origin = {60, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
        MultiBody.Interfaces.Frame_b wheelContactRL annotation(
          Placement(transformation(origin = {100, -20}, extent = {{-16, -16}, {16, 16}}),
          iconTransformation(origin = {-60, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
        MultiBody.Interfaces.Frame_b wheelContactRR annotation(
          Placement(transformation(origin = {100, -60}, extent = {{-16, -16}, {16, 16}}),
          iconTransformation(origin = {-60, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
        Components.Floor floorFL(ground_c = ground_c, ground_d = ground_d, ground_mu = ground_mu, mu_lat = mu_lat, mu_peak = mu_peak) annotation(
          Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));
        Components.Floor floorFR(ground_c = ground_c, ground_d = ground_d, ground_mu = ground_mu, mu_lat = mu_lat, mu_peak = mu_peak) annotation(
          Placement(transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}})));
        Components.Floor floorRL(ground_c = ground_c, ground_d = ground_d, ground_mu = ground_mu, mu_lat = mu_lat, mu_peak = mu_peak) annotation(
          Placement(transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}})));
        Components.Floor floorRR(ground_c = ground_c, ground_d = ground_d, ground_mu = ground_mu, mu_lat = mu_lat, mu_peak = mu_peak) annotation(
          Placement(transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}})));
      equation
        connect(floorFL.wheelContact, wheelContactFL);
        connect(floorFR.wheelContact, wheelContactFR);
        connect(floorRL.wheelContact, wheelContactRL);
        connect(floorRR.wheelContact, wheelContactRR);
        annotation(
          Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {126, 126, 126}, fillPattern = FillPattern.Solid, extent = {{-100, 51}, {100, -51}}), Rectangle(origin = {-61, -1}, lineColor = {255, 238, 56}, fillColor = {254, 238, 19}, fillPattern = FillPattern.Solid, extent = {{-21, 7}, {21, -7}}), Rectangle(origin = {-3, -1}, lineColor = {255, 238, 56}, fillColor = {254, 238, 19}, fillPattern = FillPattern.Solid, extent = {{-21, 7}, {21, -7}}), Rectangle(origin = {57, -1}, lineColor = {255, 238, 56}, fillColor = {254, 238, 19}, fillPattern = FillPattern.Solid, extent = {{-21, 7}, {21, -7}})}),
          Diagram(graphics),
          Documentation(info = "<html>
<body>
<h4>Floor4Corners</h4>
<p>Aggregates four identical <code>Floor</code> contact models (one per wheel corner) and distributes shared road parameters to all four.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>ground_c</code></td><td>1e5</td><td>Floor stiffness (N/m)</td></tr>
<tr><td><code>ground_d</code></td><td>5000</td><td>Floor damping (N&middot;s/m)</td></tr>
<tr><td><code>ground_mu</code></td><td>10000</td><td>Longitudinal friction coefficient (N&middot;s/m)</td></tr>
<tr><td><code>mu_lat</code></td><td>100000</td><td>Lateral slip-force rate (N&middot;s/m) before saturation</td></tr>
<tr><td><code>mu_peak</code></td><td>1.0</td><td>Peak friction coefficient (friction-circle grip limit for all 4 wheels); lower to reduce grip</td></tr>
<tr><td><code>R_wheel</code></td><td>outer</td><td>Tire radius &mdash; resolved from CarExample</td></tr>
</tbody>
</table>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>wheelContactFL</code></td><td>Frame_b</td><td>Front-left ground contact (&rarr; tire wheelSupport)</td></tr>
<tr><td><code>wheelContactFR</code></td><td>Frame_b</td><td>Front-right ground contact</td></tr>
<tr><td><code>wheelContactRL</code></td><td>Frame_b</td><td>Rear-left ground contact</td></tr>
<tr><td><code>wheelContactRR</code></td><td>Frame_b</td><td>Rear-right ground contact</td></tr>
</tbody>
</table>
</body>
</html>"));
      end Floor4Corners;

      package Components
        model GroundSpring "Vertical spring-damper ground contact"
          import MultiBody = Modelica.Mechanics.MultiBody;
          parameter Real ground_c = 1e5 "Floor stiffness (N/m)";
          parameter Real ground_d = 5000 "Floor damping (N.s/m)";
          outer parameter Real R_wheel "Tire radius (m)";
          outer DDynamics.Roads.Terrains.TerrainMap terrain;
          MultiBody.Interfaces.Frame_b wheelContact annotation(
            Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}),
            iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
          MultiBody.Forces.WorldForce normalForce(animation = false) annotation(
            Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}})));
        protected
          Real vy;
        equation
          connect(normalForce.frame_b, wheelContact);
          vy = der(wheelContact.r_0[2]);
          normalForce.force = {
            0,
            noEvent(max(0, ground_c * (terrain.getZ(wheelContact.r_0[1], wheelContact.r_0[3]) + R_wheel - wheelContact.r_0[2]) - ground_d * vy)),
            0
          };
          annotation(
            Documentation(info = "<html>
<body>
<h4>GroundSpring</h4>
<p>Applies a vertical spring-damper normal force to a wheel contact frame. Force is zero while the tire center is above the terrain surface; grows linearly once the tire penetrates.</p>
<p><b>Force law:</b> <code>F_y = max(0, ground_c * (terrain.getZ(x, z) + R_wheel - y) - ground_d * vy)</code></p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>ground_c</code></td><td>1e5</td><td>Stiffness (N/m)</td></tr>
<tr><td><code>ground_d</code></td><td>5000</td><td>Damping (N&middot;s/m)</td></tr>
<tr><td><code>R_wheel</code></td><td>outer</td><td>Tire radius</td></tr>
<tr><td><code>terrain</code></td><td>outer</td><td>Terrain height function</td></tr>
</tbody>
</table>
<p><b>Connector:</b> <code>wheelContact</code> (Frame_b) &mdash; attach to tire wheel center frame.</p>
</body>
</html>"));
        end GroundSpring;

        model GroundFriction "Slip-based longitudinal and viscous lateral friction"
          import MultiBody = Modelica.Mechanics.MultiBody;
          parameter Real ground_mu = 10000 "Longitudinal viscous friction coefficient (N.s/m)";
          parameter Real mu_lat = 100000 "Lateral viscous friction coefficient (N.s/m)";
          parameter Real ground_c = 1e5 "Floor stiffness (N/m) - used to estimate the normal load";
          parameter Real ground_d = 5000 "Floor damping (N.s/m) - used to estimate the normal load";
          parameter Real mu_peak = 1.0 "Peak friction coefficient; total contact force is capped at mu_peak*normalLoad (friction circle). Set <1 to reduce grip.";
          outer parameter Real R_wheel "Wheel radius (m)";
          outer DDynamics.Roads.Terrains.TerrainMap terrain;
          MultiBody.Interfaces.Frame_b wheelContact annotation(
            Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}),
            iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
          MultiBody.Forces.WorldForceAndTorque frictionForce(animation = false) annotation(
            Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}})));
        protected
          parameter Real contactRampDepth = 0.001 "Depth over which friction ramps from 0 to full (m)";
          Real vWorld[3], axleWorld[3], headingWorld[3], contactDepth, frictionScale;
          Real vLong, vLat;
          Real frictionVec[3];
          Real vyc "Vertical contact velocity (for normal-load estimate)";
          Real Nload "Estimated normal load at the contact patch (N)";
          Real fRaw[3] "Unsaturated (viscous) friction demand";
          Real fMag "Magnitude of fRaw";
          Real fMax "Friction-circle limit = mu_peak*Nload";
        equation
          connect(frictionForce.frame_b, wheelContact);
          vWorld = der(wheelContact.r_0);
// Spin-invariant axle direction: rotating around n={0,0,-1} leaves that axis unchanged,
// so resolve1(R, {0,0,-1}) equals the same world vector regardless of wheel spin angle.
          axleWorld = Modelica.Mechanics.MultiBody.Frames.resolve1(wheelContact.R, {0,0,-1});
// Rolling direction: cross product of axle and world-up {0,1,0}.
// Works for all heading directions; never degenerates when the car turns.
          headingWorld = cross(axleWorld, {0, 1, 0});
          vLong = vWorld * headingWorld;
          vLat  = vWorld * axleWorld;
          contactDepth = noEvent(max(0, terrain.getZ(wheelContact.r_0[1], wheelContact.r_0[3]) + R_wheel - wheelContact.r_0[2]));
          frictionScale = noEvent(min(1, contactDepth / contactRampDepth));
// Normal load at the patch (same spring-damper law as GroundSpring), used as the grip budget.
          vyc = der(wheelContact.r_0[2]);
          Nload = noEvent(max(0, ground_c * (terrain.getZ(wheelContact.r_0[1], wheelContact.r_0[3]) + R_wheel - wheelContact.r_0[2]) - ground_d * vyc));
// Unsaturated demand: slip-based longitudinal + viscous lateral (as before).
          fRaw = frictionScale * (
            -ground_mu * (vLong - (wheelContact.R.w * {0, 0, -1}) * R_wheel) * headingWorld
            - mu_lat * vLat * axleWorld);
// Friction circle: the combined contact force cannot exceed mu_peak*Nload. Beyond that the tire
// slides and the force saturates instead of growing without bound. Longitudinal and lateral share
// one budget, so hard acceleration eats into cornering grip (and vice-versa), as with a real tire.
          fMag = sqrt(fRaw * fRaw + 1e-12);
          fMax = mu_peak * Nload;
          frictionVec = noEvent(if fMag > fMax then fRaw * (fMax / fMag) else fRaw);
          frictionForce.force  = frictionVec;
// Torque from applying friction at the contact patch (offset R_wheel below wheel center).
// cross({0,-R,0}, F) gives the rolling torque that spins the free revolute on non-driven wheels.
          frictionForce.torque = cross({0, -R_wheel, 0}, frictionVec);
          annotation(
            Documentation(info = "<html>
<body>
<h4>GroundFriction</h4>
<p>Applies longitudinal (slip-based) and lateral (viscous) friction forces at the contact patch, plus the rolling torque from applying friction below the wheel center.</p>
<p>Heading and axle directions are computed from the wheel rotation matrix (spin-invariant: uses <code>resolve1(R, {0,0,-1})</code> and <code>cross(axle, {0,1,0})</code>).</p>
<p><b>Friction circle.</b> <code>ground_mu</code> and <code>mu_lat</code> set how fast force builds with slip
(viscous demand). That demand is then saturated so the <i>combined</i> longitudinal+lateral force cannot exceed
<code>mu_peak &middot; N</code>, where <code>N</code> is the normal load (recomputed here from the same spring-damper
law as <code>GroundSpring</code>). Below the limit behaviour is unchanged; above it the tire slides and the force
saturates instead of growing without bound. This bounds lateral grip (preventing unphysical grip-driven rollover) and
couples the two directions (hard acceleration reduces available cornering force). Lower <code>mu_peak</code> to reduce
overall grip; the default 1.0 is a typical dry tire-road peak.</p>
<pre>N = max(0, ground_c*(getZ + R - y) - ground_d*vy);   F = min(|F_demand|, mu_peak*N) in F_demand's direction</pre>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>ground_mu</code></td><td>10000</td><td>Longitudinal slip-force rate (N&middot;s/m) before saturation</td></tr>
<tr><td><code>mu_lat</code></td><td>100000</td><td>Lateral slip-force rate (N&middot;s/m) before saturation</td></tr>
<tr><td><code>mu_peak</code></td><td>1.0</td><td>Peak friction coefficient; caps |F| at <code>mu_peak&middot;N</code> (friction circle). Lower = less grip</td></tr>
<tr><td><code>ground_c</code></td><td>1e5</td><td>Floor stiffness (N/m) &mdash; for the normal-load estimate</td></tr>
<tr><td><code>ground_d</code></td><td>5000</td><td>Floor damping (N&middot;s/m) &mdash; for the normal-load estimate</td></tr>
<tr><td><code>R_wheel</code></td><td>outer</td><td>Tire radius</td></tr>
<tr><td><code>terrain</code></td><td>outer</td><td>Terrain height function</td></tr>
<tr><td><code>contactRampDepth</code></td><td>0.001 m (protected)</td><td>Penetration depth over which friction scales from 0 to full</td></tr>
</tbody>
</table>
<p><b>Connector:</b> <code>wheelContact</code> (Frame_b).</p>
<p><b>Note:</b> <code>ground_c</code>/<code>ground_d</code> must match the <code>GroundSpring</code> values for the
normal-load estimate to be correct; <code>Floor</code>/<code>Floor4Corners</code> pass the same values to both.</p>
</body>
</html>"));
        end GroundFriction;

        model Floor "Complete wheel-ground contact. Connect tire.wheelSupport to wheelContact."
          import MultiBody = Modelica.Mechanics.MultiBody;
          parameter Real ground_c = 1e5 "Floor stiffness (N/m)";
          parameter Real ground_d = 5000 "Floor damping (N.s/m)";
          parameter Real ground_mu = 10000 "Longitudinal viscous friction coefficient (N.s/m)";
          parameter Real mu_lat = 100000 "Lateral viscous friction coefficient (N.s/m)";
          parameter Real mu_peak = 1.0 "Peak friction coefficient (friction-circle limit): |F| <= mu_peak*normalLoad. Lower to reduce grip.";
          outer parameter Real R_wheel "Wheel radius (m)";
          MultiBody.Interfaces.Frame_b wheelContact annotation(
            Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}),
            iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
          GroundSpring gs(ground_c = ground_c, ground_d = ground_d) annotation(
            Placement(transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}})));
          GroundFriction gf(ground_mu = ground_mu, mu_lat = mu_lat, ground_c = ground_c, ground_d = ground_d, mu_peak = mu_peak) annotation(
            Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}})));
        equation
          connect(gs.wheelContact, wheelContact);
          connect(gf.wheelContact, wheelContact);
          annotation(
            Documentation(info = "<html>
<body>
<h4>Floor</h4>
<p>Composite model combining <code>GroundSpring</code> (normal force) and <code>GroundFriction</code> (friction + torque) into a single wheel-ground contact. Both sub-models share the same <code>wheelContact</code> frame.</p>
<p><b>Parameters:</b> <code>ground_c</code>, <code>ground_d</code>, <code>ground_mu</code>, <code>mu_lat</code>, <code>mu_peak</code> plus <code>outer R_wheel</code>. <code>ground_c</code>/<code>ground_d</code> are shared with <code>GroundSpring</code> and reused by <code>GroundFriction</code> for the friction-circle normal load.</p>
<p><b>Connector:</b> <code>wheelContact</code> (Frame_b).</p>
</body>
</html>"));
        end Floor;

      end Components;

    end Floors;

    package Terrains
      block TerrainMap "Calculates ground height based on X,Y position"
        function getZ
          input Real x;
          input Real y;
          output Real z;
        algorithm
//  z := 0.2 * Modelica.Math.sin(2 * Modelica.Constants.pi * x / 5);
          z := 1;
        end getZ;
        annotation(
          Icon(graphics = {Rectangle(origin = {0, -40}, fillColor = {163, 141, 98}, fillPattern = FillPattern.Solid, extent = {{-100, 60}, {100, -60}}), Line(origin = {-1.29108, 33.677}, points = {{-98.7089, -13.677}, {-78.7089, 16.323}, {-68.7089, 6.323}, {-58.7089, 16.323}, {-48.7089, 6.323}, {-38.7089, 16.323}, {-28.7089, 6.323}, {-18.7089, 16.323}, {-6.70892, 6.323}, {1.29108, 16.323}, {11.2911, 6.323}, {21.2911, 16.323}, {33.2911, 6.323}, {41.2911, 14.323}, {51.2911, 6.323}, {61.2911, 16.323}, {71.2911, 6.323}, {81.2911, 16.323}, {101.291, -13.677}, {-98.7089, -13.677}, {-100.709, -15.677}})}),
          Documentation(info = "<html>
<body>
<h4>TerrainMap (block)</h4>
<p>Provides the <code>getZ(x, y)</code> function that returns terrain height at any world-XZ position. All ground contact models query this block via <code>outer terrain</code>.</p>
<p>Currently returns a flat plane at <code>z = 1</code>. To implement a custom terrain, modify the <code>algorithm</code> section of <code>getZ</code> and update <code>TerrainVisualizer.groundHeight</code> and <code>terrainSurface</code> to match.</p>
</body>
</html>"));
      end TerrainMap;

      package Components
        function terrainSurface "Surface characteristic for terrain visualization (keep in sync with TerrainMap.getZ)"
          extends Modelica.Mechanics.MultiBody.Visualizers.Advanced.SurfaceCharacteristics.partialSurfaceCharacteristic(
              final multiColoredSurface=false);
          input Real x_min = -10 "Minimum X (forward)";
          input Real x_max =  10 "Maximum X (forward)";
          input Real z_min =  -5 "Minimum Z (lateral)";
          input Real z_max =   5 "Maximum Z (lateral)";
        algorithm
          for i in 1:nu loop
            for j in 1:nv loop
              X[i,j] := x_min + (i-1) * (x_max - x_min) / (nu - 1);
              Z[i,j] := z_min + (j-1) * (z_max - z_min) / (nv - 1);
          Y[i,j] := 0.2 * Modelica.Math.sin(2 * Modelica.Constants.pi * X[i,j] / 5);
//Y[i,j] := 1;
            end for;
          end for;
          annotation(
            Documentation(info = "<html>
<body>
<h4>terrainSurface (function)</h4>
<p>Surface characteristic function for 3D terrain visualization. Passed to <code>Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface</code>. Extends <code>partialSurfaceCharacteristic</code> with <code>multiColoredSurface = false</code>. <b>Must be kept in sync with <code>TerrainMap.getZ</code>.</b></p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>x_min</code></td><td>-10</td><td>Minimum X extent (m)</td></tr>
<tr><td><code>x_max</code></td><td>10</td><td>Maximum X extent (m)</td></tr>
<tr><td><code>z_min</code></td><td>-5</td><td>Minimum Z extent (m)</td></tr>
<tr><td><code>z_max</code></td><td>5</td><td>Maximum Z extent (m)</td></tr>
</tbody>
</table>
</body>
</html>"));
        end terrainSurface;

        model TerrainVisualizer "Flat ground slab visualization aligned with TerrainMap height"
          extends Modelica.Mechanics.MultiBody.Interfaces.PartialVisualizer;
          parameter Boolean animation = true "= true, if animation shall be enabled";
          parameter Real x_min = -10 "Slab start in X (forward)";
          parameter Real x_max =  10 "Slab end in X (forward)";
          parameter Real z_min =  -5 "Slab start in Z (lateral)";
          parameter Real z_max =   5 "Slab end in Z (lateral)";
          parameter Real groundHeight = 1.0 "Terrain height Y (keep in sync with TerrainMap.getZ)";
          parameter Modelica.Mechanics.MultiBody.Types.RealColor color = {0, 160, 0} "Ground color";
          parameter Real specularCoefficient = 0.1;

          Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape ground(
            shapeType = "box",
            color = color,
            specularCoefficient = specularCoefficient,
            length = x_max - x_min,
            width  = z_max - z_min,
            height = 0.02,
            lengthDirection = {1, 0, 0},
            widthDirection  = {0, 0, 1},
            r_shape = {x_min, groundHeight, 0},
            r = frame_a.r_0,
            R = frame_a.R) if world.enableAnimation and animation;
        equation
          frame_a.f = zeros(3);
          frame_a.t = zeros(3);
          annotation(
            Icon(graphics = {Rectangle(lineColor = {75, 197, 22},fillColor = {30, 165, 9}, fillPattern = FillPattern.Solid, extent = {{-100, 80}, {100, -80}})}),
            Documentation(info = "<html>
<body>
<h4>TerrainVisualizer</h4>
<p>Renders the ground surface as a flat colored box in the 3D animation. Extends <code>PartialVisualizer</code>. <b>Keep <code>groundHeight</code> in sync with <code>TerrainMap.getZ</code>.</b></p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>animation</code></td><td>true</td><td>Enable animation</td></tr>
<tr><td><code>x_min</code></td><td>-10</td><td>Slab start in X (m)</td></tr>
<tr><td><code>x_max</code></td><td>10</td><td>Slab end in X (m)</td></tr>
<tr><td><code>z_min</code></td><td>-5</td><td>Slab start in Z (m)</td></tr>
<tr><td><code>z_max</code></td><td>5</td><td>Slab end in Z (m)</td></tr>
<tr><td><code>groundHeight</code></td><td>1.0</td><td>Slab Y position &mdash; must match TerrainMap.getZ</td></tr>
<tr><td><code>color</code></td><td>{0, 160, 0}</td><td>RGB ground color</td></tr>
<tr><td><code>specularCoefficient</code></td><td>0.1</td><td>Reflectivity</td></tr>
</tbody>
</table>
<p><b>Connector:</b> <code>frame_a</code> (Frame_a, from PartialVisualizer) &mdash; connect to <code>world.frame_b</code>.</p>
</body>
</html>"));
        end TerrainVisualizer;
      end Components;

    end Terrains;

  end Roads;

  package Cars

    model Car
      Parts.Chassis.RectangularChassis chassis(m = 400, length = 3.0, width = 1.8, height = 0.5) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFL(r = {1.5, -0.25, 0.9}) annotation(
        Placement(transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFR(r = {1.5, -0.25, -0.9}) annotation(
        Placement(transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRL(r = {-1.5, -0.25, 0.9}) annotation(
        Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRR(r = {-1.5, -0.25, -0.9}) annotation(
        Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.DoubleWishbone doubleWishboneRL annotation(
        Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.DoubleWishbone doubleWishboneRR(sideSign = -1) annotation(
        Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.DoubleWishbone doubleWishboneFL(steerable = true) annotation(
        Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Suspension.DoubleWishbone doubleWishboneFR(sideSign = -1, steerable = true) annotation(
        Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.Tire ttireFL annotation(
        Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.Tire tireFR annotation(
        Placement(transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.DrivingTire tireRL annotation(
        Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Tires.DrivingTire tireRR annotation(
        Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Differentials.SolidAxle solidAxle annotation(
        Placement(transformation(origin = {-152, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Joints.FreeMotion freeMotion(r_rel_a(start = {0, 1.2, 0}), v_rel_a(start = {0, 0, 0})) annotation(
        Placement(transformation(origin = {-4, 44}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Sources.Position steerAct annotation(
        Placement(transformation(origin = {102, 10}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Sources.Position steerAct1 annotation(
        Placement(transformation(origin = {102, -12}, extent = {{-10, -10}, {10, 10}})));
      Parts.Steering.MockSteering mockSteering annotation(
        Placement(transformation(origin = {60, 24}, extent = {{-9, -9}, {9, 9}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_FL annotation(
        Placement(transformation(origin = {94, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {60, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_FR annotation(
        Placement(transformation(origin = {94, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {60, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_RL annotation(
        Placement(transformation(origin = {-150, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-80, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_RR annotation(
        Placement(transformation(origin = {-150, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-80, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a chassis_pos annotation(
        Placement(transformation(origin = {-2, -102}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation( origin = {2, 0},extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput steerInput "Front-wheel steer command [-1..1]: -1 = full left, +1 = full right (normalized; mapped to a road-wheel angle in rad by MockSteering)" annotation(
        Placement(transformation(origin = {42, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {98, -2}, extent = {{-14, -14}, {14, 14}}, rotation = 180)));
      Modelica.Blocks.Interfaces.RealInput throttleInput "Throttle command [0=idle, 1=full drive torque]" annotation(
        Placement(transformation(origin = {-80, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-97, -1}, extent = {{-13, -13}, {13, 13}})));
      Modelica.Blocks.Interfaces.RealInput brakeInput "Brake demand [0=released, 1=fully applied]" annotation(
        Placement(transformation(origin = {0, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 98}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
      Parts.Brakes.DiscBrake brakeFL(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {164, 64}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeFR(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {148, -16}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeRL(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {-128, 58}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeRR(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {-118, -64}, extent = {{-10, -10}, {10, 10}})));
      outer Modelica.Mechanics.MultiBody.World world;
  Parts.Transmission.MockTransmission mockTransmission annotation(
        Placement(transformation(origin = {-80, -4}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(mountFL.frame_b, doubleWishboneFL.chassisMount) annotation(
        Line(points = {{60, 40}, {100, 40}}, color = {95, 95, 95}));
      connect(mountFR.frame_b, doubleWishboneFR.chassisMount) annotation(
        Line(points = {{60, -40}, {100, -40}}, color = {95, 95, 95}));
      connect(doubleWishboneFR.wheelMount, tireFR.suspMount) annotation(
        Line(points = {{120, -40}, {140, -40}}, color = {95, 95, 95}));
      connect(doubleWishboneFL.wheelMount, ttireFL.suspMount) annotation(
        Line(points = {{120, 40}, {140, 40}}, color = {95, 95, 95}));
      connect(doubleWishboneRL.wheelMount, tireRL.suspMount) annotation(
        Line(points = {{-120, 40}, {-140, 40}}, color = {95, 95, 95}));
      connect(doubleWishboneRR.wheelMount, tireRR.suspMount) annotation(
        Line(points = {{-120, -40}, {-140, -40}}, color = {95, 95, 95}));
      connect(solidAxle.right_out, tireRR.spinInput) annotation(
        Line(points = {{-152, -12}, {-152, -22}, {-174, -22}, {-174, -58}, {-154, -58}, {-154, -50}}));
      connect(solidAxle.left_out, tireRL.spinInput) annotation(
        Line(points = {{-152, 8}, {-152, 19}, {-154, 19}, {-154, 30}}));
      connect(doubleWishboneRL.chassisMount, mountRL.frame_b) annotation(
        Line(points = {{-100, 40}, {-80, 40}}, color = {95, 95, 95}));
      connect(doubleWishboneRR.chassisMount, mountRR.frame_b) annotation(
        Line(points = {{-100, -40}, {-80, -40}}, color = {95, 95, 95}));
      connect(steerAct1.flange, doubleWishboneFR.steerInput) annotation(
        Line(points = {{112, -12}, {124, -12}, {124, -26}, {110, -26}, {110, -30}}));
      connect(steerAct.flange, doubleWishboneFL.steerInput) annotation(
        Line(points = {{112, 10}, {128, 10}, {128, 60}, {110, 60}, {110, 50}}));
      connect(ttireFL.wheelSupport, frame_FL) annotation(
        Line(points = {{160, 40}, {180, 40}, {180, 82}, {94, 82}, {94, 100}}, color = {95, 95, 95}));
      connect(tireFR.wheelSupport, frame_FR) annotation(
        Line(points = {{160, -40}, {174, -40}, {174, -100}, {94, -100}}, color = {95, 95, 95}));
      connect(tireRL.wheelSupport, frame_RL) annotation(
        Line(points = {{-160, 40}, {-180, 40}, {-180, 80}, {-150, 80}, {-150, 100}}, color = {95, 95, 95}));
      connect(tireRR.wheelSupport, frame_RR) annotation(
        Line(points = {{-160, -40}, {-202, -40}, {-202, -100}, {-150, -100}}, color = {95, 95, 95}));
      connect(steerInput, mockSteering.steerCmd) annotation(
        Line(points = {{42, 110}, {42, 24}, {51, 24}}, color = {0, 0, 127}));
      connect(mockSteering.steerAngle, steerAct.phi_ref) annotation(
        Line(points = {{69, 24}, {80, 24}, {80, 10}, {90, 10}}, color = {0, 0, 127}));
      connect(mockSteering.steerAngle, steerAct1.phi_ref) annotation(
        Line(points = {{69, 24}, {80, 24}, {80, -12}, {90, -12}}, color = {0, 0, 127}));
//connect(throttleInput, solidAxle.i) annotation(
//Line(points = {{-80, 110}, {-80, -2}, {-142, -2}}, color = {0, 0, 127}));
      connect(brakeFL.shaft, ttireFL.brakeFlange) annotation(
        Line(points = {{154, 64}, {154, 52}, {150, 52}, {150, 40}}));
      connect(brakeFR.shaft, tireFR.brakeFlange) annotation(
        Line(points = {{138, -16}, {138, -40}, {150, -40}}));
      connect(brakeRL.shaft, tireRL.brakeFlange) annotation(
        Line(points = {{-138, 58}, {-168, 58}, {-168, 40}, {-150, 40}}));
      connect(brakeRR.shaft, tireRR.brakeFlange) annotation(
        Line(points = {{-128, -64}, {-128, -51}, {-150, -51}, {-150, -40}}));
      connect(brakeInput, brakeFL.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {164, 80}, {164, 74}}, color = {0, 0, 127}));
      connect(brakeInput, brakeFR.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {148, 80}, {148, -6}}, color = {0, 0, 127}));
      connect(brakeInput, brakeRL.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {-128, 80}, {-128, 68}}, color = {0, 0, 127}));
      connect(brakeInput, brakeRR.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {-118, 80}, {-118, -54}}, color = {0, 0, 127}));
      connect(world.frame_b, freeMotion.frame_a) annotation(
        Line(points = {{-20, 100}, {-20, 44}, {-14, 44}}));
      connect(chassis_pos, chassis.frame_a) annotation(
        Line(points = {{-2, -102}, {0, -102}, {0, -10}}));
      connect(mountRL.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, 40}, {-26, 40}, {-26, -10}, {0, -10}}, color = {95, 95, 95}));
      connect(mountRR.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, -40}, {0, -40}, {0, -10}}, color = {95, 95, 95}));
      connect(mountFR.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, -40}, {0, -40}, {0, -10}}, color = {95, 95, 95}));
      connect(mountFL.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, 40}, {20, 40}, {20, -10}, {0, -10}}, color = {95, 95, 95}));
      connect(freeMotion.frame_b, chassis.frame_a) annotation(
        Line(points = {{6, 44}, {16, 44}, {16, -10}, {0, -10}}, color = {95, 95, 95}));
  connect(throttleInput, mockTransmission.pedalInput) annotation(
        Line(points = {{-80, 110}, {-80, 5}}, color = {0, 0, 127}));
  connect(mockTransmission.torqueOut, solidAxle.pedalInput) annotation(
        Line(points = {{-80, -14}, {-142, -14}, {-142, -2}}));
      annotation(
        Icon(graphics = {Line(points = {{-80, 60}, {-80, -60}, {80, -60}, {80, 60}, {-80, 60}, {-80, 60}}), Line(origin = {-2, 0}, points = {{-58, 40}, {-58, -40}, {62, -40}, {62, 40}, {-58, 40}, {-58, 40}, {-58, 40}}), Line(origin = {-0.193375, 0.27735}, points = {{-59.8066, 39.7226}, {-29.8066, 19.7226}, {-29.8066, -20.2774}, {-59.8066, -40.2774}, {-29.8066, -20.2774}, {40.1934, -20.2774}, {40.1934, 19.7226}, {-29.8066, 19.7226}, {40.1934, 19.7226}, {60.1934, 39.7226}, {40.1934, 19.7226}, {40.1934, -20.2774}, {60.1934, -40.2774}, {60.1934, -38.2774}})}),
        Documentation(info = "<html>
<body>
<h4>Car</h4>
<p>Complete 4-wheeled vehicle assembly. Contains a <code>RectangularChassis</code> (400 kg), 4 &times; <code>DoubleWishbone</code> suspension (front pair steerable), 2 &times; passive <code>Tire</code> (front), 2 &times; <code>DrivingTire</code> (rear), a <code>SolidAxle</code> differential, a <code>FreeMotion</code> joint (initial height y = 1.2 m), and 2 &times; <code>Position</code> actuators for steering.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>frame_FL</code></td><td>Frame_a</td><td>Front-left ground contact &mdash; connect to Road.FL</td></tr>
<tr><td><code>frame_FR</code></td><td>Frame_a</td><td>Front-right ground contact &mdash; connect to Road.FR</td></tr>
<tr><td><code>frame_RL</code></td><td>Frame_a</td><td>Rear-left ground contact &mdash; connect to Road.RL</td></tr>
<tr><td><code>frame_RR</code></td><td>Frame_a</td><td>Rear-right ground contact &mdash; connect to Road.RR</td></tr>
<tr><td><code>chassis_pos</code></td><td>Frame_a</td><td>Chassis reference frame (for external position reading)</td></tr>
<tr><td><code>throttleInput</code></td><td>RealInput</td><td>Throttle command [0..1] &mdash; 0 = idle, 1 = full drive torque</td></tr>
<tr><td><code>steerInput</code></td><td>RealInput</td><td>Front-wheel steer command [-1..1] &mdash; &minus;1 = full left, +1 = full right (normalized; mapped to a road-wheel angle in rad by MockSteering)</td></tr>
<tr><td><code>brakeInput</code></td><td>RealInput</td><td>Brake demand [0..1] &mdash; 0 = released, 1 = fully applied</td></tr>
</tbody>
</table>
<p><code>outer World world</code> is resolved from <code>Road</code>.</p>
</body>
</html>"));
    end Car;

    model CivicEKCar
      Parts.Chassis.RectangularChassis chassis(m = 990, length = 4.178, width = 1.704, height = 0.4) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFL(r = {1.31, -0.25, 0.735}) annotation(
        Placement(transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFR(r = {1.31, -0.25, -0.735}) annotation(
        Placement(transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRL(r = {-1.31, -0.25, 0.735}) annotation(
        Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRR(r = {-1.31, -0.25, -0.735}) annotation(
        Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.DoubleWishbone doubleWishboneRL(k_spring = 14000, d_damper = 1800) annotation(
        Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.DoubleWishbone doubleWishboneRR(sideSign = -1, k_spring = 14000, d_damper = 1800) annotation(
        Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.DoubleWishbone doubleWishboneFL(steerable = true, k_spring = 16000, d_damper = 1800) annotation(
        Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Suspension.DoubleWishbone doubleWishboneFR(sideSign = -1, steerable = true, k_spring = 16000, d_damper = 1800) annotation(
        Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.DrivingTire tireFL annotation(
        Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.DrivingTire tireFR annotation(
        Placement(transformation(origin = {148, -40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.Tire tireRL annotation(
        Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Tires.Tire tireRR annotation(
        Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Differentials.SolidAxle solidAxle annotation(
        Placement(transformation(origin = {164, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Mechanics.MultiBody.Joints.FreeMotion freeMotion(r_rel_a(start = {0, 1.4, 0}), v_rel_a(start = {0, 0, 0})) annotation(
        Placement(transformation(origin = {-4, 44}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Sources.Position steerAct annotation(
        Placement(transformation(origin = {102, 10}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Sources.Position steerAct1 annotation(
        Placement(transformation(origin = {102, -12}, extent = {{-10, -10}, {10, 10}})));
      Parts.Steering.MockSteering mockSteering annotation(
        Placement(transformation(origin = {60, 24}, extent = {{-9, -9}, {9, 9}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_FL annotation(
        Placement(transformation(origin = {94, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {60, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_FR annotation(
        Placement(transformation(origin = {94, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {60, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_RL annotation(
        Placement(transformation(origin = {-150, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-80, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_RR annotation(
        Placement(transformation(origin = {-150, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-80, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a chassis_pos annotation(
        Placement(transformation(origin = {-2, -102}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {2, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput steerInput "Front-wheel steer command [-1..1]: -1 = full left, +1 = full right (normalized; mapped to a road-wheel angle in rad by MockSteering)" annotation(
        Placement(transformation(origin = {42, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {98, -2}, extent = {{-14, -14}, {14, 14}}, rotation = 180)));
      Modelica.Blocks.Interfaces.RealInput throttleInput "Throttle command [0=idle, 1=full drive torque]" annotation(
        Placement(transformation(origin = {-80, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-97, -1}, extent = {{-13, -13}, {13, 13}})));
      Modelica.Blocks.Interfaces.RealInput brakeInput "Brake demand [0=released, 1=fully applied]" annotation(
        Placement(transformation(origin = {0, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 98}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
      Parts.Brakes.DiscBrake brakeFL(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {164, 64}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeFR(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {148, -16}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeRL(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {-128, 58}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeRR(maxBrakeTorque = 2000) annotation(
        Placement(transformation(origin = {-118, -64}, extent = {{-10, -10}, {10, 10}})));
      outer Modelica.Mechanics.MultiBody.World world;
  Parts.Transmission.MockTransmission mockTransmission annotation(
        Placement(transformation(origin = {-26, 64}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(mountFL.frame_b, doubleWishboneFL.chassisMount) annotation(
        Line(points = {{60, 40}, {100, 40}}, color = {95, 95, 95}));
      connect(mountFR.frame_b, doubleWishboneFR.chassisMount) annotation(
        Line(points = {{60, -40}, {100, -40}}, color = {95, 95, 95}));
      connect(doubleWishboneFR.wheelMount, tireFR.suspMount) annotation(
        Line(points = {{120, -40}, {138, -40}}, color = {95, 95, 95}));
      connect(doubleWishboneFL.wheelMount, tireFL.suspMount) annotation(
        Line(points = {{120, 40}, {140, 40}}, color = {95, 95, 95}));
      connect(doubleWishboneRL.wheelMount, tireRL.suspMount) annotation(
        Line(points = {{-120, 40}, {-140, 40}}, color = {95, 95, 95}));
      connect(doubleWishboneRR.wheelMount, tireRR.suspMount) annotation(
        Line(points = {{-120, -40}, {-140, -40}}, color = {95, 95, 95}));
      connect(solidAxle.right_out, tireFR.spinInput) annotation(
        Line(points = {{164, 8}, {164, -22}, {174, -22}, {174, -58}, {148, -58}, {148, -30}}));
      connect(solidAxle.left_out, tireFL.spinInput) annotation(
        Line(points = {{164, -12}, {164, 13}, {154, 13}, {154, 30}}));
      connect(doubleWishboneRL.chassisMount, mountRL.frame_b) annotation(
        Line(points = {{-100, 40}, {-80, 40}}, color = {95, 95, 95}));
      connect(doubleWishboneRR.chassisMount, mountRR.frame_b) annotation(
        Line(points = {{-100, -40}, {-80, -40}}, color = {95, 95, 95}));
      connect(steerAct1.flange, doubleWishboneFR.steerInput) annotation(
        Line(points = {{112, -12}, {124, -12}, {124, -26}, {110, -26}, {110, -30}}));
      connect(steerAct.flange, doubleWishboneFL.steerInput) annotation(
        Line(points = {{112, 10}, {128, 10}, {128, 60}, {110, 60}, {110, 50}}));
      connect(tireFL.wheelSupport, frame_FL) annotation(
        Line(points = {{160, 40}, {180, 40}, {180, 82}, {94, 82}, {94, 100}}, color = {95, 95, 95}));
      connect(tireFR.wheelSupport, frame_FR) annotation(
        Line(points = {{158, -40}, {174, -40}, {174, -100}, {94, -100}}, color = {95, 95, 95}));
      connect(tireRL.wheelSupport, frame_RL) annotation(
        Line(points = {{-160, 40}, {-180, 40}, {-180, 80}, {-150, 80}, {-150, 100}}, color = {95, 95, 95}));
      connect(tireRR.wheelSupport, frame_RR) annotation(
        Line(points = {{-160, -40}, {-202, -40}, {-202, -100}, {-150, -100}}, color = {95, 95, 95}));
      connect(steerInput, mockSteering.steerCmd) annotation(
        Line(points = {{42, 110}, {42, 24}, {51, 24}}, color = {0, 0, 127}));
      connect(mockSteering.steerAngle, steerAct.phi_ref) annotation(
        Line(points = {{69, 24}, {80, 24}, {80, 10}, {90, 10}}, color = {0, 0, 127}));
      connect(mockSteering.steerAngle, steerAct1.phi_ref) annotation(
        Line(points = {{69, 24}, {80, 24}, {80, -12}, {90, -12}}, color = {0, 0, 127}));
      connect(brakeFL.shaft, tireFL.brakeFlange) annotation(
        Line(points = {{154, 64}, {154, 52}, {150, 52}, {150, 40}}));
      connect(brakeFR.shaft, tireFR.brakeFlange) annotation(
        Line(points = {{138, -16}, {138, -50}, {148, -50}}));
      connect(brakeRL.shaft, tireRL.brakeFlange) annotation(
        Line(points = {{-138, 58}, {-168, 58}, {-168, 40}, {-150, 40}}));
      connect(brakeRR.shaft, tireRR.brakeFlange) annotation(
        Line(points = {{-128, -64}, {-128, -51}, {-150, -51}, {-150, -40}}));
      connect(brakeInput, brakeFL.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {164, 80}, {164, 74}}, color = {0, 0, 127}));
      connect(brakeInput, brakeFR.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {148, 80}, {148, -6}}, color = {0, 0, 127}));
      connect(brakeInput, brakeRL.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {-128, 80}, {-128, 68}}, color = {0, 0, 127}));
      connect(brakeInput, brakeRR.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {-118, 80}, {-118, -54}}, color = {0, 0, 127}));
      connect(world.frame_b, freeMotion.frame_a) annotation(
        Line(points = {{-20, 100}, {-20, 44}, {-14, 44}}));
      connect(chassis_pos, chassis.frame_a) annotation(
        Line(points = {{-2, -102}, {0, -102}, {0, -10}}));
      connect(mountRL.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, 40}, {-26, 40}, {-26, -10}, {0, -10}}, color = {95, 95, 95}));
      connect(mountRR.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, -40}, {0, -40}, {0, -10}}, color = {95, 95, 95}));
      connect(mountFR.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, -40}, {0, -40}, {0, -10}}, color = {95, 95, 95}));
      connect(mountFL.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, 40}, {20, 40}, {20, -10}, {0, -10}}, color = {95, 95, 95}));
      connect(freeMotion.frame_b, chassis.frame_a) annotation(
        Line(points = {{6, 44}, {16, 44}, {16, -10}, {0, -10}}, color = {95, 95, 95}));
  connect(throttleInput, mockTransmission.pedalInput) annotation(
        Line(points = {{-80, 110}, {-80, 86}, {-26, 86}, {-26, 74}}, color = {0, 0, 127}));
  connect(mockTransmission.torqueOut, solidAxle.pedalInput) annotation(
        Line(points = {{-26, 54}, {134, 54}, {134, -2}, {154, -2}}));
      annotation(
        Icon(graphics = {Line(points = {{-80, 60}, {-80, -60}, {80, -60}, {80, 60}, {-80, 60}, {-80, 60}}), Line(origin = {-2, 0}, points = {{-58, 40}, {-58, -40}, {62, -40}, {62, 40}, {-58, 40}, {-58, 40}, {-58, 40}}), Line(origin = {-0.193375, 0.27735}, points = {{-59.8066, 39.7226}, {-29.8066, 19.7226}, {-29.8066, -20.2774}, {-59.8066, -40.2774}, {-29.8066, -20.2774}, {40.1934, -20.2774}, {40.1934, 19.7226}, {-29.8066, 19.7226}, {40.1934, 19.7226}, {60.1934, 39.7226}, {40.1934, 19.7226}, {40.1934, -20.2774}, {60.1934, -40.2774}, {60.1934, -38.2774}})}),
        Documentation(info = "<html>
<body>
<h4>CivicEKCar</h4>
<p>Honda Civic EK hatchback vehicle model. Front-wheel drive. Dimensions: 4178 mm long, 1704 mm wide, 2620 mm wheelbase, 1130 kg total mass (990 kg sprung). Uses <code>DrivingTire</code> on the front axle and passive <code>Tire</code> on the rear. Spring rates: 16 kN/m front, 14 kN/m rear. Damping: 1800 N&middot;s/m all corners. Tire: 185/65R14 (R = 0.30 m).</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>frame_FL</code></td><td>Frame_a</td><td>Front-left ground contact &mdash; connect to Road.FL</td></tr>
<tr><td><code>frame_FR</code></td><td>Frame_a</td><td>Front-right ground contact &mdash; connect to Road.FR</td></tr>
<tr><td><code>frame_RL</code></td><td>Frame_a</td><td>Rear-left ground contact &mdash; connect to Road.RL</td></tr>
<tr><td><code>frame_RR</code></td><td>Frame_a</td><td>Rear-right ground contact &mdash; connect to Road.RR</td></tr>
<tr><td><code>chassis_pos</code></td><td>Frame_a</td><td>Chassis reference frame</td></tr>
<tr><td><code>throttleInput</code></td><td>RealInput</td><td>Throttle command [0..1] &mdash; 0 = idle, 1 = full drive torque</td></tr>
<tr><td><code>steerInput</code></td><td>RealInput</td><td>Front-wheel steer command [-1..1] &mdash; &minus;1 = full left, +1 = full right (normalized; mapped to a road-wheel angle in rad by MockSteering)</td></tr>
<tr><td><code>brakeInput</code></td><td>RealInput</td><td>Brake demand [0=released, 1=fully applied]</td></tr>
</tbody>
</table>
<p><code>outer World world</code> is resolved from <code>Road</code>.</p>
</body>
</html>"));
    end CivicEKCar;

    model E36Car
      Parts.Chassis.RectangularChassis chassis(m = 1000, length = 4.433, width = 1.710, height = 0.4) annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFL(r = {1.350, -0.15, 0.710}) annotation(
        Placement(transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFR(r = {1.350, -0.15, -0.710}) annotation(
        Placement(transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRL(r = {-1.350, -0.25, 0.710}) annotation(
        Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRR(r = {-1.350, -0.25, -0.710}) annotation(
        Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.McPherson mcphersonFL(steerable = true, k_spring = 20000, d_damper = 2200, wheelOffsetY = 0.25, wheelOffsetZ = 0.30) annotation(
        Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Suspension.McPherson mcphersonFR(sideSign = -1, steerable = true, k_spring = 20000, d_damper = 2200, wheelOffsetY = 0.25, wheelOffsetZ = 0.30) annotation(
        Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Suspension.MultiLink multiLinkRL(k_spring = 16000, d_damper = 2200) annotation(
        Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Suspension.MultiLink multiLinkRR(sideSign = -1, k_spring = 16000, d_damper = 2200) annotation(
        Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Tires.Tire tireFL annotation(
        Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.Tire tireFR annotation(
        Placement(transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}})));
      Parts.Tires.DrivingTire tireRL annotation(
        Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Tires.DrivingTire tireRR annotation(
        Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
      Parts.Differentials.SolidAxle solidAxle annotation(
        Placement(transformation(origin = {-152, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Joints.FreeMotion freeMotion(r_rel_a(start = {0, 1.35, 0}), v_rel_a(start = {0, 0, 0})) annotation(
        Placement(transformation(origin = {-4, 44}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Sources.Position steerAct annotation(
        Placement(transformation(origin = {102, 10}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Sources.Position steerAct1 annotation(
        Placement(transformation(origin = {102, -12}, extent = {{-10, -10}, {10, 10}})));
      Parts.Steering.MockSteering mockSteering annotation(
        Placement(transformation(origin = {60, 24}, extent = {{-9, -9}, {9, 9}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_FL annotation(
        Placement(transformation(origin = {94, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {60, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_FR annotation(
        Placement(transformation(origin = {94, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {60, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_RL annotation(
        Placement(transformation(origin = {-150, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-80, 98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_RR annotation(
        Placement(transformation(origin = {-150, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {-80, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a chassis_pos annotation(
        Placement(transformation(origin = {-2, -102}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {2, 0}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput steerInput "Front-wheel steer command [-1..1]: -1 = full left, +1 = full right (normalized; mapped to a road-wheel angle in rad by MockSteering)" annotation(
        Placement(transformation(origin = {42, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {98, -2}, extent = {{-14, -14}, {14, 14}}, rotation = 180)));
      Modelica.Blocks.Interfaces.RealInput throttleInput "Throttle command [0=idle, 1=full drive torque]" annotation(
        Placement(transformation(origin = {-80, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-97, -1}, extent = {{-13, -13}, {13, 13}})));
      Modelica.Blocks.Interfaces.RealInput brakeInput "Brake demand [0=released, 1=fully applied]" annotation(
        Placement(transformation(origin = {0, 110}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 98}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
      Parts.Brakes.DiscBrake brakeFL(maxBrakeTorque = 2500) annotation(
        Placement(transformation(origin = {164, 64}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeFR(maxBrakeTorque = 2500) annotation(
        Placement(transformation(origin = {148, -16}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeRL(maxBrakeTorque = 3000) annotation(
        Placement(transformation(origin = {-128, 58}, extent = {{-10, -10}, {10, 10}})));
      Parts.Brakes.DiscBrake brakeRR(maxBrakeTorque = 3000) annotation(
        Placement(transformation(origin = {-118, -64}, extent = {{-10, -10}, {10, 10}})));
      outer Modelica.Mechanics.MultiBody.World world;
  Parts.Transmission.MockTransmission mockTransmission annotation(
        Placement(transformation(origin = {-82, 2}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(mountFL.frame_b, mcphersonFL.chassisMount) annotation(
        Line(points = {{60, 40}, {100, 40}}, color = {95, 95, 95}));
      connect(mountFR.frame_b, mcphersonFR.chassisMount) annotation(
        Line(points = {{60, -40}, {100, -40}}, color = {95, 95, 95}));
      connect(mcphersonFL.wheelMount, tireFL.suspMount) annotation(
        Line(points = {{120, 40}, {140, 40}}, color = {95, 95, 95}));
      connect(mcphersonFR.wheelMount, tireFR.suspMount) annotation(
        Line(points = {{120, -40}, {140, -40}}, color = {95, 95, 95}));
      connect(multiLinkRL.wheelMount, tireRL.suspMount) annotation(
        Line(points = {{-120, 40}, {-140, 40}}, color = {95, 95, 95}));
      connect(multiLinkRR.wheelMount, tireRR.suspMount) annotation(
        Line(points = {{-120, -40}, {-140, -40}}, color = {95, 95, 95}));
      connect(multiLinkRL.chassisMount, mountRL.frame_b) annotation(
        Line(points = {{-100, 40}, {-80, 40}}, color = {95, 95, 95}));
      connect(multiLinkRR.chassisMount, mountRR.frame_b) annotation(
        Line(points = {{-100, -40}, {-80, -40}}, color = {95, 95, 95}));
      connect(solidAxle.right_out, tireRR.spinInput) annotation(
        Line(points = {{-152, -12}, {-152, -22}, {-174, -22}, {-174, -58}, {-154, -58}, {-154, -50}}));
      connect(solidAxle.left_out, tireRL.spinInput) annotation(
        Line(points = {{-152, 8}, {-152, 19}, {-154, 19}, {-154, 30}}));
      connect(steerAct1.flange, mcphersonFR.steerInput) annotation(
        Line(points = {{112, -12}, {124, -12}, {124, -26}, {110, -26}, {110, -30}}));
      connect(steerAct.flange, mcphersonFL.steerInput) annotation(
        Line(points = {{112, 10}, {128, 10}, {128, 60}, {110, 60}, {110, 50}}));
      connect(tireFL.wheelSupport, frame_FL) annotation(
        Line(points = {{160, 40}, {180, 40}, {180, 82}, {94, 82}, {94, 100}}, color = {95, 95, 95}));
      connect(tireFR.wheelSupport, frame_FR) annotation(
        Line(points = {{160, -40}, {174, -40}, {174, -100}, {94, -100}}, color = {95, 95, 95}));
      connect(tireRL.wheelSupport, frame_RL) annotation(
        Line(points = {{-160, 40}, {-180, 40}, {-180, 80}, {-150, 80}, {-150, 100}}, color = {95, 95, 95}));
      connect(tireRR.wheelSupport, frame_RR) annotation(
        Line(points = {{-160, -40}, {-202, -40}, {-202, -100}, {-150, -100}}, color = {95, 95, 95}));
      connect(steerInput, mockSteering.steerCmd) annotation(
        Line(points = {{42, 110}, {42, 24}, {51, 24}}, color = {0, 0, 127}));
      connect(mockSteering.steerAngle, steerAct.phi_ref) annotation(
        Line(points = {{69, 24}, {80, 24}, {80, 10}, {90, 10}}, color = {0, 0, 127}));
      connect(mockSteering.steerAngle, steerAct1.phi_ref) annotation(
        Line(points = {{69, 24}, {80, 24}, {80, -12}, {90, -12}}, color = {0, 0, 127}));
//connect(throttleInput, solidAxle.i) annotation(
//Line(points = {{-80, 110}, {-80, -2}, {-142, -2}}, color = {0, 0, 127}));
      connect(brakeFL.shaft, tireFL.brakeFlange) annotation(
        Line(points = {{154, 64}, {154, 52}, {150, 52}, {150, 40}}));
      connect(brakeFR.shaft, tireFR.brakeFlange) annotation(
        Line(points = {{138, -16}, {138, -40}, {150, -40}}));
      connect(brakeRL.shaft, tireRL.brakeFlange) annotation(
        Line(points = {{-138, 58}, {-168, 58}, {-168, 40}, {-150, 40}}));
      connect(brakeRR.shaft, tireRR.brakeFlange) annotation(
        Line(points = {{-128, -64}, {-128, -51}, {-150, -51}, {-150, -40}}));
      connect(brakeInput, brakeFL.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {164, 80}, {164, 74}}, color = {0, 0, 127}));
      connect(brakeInput, brakeFR.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {148, 80}, {148, -6}}, color = {0, 0, 127}));
      connect(brakeInput, brakeRL.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {-128, 80}, {-128, 68}}, color = {0, 0, 127}));
      connect(brakeInput, brakeRR.u) annotation(
        Line(points = {{0, 110}, {0, 80}, {-118, 80}, {-118, -54}}, color = {0, 0, 127}));
      connect(world.frame_b, freeMotion.frame_a) annotation(
        Line(points = {{-20, 100}, {-20, 44}, {-14, 44}}));
      connect(chassis_pos, chassis.frame_a) annotation(
        Line(points = {{-2, -102}, {0, -102}, {0, -10}}));
      connect(mountRL.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, 40}, {-26, 40}, {-26, -10}, {0, -10}}, color = {95, 95, 95}));
      connect(mountRR.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, -40}, {0, -40}, {0, -10}}, color = {95, 95, 95}));
      connect(mountFR.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, -40}, {0, -40}, {0, -10}}, color = {95, 95, 95}));
      connect(mountFL.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, 40}, {20, 40}, {20, -10}, {0, -10}}, color = {95, 95, 95}));
      connect(freeMotion.frame_b, chassis.frame_a) annotation(
        Line(points = {{6, 44}, {16, 44}, {16, -10}, {0, -10}}, color = {95, 95, 95}));
  connect(throttleInput, mockTransmission.pedalInput) annotation(
        Line(points = {{-80, 110}, {-82, 110}, {-82, 12}}, color = {0, 0, 127}));
  connect(mockTransmission.torqueOut, solidAxle.pedalInput) annotation(
        Line(points = {{-82, -8}, {-142, -8}, {-142, -2}}));
      annotation(
        Icon(graphics = {Line(points = {{-80, 60}, {-80, -60}, {80, -60}, {80, 60}, {-80, 60}, {-80, 60}}), Line(origin = {-2, 0}, points = {{-58, 40}, {-58, -40}, {62, -40}, {62, 40}, {-58, 40}, {-58, 40}, {-58, 40}}), Line(origin = {-0.193375, 0.27735}, points = {{-59.8066, 39.7226}, {-29.8066, 19.7226}, {-29.8066, -20.2774}, {-59.8066, -40.2774}, {-29.8066, -20.2774}, {40.1934, -20.2774}, {40.1934, 19.7226}, {-29.8066, 19.7226}, {40.1934, 19.7226}, {60.1934, 39.7226}, {40.1934, 19.7226}, {40.1934, -20.2774}, {60.1934, -40.2774}, {60.1934, -38.2774}})}),
        Documentation(info = "<html>
<body>
<h4>E36Car</h4>
<p>BMW E36 318is vehicle model. Rear-wheel drive. Dimensions: 4433 mm long, 1710 mm wide, 2700 mm wheelbase, 1180 kg total mass (1000 kg sprung). Front: <code>McPherson</code> strut (steerable, 20 kN/m, 2200 N&middot;s/m). Rear: <code>MultiLink</code> Z-axle (16 kN/m, 2200 N&middot;s/m). <code>DrivingTire</code> on rear axle, passive <code>Tire</code> on front. Tire: 195/65R15 (R = 0.31 m).</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>frame_FL</code></td><td>Frame_a</td><td>Front-left ground contact &mdash; connect to Road.FL</td></tr>
<tr><td><code>frame_FR</code></td><td>Frame_a</td><td>Front-right ground contact &mdash; connect to Road.FR</td></tr>
<tr><td><code>frame_RL</code></td><td>Frame_a</td><td>Rear-left ground contact &mdash; connect to Road.RL</td></tr>
<tr><td><code>frame_RR</code></td><td>Frame_a</td><td>Rear-right ground contact &mdash; connect to Road.RR</td></tr>
<tr><td><code>chassis_pos</code></td><td>Frame_a</td><td>Chassis reference frame</td></tr>
<tr><td><code>throttleInput</code></td><td>RealInput</td><td>Throttle command [0..1] &mdash; 0 = idle, 1 = full drive torque</td></tr>
<tr><td><code>steerInput</code></td><td>RealInput</td><td>Front-wheel steer command [-1..1] &mdash; &minus;1 = full left, +1 = full right (normalized; mapped to a road-wheel angle in rad by MockSteering)</td></tr>
<tr><td><code>brakeInput</code></td><td>RealInput</td><td>Brake demand [0=released, 1=fully applied]</td></tr>
</tbody>
</table>
<p><code>outer World world</code> is resolved from <code>Road</code>.</p>
</body>
</html>"));
    end E36Car;

    package Parts

      package Tires
        model Tire
          outer parameter Real R_wheel "Tire radius (m)";
          Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20, animation = false) annotation(
            Placement(transformation(origin = {-148, -40}, extent = {{210, 30}, {230, 50}})));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
            Placement(transformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
            Placement(transformation(origin = {-102, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
          Modelica.Mechanics.MultiBody.Joints.Revolute spinRL(n = {0, 0, -1}, useAxisFlange = true) annotation(
            Placement(transformation(origin = {168, -40}, extent = {{-150, 30}, {-130, 50}})));
          Components.TireVisualizer tireVisualizer(rTire = R_wheel) annotation(
            Placement(transformation(origin = {96, 46}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Rotational.Interfaces.Flange_b brakeFlange "External connection point for DiscBrake" annotation(
            Placement(transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 102}, extent = {{-10, -10}, {10, 10}})));
        equation
          connect(wheelSupport, wheelFL.frame_a) annotation(
            Line(points = {{100, 0}, {62, 0}}));
          connect(suspMount, spinRL.frame_a) annotation(
            Line(points = {{-102, 0}, {18, 0}}));
          connect(spinRL.frame_b, wheelFL.frame_a) annotation(
            Line(points = {{38, 0}, {62, 0}}, color = {95, 95, 95}));
          connect(tireVisualizer.frame_a, wheelFL.frame_a) annotation(
            Line(points = {{86, 46}, {62, 46}, {62, 0}}, color = {95, 95, 95}));
          connect(spinRL.axis, brakeFlange);
          annotation(
            Diagram(graphics),
            Icon(graphics = {Ellipse(origin = {-1, -4}, fillPattern = FillPattern.Solid, extent = {{-97, 94}, {97, -94}}), Ellipse(origin = {-1, -3}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-77, 73}, {77, -73}})}),
            Documentation(info = "<html>
<body>
<h4>Tire (passive)</h4>
<p>Non-driven wheel. A rigid <code>Body</code> (20 kg) connected through a free <code>Revolute</code> (spin axis <code>{0,0,-1}</code>) to the suspension. The tire can spin freely; no torque is applied. <code>outer parameter Real R_wheel</code> drives <code>TireVisualizer.rTire</code>.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>suspMount</code></td><td>Frame_a</td><td>Connects to suspension wheelMount</td></tr>
<tr><td><code>wheelSupport</code></td><td>Frame_a</td><td>Connects to road contact frame (Road.FL/FR/etc.)</td></tr>
</tbody>
</table>
</body>
</html>"));
        end Tire;

        model DrivingTire
          outer parameter Real R_wheel "Tire radius (m)";
          Modelica.Mechanics.MultiBody.Joints.Revolute spinFL(n = {0, 0, -1}, useAxisFlange = true) annotation(
            Placement(transformation(origin = {-148, -42}, extent = {{170, 30}, {190, 50}})));
          Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20, animation = false) annotation(
            Placement(transformation(origin = {-148, -42}, extent = {{210, 30}, {230, 50}})));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
            Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
          Modelica.Mechanics.Rotational.Interfaces.Flange_a spinInput annotation(
            Placement(transformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 102}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
            Placement(transformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, 2}, extent = {{-16, -16}, {16, 16}})));
          Components.TireVisualizer tireVisualizer(rTire = R_wheel) annotation(
            Placement(transformation(origin = {98, 56}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Rotational.Interfaces.Flange_b brakeFlange "External connection point for DiscBrake" annotation(
            Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -102}, extent = {{-10, -10}, {10, 10}})));
        equation
          connect(spinFL.frame_b, wheelFL.frame_a) annotation(
            Line(points = {{42, -2}, {62, -2}}, color = {95, 95, 95}));
          connect(wheelSupport, wheelFL.frame_a) annotation(
            Line(points = {{100, -2}, {62, -2}}));
          connect(spinInput, spinFL.axis) annotation(
            Line(points = {{32, 100}, {32, 8}}));
          connect(suspMount, spinFL.frame_a) annotation(
            Line(points = {{-102, -2}, {22, -2}}));
          connect(tireVisualizer.frame_a, wheelFL.frame_a) annotation(
            Line(points = {{88, 56}, {62, 56}, {62, -2}}, color = {95, 95, 95}));
          connect(spinFL.axis, brakeFlange);
          annotation(
            Icon(graphics = {Ellipse(origin = {-1, -4}, fillPattern = FillPattern.Solid, extent = {{-97, 94}, {97, -94}}), Ellipse(origin = {-1, -3}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-77, 73}, {77, -73}}), Rectangle(origin = {0, 46}, extent = {{-8, 54}, {8, -54}})}),
            Diagram(graphics),
            Documentation(info = "<html>
<body>
<h4>DrivingTire (driven)</h4>
<p>Driven wheel. Same structure as <code>Tire</code> but the <code>Revolute</code> has <code>useAxisFlange = true</code>, accepting a rotational input from the differential. The tire body has mass 20 kg.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>suspMount</code></td><td>Frame_a</td><td>Connects to suspension wheelMount</td></tr>
<tr><td><code>wheelSupport</code></td><td>Frame_a</td><td>Connects to road contact frame</td></tr>
<tr><td><code>spinInput</code></td><td>Flange_a</td><td>Driven by SolidAxle.left_out / right_out</td></tr>
</tbody>
</table>
</body>
</html>"));
        end DrivingTire;

        package Components
          model TireVisualizer "Visualizing a voluminous wheel"
            import Modelica.Mechanics.MultiBody.Visualizers;
            extends Modelica.Mechanics.MultiBody.Interfaces.PartialVisualizer;

            parameter Boolean animation=true "= true, if animation shall be enabled";

            parameter Modelica.Units.SI.Radius rTire=0.25 "Radius of the tire";
            parameter Modelica.Units.SI.Radius rRim= 0.14 "Radius of the rim";
            parameter Modelica.Units.SI.Radius width=0.25 "Width of the tire";
            parameter Modelica.Units.SI.Radius rCurvature=0.30 "Radius of the tire's cross section";

            parameter Modelica.Mechanics.MultiBody.Types.RealColor color={64,64,64}
              "Color of tire" annotation(Dialog(enable=animation, colorSelector=true, group="Material properties"));
            parameter Real specularCoefficient = 0.5
              "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(enable=animation, group="Material properties"));
            parameter Integer n_rTire=40 "Number of points along rTire" annotation(Dialog(enable=animation, tab="Discretization"));
            parameter Integer n_rCurvature=20 "Number of points along rCurvature" annotation(Dialog(enable=animation, tab="Discretization"));

          protected
            parameter Modelica.Units.SI.Radius rw = (width/2);
            parameter Modelica.Units.SI.Radius rCurvature2 = if rCurvature > rw then rCurvature else rw;
            final parameter Real kw = rw/rCurvature2 "Regularized width ratio (0...1)";
            parameter Modelica.Units.SI.Radius h =     sqrt(1 - kw*kw) * rCurvature2;
            parameter Modelica.Units.SI.Length ri =  rTire-rCurvature2;
            parameter Modelica.Units.SI.Radius rRim2 = if rRim < 0 then 0 else if rRim > ri+h then ri+h else rRim;

            Visualizers.Advanced.Shape pipe(
              shapeType="pipe",
              color=color,
              length=width,
              width=2*(ri + h),
              height=2*(ri + h),
              lengthDirection={0,0,1},
              widthDirection={0,1,0},
              extra=(rRim2)/(ri + h),
              r=frame_a.r_0,
              r_shape=-{0,0,1}*(width/2),
              R=frame_a.R,
              specularCoefficient=specularCoefficient) if world.enableAnimation and animation annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

            Visualizers.Advanced.Surface torus(
              redeclare function surfaceCharacteristic = Modelica.Mechanics.MultiBody.Visualizers.Advanced.SurfaceCharacteristics.torus (
                  R=ri,
                  r=rCurvature2,
                  opening=Modelica.Constants.pi - Modelica.Math.asin(kw)),
              nu=n_rTire,
              nv=n_rCurvature,
              multiColoredSurface=false,
              wireframe=false,
              color=color,
              specularCoefficient=specularCoefficient,
              transparency=0,
              R=frame_a.R,
              r_0=frame_a.r_0) if world.enableAnimation and animation annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

          equation
// No forces and torques
            frame_a.f = zeros(3);
            frame_a.t = zeros(3);
            annotation (
              Icon(
                graphics={
                  Polygon(lineColor = {64, 64, 64}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Sphere, points = {{-40, 80}, {-20, 90}, {15, 90}, {40, 85}, {58.776, 73.91}, {70.456, 56.568}, {74.951, 44.383}, {78.26, 30.614}, {80.302, 15.68}, {81, 0}, {81, 0}, {80.302, -15.68}, {78.26, -30.614}, {74.951, -44.383}, {70.456, -56.568}, {58.776, -73.91}, {40, -85}, {15, -90}, {-20, -90}, {-40, -80}, {-48.776, -73.91}, {-60.456, -56.568}, {-64.951, -44.383}, {-68.26, -30.614}, {-70.302, -15.68}, {-71, 0}, {-71, 0}, {-70.302, 15.68}, {-68.26, 30.614}, {-64.951, 44.383}, {-60.456, 56.568}, {-48.776, 73.91}}, smooth = Smooth.Bezier),
                  Polygon(lineColor = {64, 64, 64}, fillColor = {64, 64, 64}, fillPattern = FillPattern.Solid, points = {{1, 0}, {0.302, 15.68}, {-1.74, 30.614}, {-5.049, 44.383}, {-9.544, 56.568}, {-21.224, 73.91}, {-35, 80}, {-48.776, 73.91}, {-60.456, 56.568}, {-64.951, 44.383}, {-68.26, 30.614}, {-70.302, 15.68}, {-71, 0}, {-70.302, -15.68}, {-68.26, -30.614}, {-64.951, -44.383}, {-60.456, -56.568}, {-48.776, -73.91}, {-35, -80}, {-21.224, -73.91}, {-9.544, -56.568}, {-5.049, -44.383}, {-1.74, -30.614}, {0.302, -15.68}, {1, 0}}, smooth = Smooth.Bezier),
                  Polygon(lineColor = {64, 64, 64}, fillColor = {191, 191, 191}, fillPattern = FillPattern.HorizontalCylinder, points = {{-12.5, 0}, {-14.213, -19.134}, {-19.09, -35.355}, {-26.39, -46.194}, {-35, -50}, {-43.61, -46.194}, {-50.91, -35.355}, {-55.787, -19.134}, {-57.5, 0}, {-55.787, 19.134}, {-50.91, 35.355}, {-43.61, 46.194}, {-35, 50}, {-26.39, 46.194}, {-19.09, 35.355}, {-14.213, 19.134}, {-12.5, 0}}, smooth = Smooth.Bezier),
                  Text(textColor = {0,0,255}, extent = {{-150, 100}, {150, 140}}, textString = "%name"),
                  Rectangle(origin = {6.091, 0}, lineColor = {95, 95, 95}, fillColor = {215, 215, 215}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-102.091, -8}, {-19.142, 8}})},
                coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true)),
              Documentation(info = "<html>
<body>
<h4>TireVisualizer</h4>
<p>3D tire visualization using a torus (rubber sidewall) and a pipe shape (rim band). Extends <code>PartialVisualizer</code>. No forces or torques are applied.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>rTire</code></td><td>0.25 m</td><td>Overall tire radius</td></tr>
<tr><td><code>rRim</code></td><td>0.14 m</td><td>Rim inner radius</td></tr>
<tr><td><code>width</code></td><td>0.25 m</td><td>Tire width</td></tr>
<tr><td><code>rCurvature</code></td><td>0.30 m</td><td>Sidewall cross-section radius</td></tr>
<tr><td><code>color</code></td><td>{64, 64, 64}</td><td>Tire color (RGB)</td></tr>
<tr><td><code>specularCoefficient</code></td><td>0.5</td><td>Surface reflectivity</td></tr>
<tr><td><code>n_rTire</code></td><td>40</td><td>Points along tire circumference</td></tr>
<tr><td><code>n_rCurvature</code></td><td>20</td><td>Points along cross-section</td></tr>
</tbody>
</table>
<p><b>Connector:</b> <code>frame_a</code> (Frame_a, from PartialVisualizer) — attach to wheel body frame.</p>
</body>
</html>"));
          end TireVisualizer;
        end Components;

      end Tires;

      package Brakes

        model DiscBrake "Smooth Coulomb disc brake using tanh regularization"
          parameter Real maxBrakeTorque = 2000 "Peak braking torque at u=1 (N.m)";
          parameter Real sharpness = 10 "tanh knee (rad^-1.s); transition at ~1/sharpness rad/s";
          Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft "Connection to tire brake flange" annotation(
            Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
          Modelica.Blocks.Interfaces.RealInput u "Brake demand [0=released, 1=fully applied]" annotation(
            Placement(transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 102}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
        protected
          Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
            Placement(transformation(origin = {-40, -40}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Rotational.Sources.Torque brakeTorque(useSupport = false) annotation(
            Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Blocks.Sources.RealExpression tauExpr(y = -u * maxBrakeTorque * tanh(sharpness * speedSensor.w)) annotation(
            Placement(transformation(origin = {-10, 30}, extent = {{-10, -10}, {10, 10}})));
        equation
          connect(speedSensor.flange, shaft);
          connect(brakeTorque.flange, shaft);
          connect(tauExpr.y, brakeTorque.tau);
          annotation(
            Icon(graphics = {Ellipse(fillColor = {200, 200, 200}, fillPattern = FillPattern.Solid, extent = {{-80, 80}, {80, -80}}), Ellipse(fillColor = {120, 120, 120}, fillPattern = FillPattern.Solid, extent = {{-40, 40}, {40, -40}}), Line(points = {{-90, 0}, {-40, 0}}), Text(textColor = {0, 0, 255}, extent = {{-150, 100}, {150, 140}}, textString = "%name")}),
            Documentation(info = "<html>
<body>
<h4>DiscBrake</h4>
<p>Applies a smooth Coulomb braking torque to a rotational shaft. Connects externally to a
tire's <code>brakeFlange</code>.</p>
<p><b>Torque law:</b> &tau; = &minus;u &middot; maxBrakeTorque &middot; tanh(sharpness &middot; &omega;)</p>
<p>The <code>tanh</code> regularization avoids the discontinuity of <code>sign(&omega;)</code>
at zero speed, keeping the model C&sup1; continuous and event-free through zero. At
<code>sharpness=10</code> the transition region is &plusmn;0.1 rad/s.</p>
<p><code>useSupport=false</code> grounds the reaction torque internally; no external
<code>Fixed</code> component is needed.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>maxBrakeTorque</code></td><td>2000 N&middot;m</td><td>Peak torque at u=1</td></tr>
<tr><td><code>sharpness</code></td><td>10 rad<sup>-1</sup>&middot;s</td><td>tanh knee sharpness</td></tr>
</tbody>
</table>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>shaft</code></td><td>Flange_b</td><td>Connect to tire brakeFlange</td></tr>
<tr><td><code>u</code></td><td>RealInput</td><td>Brake demand [0..1]</td></tr>
</tbody>
</table>
</body>
</html>"));
        end DiscBrake;

      end Brakes;

      package Differentials

        model SolidAxle
          extends Components.Differential;
        equation
          connect(pedalInput, left_out);
          connect(pedalInput, right_out);
          annotation(
            Icon(graphics = {Rectangle(lineColor = {134, 159, 156}, fillColor = {185, 192, 194}, fillPattern = FillPattern.Solid, extent = {{-100, 20}, {100, -20}}), Rectangle(origin = {0, 40}, fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, -60}})}),
            Documentation(info = "<html>
<body>
<h4>SolidAxle</h4>
<p>Rigid (locked) rear axle. The drive-torque input flange <code>pedalInput</code> is connected
directly to both wheel output flanges, so the two rear wheels and the transmission output share a
single rotational node &mdash; equal angular velocity, no differential (speed-difference) action.
The torque delivered by the transmission flows mechanically through this node into the wheels; it
is not split or imposed by an internal source.</p>
<p>Because the coupling is a plain flange connection, any torque applied to the wheel flanges sums
on the shared node. A <code>DiscBrake</code> on a wheel flange therefore subtracts from the drive
torque and decelerates the axle, exactly as a real brake would.</p>
<p>This model has no parameters &mdash; drive effort is set upstream by the transmission
(<code>Parts.Transmission.MockTransmission.torqueValue</code>).</p>
</body>
</html>"));
        end SolidAxle;

        package Components
          partial model Differential
            Modelica.Mechanics.Rotational.Interfaces.Flange_a pedalInput annotation(
              Placement(transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 92}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
            Modelica.Mechanics.Rotational.Interfaces.Flange_a left_out annotation(
              Placement(transformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}})));
            Modelica.Mechanics.Rotational.Interfaces.Flange_a right_out annotation(
              Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
          equation
            annotation(
              uses(Modelica(version = "4.1.0")),
              Documentation(info = "<html>
<body>
<h4>Differential (partial)</h4>
<p>Base class for all differential / final-drive types. Defines only the common mechanical
interface: one rotational <b>torque input</b> flange (<code>pedalInput</code>, driven by the
transmission) and two rotational <b>wheel output</b> flanges (<code>left_out</code>,
<code>right_out</code>). It contains no equations &mdash; a concrete subclass decides how the input
torque reaches the two wheels.</p>
<p>Because all three connectors are rotational <code>Flange</code>s, torque flows through the
differential mechanically (the wheels' own inertia and the road contact determine the resulting
speed). This is what allows brake torque applied to the wheel flanges to sum with the drive torque
rather than being overridden by a kinematic speed constraint.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>pedalInput</code></td><td>Flange_a</td><td>Drive-torque input from the transmission</td></tr>
<tr><td><code>left_out</code></td><td>Flange_a</td><td>Left wheel rotational output</td></tr>
<tr><td><code>right_out</code></td><td>Flange_a</td><td>Right wheel rotational output</td></tr>
</tbody>
</table>
<p>Subclass example: <code>SolidAxle</code> connects <code>pedalInput</code> rigidly to both
outputs. An open or limited-slip differential would instead route the input through an
<code>IdealPlanetary</code> (or torque-split equations) to allow a speed difference between the two
wheels.</p>
</body>
</html>"));
          end Differential;
        end Components;

      end Differentials;

      package Suspension
        model SpringDamper
          Modelica.Mechanics.MultiBody.Joints.Prismatic suspRL(n = {0, 0, -1}, s(fixed = true, start = 0.1)) annotation(
            Placement(transformation(origin = {98, -48}, extent = {{-110, 30}, {-90, 50}})));
          Modelica.Mechanics.MultiBody.Forces.SpringDamperParallel shockRL(c = 30000, d = 2500, s_unstretched = 0.3) annotation(
            Placement(transformation(origin = {96, -48}, extent = {{-110, 60}, {-90, 80}})));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_b tireConnection annotation(
            Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, -2}, extent = {{-16, -16}, {16, 16}})));
          Modelica.Mechanics.MultiBody.Interfaces.Frame_b chassisMount annotation(
            Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}})));
        equation
          connect(shockRL.frame_a, suspRL.frame_a) annotation(
            Line(points = {{-14, 22}, {-30, 22}, {-30, -8}, {-12, -8}}, color = {95, 95, 95}));
          connect(suspRL.frame_a, tireConnection) annotation(
            Line(points = {{-12, -8}, {-100, -8}, {-100, 0}}, color = {95, 95, 95}));
          connect(suspRL.frame_b, chassisMount) annotation(
            Line(points = {{8, -8}, {100, -8}, {100, -2}}, color = {95, 95, 95}));
          connect(shockRL.frame_b, chassisMount) annotation(
            Line(points = {{6, 22}, {42, 22}, {42, -2}, {100, -2}}, color = {95, 95, 95}));
          annotation(
            Documentation(info = "<html>
<body>
<h4>SpringDamper</h4>
<p>Simple single-DOF suspension using a <code>Prismatic</code> joint (travel axis <code>{0,0,-1}</code>) and a parallel <code>SpringDamperParallel</code>.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Value</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>c</code></td><td>30000 N/m</td><td>Spring stiffness</td></tr>
<tr><td><code>d</code></td><td>2500 N&middot;s/m</td><td>Damping coefficient</td></tr>
<tr><td><code>s_unstretched</code></td><td>0.3 m</td><td>Free length</td></tr>
</tbody>
</table>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>tireConnection</code></td><td>Frame_b</td><td>Outboard (wheel side)</td></tr>
<tr><td><code>chassisMount</code></td><td>Frame_b</td><td>Inboard (chassis side)</td></tr>
</tbody>
</table>
</body>
</html>"));
        end SpringDamper;

        model DoubleWishbone
          extends Components.BaseSuspension;
          import MultiBody = Modelica.Mechanics.MultiBody;
          // --- Geometry parameters ---
          parameter Real sideSign = 1 "1 for left side, -1 for right side";
          parameter Modelica.Units.SI.Length upperArmLength = 0.35 "Upper control arm length";
          parameter Modelica.Units.SI.Length lowerArmLength = 0.35 "Lower control arm length";
          parameter Modelica.Units.SI.Length upperMountZ = 0.25 "Upper mount height above chassis mount";
          parameter Modelica.Units.SI.Length lowerMountZ = 0.15 "Lower mount height below chassis mount";
          parameter Modelica.Units.SI.Length shockTopHeight = 0.35 "Shock top mount height above chassis mount";
          // --- Elastic travel limiters (bump/droop stops) ---
          // The four-bar loop is closed by the analytic JointRRR, which loses a DOF (singular
          // position, jointUSR.revolute.k1a -> 0) if the suspension travels far enough. These
          // one-sided ElastoGap springs on the shock line halt travel before that geometry is
          // reached, so an overloaded corner bottoms/tops out instead of crashing the solver.
          parameter Boolean useEndStops = true "Enable elastic bump/droop travel limiters on the shock line";
          parameter Modelica.Units.SI.Length shockBumpLength = 0.28 "Shock length at which the bump (compression) stop engages";
          parameter Modelica.Units.SI.Length shockDroopLength = 0.66 "Shock length at which the droop (extension) stop engages";
          parameter Modelica.Units.SI.TranslationalSpringConstant endStopStiffness = 1e7 "Contact stiffness of the end-stops (N/m) - stiff so penetration stays small under large loads";
          parameter Modelica.Units.SI.TranslationalDampingConstant endStopDamping = 15000 "Contact damping of the end-stops (N.s/m)";
          parameter Real endStopExponent(min = 1) = 1 "End-stop contact force exponent (1 = linear, bounded penetration)";
          // --- Chassis-side offsets ---
          MultiBody.Parts.FixedTranslation upperChassisOffset(r={0, upperMountZ, 0}) annotation(
            Placement(transformation(extent={{-70, 20}, {-50, 40}})));
          MultiBody.Parts.FixedTranslation lowerChassisOffset(r={0, -lowerMountZ, 0}) annotation(
            Placement(transformation(extent={{-70, -40}, {-50, -20}})));
          // --- Upper A-arm (tree branch: the only regular revolute) ---
          MultiBody.Joints.Revolute upperChassisPivot(n={1, 0, 0}) annotation(
            Placement(transformation(extent={{-40, 20}, {-20, 40}})));
          MultiBody.Parts.BodyCylinder upperArm(r={0, 0, sideSign*upperArmLength}, diameter=0.03) annotation(
            Placement(transformation(extent={{-10, 20}, {10, 40}})));
          // --- Closed-loop: JointRRR handles 3 revolutes + 2 rods analytically ---
          MultiBody.Joints.Assemblies.JointRRR jointLoop(
            rRod1_ia={0, -(upperMountZ + lowerMountZ), 0},
            rRod2_ib={0, 0, sideSign*lowerArmLength},
            n_a={1, 0, 0}) annotation(
            Placement(transformation(origin = {90, 2},extent = {{20, -40}, {60, 40}}, rotation = 180)));
          // --- Hub/knuckle mass at the upper ball joint, CM at knuckle center ---
          MultiBody.Parts.Body hub(m=m_hub,
            r_CM={0, -(upperMountZ + lowerMountZ)/2, 0},
            I_11=0.1, I_22=0.1, I_33=0.1) annotation(
            Placement(transformation(origin = {18, 28}, extent = {{70, 20}, {90, 40}})));
          // --- Shock top mount (above chassis for proper vertical force transfer) ---
          MultiBody.Parts.FixedTranslation shockTopMount(r={0, shockTopHeight, 0}) annotation(
            Placement(transformation(extent={{-70, 50}, {-50, 70}})));
          // --- Wheel center offset (from upper ball joint down to knuckle midpoint) ---
          MultiBody.Parts.FixedTranslation wheelOffset(r={0, -(upperMountZ + lowerMountZ)/2, 0}) annotation(
            Placement(transformation(extent={{60, -10}, {80, 10}})));
          // --- Steering revolute (axis always exposed; locked by steerLock when steerable=false) ---
          MultiBody.Joints.Revolute steer(
            n = {0, 1, 0},
            useAxisFlange = true) annotation(
            Placement(transformation(origin = {-6, 18}, extent = {{82, -10}, {102, 10}})));
          Modelica.Mechanics.Rotational.Components.Fixed steerLock if not steerable annotation(
            Placement(transformation(origin = {76, 40}, extent = {{-6, -6}, {6, 6}})));
          // --- Spring-damper ---
          MultiBody.Forces.SpringDamperParallel shock(c=k_spring, d=d_damper, s_unstretched=0.55) annotation(
            Placement(transformation(origin = {-14, -2}, extent = {{-20, -80}, {0, -60}})));
          // --- End-stops: a massless line force on the shock axis carrying two one-sided springs.
          //     LineForceWithMass exposes flange_a.s = 0 and flange_b.s = (shock length), so an
          //     ElastoGap across the flanges resists compression (bump); reversing the flanges and
          //     negating s_rel0 makes a second ElastoGap resist extension (droop). ---
          MultiBody.Forces.LineForceWithMass endStop(m = 0, animateLine = false, animateMass = false) if useEndStops annotation(
            Placement(transformation(origin = {30, -52}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Translational.Components.ElastoGap bumpStop(c = endStopStiffness, d = endStopDamping, s_rel0 = shockBumpLength, n = endStopExponent) if useEndStops annotation(
            Placement(transformation(origin = {30, -76}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Translational.Components.ElastoGap droopStop(c = endStopStiffness, d = endStopDamping, s_rel0 = -shockDroopLength, n = endStopExponent) if useEndStops annotation(
            Placement(transformation(origin = {30, -96}, extent = {{-10, -10}, {10, 10}})));

        equation
// Chassis-side: split into upper and lower mount points
          connect(chassisMount, upperChassisOffset.frame_a) annotation(
            Line(points={{-100, 0}, {-80, 0}, {-80, 30}, {-70, 30}}, color={95, 95, 95}));
          connect(chassisMount, lowerChassisOffset.frame_a) annotation(
            Line(points={{-100, 0}, {-80, 0}, {-80, -30}, {-70, -30}}, color={95, 95, 95}));
// Tree branch: upper chassis pivot → upper A-arm
          connect(upperChassisOffset.frame_b, upperChassisPivot.frame_a) annotation(
            Line(points={{-50, 30}, {-40, 30}}, color={95, 95, 95}));
          connect(upperChassisPivot.frame_b, upperArm.frame_a) annotation(
            Line(points={{-20, 30}, {-10, 30}}, color={95, 95, 95}));
// JointRRR closes the loop analytically
          connect(upperArm.frame_b, jointLoop.frame_a) annotation(
            Line(points={{10, 30}, {16, 30}, {16, 2}, {70, 2}}, color={95, 95, 95}));
          connect(lowerChassisOffset.frame_b, jointLoop.frame_b) annotation(
            Line(points={{-50, -30}, {30, -30}, {30, 2}}, color={95, 95, 95}));
// Hub body at knuckle top (frame_ia = after first revolute of JointRRR)
          connect(jointLoop.frame_ia, hub.frame_a) annotation(
            Line(points={{66, -38}, {66, 58}, {88, 58}}, color={95, 95, 95}));
// Wheel output at knuckle center (offset down from upper ball joint)
          connect(jointLoop.frame_ia, wheelOffset.frame_a) annotation(
            Line(points={{66, -38}, {66, 50}, {60, 50}, {60, 0}}, color={95, 95, 95}));
          connect(wheelOffset.frame_b, steer.frame_a) annotation(
            Line(points = {{80, 0}, {80, 10}, {76, 10}, {76, 18}}, color = {95, 95, 95}));
// Shock: top mount above chassis to lower ball-joint point (middle revolute = frame_im)
          connect(chassisMount, shockTopMount.frame_a) annotation(
            Line(points={{-100, 0}, {-80, 0}, {-80, 60}, {-70, 60}}, color={95, 95, 95}));
          connect(shockTopMount.frame_b, shock.frame_a) annotation(
            Line(points={{-50, 60}, {-34, 60}, {-34, -72}}, color={95, 95, 95}));
          connect(jointLoop.frame_im, shock.frame_b) annotation(
            Line(points={{50, -38}, {50, -56}, {-14, -56}, {-14, -72}}, color={95, 95, 95}));
// End-stops: same two frames as the shock; ElastoGaps act on the 1-D flanges.
          connect(shockTopMount.frame_b, endStop.frame_a) annotation(
            Line(points={{-50, 60}, {20, 60}, {20, -52}}, color={95, 95, 95}));
          connect(endStop.frame_b, jointLoop.frame_im) annotation(
            Line(points={{40, -52}, {50, -52}, {50, -38}}, color={95, 95, 95}));
          connect(bumpStop.flange_a, endStop.flange_a);
          connect(bumpStop.flange_b, endStop.flange_b);
          connect(droopStop.flange_a, endStop.flange_b);
          connect(droopStop.flange_b, endStop.flange_a);
          connect(steerInput, steer.axis) annotation(
            Line(points = {{0, 100}, {0, 44}, {86, 44}, {86, 28}}));
          connect(steer.axis, steerLock.flange) annotation(
            Line(points = {{86, 28}, {86, 40}, {82, 40}}));
          connect(steer.frame_b, wheelMount) annotation(
            Line(points = {{96, 18}, {114, 18}, {114, 0}, {100, 0}}, color = {95, 95, 95}));
          annotation(Icon(graphics={
            Line(points={{-80, 30}, {0, 50}}, color={95, 95, 95}, thickness=1),
            Line(points={{-80, -30}, {0, -50}}, color={95, 95, 95}, thickness=1),
            Line(points={{0, 50}, {0, -50}}, color={0, 0, 0}, thickness=1.5),
            Ellipse(extent={{-6, 6}, {6, -6}}, origin={0, 50}, fillColor={95, 95, 95}, fillPattern=FillPattern.Solid),
            Ellipse(extent={{-6, 6}, {6, -6}}, origin={0, -50}, fillColor={95, 95, 95}, fillPattern=FillPattern.Solid),
            Line(points={{-80, 30}, {-80, -30}}, color={0, 0, 0}, thickness=2),
            Line(points={{-60, 60}, {-40, -60}}, color={0, 128, 0}, pattern=LinePattern.DashDot, thickness=0.5),
            Text(extent={{-100, -80}, {100, -100}}, textString="%name")}),
            Documentation(info = "<html>
<body>
<h4>DoubleWishbone</h4>
<p>Double A-arm suspension. Uses a <code>JointRRR</code> assembly to close the four-bar kinematic loop analytically. Front instances (<code>steerable = true</code>) include an active steering revolute; rear instances lock it via <code>steerLock</code>. Extends <code>BaseSuspension</code>.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>sideSign</code></td><td>1</td><td>1 = left side, -1 = right side (mirrors Z geometry)</td></tr>
<tr><td><code>upperArmLength</code></td><td>0.35 m</td><td>Upper A-arm outboard length</td></tr>
<tr><td><code>lowerArmLength</code></td><td>0.35 m</td><td>Lower A-arm outboard length</td></tr>
<tr><td><code>upperMountZ</code></td><td>0.25 m</td><td>Upper ball-joint height above chassis mount</td></tr>
<tr><td><code>lowerMountZ</code></td><td>0.15 m</td><td>Lower ball-joint depth below chassis mount</td></tr>
<tr><td><code>shockTopHeight</code></td><td>0.35 m</td><td>Shock absorber top mount height above chassis mount</td></tr>
<tr><td><code>useEndStops</code></td><td>true</td><td>Enable the elastic bump/droop travel limiters</td></tr>
<tr><td><code>shockBumpLength</code></td><td>0.28 m</td><td>Shock length at which the bump (compression) stop engages</td></tr>
<tr><td><code>shockDroopLength</code></td><td>0.66 m</td><td>Shock length at which the droop (extension) stop engages</td></tr>
<tr><td><code>endStopStiffness</code></td><td>1&times;10<sup>7</sup> N/m</td><td>Contact stiffness of the end-stops (stiff, so penetration stays small)</td></tr>
<tr><td><code>endStopDamping</code></td><td>15000 N&middot;s/m</td><td>Contact damping of the end-stops</td></tr>
<tr><td><code>endStopExponent</code></td><td>1</td><td>Contact force exponent (1 = linear, bounded penetration)</td></tr>
</tbody>
</table>
<p>Spring/damper parameters come from <code>BaseSuspension</code>: <code>k_spring</code> and <code>d_damper</code>. Shock free length is 0.55 m.</p>
<p><b>Travel limiters.</b> The analytic <code>JointRRR</code> loses a degree of freedom (singular position,
<code>jointUSR.revolute.k1a</code> &rarr; 0) if the suspension is driven far enough into bump or droop &mdash; e.g.
under a very large drive torque a corner can compress until the wishbone arms approach the singular geometry, which
aborts the solver. Two one-sided <code>ElastoGap</code> springs mounted on the shock line (via a massless
<code>LineForceWithMass</code>) halt travel before that geometry is reached: the corner bottoms/tops out on a stiff
elastic stop instead of crashing. They act only outside the normal travel band, so ride behaviour is unchanged. Set
<code>useEndStops = false</code> to disable them, or widen <code>shockBumpLength</code>/<code>shockDroopLength</code> to
change where they engage.</p>
</body>
</html>"));
        end DoubleWishbone;

        model McPherson
          extends Components.BaseSuspension;
          import MultiBody = Modelica.Mechanics.MultiBody;
          parameter Real sideSign = 1 "1 for left side, -1 for right side";
          parameter Modelica.Units.SI.Length shockTopHeight = 0.28 "Spring seat height above chassis attachment";
          // Wheel offset from strut bottom: compensates for the missing lower arm geometry.
          // wheelOffsetY lifts the wheel above the strut bottom (knuckle height effect).
          // wheelOffsetZ moves the wheel outboard to restore the correct track width.
          // Set these in the car model to match the lateral and vertical extent of the
          // rear suspension links so front and rear tracks/ride heights are consistent.
          parameter Modelica.Units.SI.Length wheelOffsetY = 0 "Wheel center height above strut bottom";
          parameter Modelica.Units.SI.Length wheelOffsetZ = 0 "Lateral outboard offset from strut to wheel center";
          // --- Elastic travel limiters (bump/droop stops) ---
          // The strut is a plain Prismatic joint, so there is no analytic-loop singularity here, but an
          // unbounded strut can over-travel (the wheel is pulled up through the chassis, strut s -> 0 or
          // negative, under heavy load). These one-sided ElastoGap springs on the shock line bound the
          // travel so the strut bottoms/tops out on an elastic stop instead.
          parameter Boolean useEndStops = true "Enable elastic bump/droop travel limiters on the shock line";
          parameter Modelica.Units.SI.Length shockBumpLength = 0.31 "Shock length at which the bump (compression) stop engages";
          parameter Modelica.Units.SI.Length shockDroopLength = 0.62 "Shock length at which the droop (extension) stop engages";
          parameter Modelica.Units.SI.TranslationalSpringConstant endStopStiffness = 1e7 "Contact stiffness of the end-stops (N/m) - stiff so penetration stays small under large loads";
          parameter Modelica.Units.SI.TranslationalDampingConstant endStopDamping = 15000 "Contact damping of the end-stops (N.s/m)";
          parameter Real endStopExponent(min = 1) = 1 "End-stop contact force exponent (1 = linear, bounded penetration)";
          // --- Shock top mount on chassis ---
          MultiBody.Parts.FixedTranslation shockTopMount(r = {0, shockTopHeight, 0}) annotation(
            Placement(transformation(extent = {{-60, 40}, {-40, 60}})));
          // --- Strut: purely vertical Prismatic, no kinematic loop ---
          MultiBody.Joints.Prismatic strutTravel(n = {0, -1, 0},
            s(start = 0.30, fixed = false),
            v(start = 0, fixed = false)) annotation(
            Placement(transformation(extent = {{-20, -10}, {0, 10}})));
          // --- Knuckle offset: lateral + vertical displacement from strut bottom to wheel center ---
          // Represents the effect of the lower control arm (lateral) and knuckle height (vertical).
          MultiBody.Parts.FixedTranslation knuckleOffset(r = {0, wheelOffsetY, sideSign * wheelOffsetZ}) annotation(
            Placement(transformation(extent = {{10, -10}, {30, 10}})));
          // --- Hub/knuckle mass at wheel center ---
          MultiBody.Parts.Body hub(m = m_hub,
            r_CM = {0, 0, 0},
            I_11 = 0.1, I_22 = 0.1, I_33 = 0.1) annotation(
            Placement(transformation(extent = {{40, 10}, {60, 30}})));
          // --- Steering revolute ---
          MultiBody.Joints.Revolute steer(
            n = {0, 1, 0},
            useAxisFlange = true) annotation(
            Placement(transformation(extent = {{60, -10}, {80, 10}})));
          Modelica.Mechanics.Rotational.Components.Fixed steerLock if not steerable annotation(
            Placement(transformation(extent = {{60, 20}, {80, 40}})));
          // --- Spring-damper: shock top mount to strut bottom (not wheel center) ---
          // Free length = sqrt(shockTopHeight^2 + s_rest^2) = sqrt(0.28^2+0.30^2) ~ 0.41 m
          MultiBody.Forces.SpringDamperParallel shock(c = k_spring, d = d_damper, s_unstretched = 0.41) annotation(
            Placement(transformation(extent = {{-40, -40}, {-20, -20}})));
          // --- End-stops on the shock line (see DoubleWishbone for the wiring rationale) ---
          MultiBody.Forces.LineForceWithMass endStop(m = 0, animateLine = false, animateMass = false) if useEndStops annotation(
            Placement(transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Translational.Components.ElastoGap bumpStop(c = endStopStiffness, d = endStopDamping, s_rel0 = shockBumpLength, n = endStopExponent) if useEndStops annotation(
            Placement(transformation(origin = {-30, -78}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Translational.Components.ElastoGap droopStop(c = endStopStiffness, d = endStopDamping, s_rel0 = -shockDroopLength, n = endStopExponent) if useEndStops annotation(
            Placement(transformation(origin = {-30, -94}, extent = {{-10, -10}, {10, 10}})));

        equation
          connect(chassisMount, strutTravel.frame_a) annotation(
            Line(points = {{-100, 0}, {-20, 0}}, color = {95, 95, 95}));
          connect(strutTravel.frame_b, knuckleOffset.frame_a) annotation(
            Line(points = {{0, 0}, {10, 0}}, color = {95, 95, 95}));
          connect(knuckleOffset.frame_b, hub.frame_a) annotation(
            Line(points = {{30, 0}, {40, 20}}, color = {95, 95, 95}));
          connect(knuckleOffset.frame_b, steer.frame_a) annotation(
            Line(points = {{30, 0}, {60, 0}}, color = {95, 95, 95}));
          connect(steer.frame_b, wheelMount) annotation(
            Line(points = {{80, 0}, {100, 0}}, color = {95, 95, 95}));
          connect(chassisMount, shockTopMount.frame_a) annotation(
            Line(points = {{-100, 0}, {-80, 0}, {-80, 50}, {-60, 50}}, color = {95, 95, 95}));
          connect(shockTopMount.frame_b, shock.frame_a) annotation(
            Line(points = {{-40, 50}, {-30, 50}, {-30, -20}}, color = {95, 95, 95}));
          connect(strutTravel.frame_b, shock.frame_b) annotation(
            Line(points = {{0, 0}, {10, 0}, {10, -30}, {-20, -30}}, color = {95, 95, 95}));
// End-stops: same two frames as the shock; ElastoGaps act on the 1-D flanges.
          connect(shockTopMount.frame_b, endStop.frame_a) annotation(
            Line(points = {{-40, 50}, {-30, 50}, {-30, -60}}, color = {95, 95, 95}));
          connect(endStop.frame_b, strutTravel.frame_b) annotation(
            Line(points = {{-20, -60}, {10, -60}, {10, 0}}, color = {95, 95, 95}));
          connect(bumpStop.flange_a, endStop.flange_a);
          connect(bumpStop.flange_b, endStop.flange_b);
          connect(droopStop.flange_a, endStop.flange_b);
          connect(droopStop.flange_b, endStop.flange_a);
          connect(steerInput, steer.axis) annotation(
            Line(points = {{0, 100}, {70, 100}, {70, 10}}));
          connect(steer.axis, steerLock.flange) annotation(
            Line(points = {{70, 10}, {70, 20}}));
          annotation(Icon(graphics = {
            Line(points = {{-80, -30}, {0, -50}}, color = {95, 95, 95}, thickness = 1),
            Line(points = {{-20, 60}, {0, -50}}, color = {95, 95, 95}, thickness = 1.5),
            Ellipse(extent = {{-6, 6}, {6, -6}}, origin = {0, -50}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid),
            Ellipse(extent = {{-6, 6}, {6, -6}}, origin = {-20, 60}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid),
            Line(points = {{-80, -30}, {-80, 20}}, color = {0, 0, 0}, thickness = 2),
            Line(points = {{-22, 55}, {-18, 55}, {-20, 60}, {-22, 65}, {-18, 65}}, color = {0, 128, 0}, thickness = 0.75),
            Text(extent = {{-100, -80}, {100, -100}}, textString = "%name")}),
            Documentation(info = "<html>
<body>
<h4>McPherson</h4>
<p>Simplified MacPherson strut suspension. Vertical wheel travel is a single <code>Prismatic</code> joint (strut DOF). A <code>knuckleOffset</code> <code>FixedTranslation</code> then displaces the wheel centre upward by <code>wheelOffsetY</code> and outboard by <code>wheelOffsetZ</code> to compensate for the lower control arm geometry that is not modelled kinematically. Set these two parameters in the car model so that front and rear track widths and ride heights are consistent with the rear suspension link lengths. The spring-damper connects the fixed top mount to the strut bottom (not the wheel centre), keeping the force direction along the strut axis. Extends <code>BaseSuspension</code>.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>sideSign</code></td><td>1</td><td>1 = left side, -1 = right side</td></tr>
<tr><td><code>shockTopHeight</code></td><td>0.28 m</td><td>Spring seat height above chassis attachment point</td></tr>
<tr><td><code>wheelOffsetY</code></td><td>0 m</td><td>Wheel centre height above strut bottom (knuckle height effect)</td></tr>
<tr><td><code>wheelOffsetZ</code></td><td>0 m</td><td>Lateral outboard offset from strut to wheel centre (lower arm lateral effect)</td></tr>
<tr><td><code>useEndStops</code></td><td>true</td><td>Enable the elastic bump/droop travel limiters</td></tr>
<tr><td><code>shockBumpLength</code></td><td>0.31 m</td><td>Shock length at which the bump (compression) stop engages</td></tr>
<tr><td><code>shockDroopLength</code></td><td>0.62 m</td><td>Shock length at which the droop (extension) stop engages</td></tr>
<tr><td><code>endStopStiffness</code></td><td>1&times;10<sup>7</sup> N/m</td><td>Contact stiffness of the end-stops (stiff, so penetration stays small)</td></tr>
<tr><td><code>endStopDamping</code></td><td>15000 N&middot;s/m</td><td>Contact damping of the end-stops</td></tr>
<tr><td><code>endStopExponent</code></td><td>1</td><td>Contact force exponent (1 = linear, bounded penetration)</td></tr>
</tbody>
</table>
<p>Spring/damper from <code>BaseSuspension</code>: <code>k_spring</code>, <code>d_damper</code>. Natural length 0.41 m (zero spring force at s &asymp; 0.30 m strut compression).</p>
<p><b>Travel limiters.</b> Unlike <code>DoubleWishbone</code>/<code>MultiLink</code>, the strut is a plain
<code>Prismatic</code> joint, so there is no analytic-loop singularity to trip. The elastic stops here instead prevent
the strut from over-travelling (under heavy load the wheel is otherwise pulled up until the strut coordinate
<code>s</code> reaches 0 or goes negative). Disable with <code>useEndStops = false</code>.</p>
</body>
</html>"));
        end McPherson;

        model MultiLink
          extends Components.BaseSuspension;
          import MultiBody = Modelica.Mechanics.MultiBody;
          // --- Geometry parameters ---
          parameter Real sideSign = 1 "1 for left side, -1 for right side";
          parameter Modelica.Units.SI.Length upperLinkLength = 0.30 "Upper transverse link length";
          parameter Modelica.Units.SI.Length lowerLinkLength = 0.38 "Lower link length";
          parameter Modelica.Units.SI.Length upperMountZ = 0.22 "Upper link height above chassis mount";
          parameter Modelica.Units.SI.Length lowerMountZ = 0.12 "Lower link height below chassis mount";
          parameter Modelica.Units.SI.Length rearLinkOffset = 0.08 "Fore-aft offset of lower link chassis pivot (X)";
          parameter Modelica.Units.SI.Length shockTopHeight = 0.32 "Shock top mount height above chassis mount";
          // --- Elastic travel limiters (bump/droop stops) ---
          // Same rationale as DoubleWishbone: the lower link is closed by an analytic JointRRR that
          // loses a DOF (jointUSR.revolute.k1a -> 0) near full bump. One-sided ElastoGap springs on
          // the shock line halt travel before that singular geometry (~0.10 m shock length) is reached.
          parameter Boolean useEndStops = true "Enable elastic bump/droop travel limiters on the shock line";
          parameter Modelica.Units.SI.Length shockBumpLength = 0.31 "Shock length at which the bump (compression) stop engages";
          parameter Modelica.Units.SI.Length shockDroopLength = 0.62 "Shock length at which the droop (extension) stop engages";
          parameter Modelica.Units.SI.TranslationalSpringConstant endStopStiffness = 1e7 "Contact stiffness of the end-stops (N/m) - stiff so penetration stays small under large loads";
          parameter Modelica.Units.SI.TranslationalDampingConstant endStopDamping = 15000 "Contact damping of the end-stops (N.s/m)";
          parameter Real endStopExponent(min = 1) = 1 "End-stop contact force exponent (1 = linear, bounded penetration)";
          // --- Chassis-side offsets ---
          MultiBody.Parts.FixedTranslation upperChassisOffset(r = {0, upperMountZ, 0}) annotation(
            Placement(transformation(extent = {{-70, 20}, {-50, 40}})));
          MultiBody.Parts.FixedTranslation lowerChassisOffset(r = {rearLinkOffset, -lowerMountZ, 0}) annotation(
            Placement(transformation(extent = {{-70, -40}, {-50, -20}})));
          // --- Upper link (tree branch) ---
          MultiBody.Joints.Revolute upperLinkPivot(n = {1, 0, 0}) annotation(
            Placement(transformation(extent = {{-40, 20}, {-20, 40}})));
          MultiBody.Parts.BodyCylinder upperLink(r = {0, 0, sideSign * upperLinkLength}, diameter = 0.025) annotation(
            Placement(transformation(extent = {{-10, 20}, {10, 40}})));
          // --- Loop closure via JointRRR (same assembly as DoubleWishbone) ---
          MultiBody.Joints.Assemblies.JointRRR lowerLoop(
            rRod1_ia = {0, -(upperMountZ + lowerMountZ), 0},
            rRod2_ib = {0, 0, sideSign * lowerLinkLength},
            n_a = {1, 0, 0}) annotation(
            Placement(transformation(origin = {90, 2}, extent = {{20, -40}, {60, 40}}, rotation = 180)));
          // --- Hub/knuckle mass ---
          MultiBody.Parts.Body hub(m = m_hub,
            r_CM = {0, -(upperMountZ + lowerMountZ) / 2, 0},
            I_11 = 0.1, I_22 = 0.1, I_33 = 0.1) annotation(
            Placement(transformation(origin = {18, 28}, extent = {{70, 20}, {90, 40}})));
          // --- Shock top mount ---
          MultiBody.Parts.FixedTranslation shockTopMount(r = {0, shockTopHeight, 0}) annotation(
            Placement(transformation(extent = {{-70, 50}, {-50, 70}})));
          // --- Wheel center offset ---
          MultiBody.Parts.FixedTranslation wheelOffset(r = {0, -(upperMountZ + lowerMountZ) / 2, 0}) annotation(
            Placement(transformation(origin = {20, -26}, extent = {{60, -10}, {80, 10}})));
          // --- Steering revolute (locked when steerable=false) ---
          MultiBody.Joints.Revolute steer(
            n = {0, 1, 0},
            useAxisFlange = true) annotation(
            Placement(transformation(origin = {-6, 18}, extent = {{82, -10}, {102, 10}})));
          Modelica.Mechanics.Rotational.Components.Fixed steerLock if not steerable annotation(
            Placement(transformation(origin = {76, 40}, extent = {{-6, -6}, {6, 6}})));
          // --- Spring-damper ---
          MultiBody.Forces.SpringDamperParallel shock(c = k_spring, d = d_damper, s_unstretched = 0.50) annotation(
            Placement(transformation(origin = {-14, -2}, extent = {{-20, -80}, {0, -60}})));
          // --- End-stops on the shock line (see DoubleWishbone for the wiring rationale) ---
          MultiBody.Forces.LineForceWithMass endStop(m = 0, animateLine = false, animateMass = false) if useEndStops annotation(
            Placement(transformation(origin = {30, -52}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Translational.Components.ElastoGap bumpStop(c = endStopStiffness, d = endStopDamping, s_rel0 = shockBumpLength, n = endStopExponent) if useEndStops annotation(
            Placement(transformation(origin = {30, -76}, extent = {{-10, -10}, {10, 10}})));
          Modelica.Mechanics.Translational.Components.ElastoGap droopStop(c = endStopStiffness, d = endStopDamping, s_rel0 = -shockDroopLength, n = endStopExponent) if useEndStops annotation(
            Placement(transformation(origin = {30, -96}, extent = {{-10, -10}, {10, 10}})));

        equation
// Chassis-side: upper and lower link mounts
          connect(chassisMount, upperChassisOffset.frame_a) annotation(
            Line(points = {{-100, 0}, {-80, 0}, {-80, 30}, {-70, 30}}, color = {95, 95, 95}));
          connect(chassisMount, lowerChassisOffset.frame_a) annotation(
            Line(points = {{-100, 0}, {-80, 0}, {-80, -30}, {-70, -30}}, color = {95, 95, 95}));
// Tree branch: upper transverse link
          connect(upperChassisOffset.frame_b, upperLinkPivot.frame_a) annotation(
            Line(points = {{-50, 30}, {-40, 30}}, color = {95, 95, 95}));
          connect(upperLinkPivot.frame_b, upperLink.frame_a) annotation(
            Line(points = {{-20, 30}, {-10, 30}}, color = {95, 95, 95}));
// JointRRR closes the lower link loop
          connect(upperLink.frame_b, lowerLoop.frame_a) annotation(
            Line(points = {{10, 30}, {16, 30}, {16, 2}, {70, 2}}, color = {95, 95, 95}));
          connect(lowerChassisOffset.frame_b, lowerLoop.frame_b) annotation(
            Line(points = {{-50, -30}, {30, -30}, {30, 2}}, color = {95, 95, 95}));
// Hub and wheel output
          connect(lowerLoop.frame_ia, hub.frame_a) annotation(
            Line(points = {{66, -38}, {66, 58}, {88, 58}}, color = {95, 95, 95}));
          connect(lowerLoop.frame_ia, wheelOffset.frame_a) annotation(
            Line(points = {{66, -38}, {66, -25}, {80, -25}, {80, -26}}, color = {95, 95, 95}));
          connect(wheelOffset.frame_b, steer.frame_a) annotation(
            Line(points = {{100, -26}, {100, 10}, {76, 10}, {76, 18}}, color = {95, 95, 95}));
          connect(steer.frame_b, wheelMount) annotation(
            Line(points = {{96, 18}, {114, 18}, {114, 0}, {100, 0}}, color = {95, 95, 95}));
// Shock: top mount to lower ball joint (frame_im)
          connect(chassisMount, shockTopMount.frame_a) annotation(
            Line(points = {{-100, 0}, {-80, 0}, {-80, 60}, {-70, 60}}, color = {95, 95, 95}));
          connect(shockTopMount.frame_b, shock.frame_a) annotation(
            Line(points = {{-50, 60}, {-34, 60}, {-34, -72}}, color = {95, 95, 95}));
          connect(lowerLoop.frame_im, shock.frame_b) annotation(
            Line(points = {{50, -38}, {50, -56}, {-14, -56}, {-14, -72}}, color = {95, 95, 95}));
// End-stops: same two frames as the shock; ElastoGaps act on the 1-D flanges.
          connect(shockTopMount.frame_b, endStop.frame_a) annotation(
            Line(points = {{-50, 60}, {20, 60}, {20, -52}}, color = {95, 95, 95}));
          connect(endStop.frame_b, lowerLoop.frame_im) annotation(
            Line(points = {{40, -52}, {50, -52}, {50, -38}}, color = {95, 95, 95}));
          connect(bumpStop.flange_a, endStop.flange_a);
          connect(bumpStop.flange_b, endStop.flange_b);
          connect(droopStop.flange_a, endStop.flange_b);
          connect(droopStop.flange_b, endStop.flange_a);
// Steering
          connect(steerInput, steer.axis) annotation(
            Line(points = {{0, 100}, {0, 44}, {86, 44}, {86, 28}}));
          connect(steer.axis, steerLock.flange) annotation(
            Line(points = {{86, 28}, {86, 40}, {82, 40}}));
          annotation(Icon(graphics = {
            Line(points = {{-80, 30}, {0, 50}}, color = {95, 95, 95}, thickness = 0.75),
            Line(points = {{-70, 0}, {0, 50}}, color = {95, 95, 95}, thickness = 0.75),
            Line(points = {{-80, -30}, {0, -50}}, color = {95, 95, 95}, thickness = 0.75),
            Line(points = {{0, 50}, {0, -50}}, color = {0, 0, 0}, thickness = 1.5),
            Ellipse(extent = {{-6, 6}, {6, -6}}, origin = {0, 50}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid),
            Ellipse(extent = {{-6, 6}, {6, -6}}, origin = {0, -50}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid),
            Line(points = {{-80, 30}, {-80, -30}}, color = {0, 0, 0}, thickness = 2),
            Text(extent = {{-100, -80}, {100, -100}}, textString = "%name")}),
            Documentation(info = "<html>
<body>
<h4>MultiLink</h4>
<p>Multi-link suspension. Separate upper and lower transverse links replace the wide A-arms of a double wishbone. The <code>rearLinkOffset</code> parameter shifts the lower link inboard pivot fore/aft, producing characteristic multi-link toe/caster geometry. Uses a <code>JointRRR</code> for loop closure, same as <code>DoubleWishbone</code>. Extends <code>BaseSuspension</code>.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>sideSign</code></td><td>1</td><td>1 = left side, -1 = right side</td></tr>
<tr><td><code>upperLinkLength</code></td><td>0.30 m</td><td>Upper transverse link length</td></tr>
<tr><td><code>lowerLinkLength</code></td><td>0.38 m</td><td>Lower link length</td></tr>
<tr><td><code>upperMountZ</code></td><td>0.22 m</td><td>Upper link height above chassis mount</td></tr>
<tr><td><code>lowerMountZ</code></td><td>0.12 m</td><td>Lower link height below chassis mount</td></tr>
<tr><td><code>rearLinkOffset</code></td><td>0.08 m</td><td>Fore-aft offset of lower link chassis pivot (X direction)</td></tr>
<tr><td><code>shockTopHeight</code></td><td>0.32 m</td><td>Shock absorber top mount height</td></tr>
<tr><td><code>useEndStops</code></td><td>true</td><td>Enable the elastic bump/droop travel limiters</td></tr>
<tr><td><code>shockBumpLength</code></td><td>0.31 m</td><td>Shock length at which the bump (compression) stop engages</td></tr>
<tr><td><code>shockDroopLength</code></td><td>0.62 m</td><td>Shock length at which the droop (extension) stop engages</td></tr>
<tr><td><code>endStopStiffness</code></td><td>1&times;10<sup>7</sup> N/m</td><td>Contact stiffness of the end-stops (stiff, so penetration stays small)</td></tr>
<tr><td><code>endStopDamping</code></td><td>15000 N&middot;s/m</td><td>Contact damping of the end-stops</td></tr>
<tr><td><code>endStopExponent</code></td><td>1</td><td>Contact force exponent (1 = linear, bounded penetration)</td></tr>
</tbody>
</table>
<p>Spring/damper parameters from <code>BaseSuspension</code>: <code>k_spring</code>, <code>d_damper</code>. Shock free length 0.50 m.</p>
<p><b>Travel limiters.</b> Because the lower link is closed by the same analytic <code>JointRRR</code> as
<code>DoubleWishbone</code>, it can reach a singular position under a large enough drive torque (the loop goes singular
around a shock length of ~0.26&ndash;0.31 m, depending on the loop pose). Two one-sided <code>ElastoGap</code> springs on
the shock line limit compression travel, which keeps the loop out of that region for realistic and moderately overloaded
drive torques; note that under extreme, unrealistic torque the analytic loop can still be driven singular during violent
transients &mdash; the definitive cure there is rebuilding the loop from basic joints with dynamic state selection. See
<code>DoubleWishbone</code> for the wiring; disable with <code>useEndStops = false</code>.</p>
</body>
</html>"));
        end MultiLink;

        package Components
          partial model BaseSuspension
            import MultiBody = Modelica.Mechanics.MultiBody;
            // Connection to the chassis
            MultiBody.Interfaces.Frame_a chassisMount annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
            // Connection to the wheel/tire block
            MultiBody.Interfaces.Frame_b wheelMount annotation(Placement(transformation(extent={{90,-10},{110,10}})));
            // Common parameters every suspension needs
            parameter Real k_spring = 30000 "Spring rate (N/m)";
            parameter Real d_damper = 2500 "Damping rate (N.s/m)";
            parameter Real m_hub = 15 "Unsprung mass of the hub/knuckle (kg)";
            parameter Boolean steerable = false "Enable steering revolute at wheel output";
            Modelica.Mechanics.Rotational.Interfaces.Flange_b steerInput if steerable annotation(
              Placement(transformation(extent = {{-10, 90}, {10, 110}}), iconTransformation(extent = {{-10, 90}, {10, 110}})));
            annotation(
              Documentation(info = "<html>
<body>
<h4>BaseSuspension (partial)</h4>
<p>Base class for all suspension types. Defines the chassis-to-wheel interface, common tuning parameters, and the optional steering flange.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>k_spring</code></td><td>30000 N/m</td><td>Spring rate</td></tr>
<tr><td><code>d_damper</code></td><td>2500 N&middot;s/m</td><td>Damping rate</td></tr>
<tr><td><code>m_hub</code></td><td>15 kg</td><td>Unsprung hub/knuckle mass</td></tr>
<tr><td><code>steerable</code></td><td>false</td><td>If true, exposes <code>steerInput</code> flange</td></tr>
</tbody>
</table>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Condition</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>chassisMount</code></td><td>Frame_a</td><td>always</td><td>Inboard attachment to chassis</td></tr>
<tr><td><code>wheelMount</code></td><td>Frame_b</td><td>always</td><td>Outboard attachment to tire suspMount</td></tr>
<tr><td><code>steerInput</code></td><td>Flange_b</td><td>steerable=true only</td><td>Driven by Car&apos;s steerAct actuator</td></tr>
</tbody>
</table>
</body>
</html>"));
          end BaseSuspension;
        end Components;

      end Suspension;

      package Chassis
        model RectangularChassis
          extends Components.BaseChassis;
          parameter Real length = 3.0 "Longitudinal (X) extent [m]";
          parameter Real width = 1.8 "Lateral (Z) extent [m]";
          parameter Real height = 0.3 "Vertical (Y) extent [m]";
        protected
          Modelica.Mechanics.MultiBody.Parts.FixedTranslation toRear(r = {-length/2, 0, 0});
          Modelica.Mechanics.MultiBody.Parts.BodyBox box(
            r = {length, 0, 0},
            widthDirection = {0, 0, 1},
            width = width,
            height = height,
            density = m / (length * width * height)
          );
        equation
          connect(frame_a, toRear.frame_a);
          connect(toRear.frame_b, box.frame_a);
          annotation(
            Icon(graphics = {Rectangle(lineColor = {85, 255, 255}, extent = {{-80, 100}, {80, -100}})}),
            Documentation(info = "<html>
<body>
<h4>RectangularChassis</h4>
<p>Rectangular box chassis body. Extends <code>BaseChassis</code>. Creates a <code>BodyBox</code> with density back-calculated from mass and volume. The box is offset rearward by <code>length/2</code> so <code>frame_a</code> sits at the geometric center.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>length</code></td><td>3.0 m</td><td>Longitudinal (X) extent</td></tr>
<tr><td><code>width</code></td><td>1.8 m</td><td>Lateral (Z) extent</td></tr>
<tr><td><code>height</code></td><td>0.3 m</td><td>Vertical (Y) extent</td></tr>
</tbody>
</table>
</body>
</html>"));
        end RectangularChassis;

        package Components
          partial model BaseChassis
            import MultiBody = Modelica.Mechanics.MultiBody;
            parameter Real m = 400 "Total mass [kg]";
            MultiBody.Interfaces.Frame_a frame_a annotation(
              Placement(transformation(extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {0, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
            annotation(
              Icon(graphics = {Rectangle(origin = {0, 80}, extent = {{-50, 20}, {50, -20}}), Rectangle(extent = {{-60, 60}, {60, -60}}), Rectangle(origin = {0, -80}, extent = {{-50, 20}, {50, -20}})}),
              Documentation(info = "<html>
<body>
<h4>BaseChassis (partial)</h4>
<p>Base class for all chassis types. Provides the single connection frame and total mass parameter.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Name</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>m</code></td><td>400 kg</td><td>Total chassis mass</td></tr>
</tbody>
</table>
<p><b>Connector:</b> <code>frame_a</code> (Frame_a) — central reference frame; all suspension mounts, FreeMotion, and <code>chassis_pos</code> connect here.</p>
<p>Extend this class and add <code>BodyBox</code>, <code>BodyCylinder</code>, or any geometry connected to <code>frame_a</code>.</p>
</body>
</html>"));
          end BaseChassis;
        end Components;

      end Chassis;

      package Transmission 
   model MockTransmission
          extends Components.BaseTransmission;
          Modelica.Mechanics.Rotational.Sources.Torque drive(useSupport = false);
          parameter Real torqueValue = 1500 "Drive torque per unit pedal input (N.m)";
   equation
          drive.tau = torqueValue*pedalInput;
          connect(drive.flange, torqueOut);
          annotation(
            Icon(graphics = {Ellipse(origin = {-2, -4}, extent = {{-58, 58}, {58, -58}}), Line(origin = {-3.06292, -0.980762}, points = {{-52.9371, 56.9808}, {-50.9371, 40.9808}, {-62.9371, 26.9808}, {-72.9371, 18.9808}, {-72.9371, -3.01924}, {-62.9371, -11.0192}, {-54.9371, -35.0192}, {-52.9371, -55.0192}, {-38.9371, -65.0192}, {-26.9371, -63.0192}, {-6.93708, -69.0192}, {5.06292, -77.0192}, {29.0629, -73.0192}, {37.0629, -57.0192}, {53.0629, -43.0192}, {67.0629, -41.0192}, {75.0629, -15.0192}, {65.0629, -3.01924}, {61.0629, 22.9808}, {63.0629, 38.9808}, {51.0629, 58.9808}, {37.0629, 54.9808}, {21.0629, 62.9808}, {15.0629, 74.9808}, {-8.9371, 74.9808}, {-18.9371, 64.9808}, {-36.9371, 68.9808}, {-52.9371, 56.9808}, {-52.9371, 56.9808}})}),
            Documentation(info = "<html>
<body>
<h4>MockTransmission</h4>
<p>Simplified stand-in for an engine + gearbox. Converts the driver pedal command
<code>pedalInput</code> into a mechanical drive torque on <code>torqueOut</code> via a single
synthetic relation:</p>
<pre>drive.tau = torqueValue &middot; pedalInput</pre>
<p>The torque is applied through a <code>Modelica.Mechanics.Rotational.Sources.Torque</code>
(<code>useSupport = false</code>, so the reaction goes to the inertial frame), and
<code>torqueOut</code> is a real rotational flange &mdash; the emitted torque flows into the
differential and on to the wheels. There is no speed feedback: for a constant pedal the torque is
constant, and the vehicle accelerates until traction and drag balance it.</p>
<p><b>Extending to a real driveline.</b> Because the output is a torque-carrying flange, a proper
engine/gearbox model can replace <code>MockTransmission</code> without touching the differential,
tires, or brakes &mdash; it only has to keep the same interface (<code>pedalInput</code> in,
<code>torqueOut</code> flange out) inherited from <code>Components.BaseTransmission</code>. Such a
model would compute torque from engine speed (a torque map), add flywheel inertia, and apply gear
ratios.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>torqueValue</code></td><td>200 N&middot;m</td><td>Drive torque per unit pedal input</td></tr>
</tbody>
</table>
</body>
</html>"));
   end MockTransmission;

        package Components
  model BaseTransmission
  Modelica.Blocks.Interfaces.RealInput pedalInput annotation(
           Placement(transformation(origin = {0, 106}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 92}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
         Modelica.Mechanics.Rotational.Interfaces.Flange_a torqueOut annotation(
           Placement(transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -98}, extent = {{-10, -10}, {10, 10}})));
  equation

  annotation(
    Documentation(info = "<html>
<body>
<h4>BaseTransmission (base)</h4>
<p>Base class defining the transmission interface shared by every drivetrain model: a scalar driver
command in, and a mechanical drive torque out. Extend this to build any engine/gearbox model;
downstream components (differential, wheels) connect only to these connectors, so implementations
are interchangeable.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>pedalInput</code></td><td>RealInput</td><td>Driver pedal / throttle command</td></tr>
<tr><td><code>torqueOut</code></td><td>Flange_a</td><td>Mechanical drive-torque output to the differential</td></tr>
</tbody>
</table>
</body>
</html>"));
  end BaseTransmission;
        end Components;
      end Transmission;

      package Steering
        model MockSteering
          extends Components.BaseSteering;
          parameter Modelica.Units.SI.Angle maxSteerAngle = 0.53 "Road-wheel angle at full lock (|steerCmd| = 1), rad (~30 deg)";
        equation
          steerAngle = maxSteerAngle*steerCmd;
          annotation(
            Icon(graphics = {Ellipse(extent = {{-70, 70}, {70, -70}}, lineThickness = 2), Ellipse(extent = {{-18, 18}, {18, -18}}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid), Line(points = {{0, 18}, {0, 70}}, thickness = 2), Line(points = {{-15, -10}, {-60, -36}}, thickness = 2), Line(points = {{15, -10}, {60, -36}}, thickness = 2), Text(extent = {{-100, -78}, {100, -98}}, textString = "%name")}),
            Documentation(info = "<html>
<body>
<h4>MockSteering</h4>
<p>Simplified stand-in for a steering column/rack. Maps the normalized driver steering command
<code>steerCmd</code> (&minus;1&hellip;+1) linearly to a road-wheel steer angle in radians:</p>
<pre>steerAngle = maxSteerAngle &middot; steerCmd</pre>
<p>So <code>steerCmd = &plusmn;1</code> gives full lock (&plusmn;<code>maxSteerAngle</code>) and 0 is straight ahead.
The output is a plain <code>RealOutput</code> angle intended to drive the front-wheel steering position
actuators (<code>Rotational.Sources.Position.phi_ref</code>). No steering dynamics, ratio non-linearity, or
Ackermann split are modelled &mdash; both front wheels receive the same angle.</p>
<p><b>Extending to a real column.</b> Because the interface is command in / angle out, a richer model
(steering-ratio map, compliance, rate limiting, speed-dependent ratio) can replace <code>MockSteering</code>
without touching the cars, as long as it keeps the <code>Components.BaseSteering</code> interface.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Parameter</th><th>Default</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>maxSteerAngle</code></td><td>0.53 rad (~30&deg;)</td><td>Road-wheel angle at full lock (|steerCmd| = 1)</td></tr>
</tbody>
</table>
</body>
</html>"));
        end MockSteering;

        package Components
          partial model BaseSteering
            Modelica.Blocks.Interfaces.RealInput steerCmd "Normalized steering command [-1..1]" annotation(
              Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}})));
            Modelica.Blocks.Interfaces.RealOutput steerAngle "Commanded road-wheel steer angle (rad)" annotation(
              Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
          annotation(
            Documentation(info = "<html>
<body>
<h4>BaseSteering (base)</h4>
<p>Base class defining the steering interface shared by every steering model: a normalized driver
command in (&minus;1&hellip;+1) and a road-wheel steer angle out (rad). Extend this to build any steering
model; the cars connect their <code>steerInput</code> to <code>steerCmd</code> and feed <code>steerAngle</code>
to the front-wheel position actuators, so implementations are interchangeable.</p>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>Connector</th><th>Type</th><th>Description</th></tr></thead>
<tbody>
<tr><td><code>steerCmd</code></td><td>RealInput</td><td>Normalized steering command [-1..1]</td></tr>
<tr><td><code>steerAngle</code></td><td>RealOutput</td><td>Commanded road-wheel steer angle (rad)</td></tr>
</tbody>
</table>
</body>
</html>"));
          end BaseSteering;
        end Components;
      end Steering;

    end Parts;

  end Cars;

  annotation(
    uses(Modelica(version = "4.1.0"), Modelica_DeviceDrivers(version = "2.2.0")),
    Documentation(info = "<html>
<body>
<h4>DDynamics</h4>
<p>A Modelica multibody vehicle dynamics library for simulating 4-wheeled ground vehicles with configurable suspension, terrain, and drivetrain.</p>
<h4>Quick Start</h4>
<ol>
<li>Open <code>DDynamics.mo</code> in OpenModelica or Dymola.</li>
<li>Simulate <code>DDynamics.Examples.CarExample</code>.</li>
<li>The example applies full throttle (<code>throttleInput</code> = 1) with a 0.2 steer command on a flat terrain at y = 1 m.</li>
<li>For real-time visualization in Unity, simulate <code>DDynamics.Examples.CarExampleUDP</code> instead: it streams the pose (position + orientation) of the chassis and four wheels over UDP via <code>Interfaces.FrameToUDPOrientation</code>.</li>
</ol>
<h4>Package Structure</h4>
<pre>
DDynamics
&#9500;&#9472;&#9472; Examples
&#9474;   &#9500;&#9472;&#9472; CarExample
&#9474;   &#9492;&#9472;&#9472; CarExampleUDP
&#9500;&#9472;&#9472; Interfaces
&#9474;   &#9500;&#9472;&#9472; FrameToReal
&#9474;   &#9500;&#9472;&#9472; FrameToUDP
&#9474;   &#9500;&#9472;&#9472; FrameToRealOrientation
&#9474;   &#9492;&#9472;&#9472; FrameToUDPOrientation
&#9500;&#9472;&#9472; Roads
&#9474;   &#9500;&#9472;&#9472; Road
&#9474;   &#9500;&#9472;&#9472; Floors
&#9474;   &#9474;   &#9500;&#9472;&#9472; Floor4Corners
&#9474;   &#9474;   &#9492;&#9472;&#9472; Components: GroundSpring, GroundFriction, Floor
&#9474;   &#9492;&#9472;&#9472; Terrains
&#9474;       &#9500;&#9472;&#9472; TerrainMap
&#9474;       &#9492;&#9472;&#9472; Components: terrainSurface, TerrainVisualizer
&#9492;&#9472;&#9472; Cars
    &#9500;&#9472;&#9472; Car
    &#9492;&#9472;&#9472; Parts
        &#9500;&#9472;&#9472; Tires: Tire, DrivingTire, TireVisualizer
        &#9500;&#9472;&#9472; Differentials: SolidAxle, Differential (partial)
        &#9500;&#9472;&#9472; Transmission: MockTransmission, BaseTransmission
        &#9500;&#9472;&#9472; Steering: MockSteering, BaseSteering (partial)
        &#9500;&#9472;&#9472; Suspension: SpringDamper, DoubleWishbone, BaseSuspension (partial)
        &#9492;&#9472;&#9472; Chassis: RectangularChassis, BaseChassis (partial)
</pre>
<h4>Inner/Outer Resolution</h4>
<table border=\"1\" cellspacing=\"0\">
<thead><tr><th>inner declaration</th><th>Declared in</th><th>Resolved by</th></tr></thead>
<tbody>
<tr><td><code>parameter Real R_wheel = 0.25</code></td><td><code>Examples.CarExample</code></td><td>Tires.Tire, Tires.DrivingTire, Floors.Floor4Corners, Floors.Components.Floor, GroundSpring, GroundFriction</td></tr>
<tr><td><code>Roads.Terrains.TerrainMap terrain</code></td><td><code>Roads.Road</code></td><td>Floors.Components.GroundSpring, Floors.Components.GroundFriction</td></tr>
<tr><td><code>Modelica.Mechanics.MultiBody.World world</code></td><td><code>Roads.Road</code></td><td>Cars.Car, Tires.Components.TireVisualizer, Terrains.Components.TerrainVisualizer</td></tr>
</tbody>
</table>
<h4>Extending the Library</h4>
<p><b>Custom terrain:</b> Modify <code>Roads.Terrains.TerrainMap.getZ</code>, update <code>terrainSurface</code> and <code>TerrainVisualizer.groundHeight</code> to match.</p>
<p><b>Custom differential:</b> Extend <code>Cars.Parts.Differentials.Components.Differential</code> and wire <code>pedalInput</code> to <code>left_out</code>/<code>right_out</code> (rigidly, as in <code>SolidAxle</code>, or through an <code>IdealPlanetary</code> for an open diff).</p>
<p><b>Custom transmission:</b> Extend <code>Cars.Parts.Transmission.Components.BaseTransmission</code> and compute <code>torqueOut</code> from <code>pedalInput</code> (for a real engine, derive torque from engine speed via a torque map, add flywheel inertia, and apply gear ratios).</p>
<p><b>Custom steering:</b> Extend <code>Cars.Parts.Steering.Components.BaseSteering</code> and compute <code>steerAngle</code> (rad) from the normalized <code>steerCmd</code> (for a real column, add a steering-ratio map, compliance, rate limiting, or a speed-dependent ratio).</p>
<p><b>Custom suspension:</b> Extend <code>Cars.Parts.Suspension.Components.BaseSuspension</code> and implement kinematics between <code>chassisMount</code> and <code>wheelMount</code>.</p>
<p><b>Custom chassis:</b> Extend <code>Cars.Parts.Chassis.Components.BaseChassis</code> and connect geometry to <code>frame_a</code>.</p>
</body>
</html>"));
end DDynamics;
