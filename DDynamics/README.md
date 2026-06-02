# DDynamics

A Modelica multibody vehicle dynamics library for simulating 4-wheeled ground vehicles with configurable suspension, terrain, and drivetrain.

**Dependencies**
- `Modelica 4.1.0`
- `Modelica_DeviceDrivers 2.2.0`

---

## Quick Start

1. Open `DDynamics.mo` in OpenModelica or Dymola.
2. Simulate `DDynamics.Examples.CarExample`.
3. The example drives a car at 5 m/s with 0.2 rad of steering on a flat terrain at y = 1 m.

**Top-level connection diagram**

```
Constant(speed=5) ──speedInput──┐
                                 Car ──frame_FL/FR/RL/RR── Road
Constant(steer=0.2) ─steerInput─┘
```

`CarExample` also owns the `inner R_wheel = 0.25` declaration that all sub-models resolve via `outer`.

---

## Package Structure

```
DDynamics
├── Examples
│   └── CarExample
├── Interfaces
│   ├── FrameToReal
│   └── FrameToUDP
├── Roads
│   ├── Road
│   ├── Floors
│   │   ├── Floor4Corners
│   │   └── Components
│   │       ├── GroundSpring
│   │       ├── GroundFriction
│   │       └── Floor
│   └── Terrains
│       ├── TerrainMap          (block)
│       └── Components
│           ├── terrainSurface  (function)
│           └── TerrainVisualizer
└── Cars
    ├── Car
    └── Parts
        ├── Tires
        │   ├── Tire
        │   ├── DrivingTire
        │   └── Components
        │       └── TireVisualizer
        ├── Differentials
        │   ├── SolidAxle
        │   └── Components
        │       └── Differential        ← partial
        ├── Suspension
        │   ├── SpringDamper
        │   ├── DoubleWishbone
        │   └── Components
        │       └── BaseSuspension      ← partial
        └── Chassis
            ├── RectangularChassis
            └── Components
                └── BaseChassis         ← partial
```

---

## Package Reference

### `DDynamics.Examples`

#### `CarExample`

Top-level simulation entry point. Instantiates a `Car` and a `Road`, drives them with constant speed and steering signals.

| Instance | Type | Value | Description |
|---|---|---|---|
| `R_wheel` | `inner parameter Real` | 0.25 m | Tire radius — propagated to all sub-models via `outer` |
| `car` | `Cars.Car` | — | The vehicle |
| `road` | `Roads.Road` | — | The road environment (owns `World` and terrain) |
| `speed` | `Modelica.Blocks.Sources.Constant` | k = 5 | Wheel angular velocity setpoint (rad/s) |
| `steer` | `Modelica.Blocks.Sources.Constant` | k = 0.2 | Front wheel steer angle (rad) |

Connections:
- `speed.y → car.speedInput`
- `steer.y → car.steerInput`
- `road.FL ↔ car.frame_FL`, `road.FR ↔ car.frame_FR`, `road.RL ↔ car.frame_RL`, `road.RR ↔ car.frame_RR`

---

### `DDynamics.Interfaces`

#### `FrameToReal`

Reads the world-frame position of a multibody `Frame_a` and exposes it as three `RealOutput` signals. Sets zero force and torque (sensor only, no mechanical effect).

| Connector | Type | Direction | Description |
|---|---|---|---|
| `frame_a` | `Frame_a` | in | MultiBody frame to read position from |
| `x_out` | `RealOutput` | out | X position (m) |
| `y_out` | `RealOutput` | out | Y position (m) |
| `z_out` | `RealOutput` | out | Z position (m) |

Equations: `frame_a.r_0[1] = x_out`, `frame_a.r_0[2] = y_out`, `frame_a.r_0[3] = z_out`, `frame_a.f = {0,0,0}`, `frame_a.t = {0,0,0}`.

#### `FrameToUDP`

Sends the X and Y world-frame position of a `Frame_a` over UDP using `Modelica_DeviceDrivers`. Internally chains `FrameToReal → SerialPackager → AddFloat × 2 → UDPSend`.

| Connector | Type | Direction | Description |
|---|---|---|---|
| `frame_a` | `Frame_a` | in | Frame whose position is transmitted |

