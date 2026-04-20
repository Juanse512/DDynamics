model CifacarAnimated
  Real y(start = 0.5), theta, phi, v, x(start=-5);
  parameter Real L = 1;
  parameter Real w=0.5;
  Modelica.Blocks.Interfaces.RealInput wheel annotation(
    Placement(transformation(origin = {-104, -2}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, -2}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput x_out annotation(
    Placement(transformation(origin = {102, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput y_out annotation(
    Placement(transformation(origin = {104, -38}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, -38}, extent = {{-10, -10}, {10, 10}})));
equation
  phi = wheel;
  der(x) = v*cos(theta);
  der(y) = v*sin(theta);
  der(theta) = v/L*tan(phi);
  //phi = atan(-y - theta);
  der(v) = 1 - v;
  x_out = x;
  y_out = y;
  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06, Interval = 0.02),
    uses(Modelica(version = "3.2.3")));
end CifacarAnimated;
