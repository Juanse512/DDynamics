package DDynamics

  package Tires
      model Tire
      Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
        Placement(transformation(origin = {-148, -40}, extent = {{210, 30}, {230, 50}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
        Placement(transformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
        Placement(transformation(origin = {-102, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.MultiBody.Joints.Revolute spinRL(n = {0, 0, -1}) annotation(
        Placement(transformation(origin = {168, -40}, extent = {{-150, 30}, {-130, 50}})));
  Modelica.Blocks.Interfaces.RealOutput wheelSpeed annotation(
        Placement(transformation(origin = {0, -104}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {2, -98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TireVisualizer tireVisualizer annotation(
        Placement(transformation(origin = {96, 46}, extent = {{-10, -10}, {10, 10}})));
    equation
      wheelSpeed = spinRL.w;
      connect(wheelSupport, wheelFL.frame_a) annotation(
        Line(points = {{100, 0}, {62, 0}}));
      connect(suspMount, spinRL.frame_a) annotation(
        Line(points = {{-102, 0}, {18, 0}}));
      connect(spinRL.frame_b, wheelFL.frame_a) annotation(
        Line(points = {{38, 0}, {62, 0}}, color = {95, 95, 95}));
  connect(tireVisualizer.frame_a, wheelFL.frame_a) annotation(
        Line(points = {{86, 46}, {62, 46}, {62, 0}}, color = {95, 95, 95}));
    end Tire;

    model DrivingTire
      Modelica.Mechanics.MultiBody.Joints.Revolute spinFL(n = {0, 0, -1}, useAxisFlange = true) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{170, 30}, {190, 50}})));
      Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{210, 30}, {230, 50}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
        Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a spinInput annotation(
        Placement(transformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
        Placement(transformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, 2}, extent = {{-16, -16}, {16, 16}})));
  Modelica.Blocks.Interfaces.RealOutput wheelSpeed annotation(
        Placement(transformation(origin = {0, -104}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TireVisualizer tireVisualizer annotation(
        Placement(transformation(origin = {98, 56}, extent = {{-10, -10}, {10, 10}})));
    equation
      wheelSpeed = spinFL.w;
      connect(spinFL.frame_b, wheelFL.frame_a) annotation(
        Line(points = {{42, -2}, {62, -2}}, color = {95, 95, 95}));
      connect(wheelSupport, wheelFL.frame_a) annotation(
        Line(points = {{100, -2}, {62, -2}}));
      connect(spinInput, spinFL.axis) annotation(
        Line(points = {{32, 100}, {32, 8}}));
  connect(suspMount, spinFL.frame_a) annotation(
        Line(points = {{-102, -2}, {22, -2}}));
  connect(tireVisualizer.frame_a, wheelFL.frame_a) annotation(
        Line(points = {{88, 56}, {62, 56}, {62, -2}}, color = {95, 95, 95}));
    end DrivingTire;

    
    
    
    model TireVisualizer "Visualizing a voluminous wheel"
      import Modelica.Mechanics.MultiBody.Visualizers;
      extends Modelica.Mechanics.MultiBody.Interfaces.PartialVisualizer;
    
      parameter Boolean animation=true "= true, if animation shall be enabled";
    
      parameter Modelica.Units.SI.Radius rTire=0.25 "Radius of the tire";
      parameter Modelica.Units.SI.Radius rRim= 0.14 "Radius of the rim";
      parameter Modelica.Units.SI.Radius width=0.25 "Width of the tire";
      parameter Modelica.Units.SI.Radius rCurvature=0.30 "Radius of the tire's cross section";
    
      parameter Modelica.Mechanics.MultiBody.Types.RealColor color={64,64,64}
        "Color of tire" annotation(Dialog(enable=animation, colorSelector=true, group="Material properties"));
      parameter Real specularCoefficient = 0.5
        "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(enable=animation, group="Material properties"));
      parameter Integer n_rTire=40 "Number of points along rTire" annotation(Dialog(enable=animation, tab="Discretization"));
      parameter Integer n_rCurvature=20 "Number of points along rCurvature" annotation(Dialog(enable=animation, tab="Discretization"));
    
    protected
      parameter Modelica.Units.SI.Radius rw = (width/2);
      parameter Modelica.Units.SI.Radius rCurvature2 = if rCurvature > rw then rCurvature else rw;
      final parameter Real kw = rw/rCurvature2 "Regularized width ratio (0...1)";
      parameter Modelica.Units.SI.Radius h =     sqrt(1 - kw*kw) * rCurvature2;
      parameter Modelica.Units.SI.Length ri =  rTire-rCurvature2;
      parameter Modelica.Units.SI.Radius rRim2 = if rRim < 0 then 0 else if rRim > ri+h then ri+h else rRim;
    
        Visualizers.Advanced.Shape pipe(
        shapeType="pipe",
        color=color,
        length=width,
        width=2*(ri + h),
        height=2*(ri + h),
        lengthDirection={0,0,1},
        widthDirection={0,1,0},
        extra=(rRim2)/(ri + h),
        r=frame_a.r_0,
        r_shape=-{0,0,1}*(width/2),
        R=frame_a.R,
        specularCoefficient=specularCoefficient) if world.enableAnimation and animation annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    
        Visualizers.Advanced.Surface torus(
        redeclare function surfaceCharacteristic = Modelica.Mechanics.MultiBody.Visualizers.Advanced.SurfaceCharacteristics.torus (
            R=ri,
            r=rCurvature2,
            opening=Modelica.Constants.pi - Modelica.Math.asin(kw)),
        nu=n_rTire,
        nv=n_rCurvature,
        multiColoredSurface=false,
        wireframe=false,
        color=color,
        specularCoefficient=specularCoefficient,
        transparency=0,
        R=frame_a.R,
        r_0=frame_a.r_0) if world.enableAnimation and animation annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    
    equation
// No forces and torques
      frame_a.f = zeros(3);
      frame_a.t = zeros(3);
      annotation (
        Icon(
          graphics={
            Polygon(lineColor = {64, 64, 64}, fillColor = {191, 191, 191}, fillPattern = FillPattern.Sphere, points = {{-40, 80}, {-20, 90}, {15, 90}, {40, 85}, {58.776, 73.91}, {70.456, 56.568}, {74.951, 44.383}, {78.26, 30.614}, {80.302, 15.68}, {81, 0}, {81, 0}, {80.302, -15.68}, {78.26, -30.614}, {74.951, -44.383}, {70.456, -56.568}, {58.776, -73.91}, {40, -85}, {15, -90}, {-20, -90}, {-40, -80}, {-48.776, -73.91}, {-60.456, -56.568}, {-64.951, -44.383}, {-68.26, -30.614}, {-70.302, -15.68}, {-71, 0}, {-71, 0}, {-70.302, 15.68}, {-68.26, 30.614}, {-64.951, 44.383}, {-60.456, 56.568}, {-48.776, 73.91}}, smooth = Smooth.Bezier),
            Polygon(lineColor = {64, 64, 64}, fillColor = {64, 64, 64}, fillPattern = FillPattern.Solid, points = {{1, 0}, {0.302, 15.68}, {-1.74, 30.614}, {-5.049, 44.383}, {-9.544, 56.568}, {-21.224, 73.91}, {-35, 80}, {-48.776, 73.91}, {-60.456, 56.568}, {-64.951, 44.383}, {-68.26, 30.614}, {-70.302, 15.68}, {-71, 0}, {-70.302, -15.68}, {-68.26, -30.614}, {-64.951, -44.383}, {-60.456, -56.568}, {-48.776, -73.91}, {-35, -80}, {-21.224, -73.91}, {-9.544, -56.568}, {-5.049, -44.383}, {-1.74, -30.614}, {0.302, -15.68}, {1, 0}}, smooth = Smooth.Bezier),
            Polygon(lineColor = {64, 64, 64}, fillColor = {191, 191, 191}, fillPattern = FillPattern.HorizontalCylinder, points = {{-12.5, 0}, {-14.213, -19.134}, {-19.09, -35.355}, {-26.39, -46.194}, {-35, -50}, {-43.61, -46.194}, {-50.91, -35.355}, {-55.787, -19.134}, {-57.5, 0}, {-55.787, 19.134}, {-50.91, 35.355}, {-43.61, 46.194}, {-35, 50}, {-26.39, 46.194}, {-19.09, 35.355}, {-14.213, 19.134}, {-12.5, 0}}, smooth = Smooth.Bezier),
            Text(textColor = {0,0,255}, extent = {{-150, 100}, {150, 140}}, textString = "%name"),
            Rectangle(origin = {6.091, 0}, lineColor = {95, 95, 95}, fillColor = {215, 215, 215}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-102.091, -8}, {-19.142, 8}})},
          coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true)),
        Documentation(info = "<html>
    <p>
    Model <strong>VoluminousWheel</strong> provides a simple visualization of a tire using
    a torus and a pipe shape object. The center of the wheel is located at
    connector frame_a (visualized by the red coordinate system in the figure below).
    </p>
    
    <blockquote>
    <img src=\"modelica://Modelica/Resources/Images/Mechanics/MultiBody/Visualizers/VoluminousWheel.png\">
    </blockquote>
    </html>", revisions="<html>
      <ul>
      <li> July 2010 by Martin Otter<br>
           Adapted to the new Surface model.</li>
      <li> July 2005 by Dirk Zimmer (practical training at DLR)<br>
           First version to visualize a multi-level tyre wheel model.</li>
      </ul>
    </html>"));
    end TireVisualizer;

  end Tires;

  package Differentials
     
partial model Differential
      Modelica.Blocks.Interfaces.RealInput i annotation(
        Placement(transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 92}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
      Modelica.Mechanics.Rotational.Sources.Speed left annotation(
        Placement(transformation(origin = {-64, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
      Modelica.Mechanics.Rotational.Sources.Speed right annotation(
        Placement(transformation(origin = {62, 0}, extent = {{-20, -20}, {20, 20}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a left_out annotation(
        Placement(transformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a right_out annotation(
        Placement(transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(left_out, left.flange) annotation(
        Line(points = {{-102, 0}, {-84, 0}}));
      connect(right.flange, right_out) annotation(
        Line(points = {{82, 0}, {102, 0}}));
      annotation(
        uses(Modelica(version = "4.1.0")));
    end Differential;

    model SolidAxle
      extends Differential;
    equation
      connect(i, left.w_ref) annotation(
        Line(points = {{0, 108}, {0, 0}, {-40, 0}}, color = {0, 0, 127}));
      connect(i, right.w_ref) annotation(
        Line(points = {{0, 108}, {0, 0}, {38, 0}}, color = {0, 0, 127}));
    end SolidAxle;
  end Differentials;

  package Suspension
    model SpringDamper
      Modelica.Mechanics.MultiBody.Joints.Prismatic suspRL(n = {0, 0, -1}, s(fixed = true, start = 0.1)) annotation(
        Placement(transformation(origin = {98, -48}, extent = {{-110, 30}, {-90, 50}})));
      Modelica.Mechanics.MultiBody.Forces.SpringDamperParallel shockRL(c = 30000, d = 2500, s_unstretched = 0.3) annotation(
        Placement(transformation(origin = {96, -48}, extent = {{-110, 60}, {-90, 80}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b tireConnection annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, -2}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b chassisMount annotation(
        Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}})));
    equation
      connect(shockRL.frame_a, suspRL.frame_a) annotation(
        Line(points = {{-14, 22}, {-30, 22}, {-30, -8}, {-12, -8}}, color = {95, 95, 95}));
      connect(suspRL.frame_a, tireConnection) annotation(
        Line(points = {{-12, -8}, {-100, -8}, {-100, 0}}, color = {95, 95, 95}));
      connect(suspRL.frame_b, chassisMount) annotation(
        Line(points = {{8, -8}, {100, -8}, {100, -2}}, color = {95, 95, 95}));
      connect(shockRL.frame_b, chassisMount) annotation(
        Line(points = {{6, 22}, {42, 22}, {42, -2}, {100, -2}}, color = {95, 95, 95}));
    end SpringDamper;

    partial model BaseSuspension
      import MultiBody = Modelica.Mechanics.MultiBody;
      // Connection to the chassis
      MultiBody.Interfaces.Frame_a chassisMount annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
      // Connection to the wheel/tire block
      MultiBody.Interfaces.Frame_b wheelMount annotation(Placement(transformation(extent={{90,-10},{110,10}})));
    // Common parameters every suspension needs
      parameter Real k_spring = 30000 "Spring rate (N/m)";
      parameter Real d_damper = 2500 "Damping rate (N.s/m)";
      parameter Real m_hub = 15 "Unsprung mass of the hub/knuckle (kg)";
      parameter Boolean steerable = false "Enable steering revolute at wheel output";
      Modelica.Mechanics.Rotational.Interfaces.Flange_b steerInput if steerable annotation(
        Placement(transformation(extent = {{-10, 90}, {10, 110}}), iconTransformation(extent = {{-10, 90}, {10, 110}})));
    end BaseSuspension;

    model DoubleWishbone
      extends BaseSuspension;
      import MultiBody = Modelica.Mechanics.MultiBody;
    // --- Geometry parameters ---
      parameter Real sideSign = 1 "1 for left side, -1 for right side";
      parameter Modelica.Units.SI.Length upperArmLength = 0.35 "Upper control arm length";
      parameter Modelica.Units.SI.Length lowerArmLength = 0.35 "Lower control arm length";
      parameter Modelica.Units.SI.Length upperMountZ = 0.25 "Upper mount height above chassis mount";
      parameter Modelica.Units.SI.Length lowerMountZ = 0.15 "Lower mount height below chassis mount";
      parameter Modelica.Units.SI.Length shockTopHeight = 0.35 "Shock top mount height above chassis mount";
    // --- Chassis-side offsets ---
      MultiBody.Parts.FixedTranslation upperChassisOffset(r={0, upperMountZ, 0}) annotation(
        Placement(transformation(extent={{-70, 20}, {-50, 40}})));
      MultiBody.Parts.FixedTranslation lowerChassisOffset(r={0, -lowerMountZ, 0}) annotation(
        Placement(transformation(extent={{-70, -40}, {-50, -20}})));
    // --- Upper A-arm (tree branch: the only regular revolute) ---
      MultiBody.Joints.Revolute upperChassisPivot(n={1, 0, 0}) annotation(
        Placement(transformation(extent={{-40, 20}, {-20, 40}})));
      MultiBody.Parts.BodyCylinder upperArm(r={0, 0, sideSign*upperArmLength}, diameter=0.03) annotation(
        Placement(transformation(extent={{-10, 20}, {10, 40}})));
    // --- Closed-loop: JointRRR handles 3 revolutes + 2 rods analytically ---
      MultiBody.Joints.Assemblies.JointRRR jointLoop(
        rRod1_ia={0, -(upperMountZ + lowerMountZ), 0},
        rRod2_ib={0, 0, sideSign*lowerArmLength},
        n_a={1, 0, 0}) annotation(
        Placement(transformation(origin = {90, 2},extent = {{20, -40}, {60, 40}}, rotation = 180)));
    // --- Hub/knuckle mass at the upper ball joint, CM at knuckle center ---
      MultiBody.Parts.Body hub(m=m_hub,
        r_CM={0, -(upperMountZ + lowerMountZ)/2, 0},
        I_11=0.1, I_22=0.1, I_33=0.1) annotation(
        Placement(transformation(origin = {18, 28}, extent = {{70, 20}, {90, 40}})));
    // --- Shock top mount (above chassis for proper vertical force transfer) ---
      MultiBody.Parts.FixedTranslation shockTopMount(r={0, shockTopHeight, 0}) annotation(
        Placement(transformation(extent={{-70, 50}, {-50, 70}})));

// --- Wheel center offset (from upper ball joint down to knuckle midpoint) ---
      MultiBody.Parts.FixedTranslation wheelOffset(r={0, -(upperMountZ + lowerMountZ)/2, 0}) annotation(
        Placement(transformation(extent={{60, -10}, {80, 10}})));

// --- Steering revolute (axis always exposed; locked by steerLock when steerable=false) ---
      MultiBody.Joints.Revolute steer(
        n = {0, 1, 0},
        useAxisFlange = true) annotation(
        Placement(transformation(origin = {-6, 18}, extent = {{82, -10}, {102, 10}})));
      Modelica.Mechanics.Rotational.Components.Fixed steerLock if not steerable annotation(
        Placement(transformation(origin = {76, 40}, extent = {{-6, -6}, {6, 6}})));

// --- Spring-damper ---
      MultiBody.Forces.SpringDamperParallel shock(c=k_spring, d=d_damper, s_unstretched=0.55) annotation(
        Placement(transformation(origin = {-14, -2}, extent = {{-20, -80}, {0, -60}})));
    
    equation
// Chassis-side: split into upper and lower mount points
      connect(chassisMount, upperChassisOffset.frame_a) annotation(
        Line(points={{-100, 0}, {-80, 0}, {-80, 30}, {-70, 30}}, color={95, 95, 95}));
      connect(chassisMount, lowerChassisOffset.frame_a) annotation(
        Line(points={{-100, 0}, {-80, 0}, {-80, -30}, {-70, -30}}, color={95, 95, 95}));
// Tree branch: upper chassis pivot → upper A-arm
      connect(upperChassisOffset.frame_b, upperChassisPivot.frame_a) annotation(
        Line(points={{-50, 30}, {-40, 30}}, color={95, 95, 95}));
      connect(upperChassisPivot.frame_b, upperArm.frame_a) annotation(
        Line(points={{-20, 30}, {-10, 30}}, color={95, 95, 95}));
// JointRRR closes the loop analytically
      connect(upperArm.frame_b, jointLoop.frame_a) annotation(
        Line(points={{10, 30}, {16, 30}, {16, 2}, {70, 2}}, color={95, 95, 95}));
      connect(lowerChassisOffset.frame_b, jointLoop.frame_b) annotation(
        Line(points={{-50, -30}, {30, -30}, {30, 2}}, color={95, 95, 95}));
// Hub body at knuckle top (frame_ia = after first revolute of JointRRR)
      connect(jointLoop.frame_ia, hub.frame_a) annotation(
        Line(points={{66, -38}, {66, 58}, {88, 58}}, color={95, 95, 95}));
// Wheel output at knuckle center (offset down from upper ball joint)
      connect(jointLoop.frame_ia, wheelOffset.frame_a) annotation(
        Line(points={{66, -38}, {66, 50}, {60, 50}, {60, 0}}, color={95, 95, 95}));
      connect(wheelOffset.frame_b, steer.frame_a) annotation(
        Line(points = {{80, 0}, {80, 10}, {76, 10}, {76, 18}}, color = {95, 95, 95}));
// Shock: top mount above chassis to lower ball-joint point (middle revolute = frame_im)
      connect(chassisMount, shockTopMount.frame_a) annotation(
        Line(points={{-100, 0}, {-80, 0}, {-80, 60}, {-70, 60}}, color={95, 95, 95}));
      connect(shockTopMount.frame_b, shock.frame_a) annotation(
        Line(points={{-50, 60}, {-34, 60}, {-34, -72}}, color={95, 95, 95}));
      connect(jointLoop.frame_im, shock.frame_b) annotation(
        Line(points={{50, -38}, {50, -56}, {-14, -56}, {-14, -72}}, color={95, 95, 95}));
  connect(steerInput, steer.axis) annotation(
        Line(points = {{0, 100}, {0, 44}, {86, 44}, {86, 28}}));
  connect(steer.axis, steerLock.flange) annotation(
        Line(points = {{86, 28}, {86, 40}, {82, 40}}));
  connect(steer.frame_b, wheelMount) annotation(
        Line(points = {{96, 18}, {114, 18}, {114, 0}, {100, 0}}, color = {95, 95, 95}));
      annotation(Icon(graphics={
        Line(points={{-80, 30}, {0, 50}}, color={95, 95, 95}, thickness=1),
        Line(points={{-80, -30}, {0, -50}}, color={95, 95, 95}, thickness=1),
        Line(points={{0, 50}, {0, -50}}, color={0, 0, 0}, thickness=1.5),
        Ellipse(extent={{-6, 6}, {6, -6}}, origin={0, 50}, fillColor={95, 95, 95}, fillPattern=FillPattern.Solid),
        Ellipse(extent={{-6, 6}, {6, -6}}, origin={0, -50}, fillColor={95, 95, 95}, fillPattern=FillPattern.Solid),
        Line(points={{-80, 30}, {-80, -30}}, color={0, 0, 0}, thickness=2),
        Line(points={{-60, 60}, {-40, -60}}, color={0, 128, 0}, pattern=LinePattern.DashDot, thickness=0.5),
        Text(extent={{-100, -80}, {100, -100}}, textString="%name")}));
    end DoubleWishbone;
  end Suspension;

  package Floors
    model GroundSpring "Vertical spring-damper ground contact"
      import MultiBody = Modelica.Mechanics.MultiBody;
      parameter Real ground_c = 1e5 "Floor stiffness (N/m)";
      parameter Real ground_d = 5000 "Floor damping (N.s/m)";
      outer DDynamics.Terrains.TerrainMap terrain;
      MultiBody.Interfaces.Frame_b wheelContact annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}),
        iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      MultiBody.Forces.WorldForce normalForce annotation(
        Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}})));
    protected
      Real vy;
    equation
      connect(normalForce.frame_b, wheelContact);
      vy = der(wheelContact.r_0[2]);
      normalForce.force = {
        0,
        noEvent(max(0, ground_c * (terrain.getZ(wheelContact.r_0[1], wheelContact.r_0[3]) - wheelContact.r_0[2]) - ground_d * vy)),
        0
      };
    end GroundSpring;

    model GroundFriction "Slip-based longitudinal and viscous lateral friction"
      import MultiBody = Modelica.Mechanics.MultiBody;
      parameter Real ground_mu = 10000 "Longitudinal viscous friction coefficient (N.s/m)";
      parameter Real mu_lat = 100000 "Lateral viscous friction coefficient (N.s/m)";
      parameter Real R_wheel = 0.3 "Wheel radius (m)";
      outer DDynamics.Terrains.TerrainMap terrain;
      MultiBody.Interfaces.Frame_b wheelContact annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}),
        iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Blocks.Interfaces.RealInput spinSpeed annotation(
        Placement(transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90),
        iconTransformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
      MultiBody.Forces.WorldForce frictionForce annotation(
        Placement(transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}})));
    protected
      parameter Real contactRampDepth = 0.001 "Depth over which friction ramps from 0 to full (m)";
      Real vWorld[3], axleWorld[3], headingWorld[3], contactDepth, frictionScale;
      Real vLong, vLat;
    equation
      connect(frictionForce.frame_b, wheelContact);
      vWorld = der(wheelContact.r_0);
// Spin-invariant axle direction: rotating around n={0,0,-1} leaves that axis unchanged,
// so resolve1(R, {0,0,-1}) equals the same world vector regardless of wheel spin angle.
      axleWorld = Modelica.Mechanics.MultiBody.Frames.resolve1(wheelContact.R, {0,0,-1});
// Rolling direction: cross product of axle and world-up {0,1,0}.
// Works for all heading directions; never degenerates when the car turns.
      headingWorld = cross(axleWorld, {0, 1, 0});
      vLong = vWorld * headingWorld;
      vLat  = vWorld * axleWorld;
      contactDepth = noEvent(max(0, terrain.getZ(wheelContact.r_0[1], wheelContact.r_0[3]) - wheelContact.r_0[2]));
      frictionScale = noEvent(min(1, contactDepth / contactRampDepth));
      frictionForce.force = frictionScale * (
        -ground_mu * (vLong - spinSpeed * R_wheel) * headingWorld
        - mu_lat * vLat * axleWorld);
    end GroundFriction;

    model Floor "Complete wheel-ground contact. Connect tire.wheelSupport to wheelContact."
      import MultiBody = Modelica.Mechanics.MultiBody;
      parameter Real ground_c = 1e5 "Floor stiffness (N/m)";
      parameter Real ground_d = 5000 "Floor damping (N.s/m)";
      parameter Real ground_mu = 10000 "Longitudinal viscous friction coefficient (N.s/m)";
      parameter Real mu_lat = 100000 "Lateral viscous friction coefficient (N.s/m)";
      parameter Real R_wheel = 0.3 "Wheel radius (m)";
      MultiBody.Interfaces.Frame_b wheelContact annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}),
        iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Blocks.Interfaces.RealInput spinSpeed annotation(
        Placement(transformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90),
        iconTransformation(origin = {0, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
      GroundSpring gs(ground_c = ground_c, ground_d = ground_d) annotation(
        Placement(transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}})));
      GroundFriction gf(ground_mu = ground_mu, mu_lat = mu_lat, R_wheel = R_wheel) annotation(
        Placement(transformation(origin = {0, -30}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(gs.wheelContact, wheelContact);
      connect(gf.wheelContact, wheelContact);
      gf.spinSpeed = spinSpeed;
    end Floor;
  end Floors;

  package Terrains
    block TerrainMap "Calculates ground height based on X,Y position"
      function getZ
        input Real x;
        input Real y;
        output Real z;
      algorithm // Example: A 3D wave or a ramp
//z := 0.2 * Modelica.Math.sin(2 * Modelica.Constants.pi * x / 5);
        z := 1;
      end getZ;

    end TerrainMap;

    function terrainSurface "Surface characteristic for terrain visualization (keep in sync with TerrainMap.getZ)"
      extends Modelica.Mechanics.MultiBody.Visualizers.Advanced.Interfaces.partialSurfaceCharacteristic(
          final multiColoredSurface=false);
      input Real x_min = -10 "Minimum X (forward)";
      input Real x_max =  10 "Maximum X (forward)";
      input Real z_min =  -5 "Minimum Z (lateral)";
      input Real z_max =   5 "Maximum Z (lateral)";
    algorithm
      for i in 1:nu loop
        for j in 1:nv loop
          X[i,j] := x_min + (i-1) * (x_max - x_min) / (nu - 1);
          Z[i,j] := z_min + (j-1) * (z_max - z_min) / (nv - 1);
//Y[i,j] := 0.2 * Modelica.Math.sin(2 * Modelica.Constants.pi * X[i,j] / 5);
          Y[i,j] := 1;
        end for;
      end for;
    end terrainSurface;

    model TerrainVisualizer "Flat ground slab visualization aligned with TerrainMap height"
      extends Modelica.Mechanics.MultiBody.Interfaces.PartialVisualizer;
      parameter Boolean animation = true "= true, if animation shall be enabled";
      parameter Real x_min = -10 "Slab start in X (forward)";
      parameter Real x_max =  10 "Slab end in X (forward)";
      parameter Real z_min =  -5 "Slab start in Z (lateral)";
      parameter Real z_max =   5 "Slab end in Z (lateral)";
      parameter Real groundHeight = 1.0 "Terrain height Y (keep in sync with TerrainMap.getZ)";
      parameter Modelica.Mechanics.MultiBody.Types.RealColor color = {0, 160, 0} "Ground color";
      parameter Real specularCoefficient = 0.1;

      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape ground(
        shapeType = "box",
        color = color,
        specularCoefficient = specularCoefficient,
        length = x_max - x_min,
        width  = z_max - z_min,
        height = 0.02,
        lengthDirection = {1, 0, 0},
        widthDirection  = {0, 0, 1},
        r_shape = {x_min, groundHeight, 0},
        r = frame_a.r_0,
        R = frame_a.R) if world.enableAnimation and animation;
    equation
      frame_a.f = zeros(3);
      frame_a.t = zeros(3);
    end TerrainVisualizer;

  end Terrains;

  package Interfaces
    model FrameToReal
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      // Position is a real array
      Modelica.Blocks.Interfaces.RealOutput x_out annotation(
        Placement(transformation(origin = {107, 57}, extent = {{-19, -19}, {19, 19}}), iconTransformation(origin = {102, 38}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput y_out annotation(
        Placement(transformation(origin = {110, 0}, extent = {{-22, -22}, {22, 22}}), iconTransformation(origin = {98, -42}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Blocks.Interfaces.RealOutput z_out annotation(
        Placement(transformation(origin = {111, -61}, extent = {{-21, -21}, {21, 21}}), iconTransformation(origin = {102, -84}, extent = {{-10, -10}, {10, 10}})));
    equation
      frame_a.r_0[1] = x_out;
      frame_a.r_0[2] = y_out;
      frame_a.r_0[3] = z_out;
      frame_a.f = {0, 0, 0};
      frame_a.t = {0, 0, 0};
    end FrameToReal;
  
    model FrameToUDP
      //parameter Integer port = 12345;
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(
        Placement(transformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}})));
      FrameToReal frameToReal annotation(
        Placement(transformation(origin = {-44, 0}, extent = {{-26, -26}, {26, 26}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
        Placement(transformation(origin = {48, 60}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1) annotation(
        Placement(transformation(origin = {48, 12}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1) annotation(
        Placement(transformation(origin = {48, -32}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(port_send = 12345, sampleTime = 0.01) annotation(
        Placement(transformation(origin = {82, -62}, extent = {{-10, -10}, {10, 10}})));
      Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
        Placement(transformation(origin = {-72, 82}, extent = {{-10, -10}, {10, 10}})));
    equation
      connect(frame_a, frameToReal.frame_a) annotation(
        Line(points = {{-100, 0}, {-70, 0}}));
      connect(packager.pkgOut, addFloat.pkgIn) annotation(
        Line(points = {{48, 49.2}, {48, 21.2}}));
      connect(addFloat.pkgOut[1], addFloat1.pkgIn) annotation(
        Line(points = {{48, 1.2}, {48, -22.8}}));
      connect(addFloat1.pkgOut[1], uDPSend.pkgIn) annotation(
        Line(points = {{48, -42.8}, {48, -62.8}, {72, -62.8}}));
      connect(frameToReal.x_out, addFloat.u[1]) annotation(
        Line(points = {{-18, 10}, {36, 10}, {36, 12}}, color = {0, 0, 127}));
      connect(frameToReal.y_out, addFloat1.u[1]) annotation(
        Line(points = {{-18, -10}, {36, -10}, {36, -32}}, color = {0, 0, 127}));
    end FrameToUDP;
  
  
  end Interfaces;

  package Examples
  model CarExample
    inner Terrains.TerrainMap terrainMap annotation(
        Placement(transformation(origin = {-88, 78}, extent = {{-10, -10}, {10, 10}})));
  Terrains.TerrainVisualizer terrainViz annotation(
        Placement(transformation(origin = {-88, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Parts.Body chassis(m = 400)  annotation(
        Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFL(r = {1.5, -0.25, 0.9})  annotation(
        Placement(transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountFR(r = {1.5, -0.25, -0.9})  annotation(
        Placement(transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRL(r = {-1.5, -0.25, 0.9})  annotation(
        Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation mountRR(r = {-1.5, -0.25, -0.9})  annotation(
        Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Suspension.DoubleWishbone doubleWishboneRL annotation(
        Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Suspension.DoubleWishbone doubleWishboneRR(sideSign = -1)  annotation(
        Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Suspension.DoubleWishbone doubleWishboneFL(steerable = true) annotation(
        Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Suspension.DoubleWishbone doubleWishboneFR(sideSign = -1, steerable = true)  annotation(
        Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
  Tires.Tire ttireFL annotation(
        Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}})));
  Tires.Tire tireFR annotation(
        Placement(transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}})));
  Tires.DrivingTire tireRL annotation(
        Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Tires.DrivingTire tireRR annotation(
        Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Differentials.SolidAxle solidAxle annotation(
        Placement(transformation(origin = {-152, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Floors.Floor floorFL annotation(
        Placement(transformation(origin = {180, 40}, extent = {{-10, -10}, {10, 10}})));
  Floors.Floor floorFR annotation(
        Placement(transformation(origin = {180, -40}, extent = {{-10, -10}, {10, 10}})));
  Floors.Floor floorRR annotation(
        Placement(transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Floors.Floor floorRL annotation(
        Placement(transformation(origin = {-190, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  inner Modelica.Mechanics.MultiBody.World world annotation(
        Placement(transformation(origin = {-42, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.MultiBody.Joints.FreeMotion freeMotion(r_rel_a(start = {0, 1.2, 0}), v_rel_a(start = {0, 0, 0}))  annotation(
        Placement(transformation(origin = {-4, 44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant speed(k = 5)  annotation(
        Placement(transformation(origin = {-92, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant steer(k = 0.1)  annotation(
        Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Position steerAct annotation(
        Placement(transformation(origin = {102, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.Position steerAct1 annotation(
        Placement(transformation(origin = {102, -12}, extent = {{-10, -10}, {10, 10}})));
    equation
  connect(mountFL.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, 40}, {20, 40}, {20, 0}, {-10, 0}}, color = {95, 95, 95}));
  connect(mountFR.frame_a, chassis.frame_a) annotation(
        Line(points = {{40, -40}, {20, -40}, {20, 0}, {-10, 0}}, color = {95, 95, 95}));
  connect(mountFL.frame_b, doubleWishboneFL.chassisMount) annotation(
        Line(points = {{60, 40}, {100, 40}}, color = {95, 95, 95}));
  connect(mountFR.frame_b, doubleWishboneFR.chassisMount) annotation(
        Line(points = {{60, -40}, {100, -40}}, color = {95, 95, 95}));
  connect(doubleWishboneFR.wheelMount, tireFR.suspMount) annotation(
        Line(points = {{120, -40}, {140, -40}}, color = {95, 95, 95}));
  connect(doubleWishboneFL.wheelMount, ttireFL.suspMount) annotation(
        Line(points = {{120, 40}, {140, 40}}, color = {95, 95, 95}));
  connect(doubleWishboneRL.wheelMount, tireRL.suspMount) annotation(
        Line(points = {{-120, 40}, {-140, 40}}, color = {95, 95, 95}));
  connect(doubleWishboneRR.wheelMount, tireRR.suspMount) annotation(
        Line(points = {{-120, -40}, {-140, -40}}, color = {95, 95, 95}));
  connect(solidAxle.right_out, tireRR.spinInput) annotation(
        Line(points = {{-152, -12}, {-152, -22}, {-174, -22}, {-174, -58}, {-154, -58}, {-154, -50}}));
  connect(solidAxle.left_out, tireRL.spinInput) annotation(
        Line(points = {{-152, 8}, {-152, 19}, {-154, 19}, {-154, 30}}));
  connect(ttireFL.wheelSupport, floorFL.wheelContact) annotation(
        Line(points = {{160, 40}, {170, 40}}, color = {95, 95, 95}));
  connect(tireFR.wheelSupport, floorFR.wheelContact) annotation(
        Line(points = {{160, -40}, {170, -40}}, color = {95, 95, 95}));
  connect(floorRR.wheelContact, tireRR.wheelSupport) annotation(
        Line(points = {{-180, -40}, {-160, -40}}, color = {95, 95, 95}));
  connect(floorRL.wheelContact, tireRL.wheelSupport) annotation(
        Line(points = {{-180, 40}, {-160, 40}}, color = {95, 95, 95}));
  connect(tireRL.wheelSpeed, floorRL.spinSpeed) annotation(
        Line(points = {{-150, 50}, {-150, 68}, {-216, 68}, {-216, 20}, {-190, 20}, {-190, 30}}, color = {0, 0, 127}));
  connect(tireRR.wheelSpeed, floorRR.spinSpeed) annotation(
        Line(points = {{-150, -30}, {-152, -30}, {-152, -22}, {-216, -22}, {-216, -64}, {-190, -64}, {-190, -50}}, color = {0, 0, 127}));
  connect(ttireFL.wheelSpeed, floorFL.spinSpeed) annotation(
        Line(points = {{150, 30}, {150, 8}, {210, 8}, {210, 66}, {180, 66}, {180, 50}}, color = {0, 0, 127}));
  connect(tireFR.wheelSpeed, floorFR.spinSpeed) annotation(
        Line(points = {{150, -50}, {150, -72}, {210, -72}, {210, -14}, {180, -14}, {180, -30}}, color = {0, 0, 127}));
  connect(world.frame_b, freeMotion.frame_a) annotation(
        Line(points = {{-32, 80}, {-18, 80}, {-18, 44}, {-14, 44}}, color = {95, 95, 95}));
  connect(world.frame_b, terrainViz.frame_a) annotation(
        Line(points = {{-32, 80}, {-60, 80}, {-60, 60}, {-78, 60}}, color = {95, 95, 95}));
  connect(freeMotion.frame_b, chassis.frame_a) annotation(
        Line(points = {{6, 44}, {12, 44}, {12, 20}, {-20, 20}, {-20, 0}, {-10, 0}}, color = {95, 95, 95}));
  connect(solidAxle.i, speed.y) annotation(
        Line(points = {{-142, -2}, {-102, -2}}, color = {0, 0, 127}));
  connect(steer.y, steerAct.phi_ref) annotation(
        Line(points = {{61, 0}, {75, 0}, {75, 10}, {90, 10}}, color = {0, 0, 127}));
  connect(steer.y, steerAct1.phi_ref) annotation(
        Line(points = {{61, 0}, {76, 0}, {76, -12}, {90, -12}}, color = {0, 0, 127}));
  connect(doubleWishboneRL.chassisMount, mountRL.frame_b) annotation(
        Line(points = {{-100, 40}, {-80, 40}}, color = {95, 95, 95}));
  connect(mountRL.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, 40}, {-26, 40}, {-26, 0}, {-10, 0}}, color = {95, 95, 95}));
  connect(doubleWishboneRR.chassisMount, mountRR.frame_b) annotation(
        Line(points = {{-100, -40}, {-80, -40}}, color = {95, 95, 95}));
  connect(mountRR.frame_a, chassis.frame_a) annotation(
        Line(points = {{-60, -40}, {-26, -40}, {-26, 0}, {-10, 0}}, color = {95, 95, 95}));
  connect(steerAct1.flange, doubleWishboneFR.steerInput) annotation(
        Line(points = {{112, -12}, {124, -12}, {124, -26}, {110, -26}, {110, -30}}));
  connect(steerAct.flange, doubleWishboneFL.steerInput) annotation(
        Line(points = {{112, 10}, {128, 10}, {128, 60}, {110, 60}, {110, 50}}));
    end CarExample;
  end Examples;
  annotation(
    uses(Modelica(version = "4.1.0"), Modelica_DeviceDrivers(version = "2.2.0")));
end DDynamics;
