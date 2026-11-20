# State Space Representation & State Vector

*A practical guide for understanding state-space modeling in control systems and robotics.*

---

## Table of Contents

1. [What is State Space?](#what-is-state-space)
2. [The State Vector](#the-state-vector)
3. [Continuous-Time State-Space Model](#continuous-time-state-space-model)
4. [Matrix Definitions](#matrix-definitions)
5. [Robotics Example: DC Motor](#robotics-example-dc-motor)
6. [Why State Space?](#why-state-space)
7. [Discrete-Time (Digital Control)](#discrete-time-digital-control)
8. [Key Properties: Controllability & Observability](#key-properties-controllability--observability)
9. [Canonical Forms](#canonical-forms)
10. [State Feedback (Pole Placement)](#state-feedback-pole-placement)
11. [Observer Design (State Estimation)](#observer-design-state-estimation)
12. [Summary](#summary)

---

## What is State Space?

**State space** is a mathematical framework that describes a system's internal behavior using a set of **state variables**. Unlike transfer functions (which only relate input to output), state-space models capture **what's happening inside the system**.

### Core Philosophy

> If you know the **state** at time `t₀` and all future **inputs** `u(t ≥ t₀)`, you can predict **any** future **output**.

The **state** is the minimal set of variables needed to summarize the system's past history.

---

## The State Vector

### Definition

The **state vector** `x(t)` is a column vector containing all state variables:

$$
x(t) = \begin{bmatrix} x_1(t) \\ x_2(t) \\ \vdots \\ x_n(t) \end{bmatrix} \in \mathbb{R}^n
$$

Where:
- `n` = **system order** (number of independent energy storage elements)
- Each `xᵢ(t)` = a **state variable** (e.g., position, velocity, current, voltage across capacitor)

### What Qualifies as a State Variable?

A variable is a **state** if:
1. It represents **energy storage** (capacitor voltage, inductor current, mass position/velocity, spring compression)
2. Its derivative depends on the current state and inputs
3. It's part of the **minimal set** needed to predict future behavior

### Physical Interpretation by Domain

| Domain | Typical State Variables |
|--------|------------------------|
| **Mechanical** | Position `x`, velocity `v` (or momentum `p = mv`) |
| **Electrical** | Capacitor voltage `v_C`, inductor current `i_L` |
| **Thermal** | Temperature `T` (heat energy) |
| **Hydraulic** | Pressure `p`, flow rate `q` |
| **Chemical** | Concentration `c`, reaction extent |

---

## Continuous-Time State-Space Model

### Standard Form

$$
\begin{aligned}
\dot{x}(t) &= A x(t) + B u(t) \quad &\text{(State equation / Dynamics)} \\
y(t) &= C x(t) + D u(t) \quad &\text{(Output equation / Measurement)}
\end{aligned}
$$

Where:
- `x(t) ∈ ℝⁿ` — **State vector** (n states)
- `u(t) ∈ ℝᵐ` — **Input vector** (m inputs)
- `y(t) ∈ ℝᵖ` — **Output vector** (p outputs)

### Block Diagram

```
                    ┌──────────────┐
u(t) ──────────────►│      B       │──────►┐
                    └──────────────┘       │
                                          ▼
                    ┌──────────────┐    ┌─────┐    ┌──────────────┐
                    │     A        │◄───│ x(t) │───►│      C       │──► y(t)
                    └──────────────┘    └─────┘    └──────────────┘
                         ▲               │
                         │               │
                         └───────────────┘
                              (dynamics)
```

### Matrix Dimensions

| Matrix | Size | Name | Role |
|--------|------|------|------|
| **A** | n × n | **System matrix** | Internal dynamics, state coupling |
| **B** | n × m | **Input matrix** | How inputs drive states |
| **C** | p × n | **Output matrix** | Which states are measured |
| **D** | p × m | **Feedthrough** | Direct input→output path |

---

## Robotics Example: DC Motor (Position Control)

### Physical Equations

A DC motor with armature control:

**Electrical:** `L di/dt + R i = V - Kₑ ω`  
**Mechanical:** `J dω/dt + b ω = Kₜ i`

Where:
- `V` = armature voltage (input)
- `i` = armature current
- `ω` = angular velocity
- `θ` = angular position (output)
- `L, R` = inductance, resistance
- `J, b` = inertia, damping
- `Kₜ, Kₑ` = torque constant, back-EMF constant

### Choosing States

Energy storage elements:
1. **Inductor** → current `i` (magnetic energy ½Li²)
2. **Inertia** → velocity `ω` (kinetic energy ½Jω²)
3. **Position** `θ` is integral of velocity

**State vector:**
$$
x = \begin{bmatrix} \theta \\ \omega \\ i \end{bmatrix} = \begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix}
$$

### Deriving State Equations

From physics:
```
ẋ₁ = θ̇ = ω = x₂
ẋ₂ = ω̇ = (Kₜ/J) i - (b/J) ω = (Kₜ/J)x₃ - (b/J)x₂
ẋ₃ = i̇ = (1/L)V - (R/L)i - (Kₑ/L)ω = (1/L)V - (R/L)x₃ - (Kₑ/L)x₂
```

**Matrix form:**
$$
\begin{bmatrix} \dot{x}_1 \\ \dot{x}_2 \\ \dot{x}_3 \end{bmatrix} =
\begin{bmatrix}
0 & 1 & 0 \\
0 & -b/J & K_t/J \\
0 & -K_e/L & -R/L
\end{bmatrix}
\begin{bmatrix} x_1 \\ x_2 \\ x_3 \end{bmatrix} +
\begin{bmatrix} 0 \\ 0 \\ 1/L \end{bmatrix} V
$$

**Output equation** (measuring position):
$$y = \theta = x_1 = \begin{bmatrix} 1 & 0 & 0 \end{bmatrix} x$$

### Complete Matrices

```matlab
A = [0, 1,     0;
     0, -b/J,  Kt/J;
     0, -Ke/L, -R/L];

B = [0; 0; 1/L];

C = [1, 0, 0];

D = [0];
```

---

## Why State Space? (vs Transfer Functions)

| Aspect | Transfer Function | State Space |
|--------|------------------|-------------|
| **Internal behavior** | Hidden (black box) | Explicit (white box) |
| **MIMO systems** | Awkward (matrix of TFs) | Natural (vectors/matrices) |
| **Initial conditions** | Hard to handle | Built-in (x(0)) |
| **Time-varying systems** | Can't handle | Natural |
| **Nonlinear systems** | Can't handle | Natural extension |
| **Optimal control (LQR)** | Difficult | Direct formulation |
| **Observer design** | Not applicable | Kalman filter, Luenberger |
| **Model predictive control** | Awkward | Native formulation |

**Bottom line**: Transfer functions are great for SISO frequency-domain analysis. State space is essential for MIMO, optimal control, estimation, and modern robotics.

---

## Discrete-Time (Digital Control)

For sampling time `Tₛ`:

$$
\begin{aligned}
x[k+1] &= A_d x[k] + B_d u[k] \\
y[k]   &= C_d x[k] + D_d u[k]
\end{aligned}
$$

### Conversion Methods (Continuous → Discrete)

| Method | Formula | Best For |
|--------|---------|----------|
| **Zero-Order Hold (ZOH)** | `A_d = exp(A T_s)`, `B_d = A⁻¹(A_d - I)B` | Most digital control |
| **Tustin (Bilinear)** | `A_d = (I - ½A Tₛ)⁻¹(I + ½A Tₛ)` | Best frequency match |
| **Forward Euler** | `A_d = I + A Tₛ` | Simple, low accuracy |
| **Matched Pole-Zero** | Maps poles/zeros directly | Preserves frequency response |

### MATLAB Conversion

```matlab
sys_c = ss(A, B, C, D);      % Continuous
sys_d = c2d(sys_c, Ts, 'tustin');  % Best freq match
% or
sys_d = c2d(sys_c, Ts, 'zoh');     % Standard for digital control
```

### Python (control library)

```python
import control as ctrl
sys_c = ctrl.ss(A, B, C, D)
sys_d = ctrl.sample_system(sys_c, Ts, method='tustin')
```

---

## Key Properties: Controllability & Observability

### Controllability

**Can we steer the state anywhere with inputs?**

**Controllability matrix:**
$$
\mathcal{C} = \begin{bmatrix} B & AB & A^2B & \cdots & A^{n-1}B \end{bmatrix}
$$

**Condition:** `rank(𝒞) = n` → **Fully controllable**

If not controllable → some states can't be influenced by inputs (uncontrollable modes)

```matlab
ctrb = rank(ctrb(A, B));  % or ctrb = ctrb(A, B); rank(ctrb)
```

### Observability

**Can we infer internal states from outputs?**

**Observability matrix:**
$$
\mathcal{O} = \begin{bmatrix} C \\ CA \\ CA^2 \\ \vdots \\ CA^{n-1} \end{bmatrix}
$$

**Condition:** `rank(𝒪) = n` → **Fully observable**

If not observable → some states can't be determined from outputs (unobservable modes)

```matlab
obsv = rank(obsv(A, C));  % or obsv = obsv(A, C); rank(obsv)
```

### Duality

Controllability of `(A, B)` ⇔ Observability of `(Aᵀ, Bᵀ)`

This is why:
- Pole placement uses `place(A, B, p)`
- Observer design uses `place(A', C', p)'`

---

## Canonical Forms

Different matrix representations with same input/output behavior but different internal structure.

| Form | A Matrix | Use Case |
|------|----------|----------|
| **Controllable** | Companion | Pole placement, controller design |
| **Observable** | Companionᵀ | Observer design |
| **Modal** | Diagonal (if distinct poles) | Modal analysis, decoupling |
| **Balanced** | Σ = Σ_c = Σ_o | Model reduction |

### Transformation

Any state-space model can be transformed via similarity transform `T`:

```
x̄ = T x
Ā = T A T⁻¹
B̄ = T B
C̄ = C T⁻¹
```

---

## State Feedback (Pole Placement)

### Control Law

```
u = -K x + r
```

Where:
- `K` = state feedback gain (m × n)
- `r` = reference input

**Closed-loop dynamics:**
$$\dot{x} = (A - B K) x + B r$$

### Design Goal

Choose `K` so eigenvalues of `(A - B K)` = desired closed-loop poles.

```matlab
% MATLAB
K = place(A, B, p_desired);    % Numerically stable
% or
K = acker(A, B, p_desired);    % Ackermann's formula
```

### Choosing Desired Poles

| Consideration | Guideline |
|---------------|-----------|
| **Dominant poles** | Place 2-5× faster than open-loop |
| **Damping** | ζ ≈ 0.7 for good transient |
| **Bandwidth** | 5-10× desired closed-loop BW |
| **Control effort** | Avoid excessively fast poles (saturates actuators) |
| **Noise** | Don't place poles too fast (amplifies sensor noise) |

### Robotics Application

For a joint with plant `1/(s(s+2)(s+5))`:

```matlab
% Desired: ζ=0.7, ωn=20 rad/s → dominant poles at -14 ± j14
p_desired = [-14+14i, -14-14i, -100];  % 3rd pole far left
K = place(A, B, p_desired);
```

---

## Observer Design (State Estimation)

### Problem

Not all states are measured. Need to **estimate** them.

### Luenberger Observer

```
ẋ̂ = A x̂ + B u + L (y - C x̂)
```

Where:
- `x̂` = estimated state
- `L` = observer gain (n × p)
- `y - C x̂` = output estimation error (innovation)

**Estimation error dynamics:**
$$\dot{\tilde{x}} = (A - L C) \tilde{x}, \quad \tilde{x} = x - \hat{x}$$

### Design

Place observer poles 2-5× faster than controller poles:

```matlab
% Controller poles
p_ctrl = [-14+14i, -14-14i, -100];

% Observer poles (2-3x faster)
p_obs = 3 * p_ctrl;  % [-42+42i, -42-42i, -300]

% Observer gain (dual to pole placement)
L = place(A', C', p_obs)';
```

### Kalman Filter (Optimal Observer)

For noisy systems with process noise `w` and measurement noise `v`:

```
ẋ = A x + B u + w
y = C x + v
```

Covariances: `E[w wᵀ] = Q`, `E[v vᵀ] = R`

```matlab
[L, P, E] = kalman(sys_ss, Q, R);
```

Where:
- `L` = optimal gain
- `P` = steady-state error covariance
- `E` = closed-loop observer poles

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| **State vector** | Minimal set of variables to predict future; column vector `x ∈ ℝⁿ` |
| **State equation** | `ẋ = Ax + Bu` — how states evolve |
| **Output equation** | `y = Cx + Du` — what you measure |
| **A matrix** | Internal dynamics, coupling between states |
| **B matrix** | How inputs affect states |
| **C matrix** | Which states are measured |
| **Controllability** | Can we drive states? `rank([B AB ...]) = n` |
| **Observability** | Can we infer states? `rank([C; CA; ...]) = n` |
| **State feedback** | `u = -Kx` → place poles via `K = place(A,B,p)` |
| **Observer** | Estimate states via `L = place(A',C',p)'` |
| **Kalman filter** | Optimal observer for noisy systems |

### When to Use in Robotics

- **Joint control**: `x = [θ, ω]` per joint
- **Mobile robots**: `x = [x, y, θ, v, ω]`
- **Sensor fusion**: Kalman filter (IMU + encoder + vision)
- **MPC**: State space is native formulation
- **Computed torque**: Feedforward needs full state

---

*For deeper study: Åström & Murray "Feedback Systems" (Ch. 6-7), Kailath "Linear Systems", Franklin et al. "Feedback Control of Dynamic Systems" (Ch. 3, 7-8).*