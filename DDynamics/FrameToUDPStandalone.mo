model FrameToUDPStandalone
  //parameter Integer port = 12345;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}})));
  DDynamics.FrameToReal frameToReal annotation(
    Placement(transformation(origin = {-44, 0}, extent = {{-26, -26}, {26, 26}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
    Placement(transformation(origin = {48, 86}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1) annotation(
    Placement(transformation(origin = {48, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1) annotation(
    Placement(transformation(origin = {48, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(port_send = 12345, sampleTime = 0.01) annotation(
    Placement(transformation(origin = {92, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
    Placement(transformation(origin = {-72, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat11(nu = 1) annotation(
    Placement(transformation(origin = {48, -70}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(frame_a, frameToReal.frame_a) annotation(
    Line(points = {{-100, 0}, {-70, 0}}));
  connect(packager.pkgOut, addFloat.pkgIn) annotation(
    Line(points = {{48, 75}, {48, 45}}));
  connect(addFloat.pkgOut[1], addFloat1.pkgIn) annotation(
    Line(points = {{48, 23}, {48, 1}}));
  connect(frameToReal.x_out, addFloat.u[1]) annotation(
    Line(points = {{-18, 10}, {-18, 12}, {36, 12}, {36, 34}}, color = {0, 0, 127}));
  connect(addFloat1.u[1], frameToReal.y_out) annotation(
    Line(points = {{36, -10}, {-18, -10}}, color = {0, 0, 127}));
  connect(addFloat11.u[1], frameToReal.z_out) annotation(
    Line(points = {{36, -70}, {-18, -70}, {-18, -22}}, color = {0, 0, 127}));
  connect(addFloat1.pkgOut[1], addFloat11.pkgIn) annotation(
    Line(points = {{48, -20}, {48, -60}}));
  connect(addFloat11.pkgOut[1], uDPSend.pkgIn) annotation(
    Line(points = {{48, -80}, {48, -92}, {68, -92}, {68, -80}, {82, -80}}));
end FrameToUDPStandalone;
