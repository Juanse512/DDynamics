model CifacarAnimated
  Real y(start = 0.5), theta, phi, v, x(start=-5);
  parameter Real L = 1;
  parameter Real w=0.5;
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape(color = {100, 100, 100},height = 0.1, length = L, lengthDirection = {cos(theta), 0, sin(theta)}, r = {x, 0.1, y}, specularCoefficient = 0.1, width = w, widthDirection = {sin(theta), 0, cos(theta)}) annotation(
    Placement(visible = true, transformation(origin = {6, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape shape1(color = {0, 0, 0}, height = 0.05, length = 15, r = {-5, 0, 0}, specularCoefficient = 0, width = 0.05) annotation(
    Placement(visible = true, transformation(origin = {2, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape rueda1(color = {50, 50, 50}, height = 0, length = 0.05, lengthDirection = {-sin(theta + phi), 0, cos(theta + phi)}, r = {x + L*cos(theta), 0, y + L*sin(theta)}, r_shape = {-w/2*sin(theta), 0, w/2*cos(theta)}, shapeType = "cylinder", specularCoefficient = 0.75, width = 0.3, widthDirection = {cos(theta + phi), 0, -sin(theta + phi)}) annotation(
    Placement(visible = true, transformation(origin = {52, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape rueda2(color = {50, 50, 50}, height = 0, length = 0.05, lengthDirection = {-sin(theta + phi), 0, cos(theta + phi)}, r = {x + L*cos(theta), 0, y + L*sin(theta)}, r_shape = {w/2*sin(theta), 0, -(w/2 + 0.05)*cos(theta)}, shapeType = "cylinder", specularCoefficient = 0.75, width = 0.3, widthDirection = {cos(theta + phi), 0, -sin(theta + phi)}) annotation(
    Placement(visible = true, transformation(origin = {62, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape rueda3(color = {50, 50, 50}, height = 0, length = 0.05, lengthDirection = {-sin(theta), 0, cos(theta)}, r = {x, 0, y}, r_shape = {-w/2*sin(theta), 0, w/2*cos(theta)}, shapeType = "cylinder", specularCoefficient = 0.75, width = 0.3, widthDirection = {cos(theta), 0, -sin(theta)}) annotation(
    Placement(visible = true, transformation(origin = {48, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape rueda4(color = {50, 50, 50}, height = 0, length = 0.05, lengthDirection = {-sin(theta), 0, cos(theta)}, r = {x, 0, y}, r_shape = {w/2*sin(theta), 0, -(w/2 + 0.05)*cos(theta)}, shapeType = "cylinder", specularCoefficient = 0.75, width = 0.3, widthDirection = {cos(theta), 0, -sin(theta)}) annotation(
    Placement(visible = true, transformation(origin = {78, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
