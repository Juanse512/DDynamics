package cifacar_models
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
  equation
    vxlr = vx + (Lr * sin(th) - Lw * cos(th)) * w;
    vxrr = vx + (Lr * sin(th) + Lw * cos(th)) * w;
    vxlf = vx + ((-Lf * sin(th)) - Lw * cos(th)) * w;
    vxrf = vx + ((-Lf * sin(th)) + Lw * cos(th)) * w;
    vylr = vy + ((-Lr * cos(th)) - Lw * sin(th)) * w;
    vyrr = vy + ((-Lr * cos(th)) + Lw * sin(th)) * w;
    vylf = vy + (Lf * cos(th) - Lw * sin(th)) * w;
    vyrf = vy + (Lf * cos(th) + Lw * sin(th)) * w;
    Fxlr = bf * (R * wlr * cos(th) - vxlr);
    Fylr = bf * (R * wlr * sin(th) - vylr);
    Fxrr = bf * (R * wrr * cos(th) - vxrr);
    Fyrr = bf * (R * wrr * sin(th) - vyrr);
    Fxlf = bf * (R * wlf * cos(th + psi) - vxlf);
    Fylf = bf * (R * wlf * sin(th + psi) - vylf);
    Fxrf = bf * (R * wrf * cos(th + psi) - vxrf);
    Fyrf = bf * (R * wrf * sin(th + psi) - vyrf);
    taulr = Fxlr * sin(th) * Lr - Fxlr * cos(th) * Lw - Fylr * cos(th) * Lr - Fylr * sin(th) * Lw;
    taurr = Fxrr * sin(th) * Lr + Fxrr * cos(th) * Lw - Fyrr * cos(th) * Lr + Fyrr * sin(th) * Lw;
    taulf = (-Fxlf * sin(th) * Lf) - Fxlf * cos(th) * Lw + Fylf * cos(th) * Lf - Fylf * sin(th) * Lw;
    taurf = (-Fxrf * sin(th) * Lf) + Fxrf * cos(th) * Lw + Fyrf * cos(th) * Lf + Fylf * sin(th) * Lw;
    der(x) = vx;
    der(y) = vy;
    der(th) = w;
    der(vx) = (Fxlr + Fxrr + Fxlf + Fxrf) / m;
    der(vy) = (Fylr + Fyrr + Fylf + Fyrf) / m;
    der(w) = (taulr + taurr + taulf + taurf) / J;
    der(wlr) = (Tlr - Fxlr * R * cos(th) - Fylr * R * sin(th) - bw * wlr) / Jw;
    der(wrr) = (Trr - Fxrr * R * cos(th) - Fyrr * R * sin(th) - bw * wrr) / Jw;
    der(wlf) = (Tlf - Fxlf * R * cos(th + psi) - Fylf * R * sin(th + psi) - bw * wlf) / Jw;
    der(wrf) = (Trf - Fxrf * R * cos(th + psi) - Fyrf * R * sin(th + psi) - bw * wrf) / Jw;
    v = (wlr + wrr + wlf + wrf) * R / 4;
    der(d) = abs(v);
    annotation(
      experiment(StartTime = 0, StopTime = 1000, Tolerance = 0.001, Interval = 2));
  end cifacar;




  model speed_control
    Real w, wref, tau;
    Real err, ierr;
    parameter Real Kp = 5, Ki = 1;
  equation
    err = wref - w;
    der(ierr) = err;
    tau = Kp * err + Ki * ierr;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
  end speed_control;




  model steer_control
    Real psi, psiref;
    discrete Real steer_speed(start = 0);
    parameter Real steer_err = 1e-3, steer_maxspeed = 0.15;
  equation
    der(psi) = steer_speed;
  algorithm
    when psiref > psi + steer_err then
      steer_speed := steer_maxspeed;
    end when;
    when psiref < psi - steer_err then
      steer_speed := -steer_maxspeed;
    end when;
    when psiref == psi then
      steer_speed := 0;
    end when;
    annotation(
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
  end steer_control;


  model controled_car
    cifacar car;
    speed_control spc[4];
    steer_control stc;
    discrete Real vref;
    discrete Real psiref;
  equation
    car.Tlr = spc[1].tau;
    car.Trr = spc[2].tau;
    car.Tlf = spc[3].tau;
    car.Trf = spc[4].tau;
    spc[1].w = car.wlr;
    spc[2].w = car.wrr;
    spc[3].w = car.wlf;
    spc[4].w = car.wrf;
    for i in 1:4 loop
      spc[i].wref = vref / car.R;
    end for;
    stc.psiref = psiref;
    car.psi = stc.psi;
    annotation(
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-6, Interval = 0.2));
  end controled_car;

  function arcTrajGen
    input Real x0, y0, th0, dl, dir, R;
    output Real xref, yref, thref;
    protected
    Real xc, yc, th;
  algorithm
    xc := x0 + R * dir * sin(th0);
    yc := y0 - R * dir * cos(th0);
    th := dl / R;
    if th > 3.1416 then
      th := 3.1416;
    end if;
    thref := th0 - dir * th;
    xref := xc - R * dir * sin(thref);
    yref := yc + R * dir * cos(thref);
  end arcTrajGen;

  function relativePos
    input Real xref, yref, thref, x, y, th;
    output Real rotatedX, rotatedY, rotatedTh;
  algorithm
    rotatedX := cos(th) * (xref - x) + sin(th) * (yref - y);
    rotatedY := cos(th) * (yref - y) - sin(th) * (xref - x);
    rotatedTh := thref - th;
  end relativePos;

  function rowDetect
    input Real x, y, th, rowpos, rowth;
    output Real dy, dth;
  algorithm
    dy := (rowpos - y) * cos(rowth);
    dth := rowth - th;
  end rowDetect;



  function steerControl
    input Real d, th, L;
    output Real psiref;
    protected 
    parameter Real vrefmax = 5 / 3.6;
    parameter Real maxpsi = 0.45;
  algorithm
    psiref := atan(d / L) + th;
    while psiref > 3.14159 loop
      psiref := psiref - 2 * 3.14159;
    end while;
    while psiref < (-3.14159) loop
      psiref := psiref + 2 * 3.14159;
    end while;
    if psiref > maxpsi then
      psiref := maxpsi;
    elseif psiref < (-maxpsi) then
      psiref := -maxpsi;
    end if;
  end steerControl;






  function car_observer
    input Real xp, yp, thp, psi, v, dp;
    output Real x, y, th, d;
    protected
    parameter Real T = 0.1, L = 2.2, h = 0.01;
    Real xr, yr;
  algorithm
    xr := xp - L * cos(thp);
    yr := yp - L * sin(thp);
    th := thp;
    d := dp;
    for i in 1:T / h loop
      xr := xr + h * cos(thp) * cos(psi) * v;
      yr := yr + h * sin(thp) * cos(psi) * v;
      th := th + h * tan(psi) * v / L;
      d := d + h * abs(v);
    end for;
    x := xr + L * cos(th);
    y := yr + L * sin(th);
  end car_observer;

  model tracking
    parameter Real d1 = 5.5, d2 = 4.2, d3 = 3.5, lturn = 1, vturn = 0.5, vrow = 5 / 3.6, L = 1;
    controled_car ccar;
    discrete Real x, y, th, xref, yref, thref, dx, dy, dth, l, x0, y0, th0, d0, dobs, xr, yr, psi, v, psiprev, vprev;
    discrete Real xobs, yobs, thobs;
    discrete Real rowpos(start = 0.2), rowth;
    discrete Integer turn, point;
  algorithm
    when sample(0, 0.1) then
      psi := ccar.car.psi;
      v := ccar.car.v;
      th := ccar.car.th;
      x := ccar.car.x + L * cos(th);
      y := ccar.car.y + L * sin(th);
      xr := ccar.car.x - L * cos(th);
      yr := ccar.car.y - L * sin(th);
      if turn == 0 then
        yref := rowpos;
        xref := x;
        (dy, dth) := rowDetect(x, y, th, rowpos, rowth);
        ccar.psiref := steerControl(dy, dth, 2);
        ccar.vref := vrow;
        if x > 18 then
          ccar.vref := vturn;
        end if;
        if x > 20 then
          turn := 1;
          x0 := x;
          y0 := y;
          th0 := th;
          l := 0;
          d0 := ccar.car.d;
          point := 0;
          xobs := x;
          yobs := y;
          dobs := d0;
          thobs := th;
        end if;
      else
        (xobs, yobs, thobs, dobs) := car_observer_heun(xobs, yobs, thobs, psi, v, psiprev, vprev, ccar.car.d);
        if point == 0 then
          ccar.psiref := 0.45;
          ccar.vref := vturn;
          if ccar.car.d - d0 > d1 then
            d0 := ccar.car.d;
            point := 1;
          end if;
        elseif point == 1 then
          ccar.psiref := -0.45;
          ccar.vref := -vturn;
          if ccar.car.d - d0 > d2 then
            d0 := ccar.car.d;
            point := 2;
            l := 0;
          end if;
        elseif point == 2 then
          ccar.psiref := 0.45;
          ccar.vref := vturn;
          if ccar.car.d - d0 > d3 then
            d0 := ccar.car.d;
            point := 3;
            l := 0;
          end if;
        else
          if l < lturn + 0.1 then
            l := l + vturn * 0.1;
          end if;
          (xref, yref, thref) := arcTrajGen(x0, rowpos + 2.08, 3.1416, l - lturn, -1, 4.5);
          if x - x0 < 0 then
            xref := x - 1;
            yref := rowpos + 2.08;
          end if;
          (dx, dy, dth) := relativePos(xref, yref, thref, x, y, th);
          ccar.psiref := steerControl(dy, dth, 0.5);
          ccar.vref := vturn;
        end if;
        if xobs < 18 then
          turn := 0;
          rowpos := rowpos + 2.08;
          rowth := 3.1416 - rowth;
        end if;
      end if;
      psiprev := psi;
      vprev := v;
    end when;
