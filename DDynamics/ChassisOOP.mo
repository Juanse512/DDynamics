model ChassisOOP
  import MultiBody = Modelica.Mechanics.MultiBody;
  import Rotational = Modelica.Mechanics.Rotational;
  import Blocks = Modelica.Blocks.Sources;

  // --- GLOBAL ---
  inner MultiBody.World world(g=9.81, n={0,0,-1})
    annotation(Placement(transformation(origin = {4, 10}, extent = {{-90, 70}, {-70, 90}})));
  TerrainMap terrain
    annotation(Placement(transformation(origin = {-150, -12}, extent = {{-20, 130}, {0, 150}})));
  MultiBody.Joints.FreeMotion freeMotion(
    r_rel_a(start={0, 0, 1.2}),
    v_rel_a(start={0, 0, 0}))
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  MultiBody.Parts.Body chassis(m=1200)
    annotation(Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_chassis_out
    annotation(Placement(transformation(origin = {16, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90),
               iconTransformation(origin = {0, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));

  // --- PARAMETERS ---
  parameter Real R_wheel = 0.3 "Wheel radius in meters";
  parameter Real ground_mu = 10000 "Viscous friction coefficient";
  parameter Real ground_c = 1e5 "Floor stiffness";
  parameter Real ground_d = 5000 "Floor damping";

  // --- INPUTS ---
  Blocks.Constant zeroAngle(k=0)
    annotation(Placement(transformation(origin = {40, 4}, extent = {{-30, 70}, {-10, 90}})));
  Modelica.Blocks.Sources.Constant const(k = 5)
    annotation(Placement(transformation(origin = {18, 130}, extent = {{-10, -10}, {10, 10}})));

  // --- DRIVETRAIN ---
  DDynamics.Differentials.SolidAxle solidAxle
    annotation(Placement(transformation(origin = {192, 4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  // --- FRONT LEFT (FL) ---
  MultiBody.Parts.FixedTranslation mountFL(r={1.5, 0.9, -0.25})
    annotation(Placement(transformation(extent={{50,30},{70,50}})));
  DDynamics.Suspension.DoubleWishbone suspFL(k_spring=35000, d_damper=3000);
  Rotational.Sources.Position steerActFL
    annotation(Placement(transformation(origin = {70, 222}, extent={{130,60},{150,80}}, rotation=-90)));
  DDynamics.Tires.DrivingSteeringTire frontTireL
    annotation(Placement(transformation(origin = {172, 40}, extent = {{-10, -10}, {10, 10}})));
  MultiBody.Forces.WorldForce floorFL
    annotation(Placement(transformation(extent={{250,30},{270,50}})));

  // --- FRONT RIGHT (FR) ---
  MultiBody.Parts.FixedTranslation mountFR(r={1.5, -0.9, -0.25})
    annotation(Placement(transformation(extent={{50,-50},{70,-30}})));
  DDynamics.Suspension.DoubleWishbone suspFR(k_spring=35000, d_damper=3000, sideSign=-1);
  Rotational.Sources.Position steerActFR
    annotation(Placement(transformation(origin = {88, -256}, extent={{130,-80},{150,-60}}, rotation=90)));
  DDynamics.Tires.DrivingSteeringTire frontTireR
    annotation(Placement(transformation(origin = {172, -40}, extent = {{-10, -10}, {10, 10}})));
  MultiBody.Forces.WorldForce floorFR
    annotation(Placement(transformation(extent={{250,-50},{270,-30}})));

  // --- REAR LEFT (RL) ---
  MultiBody.Parts.FixedTranslation mountRL(r={-1.5, 0.9, -0.25})
    annotation(Placement(transformation(extent={{-70,30},{-50,50}})));
  DDynamics.Suspension.DoubleWishbone suspRL(k_spring=35000, d_damper=3000);
  DDynamics.Tires.Tire rearTireL
    annotation(Placement(transformation(origin = {-164, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  MultiBody.Forces.WorldForce floorRL
    annotation(Placement(transformation(extent={{-230,30},{-210,50}})));

  // --- REAR RIGHT (RR) ---
  MultiBody.Parts.FixedTranslation mountRR(r={-1.5, -0.9, -0.25})
    annotation(Placement(transformation(extent={{-70,-50},{-50,-30}})));
  DDynamics.Suspension.DoubleWishbone suspRR(k_spring=35000, d_damper=3000, sideSign=-1);
  DDynamics.Tires.Tire rearTireR
    annotation(Placement(transformation(origin = {-162, -40}, extent = {{-10, -10}, {10, 10}})));
  MultiBody.Forces.WorldForce floorRR
    annotation(Placement(transformation(extent={{-230,-50},{-210,-30}})));

equation
  // --- GLOBAL CONNECTIONS ---
  connect(world.frame_b, freeMotion.frame_a)
    annotation(Line(points = {{-66, 90}, {-66, 80}, {-20, 80}, {-20, 10}}, color = {95, 95, 95}));
  connect(freeMotion.frame_b, chassis.frame_a)
    annotation(Line(points = {{-10, 0}, {10, 0}}, color = {95, 95, 95}));
  connect(chassis.frame_a, frame_chassis_out)
    annotation(Line(points = {{10, 0}, {16, 0}, {16, -98}}, color = {95, 95, 95}));
  connect(const.y, solidAxle.i)
    annotation(Line(points = {{30, 130}, {201, 130}, {201, 4}}, color = {0, 0, 127}));

  // --- FRONT LEFT (FL) ---
  connect(chassis.frame_a, mountFL.frame_a)
    annotation(Line(points = {{20, 0}, {20, 40}, {50, 40}}, color = {95, 95, 95}));
  connect(mountFL.frame_b, suspFL.chassisMount);
  connect(suspFL.wheelMount, frontTireL.suspMount);
  connect(zeroAngle.y, steerActFL.phi_ref)
    annotation(Line(points = {{31, 84}, {83.5, 84}, {83.5, 94}, {140, 94}}, color = {0, 0, 127}));
  connect(steerActFL.flange, frontTireL.steerInput)
    annotation(Line(points = {{140, 72}, {170, 72}, {170, 50}, {172, 50}}));
  connect(solidAxle.left_out, frontTireL.spinInput)
    annotation(Line(points = {{192, 14}, {190, 14}, {190, 60}, {176, 60}, {176, 50}}));
  connect(frontTireL.wheelSupport, floorFL.frame_b)
    annotation(Line(points = {{182, 40}, {270, 40}}, color = {95, 95, 95}));
  floorFL.force = {
    if noEvent(frontTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2]))
      then -ground_mu*(frontTireL.wheelFL.v_0[1] - frontTireL.spinFL.w*R_wheel) else 0,
    if noEvent(frontTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2]))
      then -ground_mu*frontTireL.wheelFL.v_0[2] else 0,
    if noEvent(frontTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2]))
      then ground_c*(terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2]) - frontTireL.wheelFL.frame_a.r_0[3]) - ground_d*frontTireL.wheelFL.v_0[3] else 0};

  // --- FRONT RIGHT (FR) ---
  connect(chassis.frame_a, mountFR.frame_a)
    annotation(Line(points = {{20, 0}, {20, -40}, {50, -40}}, color = {95, 95, 95}));
  connect(mountFR.frame_b, suspFR.chassisMount);
  connect(suspFR.wheelMount, frontTireR.suspMount)
    annotation(Line(points = {{110, -40}, {162, -40}}, color = {95, 95, 95}));
  connect(zeroAngle.y, steerActFR.phi_ref)
    annotation(Line(points = {{31, 84}, {68.5, 84}, {68.5, -128}, {158, -128}}, color = {0, 0, 127}));
  connect(steerActFR.flange, frontTireR.steerInput)
    annotation(Line(points = {{158, -106}, {156, -106}, {156, -16}, {172, -16}, {172, -30}}));
  connect(solidAxle.right_out, frontTireR.spinInput)
    annotation(Line(points = {{192, -6}, {190, -6}, {190, -16}, {176, -16}, {176, -30}}));
  connect(frontTireR.wheelSupport, floorFR.frame_b)
    annotation(Line(points = {{182, -40}, {270, -40}}, color = {95, 95, 95}));
  floorFR.force = {
    if noEvent(frontTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2]))
      then -ground_mu*(frontTireR.wheelFL.v_0[1] - frontTireR.spinFL.w*R_wheel) else 0,
    if noEvent(frontTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2]))
      then -ground_mu*frontTireR.wheelFL.v_0[2] else 0,
    if noEvent(frontTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2]))
      then ground_c*(terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2]) - frontTireR.wheelFL.frame_a.r_0[3]) - ground_d*frontTireR.wheelFL.v_0[3] else 0};

  // --- REAR LEFT (RL) ---
  connect(chassis.frame_a, mountRL.frame_a)
    annotation(Line(points = {{10, 0}, {10, 40}, {-50, 40}}, color = {95, 95, 95}));
  connect(mountRL.frame_b, suspRL.chassisMount);
  connect(suspRL.wheelMount, rearTireL.suspMount);
  connect(rearTireL.wheelSupport, floorRL.frame_b)
    annotation(Line(points = {{-164, 30}, {-182, 30}, {-182, 40}, {-210, 40}}, color = {95, 95, 95}));
  floorRL.force = {
    if noEvent(rearTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2]))
      then -ground_mu*(rearTireL.wheelFL.v_0[1] - rearTireL.spinRL.w*R_wheel) else 0,
    if noEvent(rearTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2]))
      then -ground_mu*rearTireL.wheelFL.v_0[2] else 0,
    if noEvent(rearTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2]))
      then ground_c*(terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2]) - rearTireL.wheelFL.frame_a.r_0[3]) - ground_d*rearTireL.wheelFL.v_0[3] else 0};

  // --- REAR RIGHT (RR) ---
  connect(chassis.frame_a, mountRR.frame_a)
    annotation(Line(points = {{10, 0}, {10, -40}, {-50, -40}}, color = {95, 95, 95}));
  connect(mountRR.frame_b, suspRR.chassisMount);
  connect(suspRR.wheelMount, rearTireR.suspMount)
    annotation(Line(points = {{-110, -40}, {-172, -40}}, color = {95, 95, 95}));
  connect(rearTireR.wheelSupport, floorRR.frame_b)
    annotation(Line(points = {{-152, -40}, {-210, -40}}, color = {95, 95, 95}));
  floorRR.force = {
    if noEvent(rearTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2]))
      then -ground_mu*(rearTireR.wheelFL.v_0[1] - rearTireR.spinRL.w*R_wheel) else 0,
    if noEvent(rearTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2]))
      then -ground_mu*rearTireR.wheelFL.v_0[2] else 0,
    if noEvent(rearTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2]))
      then ground_c*(terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2]) - rearTireR.wheelFL.frame_a.r_0[3]) - ground_d*rearTireR.wheelFL.v_0[3] else 0};

  annotation(uses(Modelica(version="4.1.0")));
end ChassisOOP;
