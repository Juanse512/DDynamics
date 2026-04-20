model FrameToUDPStandalone
  //parameter Integer port = 12345;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}})));
  DDynamics.FrameToReal frameToReal annotation(
    Placement(transformation(origin = {-44, 0}, extent = {{-26, -26}, {26, 26}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
    Placement(transformation(origin = {48, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1) annotation(
    Placement(transformation(origin = {48, 12}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1) annotation(
    Placement(transformation(origin = {48, -32}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(port_send = 12345, sampleTime = 0.01) annotation(
    Placement(transformation(origin = {82, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
    Placement(transformation(origin = {-72, 82}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(frame_a, frameToReal.frame_a) annotation(
    Line(points = {{-100, 0}, {-70, 0}}));
  connect(packager.pkgOut, addFloat.pkgIn) annotation(
    Line(points = {{48, 49.2}, {48, 21.2}}));
  connect(addFloat.pkgOut[1], addFloat1.pkgIn) annotation(
    Line(points = {{48, 1.2}, {48, -22.8}}));
  connect(addFloat1.pkgOut[1], uDPSend.pkgIn) annotation(
    Line(points = {{48, -42.8}, {48, -62.8}, {72, -62.8}}));
  connect(frameToReal.x_out, addFloat.u[1]) annotation(
    Line(points = {{-18, 10}, {36, 10}, {36, 12}}, color = {0, 0, 127}));
  connect(frameToReal.y_out, addFloat1.u[1]) annotation(
    Line(points = {{-18, -10}, {36, -10}, {36, -32}}, color = {0, 0, 127}));
end FrameToUDPStandalone;