//xref:=xref+L*cos(thref);
//yref:=yref+L*sin(thref);
    annotation(
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2));
  end tracking;

  function car_observer_heun
    input Real xp, yp, thp, psi, v, psip, vp, dp;
    output Real x, y, th, d;
    protected
    parameter Real T = 0.1, L0 = 2, DL = 0;
    Real xr, yr, k1x, k1y, k1th, L;
  algorithm
    L := L0 + DL * sign(v);
    xr := xp - L0 * cos(thp);
    yr := yp - L0 * sin(thp);
    k1x := cos(thp) * cos(psip) * vp;
    k1y := sin(thp) * cos(psip) * vp;
    k1th := tan(psip) * vp / L;
    th := thp + T / 2 * (k1th + tan(psi) * v / L);
    xr := xr + T / 2 * (k1x + cos(th) * cos(psi) * v);
    yr := yr + T / 2 * (k1y + sin(th) * cos(psi) * v);
    d := dp + T / 2 * (abs(vp) + abs(v));
    x := xr + L0 * cos(th);
    y := yr + L0 * sin(th);
  end car_observer_heun;

  model openLoopTurn
    parameter Real vturn = 1.5 / 3.6, vrow = 5 / 3.6, L = 0.79, rowLength = 20, lforward = 2, psimax = 0.57;
    parameter Real Rturn=3.58;
    parameter Real rowDist=2.08;
    parameter Real lBack=2*Rturn*asin(0.5-rowDist/4/Rturn);
    parameter Real lForward=3.1416*Rturn-lBack;
    //parameter Real d1=lForward/2,d2=lBack,d3=d1;
    parameter Real d1 = 4.5, d2 = 3.2, d3 = 3;
    controled_car ccar;
    discrete Real x, y, th, dy, dth, l, x0, y0, th0, d0, xr, yr, psi, v,xobs,yobs,thobs,psip,dl,dp;
    discrete Real rowpos(start = 0.4), rowth;
    discrete Integer turn, point, dir(start = 1);
  algorithm
    when sample(0, 0.1) then
      psip:=psi;
      psi := ccar.car.psi;
      v := ccar.car.v;
      th := ccar.car.th;
      x := ccar.car.x + L * cos(th);
      y := ccar.car.y + L * sin(th);
      xr := ccar.car.x - L * cos(th);
      yr := ccar.car.y - L * sin(th);
      if turn == 0 then
        (dy, dth) := rowDetect(x, y, th, rowpos, rowth);
        ccar.psiref := steerControl(dy, dth, lforward);
        ccar.vref := vrow;
        if x > rowLength - 2 and dir == 1 or x < 2 and dir == (-1) then
          ccar.vref := vturn;
        end if;
        if x > rowLength and dir == 1 or x < 0 and dir == (-1) then
          turn := 1;
          x0 := x;
          y0 := y;
          th0 := th;
          xobs:=xr;
          yobs:=yr;
          thobs:=th;
          l := 0;
          d0 := ccar.car.d;
          dp:=d0;
          point := 0;
        end if;
      else
        dl:=(ccar.car.d-dp)*sign(ccar.car.v);
        dp:=ccar.car.d;
        (xobs,yobs,thobs):=carObserver(xobs,yobs,thobs,psi,psip,dl);
        if point == 0 then
          ccar.psiref := psimax * dir;
          ccar.vref := vturn;
          if ccar.car.d - d0 > d1 then
            d0 := ccar.car.d;
            point := 1;
          end if;
        elseif point == 1 then
          ccar.psiref := -psimax * dir;
          ccar.vref := -vturn;
          if ccar.car.d - d0 > d2 then
            d0 := ccar.car.d;
            point := 2;
            l := 0;
          end if;
        else
          ccar.psiref := psimax * dir;
          ccar.vref := vturn;
          if ccar.car.d - d0 > d3 then
            d0 := ccar.car.d;
            point := 3;
            l := 0;
            turn := 0;
            dir := -dir;
            rowpos := rowpos + 2.08;
            rowth := 3.1416 - rowth;
          end if;
        end if;
      end if;
    end when;
    annotation(
      experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 0.4));
  end openLoopTurn;















