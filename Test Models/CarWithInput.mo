model CarWithInput
  CifacarAnimated cifacarAnimated annotation(
    Placement(transformation(origin = {8, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 2)  annotation(
    Placement(transformation(origin = {-82, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, cifacarAnimated.wheel) annotation(
    Line(points = {{-70, 0}, {-2, 0}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")));
end CarWithInput;
