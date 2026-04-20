model CarWorld
  FullChassisSimplifiedGraphic fullChassisSimplifiedGraphic annotation(
    Placement(transformation(origin = {4, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 10)  annotation(
    Placement(transformation(origin = {-24, 30}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, fullChassisSimplifiedGraphic.throttleIN) annotation(
    Line(points = {{-12, 30}, {4, 30}, {4, 6}}, color = {0, 0, 127}));

annotation(
    uses(Modelica(version = "4.1.0")));
end CarWorld;
