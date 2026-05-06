model ChassisOOP
  import MultiBody = Modelica.Mechanics.MultiBody;
  import Rotational = Modelica.Mechanics.Rotational;
  import Blocks = Modelica.Blocks.Sources;

// --- GLOBAL CONTROL ---
  inner MultiBody.World world(g=9.81, n={0,0,-1}) 
    annotation(Placement(transformation(origin = {4, 10}, extent = {{-90, 70}, {-70, 90}})));
  Blocks.Constant zeroAngle(k=0) 
    annotation(Placement(transformation(origin = {40, 4}, extent = {{-30, 70}, {-10, 90}})));
  // FIX 1: FreeMotion needs to be connected to give the chassis 6 DOF
  MultiBody.Joints.FreeMotion freeMotion(
    r_rel_a(start={0, 0, 0.3}), 
    v_rel_a(start={0, 0, 0})) 
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
   TerrainMap terrain annotation(Placement(transformation(origin = {-150, -12}, extent = {{-20, 130}, {0, 150}})));
    
  MultiBody.Parts.Body chassis(m=1200) 
    annotation(Placement(transformation(extent={{10,-10},{30,10}})));
  // --- GROUND FORCES ---
  parameter Real R_wheel = 0.3 "Wheel radius in meters";
  parameter Real ground_mu = 10000 "Viscous friction coefficient";
  parameter Real joint_damping = 1.0 "Tiny damping to prevent singularity";
  // --- FRONT LEFT (FL) ---
  MultiBody.Parts.FixedTranslation mountFL(r={1.5, 0.9, -0.2}) annotation(Placement(transformation(extent={{50,30},{70,50}})));
  MultiBody.Joints.Prismatic suspFL(n={0,0,-1}, s(start=0.1, fixed=true)) annotation(Placement(transformation(extent={{90,30},{110,50}})));
  MultiBody.Forces.SpringDamperParallel shockFL(s_unstretched=0.3, c=30000, d=2500) annotation(Placement(transformation(origin = {0, -6}, extent = {{90, 60}, {110, 80}})));
  // FIX 2: Added useAxisFlange=true so we can connect actuators
  Rotational.Sources.Position steerActFL annotation(Placement(transformation(origin = {70, 222},extent={{130,60},{150,80}}, rotation=-90)));
  //Modelica.Mechanics.Translational.Components.ElastoGap bumpFL(c=1e3, d=50000, s_rel0=0.05);
  // --- FRONT RIGHT (FR) ---
  MultiBody.Parts.FixedTranslation mountFR(r={1.5, -0.9, -0.2}) annotation(Placement(transformation(extent={{50,-50},{70,-30}})));
  MultiBody.Joints.Prismatic suspFR(n={0,0,-1}, s(start=0.1, fixed=true)) annotation(Placement(transformation(extent={{90,-50},{110,-30}})));
  MultiBody.Forces.SpringDamperParallel shockFR(s_unstretched=0.3, c=30000, d=2500) annotation(Placement(transformation(extent={{90,-80},{110,-60}})));
  Rotational.Sources.Position steerActFR annotation(Placement(transformation(origin = {88, -256},extent={{130,-80},{150,-60}}, rotation=90)));
  //Rotational.Sources.Position spinActFR annotation(Placement(transformation(extent={{170,-80},{190,-60}}, rotation=90)));
  //Modelica.Mechanics.Translational.Components.ElastoGap bumpFR(c=1e3, d=50000, s_rel0=0.05);
  // --- REAR LEFT (RL) ---
  MultiBody.Parts.FixedTranslation mountRL(r={-1.5, 0.9, -0.2}) annotation(Placement(transformation(extent={{-70,30},{-50,50}})));
  MultiBody.Joints.Prismatic suspRL(n={0,0,-1}, s(start=0.1, fixed=true)) annotation(Placement(transformation(extent={{-110,30},{-90,50}})));
  MultiBody.Forces.SpringDamperParallel shockRL(s_unstretched=0.3, c=30000, d=2500) annotation(Placement(transformation(origin = {-2, 0}, extent = {{-110, 60}, {-90, 80}})));
  // No actuator, so no flange needed
  //Modelica.Mechanics.Translational.Components.ElastoGap bumpRL(c=1e3, d=50000, s_rel0=0.05);
  // --- REAR RIGHT (RR) ---
  MultiBody.Parts.FixedTranslation mountRR(r={-1.5, -0.9, -0.2}) annotation(Placement(transformation(extent={{-70,-50},{-50,-30}})));
  MultiBody.Joints.Prismatic suspRR(n={0,0,-1}, s(start=0.1, fixed=true)) annotation(Placement(transformation(extent={{-110,-50},{-90,-30}})));
  MultiBody.Forces.SpringDamperParallel shockRR(s_unstretched=0.3, c=30000, d=2500) annotation(Placement(transformation(origin = {2, -2}, extent = {{-110, -80}, {-90, -60}})));
  // No actuator, so no flange needed
  //Modelica.Mechanics.Translational.Components.ElastoGap bumpRR(c=1e3, d=50000, s_rel0=0.05);
  // --- 1D TRANSLATIONAL BRIDGES (To fix Pantelides error) ---
  Modelica.Mechanics.Translational.Components.Fixed transGround;
  Modelica.Mechanics.Translational.Components.Mass dummyMassFL(m=0.001);
  Modelica.Mechanics.Translational.Components.Mass dummyMassFR(m=0.001);
  Modelica.Mechanics.Translational.Components.Mass dummyMassRL(m=0.001);
  Modelica.Mechanics.Translational.Components.Mass dummyMassRR(m=0.001);
  // --- FLOOR LOGIC ---
  MultiBody.Forces.WorldForce floorFL annotation(Placement(transformation(extent={{250,30},{270,50}})));
  MultiBody.Forces.WorldForce floorFR annotation(Placement(transformation(extent={{250,-50},{270,-30}})));
  MultiBody.Forces.WorldForce floorRL annotation(Placement(transformation(extent={{-230,30},{-210,50}})));
  MultiBody.Forces.WorldForce floorRR annotation(Placement(transformation(extent={{-230,-50},{-210,-30}})));
  // Parameters for floor stiffness (very high)
  parameter Real ground_c = 1e5 "Floor stiffness";
  parameter Real ground_d = 5000 "Floor damping";
  //Modelica.Mechanics.Rotational.Sources.Accelerate spinAccActFL annotation(
  // Placement(transformation(origin = {182, 82}, extent = {{-10, -10}, {10, 10}})));
  //Modelica.Mechanics.Rotational.Sources.Accelerate spinAccActFR annotation(
  //Placement(transformation(origin = {186, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  //Modelica.Mechanics.Rotational.Sources.Accelerate spinAccActFL annotation(
  //Placement(transformation(origin = {176, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = 5)  annotation(
    Placement(transformation(origin = {18, 130}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Ramp ramp(height = 5, startTime = 5)  annotation(
    Placement(transformation(origin = {-62, 132}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_chassis_out annotation(
    Placement(transformation(origin = {16, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90), iconTransformation(origin = {0, -100}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  DDynamics.Tires.DrivingSteeringTire frontTireL annotation(
    Placement(transformation(origin = {172, 40}, extent = {{-10, -10}, {10, 10}})));
  DDynamics.Tires.DrivingSteeringTire frontTireR annotation(
    Placement(transformation(origin = {172, -40}, extent = {{-10, -10}, {10, 10}})));
  DDynamics.Tires.Tire rearTireL annotation(
    Placement(transformation(origin = {-164, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  DDynamics.Tires.Tire rearTireR annotation(
    Placement(transformation(origin = {-162, -40}, extent = {{-10, -10}, {10, 10}})));
  SolidAxle solidAxle annotation(
    Placement(transformation(origin = {192, 4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
// FIX 1: Connecting the Chassis to the World
  connect(world.frame_b, freeMotion.frame_a) annotation(
    Line(points = {{-66, 90}, {-66, 80}, {-20, 80}, {-20, 10}}, color = {95, 95, 95}));
  connect(freeMotion.frame_b, chassis.frame_a) annotation(
    Line(points = {{-10, 0}, {10, 0}}, color = {95, 95, 95}));
// --- FRONT LEFT (FL) ---
  connect(chassis.frame_a, mountFL.frame_a) annotation(
    Line(points = {{20, 0}, {20, 40}, {50, 40}}, color = {95, 95, 95}));
  connect(mountFL.frame_b, suspFL.frame_a) annotation(
    Line(points = {{70, 40}, {90, 40}}, color = {95, 95, 95}));
  connect(mountFL.frame_b, shockFL.frame_a) annotation(
    Line(points = {{70, 40}, {80, 40}, {80, 64}, {90, 64}}, color = {95, 95, 95}));
  connect(suspFL.frame_b, shockFL.frame_b) annotation(
    Line(points = {{110, 40}, {120, 40}, {120, 64}, {110, 64}}, color = {95, 95, 95}));
  connect(zeroAngle.y, steerActFL.phi_ref) annotation(
    Line(points = {{31, 84}, {83.5, 84}, {83.5, 94}, {140, 94}}, color = {0, 0, 127}));
//connect(suspFL.support, bumpFL.flange_a);
//connect(suspFL.axis, bumpFL.flange_b);
// --- FRONT RIGHT (FR) ---
  connect(chassis.frame_a, mountFR.frame_a) annotation(
    Line(points = {{20, 0}, {20, -40}, {50, -40}}, color = {95, 95, 95}));
  connect(mountFR.frame_b, suspFR.frame_a) annotation(
    Line(points = {{70, -40}, {90, -40}}, color = {95, 95, 95}));
  connect(mountFR.frame_b, shockFR.frame_a) annotation(
    Line(points = {{70, -40}, {80, -40}, {80, -70}, {90, -70}}, color = {95, 95, 95}));
  connect(suspFR.frame_b, shockFR.frame_b) annotation(
    Line(points = {{110, -40}, {120, -40}, {120, -70}, {110, -70}}, color = {95, 95, 95}));
  connect(zeroAngle.y, steerActFR.phi_ref) annotation(
    Line(points = {{31, 84}, {68.5, 84}, {68.5, -128}, {158, -128}}, color = {0, 0, 127}));
//connect(suspFR.support, bumpFR.flange_a);
//connect(suspFR.axis, bumpFR.flange_b);
//connect(zeroAngle.y, spinActFR.phi_ref) annotation(
//Line(points = {{31, 84}, {31, -80}, {180, -80}}, color = {0, 0, 127}));
//connect(spinActFR.flange, frontTireR.spinFL.axis) annotation(
//Line(points = {{180, -60}, {180, -50}}, color = {0, 0, 127}));
// --- REAR LEFT (RL) ---
  connect(chassis.frame_a, mountRL.frame_a) annotation(
    Line(points = {{10, 0}, {10, 40}, {-50, 40}}, color = {95, 95, 95}));
  connect(mountRL.frame_b, suspRL.frame_a) annotation(
    Line(points = {{-70, 40}, {-90, 40}}, color = {95, 95, 95}));
  connect(mountRL.frame_b, shockRL.frame_a) annotation(
    Line(points = {{-70, 40}, {-80, 40}, {-80, 70}, {-112, 70}}, color = {95, 95, 95}));
  connect(suspRL.frame_b, shockRL.frame_b) annotation(
    Line(points = {{-110, 40}, {-120, 40}, {-120, 70}, {-92, 70}}, color = {95, 95, 95}));
//connect(suspRL.support, bumpRL.flange_a);
//connect(suspRL.axis, bumpRL.flange_b);
// --- REAR RIGHT (RR) ---
  connect(chassis.frame_a, mountRR.frame_a) annotation(
    Line(points = {{10, 0}, {10, -40}, {-50, -40}}, color = {95, 95, 95}));
  connect(mountRR.frame_b, suspRR.frame_a) annotation(
    Line(points = {{-70, -40}, {-90, -40}}, color = {95, 95, 95}));
  connect(mountRR.frame_b, shockRR.frame_a) annotation(
    Line(points = {{-70, -40}, {-80, -40}, {-80, -72}, {-108, -72}}, color = {95, 95, 95}));
  connect(suspRR.frame_b, shockRR.frame_b) annotation(
    Line(points = {{-110, -40}, {-120, -40}, {-120, -72}, {-88, -72}}, color = {95, 95, 95}));
//connect(suspRR.support, bumpRR.flange_a);
//connect(suspRR.axis, bumpRR.flange_b);
/*
 // --- SUSPENSION BUMP STOP CONNECTIONS ---
  // Front Left
  connect(transGround.flange, bumpFL.flange_a);
  connect(bumpFL.flange_b, suspFL.axis);
  connect(dummyMassFL.flange_a, suspFL.axis);
  
  // Front Right
  connect(transGround.flange, bumpFR.flange_a);
  connect(bumpFR.flange_b, suspFR.axis);
  connect(dummyMassFR.flange_a, suspFR.axis);

  // Rear Left
  connect(transGround.flange, bumpRL.flange_a);
  connect(bumpRL.flange_b, suspRL.axis);
  connect(dummyMassRL.flange_a, suspRL.axis);

  // Rear Right
  connect(transGround.flange, bumpRR.flange_a);
  connect(bumpRR.flange_b, suspRR.axis);
  connect(dummyMassRR.flange_a, suspRR.axis);
  */
// --- FRONT LEFT FLOOR ---
/*floorFL.force = {
    if frontTireL.wheelFL.frame_a.r_0[3] < ramp.y then -ground_mu * (frontTireL.wheelFL.v_0[1] - frontTireL.spinFL.w * R_wheel) else 0,
    if frontTireL.wheelFL.frame_a.r_0[3] < ramp.y then -ground_mu * frontTireL.wheelFL.v_0[2] else 0,
    // FIX: Force is now based on (Ramp Height - Wheel Height)
    if frontTireL.wheelFL.frame_a.r_0[3] < ramp.y then ground_c*(ramp.y - frontTireL.wheelFL.frame_a.r_0[3]) - ground_d*frontTireL.wheelFL.v_0[3] else 0
  };*/
  floorFL.force = {if noEvent(frontTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2])) then -ground_mu*(frontTireL.wheelFL.v_0[1] - frontTireL.spinFL.w*R_wheel) else 0, if noEvent(frontTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2])) then -ground_mu*frontTireL.wheelFL.v_0[2] else 0, if noEvent(frontTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2])) then ground_c*(terrain.getZ(frontTireL.wheelFL.frame_a.r_0[1], frontTireL.wheelFL.frame_a.r_0[2]) - frontTireL.wheelFL.frame_a.r_0[3]) - ground_d*frontTireL.wheelFL.v_0[3] else 0};
// --- FRONT RIGHT FLOOR ---
  floorFR.force = {if noEvent(frontTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2])) then -ground_mu*(frontTireR.wheelFL.v_0[1] - frontTireR.spinFL.w*R_wheel) else 0, if noEvent(frontTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2])) then -ground_mu*frontTireR.wheelFL.v_0[2] else 0, if noEvent(frontTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2])) then ground_c*(terrain.getZ(frontTireR.wheelFL.frame_a.r_0[1], frontTireR.wheelFL.frame_a.r_0[2]) - frontTireR.wheelFL.frame_a.r_0[3]) - ground_d*frontTireR.wheelFL.v_0[3] else 0};
// --- REAR LEFT FLOOR ---
  floorRL.force = {if noEvent(rearTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2])) then -ground_mu*(rearTireL.wheelFL.v_0[1] - rearTireL.spinRL.w*R_wheel) else 0, if noEvent(rearTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2])) then -ground_mu*rearTireL.wheelFL.v_0[2] else 0, if noEvent(rearTireL.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2])) then ground_c*(terrain.getZ(rearTireL.wheelFL.frame_a.r_0[1], rearTireL.wheelFL.frame_a.r_0[2]) - rearTireL.wheelFL.frame_a.r_0[3]) - ground_d*rearTireL.wheelFL.v_0[3] else 0};
