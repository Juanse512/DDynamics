model CifacarAnimated
  Real y(start = 0.5), theta, phi, v, x(start=-5), accel;
  parameter Real L = 1;
  parameter Real w=0.5;
  parameter Real top_accel;
  Modelica.Blocks.Interfaces.RealInput wheel annotation(
    Placement(transformation(origin = {-104, 38}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput x_out annotation(
    Placement(transformation(origin = {102, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput y_out annotation(
    Placement(transformation(origin = {104, -38}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, -38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput throttle annotation(
    Placement(transformation(origin = {-104, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, -40}, extent = {{-20, -20}, {20, 20}})));
equation
  phi = wheel;
  accel = top_accel * (throttle/100);
  der(x) = v*cos(theta);
  der(y) = v*sin(theta);
  der(theta) = v/L*tan(phi);
  der(v) = accel;
  //phi = atan(-y - theta);
  //der(v) = 1 - v;
  x_out = x;
  y_out = y;

annotation(
    uses(Modelica(version = "4.1.0")));
end CifacarAnimated;
