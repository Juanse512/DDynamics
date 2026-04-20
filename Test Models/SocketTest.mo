model SocketTest
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
    Placement(transformation(origin = {-20, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddReal addReal(nu = 1) annotation(
    Placement(transformation(origin = {-20, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.Communication.TCPIPServerSend tCPIPServerSend(clientIndex = 1, blockUntilConnected = true, enableExternalTrigger = false, sampleTime = 0.0001) annotation(
    Placement(transformation(origin = {20, -48}, extent = {{-10, -10}, {10, 10}})));
  Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
    Placement(transformation(origin = {-6, 6}, extent = {{-40, -80}, {-20, -60}})));
  inner Modelica_DeviceDrivers.Blocks.Communication.TCPIPServerConfig tcpipserverconfig(port = 5000, maxClients = 10, useNonblockingMode = false) annotation(
    Placement(transformation(origin = {-78, -62}, extent = {{-10, -10}, {10, 10}})));
  DSFLib.Mechanical.Translational.Components.Mass mass annotation(
    Placement(transformation(origin = {-128, 36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  DSFLib.Mechanical.Translational.Components.Spring spring(s_rel0 = 1) annotation(
    Placement(transformation(origin = {-92, 58}, extent = {{-10, -10}, {10, 10}})));
  DSFLib.Mechanical.Translational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {-58, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DSFLib.Mechanical.Translational.Interfaces.FlangeToReal flangeToReal annotation(
    Placement(transformation(origin = {-84, 8}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(packager.pkgOut, addReal.pkgIn) annotation(
    Line(points = {{-20, 38}, {-20, 12}}));
  connect(addReal.pkgOut[1], tCPIPServerSend.pkgIn) annotation(
    Line(points = {{-20, -8}, {-20, -48}, {9, -48}}));
  connect(spring.flange_b, fixed.flange) annotation(
    Line(points = {{-82, 58}, {-70, 58}, {-70, 42}, {-58, 42}}));
  connect(mass.flange, spring.flange_a) annotation(
    Line(points = {{-128, 36}, {-118, 36}, {-118, 58}, {-102, 58}}));
  connect(mass.flange, flangeToReal.flange) annotation(
    Line(points = {{-128, 36}, {-138, 36}, {-138, 8}, {-94, 8}}));
  connect(flangeToReal.y, addReal.u[1]) annotation(
    Line(points = {{-74, 8}, {-56, 8}, {-56, 2}, {-32, 2}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica_DeviceDrivers(version = "2.1.1"), Modelica(version = "4.0.0")),
    Diagram);
end SocketTest;