model CLTurn
  controled_car ccar;
  parameter Real vturn = 3 / 3.6, vrow = 5 / 3.6, L = 0.79, rowLength = 30, lforward = 4, psimax = 0.45;
  parameter Real Rturn = 3.58;
  parameter Real rowDist = 2.08;
  discrete Real x, y, th, dx, dy, dth, l, x0, y0, th0, d0, xr, yr, psi, v, xobs, yobs, thobs, psip, dl, dp, xref, yref, thref;
  discrete Real rowpos(start = 0.4), rowth;
  discrete Integer turn, dir(start = 1);
algorithm
  when sample(0, 0.1) then
    psip := psi;
    psi := ccar.car.psi;
    v := ccar.car.v;
    th := ccar.car.th;
    x := ccar.car.x + L * cos(th);
    y := ccar.car.y + L * sin(th);
    xr := ccar.car.x - L * cos(th);
    yr := ccar.car.y - L * sin(th);
    if turn == 0 then
      (dy, dth) := rowDetect(x, y, th, rowpos, rowth);
      ccar.psiref := steerControl(dy, dth, lforward);
      ccar.vref := vrow;
      if x > rowLength - 2 and dir == 1 or x < 2 and dir == (-1) then
        ccar.vref := vturn;
      end if;
      if x > rowLength and dir == 1 or x < 0 and dir == (-1) then
        turn := 1;
        x0 := 0;
        y0 := 0;
        th0 := 0;
        xobs := 0;
        yobs := 0;
        thobs := 0;
        l := 0;
        d0 := ccar.car.d;
        dp := d0;
      end if;
    else
      dl := (ccar.car.d - dp) * sign(ccar.car.v);
      dp := ccar.car.d;
      (xobs, yobs, thobs) := carObserver(xobs, yobs, thobs, psi, psip, dl);
      psip:=psi;
      l:=ccar.car.d-d0;
      (xref,yref,thref,ccar.vref) := referenceTurn(x0,y0,th0,l+1,dir);
      (dx, dy, dth) := relativePos(xref+2*L*cos(thref), yref+2*L*sin(thref), thref, xobs + 2 * L * cos(thobs), yobs + 2 * L * sin(thobs), thobs);
          ccar.psiref := steerControl(dy, dth, dx);
         if ccar.vref<0 then 
          ccar.psiref:=-psimax*dir;
         end if;
        if xobs<-0.01  then
          l := 0;
          turn := 0;
          dir := -dir;
          rowpos := rowpos + 2.08;
          rowth := 3.1416 - rowth;
        end if;
    end if;
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 0.4));
end CLTurn;
  






















  function carObserver
    input Real xp, yp, thp, psi, psip, dl;
    output Real x, y, th;
    protected
    parameter Real L = 0.85*2;
  algorithm
    th:=thp+(tan(psip)+tan(psi))/2/L*dl;
    x:=xp+(cos(thp)+cos(th))/2*dl;
    y:=yp+(sin(thp)+sin(th))/2*dl;
  end carObserver;








  model mixedTurn
    parameter Real vturn = 2 / 3.6, vrow = 5 / 3.6, L = 0.79, rowLength = 30, lforward = 4, psimax = 0.57;
    parameter Real Rturn = 3.58;
    parameter Real rowDist = 2.08;
    parameter Real lBack = 2 * Rturn * asin(0.5 - rowDist / 4 / Rturn);
    parameter Real lForward = 3.1416 * Rturn - lBack;
    //parameter Real d1=lForward/2,d2=lBack,d3=d1;
    parameter Real d1 = 5, d2 = 4, d3 = 3;
    controled_car ccar;
    discrete Real x, y, th, dx,dy, dth, l, x0, y0, th0, d0, xr, yr, psi, v, xobs, yobs, thobs, psip, dl, dp,xref,yref,thref;
    discrete Real rowpos(start = 0.4), rowth;
    discrete Integer turn, point, dir(start = 1);
  algorithm
    when sample(0, 0.1) then
      psip := psi;
      psi := ccar.car.psi;
      v := ccar.car.v;
      th := ccar.car.th;
      x := ccar.car.x + L * cos(th);
      y := ccar.car.y + L * sin(th);
      xr := ccar.car.x - L * cos(th);
      yr := ccar.car.y - L * sin(th);
      if turn == 0 then
        (dy, dth) := rowDetect(x, y, th, rowpos, rowth);
        ccar.psiref := steerControl(dy, dth, lforward);
        ccar.vref := vrow;
        if x > rowLength - 2 and dir == 1 or x < 2 and dir == (-1) then
          ccar.vref := vturn;
        end if;
        if x > rowLength and dir == 1 or x < 0 and dir == (-1) then
          turn := 1;
          x0 := x;
          y0 := y;
          th0 := th;
          xobs := xr;
          yobs := yr;
          thobs := th;
          l := 0;
          d0 := ccar.car.d;
          dp := d0;
          point := 0;
        end if;
      else
        dl := (ccar.car.d - dp) * sign(ccar.car.v);
        dp := ccar.car.d;
        (xobs, yobs, thobs) := carObserver(xobs, yobs, thobs, psi, psip, dl);
        if point == 0 then
          ccar.psiref := psimax * dir;
          ccar.vref := vturn;
          if ccar.car.d - d0 > d1 then
            d0 := ccar.car.d;
            point := 1;
          end if;
        elseif point == 1 then
          ccar.psiref := -psimax * dir;
          ccar.vref := -vturn;
          if ccar.car.d - d0 > d1 then
            d0 := ccar.car.d;
            point := 1;
          end if;
          if abs(thobs-3.14159+rowth)<0.7854 then
            d0 := ccar.car.d;
            x0:=xobs;
            y0:=yobs;
            point := 2;
            l := 0;
          end if;
        else
          (xref,yref,thref):=arcTrajGen(x0,y0,3.1416-0.7854,ccar.car.d-d0,-dir,(rowpos+2.08-y0)/0.2929);
          (dx, dy, dth) := relativePos(xref, yref, thref, xobs+2*L*cos(thobs), yobs+2*L*sin(thobs), thobs);
          ccar.psiref := steerControl(dy, dth, 1);
          ccar.vref := vturn;
          if abs(thobs-3.14159+rowth)<0.1 then
            d0 := ccar.car.d;
            point := 3;
            l := 0;
            turn := 0;
            dir := -dir;
            rowpos := rowpos + 2.08;
            rowth := 3.1416 - rowth;
          end if;
        end if;
      end if;
    end when;
    annotation(
      experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 0.4));
  end mixedTurn;




















