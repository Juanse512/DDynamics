model CarWithInput2
  CifacarAnimated cifacarAnimated(top_accel = 10)  annotation(
    Placement(transformation(origin = {-14, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
    Placement(transformation(origin = {58, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1)  annotation(
    Placement(transformation(origin = {58, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1)  annotation(
    Placement(transformation(origin = {58, -26}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(port_send = 12345, sampleTime = 0.01)  annotation(
    Placement(transformation(origin = {78, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
    Placement(transformation(origin = {-64, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step step(height = -4, offset = 1, startTime = 5)  annotation(
    Placement(transformation(origin = {-80, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 20)  annotation(
    Placement(transformation(origin = {-80, -22}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(packager.pkgOut, addFloat.pkgIn) annotation(
    Line(points = {{58, 50}, {58, 26}}));
  connect(addFloat.pkgOut[1], addFloat1.pkgIn) annotation(
    Line(points = {{58, 6}, {58, -16}}));
  connect(cifacarAnimated.x_out, addFloat.u[1]) annotation(
    Line(points = {{-4, 8}, {46, 8}, {46, 16}}, color = {0, 0, 127}));
  connect(cifacarAnimated.y_out, addFloat1.u[1]) annotation(
    Line(points = {{-4, 0}, {46, 0}, {46, -26}}, color = {0, 0, 127}));
  connect(addFloat1.pkgOut[1], uDPSend.pkgIn) annotation(
    Line(points = {{58, -36}, {58, -60}, {67, -60}}));
  connect(step.y, cifacarAnimated.wheel) annotation(
    Line(points = {{-68, 8}, {-24, 8}, {-24, 4}}, color = {0, 0, 127}));
  connect(const.y, cifacarAnimated.throttle) annotation(
    Line(points = {{-68, -22}, {-50, -22}, {-50, 0}, {-24, 0}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.1.0"), Modelica_DeviceDrivers(version = "2.2.0")));
end CarWithInput2;
