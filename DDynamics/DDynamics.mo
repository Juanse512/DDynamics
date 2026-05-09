package DDynamics
  model cifacar
    parameter Real Lr = 0.79, Lf = 0.79, Lw = 0.6, R = 0.3;
    //car geometry
    parameter Real m = 200, J = 50;
    //weight
    parameter Real Jw = 5, bw = 1.7;
    //wheel intertia and friction
    parameter Real bf = 10000;
    //friction coefficient
    Real x, y, th, vx, vy, w, d;
    //state variables
    Real Fxlr, Fxrr, Fxlf, Fxrf, Fylr, Fyrr, Fylf, Fyrf;
    //tire forces
    Real taulr, taurr, taulf, taurf;
    //tire transmitted torques
    Real Tlr, Trr, Tlf, Trf;
    //tire input torques
    Real wlr, wrr, wlf, wrf;
    // wheels' speed
    Real vxlr, vylr, vxrr, vyrr, vxlf, vylf, vxrf, vyrf;
    //tire speed
    Real psi;
    //steer angle
    Real v;
    Modelica.Blocks.Interfaces.RealInput wheel_input annotation(
      Placement(transformation(origin = {-104, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-98, 40}, extent = {{-20, -20}, {20, 20}})));
    Modelica.Blocks.Interfaces.RealInput throttle annotation(
      Placement(transformation(origin = {-104, -42}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-100, -42}, extent = {{-20, -20}, {20, 20}})));
    Modelica.Blocks.Interfaces.RealOutput x_out annotation(
      Placement(transformation(origin = {111, 39}, extent = {{-19, -19}, {19, 19}}), iconTransformation(origin = {102, 38}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.RealOutput y_out annotation(
      Placement(transformation(origin = {114, -44}, extent = {{-22, -22}, {22, 22}}), iconTransformation(origin = {98, -42}, extent = {{-10, -10}, {10, 10}})));
  equation
    wheel_input = psi;
    Tlr = throttle;
    Trr = throttle;
    Tlf = throttle;
    Trf = throttle;
    vxlr = vx + (Lr*sin(th) - Lw*cos(th))*w;
    vxrr = vx + (Lr*sin(th) + Lw*cos(th))*w;
    vxlf = vx + ((-Lf*sin(th)) - Lw*cos(th))*w;
    vxrf = vx + ((-Lf*sin(th)) + Lw*cos(th))*w;
    vylr = vy + ((-Lr*cos(th)) - Lw*sin(th))*w;
    vyrr = vy + ((-Lr*cos(th)) + Lw*sin(th))*w;
    vylf = vy + (Lf*cos(th) - Lw*sin(th))*w;
    vyrf = vy + (Lf*cos(th) + Lw*sin(th))*w;
    Fxlr = bf*(R*wlr*cos(th) - vxlr);
    Fylr = bf*(R*wlr*sin(th) - vylr);
    Fxrr = bf*(R*wrr*cos(th) - vxrr);
    Fyrr = bf*(R*wrr*sin(th) - vyrr);
    Fxlf = bf*(R*wlf*cos(th + psi) - vxlf);
    Fylf = bf*(R*wlf*sin(th + psi) - vylf);
    Fxrf = bf*(R*wrf*cos(th + psi) - vxrf);
    Fyrf = bf*(R*wrf*sin(th + psi) - vyrf);
    taulr = Fxlr*sin(th)*Lr - Fxlr*cos(th)*Lw - Fylr*cos(th)*Lr - Fylr*sin(th)*Lw;
    taurr = Fxrr*sin(th)*Lr + Fxrr*cos(th)*Lw - Fyrr*cos(th)*Lr + Fyrr*sin(th)*Lw;
    taulf = (-Fxlf*sin(th)*Lf) - Fxlf*cos(th)*Lw + Fylf*cos(th)*Lf - Fylf*sin(th)*Lw;
    taurf = (-Fxrf*sin(th)*Lf) + Fxrf*cos(th)*Lw + Fyrf*cos(th)*Lf + Fylf*sin(th)*Lw;
    der(x) = vx;
    der(y) = vy;
    der(th) = w;
    der(vx) = (Fxlr + Fxrr + Fxlf + Fxrf)/m;
    der(vy) = (Fylr + Fyrr + Fylf + Fyrf)/m;
    der(w) = (taulr + taurr + taulf + taurf)/J;
    der(wlr) = (Tlr - Fxlr*R*cos(th) - Fylr*R*sin(th) - bw*wlr)/Jw;
    der(wrr) = (Trr - Fxrr*R*cos(th) - Fyrr*R*sin(th) - bw*wrr)/Jw;
    der(wlf) = (Tlf - Fxlf*R*cos(th + psi) - Fylf*R*sin(th + psi) - bw*wlf)/Jw;
    der(wrf) = (Trf - Fxrf*R*cos(th + psi) - Fyrf*R*sin(th + psi) - bw*wrf)/Jw;
    v = (wlr + wrr + wlf + wrf)*R/4;
    der(d) = abs(v);
    x_out = x;
    y_out = y;
    annotation(
      experiment(StartTime = 0, StopTime = 1000, Tolerance = 0.001, Interval = 2));
  end cifacar;

  model cifacar_inputs
    cifacar cifacar1 annotation(
      Placement(transformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Sources.Constant const(k = 100) annotation(
      Placement(transformation(origin = {-84, 6}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Sources.Constant const1(k = 100) annotation(
      Placement(transformation(origin = {-84, -22}, extent = {{-10, -10}, {10, 10}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.Packager packager annotation(
      Placement(transformation(origin = {54, 54}, extent = {{-10, -10}, {10, 10}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat(nu = 1) annotation(
      Placement(transformation(origin = {54, 6}, extent = {{-10, -10}, {10, 10}})));
    Modelica_DeviceDrivers.Blocks.Packaging.SerialPackager.AddFloat addFloat1(nu = 1) annotation(
      Placement(transformation(origin = {54, -38}, extent = {{-10, -10}, {10, 10}})));
    Modelica_DeviceDrivers.Blocks.Communication.UDPSend uDPSend(sampleTime = 0.01, port_send = 12345) annotation(
      Placement(transformation(origin = {88, -68}, extent = {{-10, -10}, {10, 10}})));
    Modelica_DeviceDrivers.Blocks.OperatingSystem.RealtimeSynchronize realtimeSynchronize annotation(
      Placement(transformation(origin = {-72, 70}, extent = {{-10, -10}, {10, 10}})));
  equation
    connect(const.y, cifacar1.wheel_input) annotation(
      Line(points = {{-73, 6}, {-10, 6}}, color = {0, 0, 127}));
    connect(const1.y, cifacar1.throttle) annotation(
      Line(points = {{-72, -22}, {-32, -22}, {-32, -2}, {-10, -2}}, color = {0, 0, 127}));
    connect(cifacar1.x_out, addFloat.u[1]) annotation(
      Line(points = {{10, 6}, {42, 6}}, color = {0, 0, 127}));
    connect(cifacar1.y_out, addFloat1.u[1]) annotation(
      Line(points = {{10, -2}, {24, -2}, {24, -38}, {42, -38}}, color = {0, 0, 127}));
    connect(packager.pkgOut, addFloat.pkgIn) annotation(
      Line(points = {{54, 44}, {54, 16}}));
    connect(addFloat.pkgOut[1], addFloat1.pkgIn) annotation(
      Line(points = {{54, -4}, {54, -28}}));
    connect(addFloat1.pkgOut[1], uDPSend.pkgIn) annotation(
      Line(points = {{54, -48}, {54, -68}, {78, -68}}));
  end cifacar_inputs;

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

  model FrontTire
    Modelica.Mechanics.MultiBody.Joints.Revolute steerFL(n = {0, 0, 1}, useAxisFlange = true) annotation(
      Placement(transformation(origin = {-148, -42}, extent = {{130, 30}, {150, 50}})));
    Modelica.Mechanics.MultiBody.Joints.Revolute spinFL(n = {0, 1, 0}, useAxisFlange = true) annotation(
      Placement(transformation(origin = {-148, -42}, extent = {{170, 30}, {190, 50}})));
    Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
      Placement(transformation(origin = {-148, -42}, extent = {{210, 30}, {230, 50}})));
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
      Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a steerInput annotation(
      Placement(transformation(origin = {-8, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-6, 100}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a spinInput annotation(
      Placement(transformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
      Placement(transformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, 2}, extent = {{-16, -16}, {16, 16}})));
  equation
    connect(steerFL.frame_b, spinFL.frame_a) annotation(
      Line(points = {{2, -2}, {22, -2}}, color = {95, 95, 95}));
    connect(spinFL.frame_b, wheelFL.frame_a) annotation(
      Line(points = {{42, -2}, {62, -2}}, color = {95, 95, 95}));
    connect(wheelSupport, wheelFL.frame_a) annotation(
      Line(points = {{100, -2}, {62, -2}}));
    connect(steerInput, steerFL.axis) annotation(
      Line(points = {{-8, 100}, {-8, 8}}));
    connect(spinInput, spinFL.axis) annotation(
      Line(points = {{32, 100}, {32, 8}}));
    connect(suspMount, steerFL.frame_a) annotation(
      Line(points = {{-102, -2}, {-18, -2}}));
  end FrontTire;

  model RearTire
    Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
      Placement(transformation(origin = {-148, -42}, extent = {{210, 30}, {230, 50}})));
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
      Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
      Placement(transformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, 2}, extent = {{-16, -16}, {16, 16}})));
    Modelica.Mechanics.MultiBody.Joints.Revolute spinRL(n = {0, 1, 0}) annotation(
      Placement(transformation(origin = {168, -42}, extent = {{-150, 30}, {-130, 50}})));
  equation
    connect(wheelSupport, wheelFL.frame_a) annotation(
      Line(points = {{100, -2}, {62, -2}}));
    connect(suspMount, spinRL.frame_a) annotation(
      Line(points = {{-102, -2}, {18, -2}}));
    connect(spinRL.frame_b, wheelFL.frame_a) annotation(
      Line(points = {{38, -2}, {62, -2}}, color = {95, 95, 95}));
  end RearTire;

  class Tires
      model Tire
      Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
        Placement(transformation(origin = {-148, -40}, extent = {{210, 30}, {230, 50}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
        Placement(transformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
        Placement(transformation(origin = {-102, 0}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.MultiBody.Joints.Revolute spinRL(n = {0, 1, 0}) annotation(
        Placement(transformation(origin = {168, -40}, extent = {{-150, 30}, {-130, 50}})));
    equation
      connect(wheelSupport, wheelFL.frame_a) annotation(
        Line(points = {{100, 0}, {62, 0}}));
      connect(suspMount, spinRL.frame_a) annotation(
        Line(points = {{-102, 0}, {18, 0}}));
      connect(spinRL.frame_b, wheelFL.frame_a) annotation(
        Line(points = {{38, 0}, {62, 0}}, color = {95, 95, 95}));
    end Tire;

    model DrivingTire
      Modelica.Mechanics.MultiBody.Joints.Revolute spinFL(n = {0, 1, 0}, useAxisFlange = true) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{170, 30}, {190, 50}})));
      Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{210, 30}, {230, 50}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
        Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a spinInput annotation(
        Placement(transformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
        Placement(transformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, 2}, extent = {{-16, -16}, {16, 16}})));
    equation
      connect(spinFL.frame_b, wheelFL.frame_a) annotation(
        Line(points = {{42, -2}, {62, -2}}, color = {95, 95, 95}));
      connect(wheelSupport, wheelFL.frame_a) annotation(
        Line(points = {{100, -2}, {62, -2}}));
      connect(spinInput, spinFL.axis) annotation(
        Line(points = {{32, 100}, {32, 8}}));
  connect(suspMount, spinFL.frame_a) annotation(
        Line(points = {{-102, -2}, {22, -2}}));
    end DrivingTire;

    model SteeringTire
      Modelica.Mechanics.MultiBody.Joints.Revolute steerFL(n = {0, 0, 1}, useAxisFlange = true) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{130, 30}, {150, 50}})));
      Modelica.Mechanics.MultiBody.Joints.Revolute spinFL(n = {0, 1, 0}, useAxisFlange = true) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{170, 30}, {190, 50}})));
      Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{210, 30}, {230, 50}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
        Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a steerInput annotation(
        Placement(transformation(origin = {-8, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-6, 100}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
        Placement(transformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, 2}, extent = {{-16, -16}, {16, 16}})));
    equation
      connect(steerFL.frame_b, spinFL.frame_a) annotation(
        Line(points = {{2, -2}, {22, -2}}, color = {95, 95, 95}));
      connect(spinFL.frame_b, wheelFL.frame_a) annotation(
        Line(points = {{42, -2}, {62, -2}}, color = {95, 95, 95}));
      connect(wheelSupport, wheelFL.frame_a) annotation(
        Line(points = {{100, -2}, {62, -2}}));
      connect(steerInput, steerFL.axis) annotation(
        Line(points = {{-8, 100}, {-8, 8}}));
      connect(suspMount, steerFL.frame_a) annotation(
        Line(points = {{-102, -2}, {-18, -2}}));
    end SteeringTire;

    model DrivingSteeringTire
      Modelica.Mechanics.MultiBody.Joints.Revolute steerFL(n = {0, 0, 1}, useAxisFlange = true) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{130, 30}, {150, 50}})));
      Modelica.Mechanics.MultiBody.Joints.Revolute spinFL(n = {0, 1, 0}, useAxisFlange = true) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{170, 30}, {190, 50}})));
      Modelica.Mechanics.MultiBody.Parts.Body wheelFL(m = 20) annotation(
        Placement(transformation(origin = {-148, -42}, extent = {{210, 30}, {230, 50}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a wheelSupport annotation(
        Placement(transformation(origin = {100, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {100, 0}, extent = {{-16, -16}, {16, 16}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a steerInput annotation(
        Placement(transformation(origin = {-8, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-6, 100}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a spinInput annotation(
        Placement(transformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {32, 100}, extent = {{-10, -10}, {10, 10}})));
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a suspMount annotation(
        Placement(transformation(origin = {-102, -2}, extent = {{-16, -16}, {16, 16}}), iconTransformation(origin = {-102, 2}, extent = {{-16, -16}, {16, 16}})));
    equation
      connect(steerFL.frame_b, spinFL.frame_a) annotation(
        Line(points = {{2, -2}, {22, -2}}, color = {95, 95, 95}));
      connect(spinFL.frame_b, wheelFL.frame_a) annotation(
        Line(points = {{42, -2}, {62, -2}}, color = {95, 95, 95}));
      connect(wheelSupport, wheelFL.frame_a) annotation(
        Line(points = {{100, -2}, {62, -2}}));
      connect(steerInput, steerFL.axis) annotation(
        Line(points = {{-8, 100}, {-8, 8}}));
      connect(spinInput, spinFL.axis) annotation(
        Line(points = {{32, 100}, {32, 8}}));
      connect(suspMount, steerFL.frame_a) annotation(
        Line(points = {{-102, -2}, {-18, -2}}));
    end DrivingSteeringTire;
  end Tires;

  class Differentials
     
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

  class Suspension
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
      MultiBody.Parts.FixedTranslation upperChassisOffset(r={0, 0, upperMountZ}) annotation(
        Placement(transformation(extent={{-70, 20}, {-50, 40}})));
      MultiBody.Parts.FixedTranslation lowerChassisOffset(r={0, 0, -lowerMountZ}) annotation(
        Placement(transformation(extent={{-70, -40}, {-50, -20}})));
    
      // --- Upper A-arm (tree branch: the only regular revolute) ---
      MultiBody.Joints.Revolute upperChassisPivot(n={1, 0, 0}) annotation(
        Placement(transformation(extent={{-40, 20}, {-20, 40}})));
      MultiBody.Parts.BodyCylinder upperArm(r={0, sideSign*upperArmLength, 0}, diameter=0.03) annotation(
        Placement(transformation(extent={{-10, 20}, {10, 40}})));
    
      // --- Closed-loop: JointRRR handles 3 revolutes + 2 rods analytically ---
      MultiBody.Joints.Assemblies.JointRRR jointLoop(
        rRod1_ia={0, 0, -(upperMountZ + lowerMountZ)},
        rRod2_ib={0, sideSign*lowerArmLength, 0},
        n_a={1, 0, 0}) annotation(
        Placement(transformation(origin = {90, 2},extent = {{20, -40}, {60, 40}}, rotation = 180)));
    
      // --- Hub/knuckle mass at the upper ball joint, CM at knuckle center ---
      MultiBody.Parts.Body hub(m=m_hub,
        r_CM={0, 0, -(upperMountZ + lowerMountZ)/2},
        I_11=0.1, I_22=0.1, I_33=0.1) annotation(
        Placement(transformation(origin = {18, 28}, extent = {{70, 20}, {90, 40}})));
    
      // --- Shock top mount (above chassis for proper vertical force transfer) ---
      MultiBody.Parts.FixedTranslation shockTopMount(r={0, 0, shockTopHeight}) annotation(
        Placement(transformation(extent={{-70, 50}, {-50, 70}})));

      // --- Wheel center offset (from upper ball joint down to knuckle midpoint) ---
      MultiBody.Parts.FixedTranslation wheelOffset(r={0, 0, -(upperMountZ + lowerMountZ)/2}) annotation(
        Placement(transformation(extent={{60, -10}, {80, 10}})));

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
      connect(wheelOffset.frame_b, wheelMount) annotation(
        Line(points={{80, 0}, {100, 0}}, color={95, 95, 95}));
    
      // Shock: top mount above chassis to lower ball-joint point (middle revolute = frame_im)
      connect(chassisMount, shockTopMount.frame_a) annotation(
        Line(points={{-100, 0}, {-80, 0}, {-80, 60}, {-70, 60}}, color={95, 95, 95}));
      connect(shockTopMount.frame_b, shock.frame_a) annotation(
        Line(points={{-50, 60}, {-34, 60}, {-34, -72}}, color={95, 95, 95}));
      connect(jointLoop.frame_im, shock.frame_b) annotation(
        Line(points={{50, -38}, {50, -56}, {-14, -56}, {-14, -72}}, color={95, 95, 95}));
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
  annotation(
    uses(Modelica(version = "4.1.0"), Modelica_DeviceDrivers(version = "2.2.0")));
end DDynamics;
