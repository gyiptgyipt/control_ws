# Control Engineering Fundamentals for Robotics

*A practical reference for understanding core concepts when building robot control systems.*

---

## Table of Contents

1. [Transfer Functions & Laplace Domain](#transfer-functions--laplace-domain)
2. [Poles and Zeros](#poles-and-zeros)
3. [The Integrator (1/s)](#the-integrator-1s)
4. [System Types & Steady-State Error](#system-types--steady-state-error)
5. [First & Second Order Systems](#first--second-order-systems)
6. [Stability & Routh-Hurwitz](#stability--routh-hurwitz)
7. [Root Locus](#root-locus)
8. [Frequency Response & Bode](#frequency-response--bode)
9. [PID Control](#pid-control)
10. [State Space Representation](#state-space-representation)
11. [Robotics-Specific Applications](#robotics-specific-applications)
12. [Quick Reference Tables](#quick-reference-tables)

---

## Transfer Functions & Laplace Domain

### Definition
For an LTI system with zero initial conditions:
$$G(s) = \frac{Y(s)}{U(s)} = \frac{\text{Output}}{\text{Input}}$$

### Why Laplace?
- Converts differential equations → algebraic equations
- Convolution in time → multiplication in s-domain
- Reveals stability, frequency response, transient behavior

### Common Laplace Pairs

| Time Domain | s-Domain |
|-------------|----------|
| $\delta(t)$ (impulse) | $1$ |
| $1(t)$ (step) | $\frac{1}{s}$ |
| $t$ (ramp) | $\frac{1}{s^2}$ |
| $e^{-at}$ | $\frac{1}{s+a}$ |
| $t e^{-at}$ | $\frac{1}{(s+a)^2}$ |
| $\sin(\omega t)$ | $\frac{\omega}{s^2+\omega^2}$ |
| $\cos(\omega t)$ | $\frac{s}{s^2+\omega^2}$ |

### Block Diagram Algebra

```
Series:       G1(s) → G2(s)     = G1(s)G2(s)
Parallel:     G1(s) + G2(s)     = G1(s)+G2(s)
Feedback:     G/(1+GH)          = Forward/(1+LoopGain)
```

---

## Poles and Zeros

### Definitions

| Term | Definition | Physical Meaning |
|------|------------|------------------|
| **Zeros** | Roots of numerator | Frequencies where output = 0 (blocking) |
| **Poles** | Roots of denominator | Natural modes of the system (resonance) |

### Pole-Zero Plot (S-Plane)

```
Imaginary (jω)
    ↑
    │     ×         ×        ← Complex conjugate poles
    │    / \       / \
    │   /   \     /   \
    │  ×-----×---×-----×  ← Real axis (σ)
    │
    └──────────────────→ Real (σ)
         Stable region: σ < 0
```

### Pole Locations & Time Response

| Pole Location | Time Response | Stability |
|---------------|---------------|-----------|
| Real, negative: $s = -a$ | $e^{-at}$ (exponential decay) | Stable |
| Real, positive: $s = +a$ | $e^{+at}$ (exponential growth) | **Unstable** |
| Imaginary: $s = \pm j\omega$ | $\sin(\omega t)$ (sustained oscillation) | Marginally stable |
| Complex: $s = -\sigma \pm j\omega_d$ | $e^{-\sigma t}\sin(\omega_d t)$ (damped oscillation) | Stable if $\sigma > 0$ |

### Key Properties

1. **Poles determine natural response** (transient)
2. **Zeros determine forced response** (amplitude scaling)
3. **Dominant poles** (closest to imaginary axis) ≈ system behavior
4. **Non-minimum phase zeros** (RHP zeros) cause inverse response

---

## The Integrator (1/s)

### What It Is
$$\frac{1}{s} \leftrightarrow \int_0^t u(\tau) d\tau$$

### Why It Matters in Robotics

| Application | Role |
|-------------|------|
| **Position from velocity** | $\theta = \int \omega dt$ |
| **Velocity from acceleration** | $v = \int a dt$ |
| **PID Integral term** | Eliminates steady-state error |
| **Motor dynamics** | Voltage → current → torque → acceleration → velocity → position |

### Integrator Properties

| Property | Description |
|----------|-------------|
| **Pole at origin** | $s=0$ (marginally stable) |
| **Phase lag** | -90° at all frequencies |
| **Gain slope** | -20 dB/decade |
| **Step response** | Ramp (unbounded) |
| **DC gain** | Infinite |

### Implementing an Integrator

#### Continuous (Analog / Simulation)
```matlab
% Transfer function
G = tf(1, [1 0]);  % 1/s

% State space
A = 0; B = 1; C = 1; D = 0;  % dx/dt = u, y = x
```

#### Discrete (Digital Implementation)

| Method | Formula | Pros/Cons |
|--------|---------|-----------|
| **Forward Euler** | $y[k] = y[k-1] + T_s \cdot u[k-1]$ | Simple, but unstable for some systems |
| **Backward Euler** | $y[k] = y[k-1] + T_s \cdot u[k]$ | Stable, implicit |
| **Trapezoidal (Tustin)** | $y[k] = y[k-1] + \frac{T_s}{2}(u[k]+u[k-1])$ | Best frequency match, energy conserving |

```python
# Python: Discrete integrator (Tustin)
def integrator_tustin(u, Ts, y_prev=0, u_prev=0):
    y = y_prev + (Ts/2) * (u + u_prev)
    return y

# PID integral term (anti-windup)
def pid_integral(error, Ts, Ki, y_prev, saturated=False):
    if not saturated:  # Anti-windup: stop integrating when output saturates
        y = y_prev + Ki * Ts * error
    else:
        y = y_prev
    return y
```

### Integrator Windup (Critical!)

**Problem**: Output saturates → integrator keeps accumulating → massive overshoot when unsaturated

**Solutions**:
1. **Back-calculation**: Feedback difference between saturated/unsaturated output
2. **Clamping**: Stop integration when output saturates
3. **Conditional integration**: Only integrate when error is small or output not saturated

```matlab
% Simulink PID block: Enable "Anti-windup" → "Back-calculation"
% Set Kb (anti-windup gain) ≈ 1/Kp to 1/(10*Kp)
```

---

## System Types & Steady-State Error

### System Type = Number of Integrators in Open-Loop

| Type | Open-Loop Form | Step Input | Ramp Input | Parabolic Input |
|------|----------------|------------|------------|-----------------|
| **Type 0** | No poles at origin | $e_{ss} = \frac{1}{1+K_p}$ | ∞ | ∞ |
| **Type 1** | One pole at origin | **0** | $e_{ss} = \frac{1}{K_v}$ | ∞ |
| **Type 2** | Two poles at origin | **0** | **0** | $e_{ss} = \frac{1}{K_a}$ |

### Error Constants

| Constant | Formula | Physical Meaning |
|----------|---------|------------------|
| $K_p$ (Position) | $\lim_{s\to0} G(s)$ | Step tracking accuracy |
| $K_v$ (Velocity) | $\lim_{s\to0} sG(s)$ | Ramp tracking accuracy |
| $K_a$ (Acceleration) | $\lim_{s\to0} s^2G(s)$ | Parabolic tracking accuracy |

### Robotics Example: Position Control

```
Motor: G(s) = 1/(s(s+2)(s+5))  → Type 1 (one integrator)
       └─ Position from velocity integrator

Controller: C(s) = Kp + Ki/s + Kd·s
Loop: L(s) = C(s)G(s)

Result: Type 2 system (two integrators) → Zero steady-state error to ramp (constant velocity)
```

---

## First & Second Order Systems

### First Order: $G(s) = \frac{K}{\tau s + 1}$

| Metric | Formula | Value |
|--------|---------|-------|
| **Time constant** | $\tau$ | 63.2% rise time |
| **Settling (2%)** | $4\tau$ | Time to stay within 2% |
| **Settling (5%)** | $3\tau$ | Time to stay within 5% |
| **Bandwidth** | $\omega_{bw} = 1/\tau$ | -3dB frequency |
| **Pole** | $s = -1/\tau$ | Real, negative |

### Second Order: $G(s) = \frac{K\omega_n^2}{s^2 + 2\zeta\omega_n s + \omega_n^2}$

| Parameter | Symbol | Meaning |
|-----------|--------|---------|
| Natural frequency | $\omega_n$ | Oscillation frequency (undamped) |
| Damping ratio | $\zeta$ | Shape of response |

#### Damping Regions

| $\zeta$ | Type | Poles | Overshoot |
|---------|------|-------|-----------|
| $\zeta > 1$ | Overdamped | Two real, distinct | 0% |
| $\zeta = 1$ | Critically damped | Two real, repeated | 0% |
| $0 < \zeta < 1$ | Underdamped | Complex conjugate | $e^{-\zeta\pi/\sqrt{1-\zeta^2}}$ |
| $\zeta = 0$ | Undamped | Pure imaginary $\pm j\omega_n$ | 100% (sustained) |
| $\zeta < 0$ | Unstable | RHP complex | Growing |

#### Performance Metrics (Underdamped, $0<\zeta<1$)

| Metric | Formula |
|--------|---------|
| **Peak time** | $t_p = \frac{\pi}{\omega_n\sqrt{1-\zeta^2}}$ |
| **% Overshoot** | $\%OS = 100 e^{-\zeta\pi/\sqrt{1-\zeta^2}}$ |
| **Settling (2%)** | $t_s \approx \frac{4}{\zeta\omega_n}$ |
| **Rise time (10-90%)** | $t_r \approx \frac{1.8}{\omega_n}$ (for $\zeta \approx 0.5$) |
| **Damped freq** | $\omega_d = \omega_n\sqrt{1-\zeta^2}$ |

#### Design Targets for Robotics

| Application | Target $\zeta$ | Target $\omega_n$ | Rationale |
|-------------|----------------|-------------------|-----------|
| **Joint position** | 0.7 - 1.0 | 10 - 50 rad/s | Minimal overshoot, fast settling |
| **Force control** | 0.5 - 0.7 | 5 - 20 rad/s | Compliance, disturbance rejection |
| **Trajectory tracking** | 0.7 - 0.9 | 5 - 30 rad/s | Balance speed/overshoot |
| **Balancing robot** | 0.3 - 0.5 | 2 - 10 rad/s | Fast response, some oscillation OK |

---

## Stability & Routh-Hurwitz

### Stability Criterion
All poles must have **negative real parts** (LHP).

### Routh-Hurwitz Test

For characteristic polynomial: $a_n s^n + a_{n-1}s^{n-1} + ... + a_0 = 0$

1. All coefficients $a_i > 0$ (necessary but not sufficient)
2. Build Routh array:
```
s^n:  a_n    a_{n-2}  a_{n-4} ...
s^{n-1}: a_{n-1} a_{n-3}  a_{n-5} ...
s^{n-2}: b_1    b_2      b_3 ...
s^{n-3}: c_1    c_2      c_3 ...
...
s^0:    ...
```
Where $b_1 = \frac{a_{n-1}a_{n-2} - a_n a_{n-3}}{a_{n-1}}$, etc.

3. **Stable** iff all first-column elements > 0

### Example: $s^3 + 7s^2 + 10s + K = 0$

```
s^3:  1    10
s^2:  7    K
s^1:  (70-K)/7   0
s^0:  K
```

Stable for: $K > 0$ and $(70-K)/7 > 0$ → **$0 < K < 70$**

---

## Root Locus

### What It Shows
Closed-loop pole locations as gain $K$ varies from $0$ to $\infty$.

### Construction Rules

| Rule | Description |
|------|-------------|
| 1. Branches | $n$ branches ($n$ = poles) |
| 2. Start/End | Start at poles ($K=0$), end at zeros ($K=\infty$) |
| 3. Real axis | Locus exists where odd \# of poles+zeros to the right |
| 4. Asymptotes | $n-m$ branches → $\infty$ along asymptotes |
| 5. Breakaway | Where $dK/ds = 0$ on real axis |
| 6. $j\omega$ crossing | Routh-Hurwitz: find $K$ where poles cross imaginary axis |

### Asymptotes

| Property | Formula |
|----------|---------|
| Centroid | $\sigma_a = \frac{\sum\text{poles} - \sum\text{zeros}}{n-m}$ |
| Angles | $\theta_a = \frac{(2k+1)180°}{n-m}$, $k=0,1,...,n-m-1$ |

### Robotics Application

```
Design K for:
- Desired damping (ζ ≈ 0.7 → 45° line)
- Desired speed (ωn distance from origin)
- Stability margin (distance from jω axis)
```

---

## Frequency Response & Bode

### Bode Plot: Two Charts

| Plot | Y-Axis | X-Axis | Key Info |
|------|--------|--------|----------|
| **Magnitude** | 20log₁₀\|G(jω)\| (dB) | log₁₀ω | Gain, bandwidth, slopes |
| **Phase** | ∠G(jω) (deg) | log₁₀ω | Phase lag, delays |

### Asymptotic Approximations

| Term | Corner Freq | Mag Slope | Phase |
|------|-------------|-----------|-------|
| $K$ | - | 0 dB/dec | 0° |
| $\frac{1}{s}$ | - | -20 dB/dec | -90° |
| $s$ | - | +20 dB/dec | +90° |
| $\frac{1}{\tau s+1}$ | $1/\tau$ | -20 dB/dec (after) | -90° (after) |
| $\tau s+1$ | $1/\tau$ | +20 dB/dec (after) | +90° (after) |
| $\frac{\omega_n^2}{s^2+2\zeta\omega_n s+\omega_n^2}$ | $\omega_n$ | -40 dB/dec (after) | -180° (after) |

### Stability Margins

| Margin | Definition | Target |
|--------|------------|--------|
| **Gain Margin (GM)** | $1/\|G(j\omega_{180})\|$ where phase = -180° | ≥ 6 dB (2×) |
| **Phase Margin (PM)** | $180° + \angle G(j\omega_0)$ where \|G\| = 1 | ≥ 30° (robust), ≥ 45° (good), ≥ 60° (very robust) |

### Crossover Frequencies

| Frequency | Definition |
|-----------|------------|
| $\omega_{gc}$ (gain crossover) | \|G(jω)\| = 1 (0 dB) |
| $\omega_{pc}$ (phase crossover) | ∠G(jω) = -180° |

### Bandwidth
- Closed-loop -3dB frequency
- $\omega_{bw} \approx 1.5/\tau_r$ (rise time $\tau_r$)
- Higher = faster but more noise sensitive

---

## PID Control

### Continuous Form
$$C(s) = K_p + \frac{K_i}{s} + K_d s = K_p\left(1 + \frac{1}{T_i s} + T_d s\right)$$

### Term Effects

| Term | Time Domain | Frequency Domain | Effect |
|------|-------------|------------------|--------|
| **P** | $K_p e(t)$ | $K_p$ | Immediate response, reduces rise time |
| **I** | $K_i \int e dt$ | $\frac{K_i}{j\omega}$ | Eliminates steady-state error, -90° phase |
| **D** | $K_d \frac{de}{dt}$ | $K_d j\omega$ | Predicts future error, +90° phase |

### Tuning Methods

| Method | When to Use | Steps |
|--------|-------------|-------|
| **Z-N Step Response** | FOPDT model | $K_p = 1.2\tau/(KL)$, $K_i = K_p/(2L)$, $K_d = 0.5K_p L$ |
| **Z-N Ultimate Gain** | Can oscillate system | Find $K_u$, $T_u$; $K_p=0.6K_u$, $K_i=1.2K_u/T_u$, $K_d=0.075K_u T_u$ |
| **Cohen-Coon** | Large dead time | Modified Z-N for better disturbance rejection |
| **PID Tuner (MATLAB)** | Any model | Interactive, optimal trade-offs |

### Practical PID for Robotics

```matlab
% Robot joint PID structure
% Plant: Motor + gearbox + link = 1/(s(Js+b)(Ls+R)+K^2)
% Often simplified to: 1/(s*(s+a)*(s+b))

% Standard form with filter
C(s) = Kp*(1 + 1/(Ti*s) + Td*s/(1+Td/N*s))

% Typical N (filter coefficient) = 10-100
% Anti-windup: back-calculation with Kb = 1/Kp to 1/(10*Kp)
```

### Digital PID Implementation

```python
# Discrete PID (Tustin/Trapezoidal)
class DiscretePID:
    def __init__(self, Kp, Ki, Kd, Ts, N=100):
        self.Kp, self.Ki, self.Kd, self.Ts, self.N = Kp, Ki, Kd, Ts, N
        self.integral = 0
        self.prev_error = 0
        self.prev_derivative = 0
    
    def update(self, error, output_limits=(-1, 1)):
        # Proportional
        P = self.Kp * error
        
        # Integral (trapezoidal) with anti-windup
        self.integral += self.Ki * self.Ts * (error + self.prev_error) / 2
        # Anti-windup: clamp integral if output saturates
        # (implementation depends on saturation detection)
        
        # Derivative (filtered)
        derivative = self.Kd * self.N * (error - self.prev_error) / (1 + self.N * self.Ts/2)
        
        output = P + self.integral + derivative
        
        self.prev_error = error
        return np.clip(output, *output_limits)
```

---

## State Space Representation

### Continuous Form
$$\dot{x} = Ax + Bu$$
$$y = Cx + Du$$

| Variable | Dimension | Meaning |
|----------|-----------|---------|
| $x$ | $n \times 1$ | State vector |
| $u$ | $m \times 1$ | Input vector |
| $y$ | $p \times 1$ | Output vector |
| $A$ | $n \times n$ | System dynamics |
| $B$ | $n \times m$ | Input mapping |
| $C$ | $p \times n$ | Output mapping |
| $D$ | $p \times m$ | Feedthrough |

### Canonical Forms

| Form | A Matrix | Use Case |
|------|----------|----------|
| **Controllable** | Companion | Controller design |
| **Observable** | Companionᵀ | Observer design |
| **Modal** | Diagonal (if distinct poles) | Modal analysis |
| **Balanced** | $\Sigma = \Sigma_c = \Sigma_o$ | Model reduction |

### Transfer Function → State Space

```matlab
% MATLAB
sys_tf = tf([1], [1, 7, 10, 0]);  % 1/(s^3+7s^2+10s)
sys_ss = ss(sys_tf);  % Controllable canonical form

% Check controllability/observability
ctrb = rank(ctrb(sys_ss.A, sys_ss.B));
obsv = rank(obsv(sys_ss.A, sys_ss.C));
```

### State Feedback Control (Pole Placement)

```matlab
% Desired closed-loop poles
p_desired = [-2, -3, -4];

% Compute gain K (Ackermann's formula)
K = place(A, B, p_desired);  % or K = acker(A, B, p_desired)

% Closed-loop system
A_cl = A - B*K;
```

### Observer Design (State Estimation)

```matlab
% Full-order observer (Luenberger)
% Observer poles 2-5x faster than controller poles
p_obs = 3 * p_desired;
L = place(A', C', p_obs)';  % Dual to pole placement

% Kalman filter (optimal)
[L, P, E] = kalman(sys_ss, Qn, Rn);  % Qn=process noise, Rn=measurement noise
```

---

## Robotics-Specific Applications

### 1. Motor + Gearbox + Link Dynamics

```
Voltage → Current → Torque → Acceleration → Velocity → Position
   V       i = (V-Kv)/R    τ = Kt*i      α = τ/J       ω = ∫α dt      θ = ∫ω dt

Transfer function (V → θ):
G(s) = K / [s (Js+b) (Ls+R) + Kt*Ke]
     ≈ K / [s (τ_m s+1) (τ_e s+1)]  (mechanical + electrical time constants)
```

### 2. Common Robot Control Architectures

| Architecture | Structure | Use Case |
|--------------|-----------|----------|
| **Computed Torque** | $\tau = M(q)\ddot{q}_d + C(q,\dot{q})\dot{q}_d + g(q) + K_p e + K_d \dot{e}$ | Model-based, high performance |
| **PD + Gravity Comp** | $\tau = g(q) + K_p e + K_d \dot{e}$ | Simpler, good for slow motion |
| **Impedance Control** | $M_d\ddot{x} + B_d\dot{x} + K_d x = F_{ext}$ | Interaction, force control |
| **Admittance Control** | $\ddot{x} = M^{-1}(F_{ext} - B\dot{x} - Kx)$ | Human-robot interaction |

### 3. Cascaded Control Loops

```
┌─────────────────────────────────────────────────────┐
│ Position Loop (outer, ~100-500 Hz)                  │
│   PD or PID on position error                       │
│   Output: velocity command                          │
│   └──────────────────────────────────────────────┐  │
│   Velocity Loop (middle, ~1-2 kHz)               │  │
│     PI on velocity error                          │  │
│     Output: current/torque command                │  │
│     └────────────────────────────────────────┐   │  │
│     Current Loop (inner, ~10-20 kHz)         │   │  │
│       PI on current error                     │   │  │
│       Output: PWM voltage                     │   │  │
│       └────────────────────────────────────┐  │   │  │
│       Motor + Driver + Encoder              │  │   │  │
│                                             │  │   │  │
└─────────────────────────────────────────────┘  └───┘  └─┘
```

### 4. Typical Bandwidth Hierarchy

| Loop | Bandwidth | Update Rate | Controller |
|------|-----------|-------------|------------|
| Current | 1-5 kHz | 10-20 kHz | PI |
| Velocity | 200-500 Hz | 1-2 kHz | PI |
| Position | 50-200 Hz | 500-1000 Hz | PD/PID |

---

## Quick Reference Tables

### Common Transfer Functions in Robotics

| Component | Transfer Function | Notes |
|-----------|-------------------|-------|
| DC Motor (V→ω) | $\frac{K}{(Js+b)(Ls+R)+K^2}$ | 2nd order + integrator if position |
| DC Motor (V→θ) | $\frac{K}{s[(Js+b)(Ls+R)+K^2]}$ | 3rd order |
| Gearbox | $\frac{1}{N}$ (ideal) | Ratio $N:1$ |
| Flexible joint | $\frac{K}{s^2(J_m s^2+b_m s+k)(J_l s^2+b_l s)+k}$ | 4th+ order |
| PID | $K_p + K_i/s + K_d s$ | Add filter on D: $K_d s/(1+\tau_f s)$ |
| Lead comp | $K \frac{s+z}{s+p}, z<p$ | Phase lead |
| Lag comp | $K \frac{s+z}{s+p}, z>p$ | Low-freq gain |

### Useful MATLAB/Python Commands

```matlab
% Analysis
tf(num, den)           % Create TF
ss(A,B,C,D)            % Create SS
tf2ss, ss2tf           % Convert
pole(sys), zero(sys)   % Poles/zeros
step(sys), impulse(sys) % Time response
bode(sys), nyquist(sys) % Frequency response
margin(sys)            % GM, PM
rlocus(sys)            % Root locus
pidtune(sys, 'PID')    % Auto PID
place(A,B,p)           % Pole placement
acker(A,B,p)           % Ackermann
ctrb, obsv             % Controllability/observability
kalman(sys, Q, R)      % Kalman filter
```

```python
# Python (control library)
import control as ctrl
ctrl.tf(num, den)
ctrl.ss(A, B, C, D)
ctrl.pole(sys), ctrl.zero(sys)
ctrl.step_response(sys)
ctrl.bode(sys)
ctrl.margin(sys)
ctrl.root_locus(sys)
ctrl.pid_tune(sys, 'PID')
ctrl.place(A, B, p)
ctrl.ctrb(A, B), ctrl.obsv(A, C)
```

### Stability Quick Check

| Test | Pass Condition |
|------|----------------|
| All coefficients > 0 | Necessary |
| Routh array 1st column > 0 | Sufficient |
| Nyquist: no encirclements of -1 | Stable (if P=0) |
| Bode: GM > 0 dB, PM > 0° | Stable |
| Root locus: all poles in LHP | Stable |

---

## Key Takeaways for Robotics

1. **Integrators are everywhere** (position from velocity, PID integral)
2. **System type determines steady-state error** → add integrators for zero error
3. **Second-order approximation** works for most joint controllers
4. **Cascaded loops** separate bandwidths: current > velocity > position
5. **Digital implementation matters**: use Tustin, anti-windup, proper sampling
6. **Model-based control** (computed torque, feedforward) outperforms pure PID
7. **Always validate** with real hardware: friction, backlash, saturation, delays

---

*This reference covers the fundamentals needed to analyze, design, and implement control systems for robotic applications. For deeper study: Åström & Murray "Feedback Systems", Spong et al. "Robot Modeling and Control", Franklin et al. "Feedback Control of Dynamic Systems".*