// --- REAR RIGHT FLOOR ---
  floorRR.force = {if noEvent(rearTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2])) then -ground_mu*(rearTireR.wheelFL.v_0[1] - rearTireR.spinRL.w*R_wheel) else 0, if noEvent(rearTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2])) then -ground_mu*rearTireR.wheelFL.v_0[2] else 0, if noEvent(rearTireR.wheelFL.frame_a.r_0[3] < terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2])) then ground_c*(terrain.getZ(rearTireR.wheelFL.frame_a.r_0[1], rearTireR.wheelFL.frame_a.r_0[2]) - rearTireR.wheelFL.frame_a.r_0[3]) - ground_d*rearTireR.wheelFL.v_0[3] else 0};
  connect(chassis.frame_a, frame_chassis_out) annotation(
    Line(points = {{10, 0}, {16, 0}, {16, -98}}, color = {95, 95, 95}));
  connect(suspFL.frame_b, frontTireL.suspMount) annotation(
    Line(points = {{110, 40}, {162, 40}}, color = {95, 95, 95}));
  connect(steerActFL.flange, frontTireL.steerInput) annotation(
    Line(points = {{140, 72}, {170, 72}, {170, 50}, {172, 50}}));
  connect(frontTireL.wheelSupport, floorFL.frame_b) annotation(
    Line(points = {{182, 40}, {270, 40}}, color = {95, 95, 95}));
  connect(suspFR.frame_b, frontTireR.suspMount) annotation(
    Line(points = {{110, -40}, {162, -40}}, color = {95, 95, 95}));
  connect(frontTireR.wheelSupport, floorFR.frame_b) annotation(
    Line(points = {{182, -40}, {270, -40}}, color = {95, 95, 95}));
  connect(steerActFR.flange, frontTireR.steerInput) annotation(
    Line(points = {{158, -106}, {156, -106}, {156, -16}, {172, -16}, {172, -30}}));
