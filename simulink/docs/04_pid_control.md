# Tutorial 4: PID Control

## Overview

Proportional-Integral-Derivative (PID) control is the most widely used control algorithm in industry. This tutorial covers PID structure, tuning methods, and Simulink implementation.

## Learning Objectives

- Understand P, I, D terms and their effects
- Apply manual and systematic tuning methods
- Use Ziegler-Nichols tuning rules
- Implement PID in Simulink
- Use PID Tuner (Simulink Control Design)

## PID Controller Structure

### Continuous-Time PID

$$
C(s) = K_p + \frac{K_i}{s} + K_d s = K_p\left(1 + \frac{1}{T_i s} + T_d s\right)
$$

Where:
- **Kp** = Proportional gain
- **Ki** = Integral gain (Ki = Kp/Ti)
- **Kd** = Derivative gain (Kd = Kp·Td)
- **Ti** = Integral time constant
- **Td** = Derivative time constant

### Parallel Form (Simulink Default)

$$
C(s) = K_p + \frac{K_i}{s} + \frac{K_d s}{1 + \frac{K_d}{N} s}
$$

Where N = filter coefficient (default 100) to limit high-frequency gain.

## Term Effects

| Term | Effect on Response | Trade-off |
|------|-------------------|-----------|
| **P (Proportional)** | Reduces rise time, reduces steady-state error | Increases overshoot, may cause instability |
| **I (Integral)** | Eliminates steady-state error | Increases overshoot, slows response, may cause oscillation |
| **D (Derivative)** | Reduces overshoot, improves stability | Amplifies noise, sensitive to measurement noise |

## Tuning Methods

### 1. Manual Tuning (Heuristic)

1. Set Ki = 0, Kd = 0
2. Increase Kp until sustained oscillation
3. Set Kp ≈ 0.5 × Kp_critical
4. Increase Ki to eliminate steady-state error
5. Increase Kd to reduce overshoot

### 2. Ziegler-Nichols Step Response Method

For plant approximated as FOPDT: $G(s) = \frac{K e^{-Ls}}{\tau s + 1}$

| Controller | Kp | Ti | Td |
|------------|-----|-----|-----|
| P | τ/(K·L) | - | -
| PI | 0.9τ/(K·L) | 3.33L | -
| PID | 1.2τ/(K·L) | 2L | 0.5L |

### 3. Ziegler-Nichols Ultimate Gain Method

1. Set Ki = 0, Kd = 0
2. Increase Kp until sustained oscillation (Ku = ultimate gain)
3. Measure oscillation period Tu

| Controller | Kp | Ti | Td |
|------------|-----|-----|-----|
| P | 0.5Ku | - | -
| PI | 0.45Ku | Tu/1.2 | -
| PID | 0.6Ku | Tu/2 | Tu/8 |

### 4. Cohen-Coon Method (for FOPDT)

Better for processes with large dead time:

| Controller | Kp | Ti | Td |
|------------|-----|-----|-----|
| P | (τ/KL)(1 + L/(3τ)) | - | -
| PI | (0.9τ/KL)(1 + L/(12τ)) | L(30+3L/τ)/(9+20L/τ) | -
| PID | (1.2τ/KL)(1 + L/(8τ)) | L(30+3L/τ)/(9+20L/τ) | L(4/(11+2L/τ)) |

### 5. PID Tuner (Simulink Control Design)

Automated tuning with design requirements:
- Response time
- Transient behavior (overshoot)
- Robustness (gain/phase margin)

## Simulink Implementation

### PID Controller Block
- Library: `simulink/Continuous/PID Controller`
- Supports: P, PI, PD, PID, PDF, I, ID
- Forms: Parallel, Ideal
- Features: Anti-windup, output saturation, filter coefficient

### Block Parameters

| Parameter | Description |
|-----------|-------------|
| Controller | P, PI, PD, PID, etc. |
| Form | Parallel, Ideal |
| Time domain | Continuous, Discrete |
| Sample time | For discrete (-1 = inherited) |
| Kp, Ki, Kd | Gains (tunable) |
| N | Filter coefficient (derivative filter) |
| Anti-windup | Back-calculation, clamping |
| Output saturation | Min/Max limits |
| Initial conditions | Integrator, filter states |

### PID Tuner Workflow

1. Add PID Controller block to model
2. Double-click block → Click **Tune**
3. PID Tuner opens with linearized plant
4. Adjust sliders:
   - **Response Time**: Speed of response
   - **Transient Behavior**: Overshoot vs. speed
   - **Robustness**: Gain/phase margins
