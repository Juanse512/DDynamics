model FullChassisSimplified
  import MultiBody = Modelica.Mechanics.MultiBody;
  import Rotational = Modelica.Mechanics.Rotational;
  import Blocks = Modelica.Blocks.Sources;

  // --- GLOBAL CONTROL ---
  inner MultiBody.World world(g=9.81, n={0,0,-1}) annotation(Placement(transformation(origin={0,90}, extent={{-10,-10},{10,10}})));
  Blocks.Constant zeroAngle(k=0) annotation(Placement(transformation(extent={{-90,40},{-70,60}})));
  
  // FIX 1: FreeMotion needs to be connected to give the chassis 6 DOF
  MultiBody.Joints.FreeMotion freeMotion(
    r_rel_a(start={0, 0, 1.0}), 
    v_rel_a(start={0, 0, 0})) 
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
    
  MultiBody.Parts.Body chassis(m=1200) annotation(Placement(transformation(extent={{0,-10},{20,10}})));

  // --- FRONT LEFT (FL) ---
  MultiBody.Parts.FixedTranslation mountFL(r={1.5, 0.9, -0.2});
  MultiBody.Joints.Prismatic suspFL(n={0,0,1}, s(start=0.1, fixed=true));
  MultiBody.Forces.SpringDamperParallel shockFL(s_unstretched=0.3, c=30000, d=2500);
  
  // FIX 2: Added useAxisFlange=true so we can connect actuators
  MultiBody.Joints.Revolute steerFL(n={0,0,1}, useAxisFlange=true);
  Rotational.Sources.Position steerActFL;
  MultiBody.Joints.Revolute spinFL(n={0,1,0}, useAxisFlange=true);
  Rotational.Sources.Position spinActFL;
  MultiBody.Parts.Body wheelFL(m=20);

  // --- FRONT RIGHT (FR) ---
  MultiBody.Parts.FixedTranslation mountFR(r={1.5, -0.9, -0.2});
  MultiBody.Joints.Prismatic suspFR(n={0,0,1}, s(start=0.1, fixed=true));
  MultiBody.Forces.SpringDamperParallel shockFR(s_unstretched=0.3, c=30000, d=2500);
  MultiBody.Joints.Revolute steerFR(n={0,0,1}, useAxisFlange=true);
  Rotational.Sources.Position steerActFR;
  MultiBody.Joints.Revolute spinFR(n={0,1,0}, useAxisFlange=true);
  Rotational.Sources.Position spinActFR;
  MultiBody.Parts.Body wheelFR(m=20);

  // --- REAR LEFT (RL) ---
  MultiBody.Parts.FixedTranslation mountRL(r={-1.5, 0.9, -0.2});
  MultiBody.Joints.Prismatic suspRL(n={0,0,1}, s(start=0.1, fixed=true));
  MultiBody.Forces.SpringDamperParallel shockRL(s_unstretched=0.3, c=30000, d=2500);
  MultiBody.Joints.Revolute spinRL(n={0,1,0}); // No actuator, so no flange needed
  MultiBody.Parts.Body wheelRL(m=20);

  // --- REAR RIGHT (RR) ---
  MultiBody.Parts.FixedTranslation mountRR(r={-1.5, -0.9, -0.2});
  MultiBody.Joints.Prismatic suspRR(n={0,0,1}, s(start=0.1, fixed=true));
  MultiBody.Forces.SpringDamperParallel shockRR(s_unstretched=0.3, c=30000, d=2500);
  MultiBody.Joints.Revolute spinRR(n={0,1,0}); // No actuator, so no flange needed
  MultiBody.Parts.Body wheelRR(m=20);

  // --- FLOOR LOGIC ---
  MultiBody.Forces.WorldForce floorFL;
  MultiBody.Forces.WorldForce floorFR;
  MultiBody.Forces.WorldForce floorRL;
  MultiBody.Forces.WorldForce floorRR;
  
  // Parameters for floor stiffness (very high)
  parameter Real ground_c = 1e6 "Floor stiffness";
  parameter Real ground_d = 1e4 "Floor damping";