**Packet format** — 12 bytes, sent to UDP port 12345 at 100 Hz (sample time 0.01 s):

| Bytes | Type | Value |
|---|---|---|
| 0 – 3 | `float` (32-bit IEEE 754, little-endian) | X position (m) |
| 4 – 7 | `float` (32-bit IEEE 754, little-endian) | Y position (m) |
| 8 – 11 | `float` (32-bit IEEE 754, little-endian) | Z position (m) |

All three axes are packed, each by a separate `AddFloat(nu=1)` block in sequence: `packager → addFloat(X) → addFloat1(Y) → addFloat11(Z) → uDPSend`.

`RealtimeSynchronize` locks simulation time to wall-clock time, so the 100 Hz sample rate corresponds to real seconds on the receiving end.

---

### `DDynamics.Roads`

#### `Road`

Self-contained road environment. Owns the Modelica `World`, the terrain height map, and the four ground-contact floor models. Exposes four `Frame_a` connectors that attach to the vehicle's wheel support frames.

**Inner objects** (accessible by any sub-model via `outer`):

| Name | Type | Description |
|---|---|---|
| `terrain` | `DDynamics.Roads.Terrains.TerrainMap` | Terrain height lookup |
| `world` | `Modelica.Mechanics.MultiBody.World` | Gravity and animation root |

**Connectors:**

| Name | Type | Description |
|---|---|---|
| `FL` | `Frame_a` | Front-left wheel contact point |
| `FR` | `Frame_a` | Front-right wheel contact point |
| `RL` | `Frame_a` | Rear-left wheel contact point |
| `RR` | `Frame_a` | Rear-right wheel contact point |

Internal instances: `terrain`, `floor4Corners` (Floor4Corners), `terrainViz` (TerrainVisualizer), `world`.

---

#### `Floors.Floor4Corners`

Aggregates four identical `Floor` contact models — one per wheel corner — and distributes shared road parameters to all four.

**Parameters:**

| Name | Default | Description |
|---|---|---|
| `ground_c` | 1e5 | Floor stiffness (N/m) |
| `ground_d` | 5000 | Floor damping (N·s/m) |
| `ground_mu` | 10000 | Longitudinal friction coefficient (N·s/m) |
| `mu_lat` | 100000 | Lateral friction coefficient (N·s/m) |
| `R_wheel` | `outer` | Tire radius — resolved from `CarExample` |

**Connectors:**

| Name | Type | Description |
|---|---|---|
| `wheelContactFL` | `Frame_b` | Front-left ground contact (→ tire wheelSupport) |
| `wheelContactFR` | `Frame_b` | Front-right ground contact |
| `wheelContactRL` | `Frame_b` | Rear-left ground contact |
| `wheelContactRR` | `Frame_b` | Rear-right ground contact |

---

#### `Floors.Components.GroundSpring`

Applies a vertical spring-damper normal force to a wheel contact frame. The force is zero while the tire center is above the terrain surface; it grows linearly once the tire penetrates.

**Force law:**
```
F_y = max(0, ground_c * (terrain.getZ(x, z) + R_wheel - y) - ground_d * vy)
```
where `(x, y, z)` is `wheelContact.r_0` and `vy = der(y)`.

**Parameters:**

| Name | Default | Description |
|---|---|---|
| `ground_c` | 1e5 | Stiffness (N/m) |
| `ground_d` | 5000 | Damping (N·s/m) |
| `R_wheel` | `outer` | Tire radius |
| `terrain` | `outer` | Terrain height function |

**Connector:** `wheelContact` (Frame_b) — attach to tire wheel center frame.

---

#### `Floors.Components.GroundFriction`

Applies longitudinal (slip-based) and lateral (viscous) friction forces at the contact patch, plus the rolling torque that arises from applying friction below the wheel center.

Heading and axle directions are computed from the wheel rotation matrix (spin-invariant: uses `resolve1(R, {0,0,-1})` and `cross(axle, {0,1,0})`), so they are correct regardless of wheel spin angle or vehicle heading.

**Protected parameter:**

| Name | Value | Description |
|---|---|---|
| `contactRampDepth` | 0.001 m | Penetration depth over which friction scales from 0 to full |

