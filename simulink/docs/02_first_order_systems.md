# Tutorial 2: First-Order Systems

## Overview

First-order systems are the simplest dynamic systems, characterized by a single energy storage element. They appear frequently in thermal systems, RC circuits, and as approximations of higher-order systems.

## Learning Objectives

- Understand first-order system transfer function
- Analyze step response characteristics
- Identify time constant and steady-state gain
- Simulate first-order systems in Simulink
- Calculate performance metrics

## System Definition

### Transfer Function

$$
G(s) = \frac{K}{\tau s + 1}
$$

Where:
- **K** = DC gain (steady-state gain)
- **τ (tau)** = Time constant (seconds)

### Differential Equation

$$
\tau \frac{dy}{dt} + y = K u(t)
$$

### State-Space Form

$$
\dot{x} = -\frac{1}{\tau}x + \frac{K}{\tau}u
$$
$$
y = x
$$

## Step Response Analysis

### Response to Unit Step Input

$$
y(t) = K(1 - e^{-t/\tau}), \quad t \ge 0
$$

### Key Characteristics

| Metric | Formula | Value |
|--------|---------|-------|
| **Time Constant (τ)** | Time to reach 63.2% of final value | τ |
| **Steady-State Value** | $y(\infty)$ | K |
| **Rise Time (10-90%)** | $t_{r} = \tau \ln(9)$ | 2.2τ |
| **Settling Time (2%)** | $t_{s} = 4\tau$ | 4τ |
| **Settling Time (5%)** | $t_{s} = 3\tau$ | 3τ |
| **Initial Slope** | $\dot{y}(0)$ | K/τ |

## Simulink Implementation

### Block Diagram
```
Step Input → [Sum] → Transfer Fcn (K/(τs+1)) → Scope
              ↑                                    |
              └────────────────────────────────────┘
```

### Block Parameters

| Block | Key Parameters |
|-------|----------------|
| Step | Time=0, Before=0, After=1, SampleTime=0 |
| Transfer Fcn | Numerator=[K], Denominator=[τ 1] |
| Scope | NumInputPorts=2, TimeRange=auto |
| To Workspace | VariableName=yout, SaveFormat=Array |

### MATLAB Script
```matlab
% Run the tutorial script
cd simulink/scripts
build_first_order
```

This creates `first_order_system.slx` and generates plots.

## Example: RC Circuit

### System
- R = 1 kΩ, C = 1 μF
- τ = RC = 1 ms
- K = 1 (voltage divider)

### Transfer Function
$$
G(s) = \frac{1}{0.001s + 1}
$$

### Simulink Setup
```matlab
add_block('simulink/Continuous/Transfer Fcn', 'model/RC', ...
    'Numerator', '[1]', 'Denominator', '[0.001 1]')
```

## Performance Analysis

### Effect of Time Constant
- **Small τ**: Fast response, quick settling
- **Large τ**: Slow response, sluggish

### Effect of Gain K
- Scales the steady-state value
- Does not affect time constant or shape

### Pole Location
- Single real pole at $s = -1/\tau$
- Always stable for τ > 0
- Closer to origin = slower response

## Simulink Model: first_order_system.slx

The provided model demonstrates:
1. Open-loop step response
2. Time constant measurement (63.2% point)
3. Steady-state verification
4. Data logging to MATLAB workspace

### Running the Model
```matlab
open_system('first_order_system')
sim('first_order_system')
```

### Accessing Logged Data
```matlab
simOut = sim('first_order_system');
t = simOut.get('tout').Values.Data;
y = simOut.get('yout').Values.Data;

% Calculate actual time constant from data
idx_63 = find(y >= 0.632 * y(end), 1);
tau_measured = t(idx_63);
```

## Exercises

1. **Vary τ**: Change τ from 0.5 to 5, observe response speed
2. **Vary K**: Change K from 0.5 to 5, observe steady-state scaling
3. **Impulse response**: Replace Step with Pulse Generator, analyze
4. **Ramp response**: Use Ramp input, compute steady-state error
5. **Initial conditions**: Set Transfer Fcn initial condition, observe

## Summary

- First-order systems have **one pole** at -1/τ
- **Time constant τ** completely characterizes transient response
- **Gain K** determines steady-state magnitude
- **Always stable** for positive τ
- **No overshoot** or oscillation
- Rise time ≈ 2.2τ, Settling time ≈ 4τ

## Next Tutorial

Proceed to Tutorial 3: Second-Order Systems for oscillatory behavior, overshoot, and damping analysis.

---

*Part of the Simulink Basic Control Tutorial series*