function referenceTurn
   input Real x0,y0,th0,l,dir;
   output Real xref,yref,thref,vref;
   protected
   parameter Real R=5,d=2.08;
   parameter Real th1=acos((R-d/2)/(2*R));
   parameter Real th2=3.1416-2*th1;
   parameter Real l1=R*th1;
   parameter Real l2=R*th2;
   parameter Real l3=l1;
   parameter Real dl=1;
   parameter Real vmin=1/3.6;
   parameter Real vmax=2/3.6;
algorithm
    if l<l1 then 
      (xref,yref,thref):=arcTrajGen(x0,y0,th0,l,-1*dir,R);
      vref:=vmax;
    elseif l<l1+dl then
      (xref,yref,thref):=arcTrajGen(x0,y0,th0,l1,-1*dir,R);
      vref:=vmin;
    elseif l<l1+l2+dl then
      (xref,yref,thref):=arcTrajGen(x0,y0,th0,l1,-1*dir,R);
      (xref,yref,thref):=arcTrajGen(xref,yref,thref,l1+dl-l,1*dir,R);
      vref:=-vmax;
    elseif l<l1+l2+2*dl then
      (xref,yref,thref):=arcTrajGen(x0,y0,th0,l1,-1*dir,R);
      (xref,yref,thref):=arcTrajGen(xref,yref,thref,-l2,1*dir,R);
      vref:=-vmin;
    elseif l<l1+l2+l3+2*dl then
      (xref,yref,thref):=arcTrajGen(x0,y0,th0,l1,-1*dir,R);
      (xref,yref,thref):=arcTrajGen(xref,yref,thref,-l2,1*dir,R);
      (xref,yref,thref):=arcTrajGen(xref,yref,thref,l-l1-l2-2*dl,-1*dir,R);
      vref:=vmax;
     else
      (xref,yref,thref):=arcTrajGen(x0,y0,th0,l1,-1*dir,R);
      (xref,yref,thref):=arcTrajGen(xref,yref,thref,-l2,1*dir,R);
      (xref,yref,thref):=arcTrajGen(xref,yref,thref,l3,-1*dir,R);
      (xref,yref,thref):=arcTrajGen(xref,yref,thref,l-l1-l2-l3-2*dl,-1*dir,R*100);
      vref:=vmin;
     end if; 

   