**Parameters:**

| Name | Default | Description |
|---|---|---|
| `ground_mu` | 10000 | Longitudinal friction coefficient (N·s/m) |
| `mu_lat` | 100000 | Lateral friction coefficient (N·s/m) |
| `R_wheel` | `outer` | Tire radius |
| `terrain` | `outer` | Terrain height function |

**Connector:** `wheelContact` (Frame_b).

---

#### `Floors.Components.Floor`

Composite model combining `GroundSpring` (normal force) and `GroundFriction` (friction + torque) into a single wheel-ground contact. Both sub-models share the same `wheelContact` frame.

**Parameters:** all four road parameters (`ground_c`, `ground_d`, `ground_mu`, `mu_lat`) plus `outer R_wheel`.

**Connector:** `wheelContact` (Frame_b).

---

#### `Terrains.TerrainMap` *(block)*

Provides the `getZ(x, y)` function that returns terrain height at any world-XZ position. All ground contact models query this block via `outer terrain`.

**Function:**
```modelica
function getZ
  input Real x;   // forward position (m)
  input Real y;   // lateral position (m)
  output Real z;  // height (m)
```

Currently returns a flat plane at `z = 1`. To implement a custom terrain, modify the `algorithm` section of `getZ` and update `TerrainVisualizer.groundHeight` and `terrainSurface` to match.

---

#### `Terrains.Components.terrainSurface` *(function)*

Surface characteristic function for 3D terrain visualization. Passed to `Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface`. **Must be kept in sync with `TerrainMap.getZ`.**

Extends `partialSurfaceCharacteristic` with `multiColoredSurface = false`.

**Parameters:**

| Name | Default | Description |
|---|---|---|
| `x_min` | -10 | Minimum X extent (m) |
| `x_max` | 10 | Maximum X extent (m) |
| `z_min` | -5 | Minimum Z extent (m) |
| `z_max` | 5 | Maximum Z extent (m) |

---

#### `Terrains.Components.TerrainVisualizer`

Renders the ground surface as a flat colored box in the 3D animation. Extends `PartialVisualizer`.

**Parameters:**

| Name | Default | Description |
|---|---|---|
| `animation` | true | Enable animation |
| `x_min` | -10 | Slab start in X (m) |
| `x_max` | 10 | Slab end in X (m) |
| `z_min` | -5 | Slab start in Z (m) |
| `z_max` | 5 | Slab end in Z (m) |
| `groundHeight` | 1.0 | Slab Y position — **must match `TerrainMap.getZ`** |
| `color` | {0, 160, 0} | RGB ground color |
| `specularCoefficient` | 0.1 | Reflectivity |

**Connector:** `frame_a` (Frame_a, from PartialVisualizer) — connect to `world.frame_b`.

---

### `DDynamics.Cars`

#### `Car`

Complete 4-wheeled vehicle assembly. Contains:
- `RectangularChassis` (400 kg body)
- 4 × `DoubleWishbone` suspension (front pair steerable)
- 2 × `Tire` (passive front)
- 2 × `DrivingTire` (driven rear)
- `SolidAxle` differential
- `FreeMotion` joint (initial height y = 1.2 m)
- 2 × `Position` actuators for steering

**Connectors:**

| Name | Type | Description |
|---|---|---|
| `frame_FL` | `Frame_a` | Front-left ground contact — connect to `Road.FL` |
| `frame_FR` | `Frame_a` | Front-right ground contact — connect to `Road.FR` |
| `frame_RL` | `Frame_a` | Rear-left ground contact — connect to `Road.RL` |
| `frame_RR` | `Frame_a` | Rear-right ground contact — connect to `Road.RR` |
| `chassis_pos` | `Frame_a` | Chassis reference frame (for external position reading) |
| `speedInput` | `RealInput` | Rear wheel angular velocity setpoint (rad/s) |
| `steerInput` | `RealInput` | Front wheel steer angle (rad) |

`outer World world` is resolved from `Road`.

---

#### `Parts.Tires.Tire` *(passive)*

Non-driven wheel. A rigid `Body` (20 kg) connected through a free `Revolute` (spin axis `{0,0,-1}`) to the suspension. The tire can spin freely; no torque is applied.