equation
  // FIX 1: Connecting the Chassis to the World
  connect(world.frame_b, freeMotion.frame_a);
  connect(freeMotion.frame_b, chassis.frame_a);

  // --- FRONT LEFT (FL) ---
  connect(chassis.frame_a, mountFL.frame_a);
  connect(mountFL.frame_b, suspFL.frame_a);
  connect(mountFL.frame_b, shockFL.frame_a); 
  connect(suspFL.frame_b, shockFL.frame_b);
  connect(suspFL.frame_b, steerFL.frame_a);
  connect(steerFL.frame_b, spinFL.frame_a);
  connect(spinFL.frame_b, wheelFL.frame_a);
  connect(zeroAngle.y, steerActFL.phi_ref);
  connect(steerActFL.flange, steerFL.axis);
  connect(zeroAngle.y, spinActFL.phi_ref);
  connect(spinActFL.flange, spinFL.axis);

  // --- FRONT RIGHT (FR) ---
  connect(chassis.frame_a, mountFR.frame_a);
  connect(mountFR.frame_b, suspFR.frame_a);
  connect(mountFR.frame_b, shockFR.frame_a);
  connect(suspFR.frame_b, shockFR.frame_b);
  connect(suspFR.frame_b, steerFR.frame_a);
  connect(steerFR.frame_b, spinFR.frame_a);
  connect(spinFR.frame_b, wheelFR.frame_a);
  connect(zeroAngle.y, steerActFR.phi_ref);
  connect(steerActFR.flange, steerFR.axis);
  connect(zeroAngle.y, spinActFR.phi_ref);
  connect(spinActFR.flange, spinFR.axis);

  // --- REAR LEFT (RL) ---
  connect(chassis.frame_a, mountRL.frame_a);
  connect(mountRL.frame_b, suspRL.frame_a);
  connect(mountRL.frame_b, shockRL.frame_a);
  connect(suspRL.frame_b, shockRL.frame_b);
  connect(suspRL.frame_b, spinRL.frame_a);
  connect(spinRL.frame_b, wheelRL.frame_a);

  // --- REAR RIGHT (RR) ---
  connect(chassis.frame_a, mountRR.frame_a);
  connect(mountRR.frame_b, suspRR.frame_a);
  connect(mountRR.frame_b, shockRR.frame_a);
  connect(suspRR.frame_b, shockRR.frame_b);
  connect(suspRR.frame_b, spinRR.frame_a);
  connect(spinRR.frame_b, wheelRR.frame_a);
  
  
  // --- FRONT LEFT FLOOR ---
  connect(floorFL.frame_b, wheelFL.frame_a);
  // Force logic: F = if z < 0 then -(c*z + d*vz) else 0
  floorFL.force = {0, 0, if wheelFL.frame_a.r_0[3] < 0 then 
                -ground_c * wheelFL.frame_a.r_0[3] - ground_d * wheelFL.v_0[3] 
                else 0};

  // --- FRONT RIGHT FLOOR ---
  connect(floorFR.frame_b, wheelFR.frame_a);
  floorFR.force = {0, 0, if wheelFR.frame_a.r_0[3] < 0 then 
                -ground_c * wheelFR.frame_a.r_0[3] - ground_d * wheelFR.v_0[3] 
                else 0};

  // --- REAR LEFT FLOOR ---
  connect(floorRL.frame_b, wheelRL.frame_a);
  floorRL.force = {0, 0, if wheelRL.frame_a.r_0[3] < 0 then 
                -ground_c * wheelRL.frame_a.r_0[3] - ground_d * wheelRL.v_0[3] 
                else 0};

  // --- REAR RIGHT FLOOR ---
  connect(floorRR.frame_b, wheelRR.frame_a);
  floorRR.force = {0, 0, if wheelRR.frame_a.r_0[3] < 0 then 
                -ground_c * wheelRR.frame_a.r_0[3] - ground_d * wheelRR.v_0[3] 
                else 0};

annotation(uses(Modelica(version="4.1.0")));
end FullChassisSimplified;
