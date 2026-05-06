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
  annotation(
    uses(Modelica(version = "4.1.0"), Modelica_DeviceDrivers(version = "2.2.0")));
end DDynamics;