| Connector | Type | Description |
|---|---|---|
| `suspMount` | `Frame_a` | Connects to suspension `wheelMount` |
| `wheelSupport` | `Frame_a` | Connects to road contact frame (Road.FL/FR/etc.) |

`outer parameter Real R_wheel` — drives `TireVisualizer.rTire`.

---

#### `Parts.Tires.DrivingTire` *(driven)*

Driven wheel. Same structure as `Tire` but the `Revolute` has `useAxisFlange = true`, accepting a rotational input from the differential.

| Connector | Type | Description |
|---|---|---|
| `suspMount` | `Frame_a` | Connects to suspension `wheelMount` |
| `wheelSupport` | `Frame_a` | Connects to road contact frame |
| `spinInput` | `Flange_a` | Driven by `SolidAxle.left_out` / `right_out` |

---

#### `Parts.Tires.Components.TireVisualizer`

3D tire visualization using a torus (rubber sidewall) and a pipe shape (rim band). Extends `PartialVisualizer`. No forces or torques are applied.

**Parameters:**

| Name | Default | Description |
|---|---|---|
| `rTire` | 0.25 m | Overall tire radius |
| `rRim` | 0.14 m | Rim inner radius |
| `width` | 0.25 m | Tire width |
| `rCurvature` | 0.30 m | Sidewall cross-section radius |
| `color` | {64, 64, 64} | Tire color (RGB) |
| `specularCoefficient` | 0.5 | Surface reflectivity |
| `n_rTire` | 40 | Points along tire circumference |
| `n_rCurvature` | 20 | Points along cross-section |

**Connector:** `frame_a` (Frame_a, from PartialVisualizer) — attach to wheel body frame.

---

#### `Parts.Differentials.SolidAxle`

Rigid rear axle. Both rear wheels receive exactly the same angular velocity as `speedInput` (no torque split). Extends `Differential`.

---

#### `Parts.Differentials.Components.Differential` *(partial)*

Base class for all differential types. Defines the common interface: one speed input, two rotational outputs. Internally uses two `Modelica.Mechanics.Rotational.Sources.Speed` instances.

| Connector | Type | Description |
|---|---|---|
| `i` | `RealInput` | Target angular velocity (rad/s) |
| `left_out` | `Flange_a` | Left wheel rotational output |
| `right_out` | `Flange_a` | Right wheel rotational output |

To implement a custom differential (e.g., open, limited-slip), extend this partial and override how `i` maps to `left.w_ref` and `right.w_ref`.

---

#### `Parts.Suspension.SpringDamper`

Simple single-DOF suspension using a `Prismatic` joint (travel axis `{0,0,-1}`) and a parallel `SpringDamperParallel`.

| Parameter | Value | Description |
|---|---|---|
| `c` | 30000 N/m | Spring stiffness |
| `d` | 2500 N·s/m | Damping coefficient |
| `s_unstretched` | 0.3 m | Free length |

| Connector | Type | Description |
|---|---|---|
| `tireConnection` | `Frame_b` | Outboard (wheel side) |
| `chassisMount` | `Frame_b` | Inboard (chassis side) |

---

#### `Parts.Suspension.DoubleWishbone`

Double A-arm suspension. Uses a `JointRRR` assembly to close the four-bar kinematic loop analytically. Front instances (`steerable = true`) include an active steering revolute; rear instances lock it via `steerLock`.

Extends `BaseSuspension` (inherits `k_spring`, `d_damper`, `m_hub`, `steerable`, `chassisMount`, `wheelMount`, `steerInput`).

**Additional parameters:**

| Name | Default | Description |
|---|---|---|
| `sideSign` | 1 | 1 = left side, -1 = right side (mirrors Z geometry) |
| `upperArmLength` | 0.35 m | Upper A-arm outboard length |
| `lowerArmLength` | 0.35 m | Lower A-arm outboard length |
| `upperMountZ` | 0.25 m | Upper ball-joint height above chassis mount |
| `lowerMountZ` | 0.15 m | Lower ball-joint depth below chassis mount |
| `shockTopHeight` | 0.35 m | Shock absorber top mount height above chassis mount |

