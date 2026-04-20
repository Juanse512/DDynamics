model ActuatorTest
  DSFLib.Mechanical.Translational.Components.Mass mass annotation(
    Placement(transformation(origin = {0, 18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  DSFLib.Mechanical.Translational.Components.Spring spring(s_rel0 = 1) annotation(
    Placement(transformation(origin = {42, 40}, extent = {{-10, -10}, {10, 10}})));
  DSFLib.Mechanical.Translational.Components.Fixed fixed annotation(
    Placement(transformation(origin = {76, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DSFLib.Mechanical.Translational.Interfaces.RealToPosition realToPosition(mult = 1) annotation(
    Placement(transformation(origin = {-50, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Sine sine annotation(
    Placement(transformation(origin = {-96, 18}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(spring.flange_b, fixed.flange) annotation(
    Line(points = {{52, 40}, {64, 40}, {64, 24}, {76, 24}}));
  connect(mass.flange, spring.flange_a) annotation(
    Line(points = {{0, 18}, {32, 18}, {32, 40}}));
  connect(sine.y, realToPosition.y) annotation(
    Line(points = {{-84, 18}, {-60, 18}}, color = {0, 0, 127}));
  connect(realToPosition.flange, mass.flange) annotation(
    Line(points = {{-40, 18}, {0, 18}}));
  annotation(
    uses(Modelica_DeviceDrivers(version = "2.1.1"), Modelica(version = "4.0.0")),
    Diagram);
end ActuatorTest;
