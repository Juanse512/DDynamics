# Documentation: FullChassisSimplified Model

## 1. Overview
The `FullChassisSimplified` model represents a full 3D vehicle dynamics simulation using the `Modelica.Mechanics.MultiBody` library. It features a central chassis with 6 degrees of freedom (DOF), four independent suspension systems, actuated front steering and wheel spin, and a custom ground-contact penalty method to simulate the floor.

---

## 2. Global & Environment Components
These components define the physical world and the overarching kinematic state of the vehicle.

* **`world` (`MultiBody.World`)**: The universal reference frame. It defines gravity (**9.81 m/s²**) acting strictly downward along the negative Z-axis (`n={0,0,-1}`).
* **`freeMotion` (`MultiBody.Joints.FreeMotion`)**: The crucial joint connecting the `world` to the `chassis`. By default, Modelica grounds unattached bodies. This joint explicitly grants the chassis 6 DOF (3 translational, 3 rotational), allowing it to drop, pitch, roll, and yaw freely in space. It is initialized at a height of **1.0 m**.
* **`zeroAngle` (`Blocks.Sources.Constant`)**: A signal generator outputting a constant `0`. This is used as the reference signal to keep the front wheels locked straight and prevent them from spinning freely in this iteration.

---

## 3. The Central Body
* **`chassis` (`MultiBody.Parts.Body`)**: Represents the sprung mass of the vehicle. It is configured with a mass of **1200 kg**. All four suspension corners branch out from this central frame.

---

## 4. The Suspension Corners (FL, FR, RL, RR)
Each of the four corners (Front Left, Front Right, Rear Left, Rear Right) follows a nearly identical kinematic chain. 

### Kinematic Chain Sequence
1.  **`mount` (`FixedTranslation`)**: A rigid, massless offset from the center of the chassis to the mounting point of the suspension. Example: `r={1.5, 0.9, -0.2}` means 1.5m forward, 0.9m left, and 0.2m down from the chassis center.
2.  **`susp` (`Joints.Prismatic`)**: The physical suspension joint. It restricts movement to a single axis (`n={0,0,1}`, the Z-axis). This ensures the wheel only travels up and down relative to the chassis.
3.  **`shock` (`Forces.SpringDamperParallel`)**: The physics of the suspension. It acts parallel to the prismatic joint, applying a spring stiffness (`c=30000 N/m`) and damping coefficient (`d=2500 Ns/m`) based on the displacement of the prismatic joint.
4.  **`steer` (`Joints.Revolute`) *(Front Only)***: Allows the front wheels to rotate around the vertical Z-axis (`n={0,0,1}`) for steering.
5.  **`spin` (`Joints.Revolute`)**: Allows the wheel to roll around the lateral Y-axis (`n={0,1,0}`).
6.  **`wheel` (`Parts.Body`)**: Represents the unsprung mass of the corner (**20 kg**).

### Actuation (Front Corners Only)
To prevent the solver from encountering an infinite number of solutions (unconstrained degrees of freedom), the front `steer` and `spin` joints are explicitly controlled via their 1D rotational axes:
* **`steerAct` / `spinAct` (`Rotational.Sources.Position`)**: These components force the angle of the revolute joints to strictly follow an input signal. They are connected to the `zeroAngle` global block, meaning the front wheels are currently locked at **0 radians** (straight and not spinning).

*(Note: The rear `spin` joints are left unactuated and free-spinning, which is typical for non-driven wheels in a simplified model).*

---

## 5. Ground Contact (Floor Logic)
Instead of relying on complex 3D contact models, this model uses a highly efficient "penalty method" to simulate the ground.

* **`floorFL`, `floorFR`, `floorRL`, `floorRR` (`MultiBody.Forces.WorldForce`)**: These elements apply a 3D force vector directly to the center of each wheel in the global coordinate system.
* **The Custom Equation**:
    $$F_z = \begin{cases} -c_{ground} \cdot z - d_{ground} \cdot v_z & \text{if } z < 0 \\ 0 & \text{otherwise} \end{cases}$$
    * **Mechanism**: If the wheel's Z-coordinate drops below `0` (the floor level), a massive virtual spring (`ground_c = 1e6`) and damper (`ground_d = 1e4`) push back upwards. If the wheel is above the ground, the force is exactly 0.

---

## 6. Connection Topology
The `equation` section establishes the topology. The connections dictate how forces and movements transfer through the vehicle:

* **Structural**: `World` -> `FreeMotion` -> `Chassis`
* **Branching**: `Chassis` connects to all four `mount` components simultaneously.
* **Parallel Loops**: Inside each corner, `mount.frame_b` splits:
    * Path A: Goes through the `susp` (Prismatic joint kinematics).
    * Path B: Goes through the `shock` (Spring/Damper kinetics).
    * Both paths merge at `susp.frame_b`, completing the mechanical loop.
* **Signal to Mechanical**: The blue 1D signal from `zeroAngle.y` feeds into the `phi_ref` port of the Actuators. The Actuator's physical `flange` then connects to the `axis` port of the 3D Revolute joint.