end referenceTurn;























model closedLoopTurn
  parameter Real vturn = 2 / 3.6, vrow = 5 / 3.6, L = 0.79, rowLength = 30, lforward = 4, psimax = 0.45;
 // parameter Real Rturn = 3.58;
  parameter Real rowDist = 2.08;
 // parameter Real lBack = 2 * Rturn * asin(0.5 - rowDist / 4 / Rturn);
 // parameter Real lForward = 3.1416 * Rturn - lBack;
  //parameter Real d1=lForward/2,d2=lBack,d3=d1;
  parameter Real d1 = 5, d2 = 4, d3 = 3;
  controled_car ccar;
  discrete Real x, y, th, dx, dy, dth, l, x0, y0, th0, d0, xr, yr, psi, v, xobs, yobs, thobs, psip, dl, dp, xref, yref, thref;
  discrete Real rowpos(start = 0.4), rowth;
  discrete Integer turn, point, dir(start = 1);
algorithm
  when sample(0, 0.1) then
    psip := psi;
    psi := ccar.car.psi;
    v := ccar.car.v;
    th := ccar.car.th;
    x := ccar.car.x + L * cos(th);
    y := ccar.car.y + L * sin(th);
    xr := ccar.car.x - L * cos(th);
    yr := ccar.car.y - L * sin(th);
    if turn == 0 then
      (dy, dth) := rowDetect(x, y, th, rowpos, rowth);
      ccar.psiref := steerControl(dy, dth, lforward);
      ccar.vref := vrow;
      if x > rowLength - 2 and dir == 1 or x < 2 and dir == (-1) then
        ccar.vref := vturn;
      end if;
      if x > rowLength and dir == 1 or x < 0 and dir == (-1) then
        turn := 1;
        x0 := xr;
        y0 := yr;
        th0 := th;
        xobs := xr;
        yobs := yr;
        thobs := th;
        l := 0;
        d0 := ccar.car.d;
        dp := d0;
        point := 0;
      end if;
    else
      dl := (ccar.car.d - dp) * sign(ccar.car.v);
      dp := ccar.car.d;
      (xobs, yobs, thobs) := carObserver(xobs, yobs, thobs, psi, psip, dl);
      psip:=psi;
      (xref,yref,thref,ccar.vref) := referenceTurn(x0,y0,th0,ccar.car.d-d0+1,dir);
      (dx, dy, dth) := relativePos(xref+2*L*cos(thref), yref+2*L*sin(thref), thref, xobs + 2 * L * cos(thobs), yobs + 2 * L * sin(thobs), thobs);
          ccar.psiref := steerControl(dy, dth, dx);
         if ccar.vref<0 then 
          ccar.psiref:=-psimax*dir;
         end if;
        if abs(3.14159-rowth-thref)<0.01  then
          d0 := ccar.car.d;
          point := 3;
          l := 0;
          turn := 0;
          dir := -dir;
          rowpos := rowpos + 2.08;
          rowth := 3.1416 - rowth;
        end if;
    end if;
  end when;
  annotation(
    experiment(StartTime = 0, StopTime = 200, Tolerance = 1e-06, Interval = 0.4));
end closedLoopTurn;




  model turning
    controled_car ccar;
    parameter Real psiref=0.57;
    parameter Real vref=1.6;
  algorithm
    when sample(0, 0.1) then
      ccar.psiref:=psiref;
      ccar.vref:=vref;
    end when;
 
  end turning;























  
  
  
  
  




























































end cifacar_models;