Spring/damper (`shock`) parameters come from `BaseSuspension`: `k_spring` and `d_damper`. Free length is 0.55 m.

---

#### `Parts.Suspension.Components.BaseSuspension` *(partial)*

Base class for all suspension types. Defines the chassis-to-wheel interface, common tuning parameters, and the optional steering flange.

**Parameters:**

| Name | Default | Description |
|---|---|---|
| `k_spring` | 30000 N/m | Spring rate |
| `d_damper` | 2500 N·s/m | Damping rate |
| `m_hub` | 15 kg | Unsprung hub/knuckle mass |
| `steerable` | false | If true, exposes `steerInput` flange |

**Connectors:**

| Name | Type | Condition | Description |
|---|---|---|---|
| `chassisMount` | `Frame_a` | always | Inboard attachment to chassis |
| `wheelMount` | `Frame_b` | always | Outboard attachment to tire `suspMount` |
| `steerInput` | `Flange_b` | only when `steerable = true` | Driven by `Car`'s `steerAct` actuator |

---

#### `Parts.Chassis.RectangularChassis`

Rectangular box chassis body. Extends `BaseChassis` (inherits `m` and `frame_a`). Creates a `BodyBox` with density back-calculated from mass and volume.

**Parameters (in addition to `BaseChassis`):**

| Name | Default | Description |
|---|---|---|
| `length` | 3.0 m | Longitudinal (X) extent |
| `width` | 1.8 m | Lateral (Z) extent |
| `height` | 0.3 m | Vertical (Y) extent |

The `BodyBox` is offset rearward by `length/2` so `frame_a` sits at the geometric center.

---

#### `Parts.Chassis.Components.BaseChassis` *(partial)*

Base class for all chassis types. Provides the single connection frame and total mass parameter.

**Parameter:**

| Name | Default | Description |
|---|---|---|
| `m` | 400 kg | Total chassis mass |

**Connector:**

| Name | Type | Description |
|---|---|---|
| `frame_a` | `Frame_a` | Central reference frame — all suspension mounts, FreeMotion, and `chassis_pos` connect here |

---

## Inner/Outer Resolution

DDynamics uses Modelica's `inner`/`outer` mechanism so shared values are declared once at the top level and automatically resolved by any sub-model in the instantiation hierarchy.

| `inner` declaration | Declared in | Resolved by |
|---|---|---|
| `parameter Real R_wheel = 0.25` | `Examples.CarExample` | `Tires.Tire`, `Tires.DrivingTire`, `Floors.Floor4Corners`, `Floors.Components.Floor`, `Floors.Components.GroundSpring`, `Floors.Components.GroundFriction` |
| `Roads.Terrains.TerrainMap terrain` | `Roads.Road` | `Floors.Components.GroundSpring`, `Floors.Components.GroundFriction` |
| `Modelica.Mechanics.MultiBody.World world` | `Roads.Road` | `Cars.Car`, `Tires.Components.TireVisualizer`, `Terrains.Components.TerrainVisualizer` |

**Rule:** every `outer` declaration is resolved by walking up the instantiation tree until a matching `inner` is found. `R_wheel` resolves because `car` and `road` are both direct children of `CarExample`, which owns the `inner`.

---

## Extending the Library

### Custom terrain
1. Modify `Roads.Terrains.TerrainMap.getZ` with your height function.
2. Update `Roads.Terrains.Components.terrainSurface` to generate the matching visualization mesh.
3. Update `Roads.Terrains.Components.TerrainVisualizer.groundHeight` to match the new height.

### Custom differential
Extend `Cars.Parts.Differentials.Components.Differential` and override the equations that map `i` to `left.w_ref` and `right.w_ref` (e.g., add a torque bias or slip model).

### Custom suspension
Extend `Cars.Parts.Suspension.Components.BaseSuspension` and implement the kinematics between `chassisMount` and `wheelMount`. The `steerable` parameter and `steerInput` flange are already wired in the base.

### Custom chassis
Extend `Cars.Parts.Chassis.Components.BaseChassis` and add `BodyBox`, `BodyCylinder`, or any geometry connected to `frame_a`.
