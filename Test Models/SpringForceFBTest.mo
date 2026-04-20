model SpringForceFBTest
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
    Placement(transformation(origin = {-20, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
    Placement(transformation(origin = {102, 78}, extent = {{-40, -80}, {-20, -60}})));
  DSFLib.Mechanical.Translational.Components.Mass mass annotation(
    Placement(transformation(origin = {-138, 34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  DSFLib.Mechanical.Translational.Components.Spring spring(s_rel0 = 1) annotation(
    Placement(transformation(origin = {-92, 58}, extent = {{-10, -10}, {10, 10}})));
  DSFLib.Mechanical.Translational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {-58, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(sampleTime = 0.1, port_send = 12345)  annotation(
    Placement(transformation(origin = {26, -32}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1)  annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}})));
  DSFLib.ControlSystems.Sensors.Mechanical.Translational.ForceSensor forceSensor annotation(
    Placement(transformation(origin = {-112, 34}, extent = {{-10, -10}, {10, 10}})));
  DSFLib.Mechanical.Translational.Interfaces.FlangeToReal flangeToReal annotation(
    Placement(transformation(origin = {-104, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager1 annotation(
    Placement(transformation(origin = {-66, -8}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1) annotation(
    Placement(transformation(origin = {-66, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend1(port_send = 12346, sampleTime = 0.1) annotation(
    Placement(transformation(origin = {-66, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  DSFLib.Mechanical.Translational.Interfaces.RealToPosition realToPosition(mult = 1) annotation(
    Placement(transformation(origin = {-86, 86}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Communication.UDPReceive uDPReceive(port_recv = 12347, sampleTime = 0.1)  annotation(
    Placement(transformation(origin = {-160, 112}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.GetFloat getFloat annotation(
    Placement(transformation(origin = {-128, 88}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(spring.flange_b, fixed.flange) annotation(
    Line(points = {{-82, 58}, {-70, 58}, {-70, 42}, {-58, 42}}));
  connect(packager.pkgOut, addFloat.pkgIn) annotation(
    Line(points = {{-20, 37.2}, {-20, 11}}));
  connect(addFloat.pkgOut[1], uDPSend.pkgIn) annotation(
    Line(points = {{-20, -11}, {-20, -32.8}, {16, -32.8}}));
  connect(forceSensor.y, addFloat.u[1]) annotation(
    Line(points = {{-112, 22}, {-55, 22}, {-55, 0}, {-32, 0}}, color = {0, 0, 127}));
  connect(spring.flange_a, forceSensor.flange_b) annotation(
    Line(points = {{-102, 58}, {-102, 34}}));
  connect(forceSensor.flange_a, mass.flange) annotation(
    Line(points = {{-122, 34}, {-138, 34}}));
  connect(mass.flange, flangeToReal.flange) annotation(
    Line(points = {{-138, 34}, {-138, -10}, {-114, -10}}));
  connect(flangeToReal.y, addFloat1.u[1]) annotation(
    Line(points = {{-94, -10}, {-90, -10}, {-90, -50}, {-78, -50}}, color = {0, 0, 127}));
  connect(packager1.pkgOut, addFloat1.pkgIn) annotation(
    Line(points = {{-66, -18}, {-66, -40}}));
  connect(addFloat1.pkgOut[1], uDPSend1.pkgIn) annotation(
    Line(points = {{-66, -60}, {-66, -80}}));
  connect(realToPosition.flange, mass.flange) annotation(
    Line(points = {{-76, 86}, {-66, 86}, {-66, 68}, {-138, 68}, {-138, 34}}));
  connect(uDPReceive.pkgOut, getFloat.pkgIn) annotation(
    Line(points = {{-150, 112}, {-128, 112}, {-128, 98}}));
  connect(getFloat.y[1], realToPosition.y) annotation(
    Line(points = {{-116, 88}, {-96, 88}, {-96, 86}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica_DeviceDrivers(version = "2.1.1"), Modelica(version = "4.0.0")),
    Diagram);
end SpringForceFBTest;