5. Click **Update Block** to apply

## Example: Type 1 Plant

### Plant
$$
G(s) = \frac{1}{s(s+2)(s+5)} = \frac{1}{s^3 + 7s^2 + 10s}
$$
- Integrator (type 1) → zero steady-state error to step
- Three poles: 0, -2, -5

### Manual Tuning Result
- Kp = 15, Ki = 8, Kd = 2
- %OS ≈ 15%, ts ≈ 2.5s
- Stable with good margins

### Ziegler-Nichols for This Plant
- Ultimate gain Ku ≈ 70 (from root locus)
- Ultimate period Tu ≈ 2π/√10 ≈ 2.0s
- PID: Kp = 0.6×70 = 42, Ki = 1.2×70/2 = 42, Kd = 0.075×70×2 = 10.5
- Typically too aggressive, needs detuning

## Simulink Model: pid_control.slx

Features:
1. Closed-loop with reference tracking
2. PID Controller block with tunable gains
3. Plant: 1/(s(s+2)(s+5))
4. Scopes for output, control effort, error
5. Data logging to workspace

### Running the Model
```matlab
open_system('pid_control')
sim('pid_control')
```

### Using PID Tuner
```matlab
open_system('pid_control')
% Double-click PID Controller block
% Click 'Tune' button
% Adjust response time, overshoot, robustness
% Click 'Update Block'
```

## Anti-Windup

### Problem
Integrator accumulates error during saturation → large overshoot when unsaturated

### Solutions
1. **Back-calculation**: Feedback difference between saturated/unsaturated output
2. **Clamping**: Stop integration when output saturates
3. **Conditional integration**: Integrate only when not saturated

### Simulink PID Block
- Enable **Anti-windup method**: back-calculation or clamping
- Set **Anti-windup gain (Kb)**: typically 1/Kp to 1/(10·Kp)
- Set **Output saturation limits**: match actuator limits

## Discrete PID Implementation

### Discrete Forms
**Forward Euler:**
$$
C(z) = K_p + K_i \frac{T_s}{z-1} + K_d \frac{z-1}{T_s z}
$$

**Backward Euler (Tustin):**
$$
C(z) = K_p + K_i \frac{T_s(z+1)}{2(z-1)} + K_d \frac{2(z-1)}{T_s(z+1)}
$$

### Simulink Discrete PID
- Set **Time domain** = Discrete
- Set **Sample time** = Ts (e.g., 0.01)
- Choose **Integrator method**: Forward/Backward/Trapezoidal
- Choose **Filter method**: same options

## Performance Metrics

```matlab
% After simulation
info = stepinfo(sys_cl);

% Key metrics
info.RiseTime       % 10-90% rise time
info.SettlingTime   % 2% settling time
info.Overshoot      % Percent overshoot
info.PeakTime       % Time to peak
info.SteadyStateValue
```

## Exercises

1. **Manual tune**: Start with Kp=1, Ki=0, Kd=0; tune step by step
2. **Ziegler-Nichols**: Find Ku, Tu for the plant; apply rules
3. **PID Tuner**: Use Simulink Control Design to auto-tune
4. **Anti-windup**: Add output saturation ±10, test with/without anti-windup
5. **Discrete PID**: Convert to discrete with Ts=0.01, compare
6. **Disturbance rejection**: Add step disturbance at plant input
7. **Setpoint weighting**: Use 2-DOF PID for setpoint vs. disturbance

## Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Oscillatory | Kp too high | Reduce Kp, add Kd |
| Slow response | Kp too low | Increase Kp |
| Steady-state error | No integral | Add Ki |
| Large overshoot | High Kp, low Kd | Reduce Kp, add Kd |
| Noise amplification | Derivative action | Increase filter N, reduce Kd |
| Windup | Output saturation | Enable anti-windup |
| Instability | Wrong signs | Check feedback polarity |

## Summary

- **PID** combines three actions for robust control
- **P** for responsiveness, **I** for accuracy, **D** for stability
- **Multiple tuning methods** exist; PID Tuner is easiest
- **Anti-windup** essential for real actuators with limits
- **Discrete implementation** needed for digital control
- **Plant knowledge** (model) greatly improves tuning

## Next Tutorial

Proceed to Tutorial 5: Root Locus Analysis for stability analysis and compensator design.

---

*Part of the Simulink Basic Control Tutorial series*