/*
  connect(rearTireL.wheelSupport, floorRL.frame_b) annotation(
    Line(points = {{-174, 40}, {-210, 40}}, color = {95, 95, 95}));
  connect(rearTireL.suspMount, suspRL.frame_a) annotation(
    Line(points = {{-154, 40}, {-110, 40}}, color = {95, 95, 95}));
  connect(rearTireR.suspMount, floorRR.frame_b) annotation(
    Line(points = {{-172, -40}, {-210, -40}}, color = {95, 95, 95}));
  connect(rearTireR.wheelSupport, suspRR.frame_a) annotation(
    Line(points = {{-152, -40}, {-110, -40}}, color = {95, 95, 95}));
  */
// --- REAR LEFT CONNECTIONS ---
  connect(suspRL.frame_b, rearTireL.suspMount) annotation(
    Line(points = {{-110, 40}, {-174, 40}}, color = {95, 95, 95}));
  connect(rearTireL.wheelSupport, floorRL.frame_b) annotation(
    Line(points = {{-154, 40}, {-210, 40}}, color = {95, 95, 95}));
// --- REAR RIGHT CONNECTIONS ---
  connect(suspRR.frame_b, rearTireR.suspMount) annotation(
    Line(points = {{-110, -40}, {-172, -40}}, color = {95, 95, 95}));
  connect(rearTireR.wheelSupport, floorRR.frame_b) annotation(
    Line(points = {{-152, -40}, {-210, -40}}, color = {95, 95, 95}));
  connect(const.y, solidAxle.i) annotation(
    Line(points = {{30, 130}, {201, 130}, {201, 4}}, color = {0, 0, 127}));
  connect(solidAxle.left_out, frontTireL.spinInput) annotation(
    Line(points = {{192, 14}, {190, 14}, {190, 60}, {176, 60}, {176, 50}}));
  connect(solidAxle.right_out, frontTireR.spinInput) annotation(
    Line(points = {{192, -6}, {190, -6}, {190, -16}, {176, -16}, {176, -30}}));
  annotation(uses(Modelica(version="4.1.0")));
end ChassisOOP;
