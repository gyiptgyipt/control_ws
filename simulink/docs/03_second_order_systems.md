# Tutorial 3: Second-Order Systems

## Overview

Second-order systems contain two energy storage elements and exhibit oscillatory behavior. They are fundamental to understanding vibration, resonance, and control system dynamics.

## Learning Objectives

- Understand second-order transfer function and parameters
- Analyze step response based on damping ratio
- Identify peak time, overshoot, settling time
- Simulate underdamped, critically damped, and overdamped systems
- Relate pole locations to time-domain response

## System Definition

### Standard Transfer Function

$$
G(s) = \frac{K\omega_n^2}{s^2 + 2\zeta\omega_n s + \omega_n^2}
$$

Where:
- **ωₙ (wn)** = Natural frequency (rad/s)
- **ζ (zeta)** = Damping ratio (dimensionless)
- **K** = DC gain

### Alternative Forms

**Time constant form:**
$$
G(s) = \frac{K}{(\tau_1 s + 1)(\tau_2 s + 1)}
$$

**Pole-zero form:**
$$
G(s) = \frac{K\omega_n^2}{(s - p_1)(s - p_2)}
$$

## Damping Classification

| Damping Ratio (ζ) | Pole Locations | Response Type |
|-------------------|----------------|---------------|
| ζ > 1 | Two distinct real poles | **Overdamped** |
| ζ = 1 | Repeated real pole at -ωₙ | **Critically Damped** |
| 0 < ζ < 1 | Complex conjugate poles | **Underdamped** |
| ζ = 0 | Pure imaginary ±jωₙ | **Undamped** |
| ζ < 0 | RHP poles | **Unstable** |

## Underdamped Response (0 < ζ < 1)

### Poles
$$
p_{1,2} = -\zeta\omega_n \pm j\omega_n\sqrt{1-\zeta^2} = -\sigma \pm j\omega_d
$$
Where:
- σ = ζωₙ (real part, decay rate)
- ω_d = ωₙ√(1-ζ²) (damped natural frequency)

### Step Response
$$
y(t) = K\left[1 - \frac{e^{-\zeta\omega_n t}}{\sqrt{1-\zeta^2}}\sin(\omega_d t + \phi)\right]
$$
Where φ = cos⁻¹(ζ)

### Key Performance Metrics

| Metric | Formula | Description |
|--------|---------|-------------|
| **Peak Time (tp)** | π / ω_d | Time to first peak |
| **Percent Overshoot (%OS)** | 100·e^(-ζπ/√(1-ζ²)) | Peak overshoot |
| **Settling Time (2%)** | 4 / (ζωₙ) | Time within 2% of final |
| **Settling Time (5%)** | 3 / (ζωₙ) | Time within 5% of final |
| **Rise Time (0-100%)** | (π - φ)/ω_d | Time from 0 to 100% |
| **Rise Time (10-90%)** | ≈ 1.8/ωₙ (ζ=0.5) | Common definition |

### Damping Ratio vs. %OS

| ζ | %OS | ζ | %OS |
|---|-----|---|-----|
| 0.1 | 73% | 0.6 | 9.5% |
| 0.2 | 53% | 0.7 | 4.6% |
| 0.3 | 37% | 0.8 | 1.5% |
| 0.4 | 25% | 0.9 | 0.15% |
| 0.5 | 16% | 1.0 | 0% |

## Overdamped Response (ζ > 1)

### Poles
Two real poles: $p_1 = -\zeta\omega_n + \omega_n\sqrt{\zeta^2-1}$, $p_2 = -\zeta\omega_n - \omega_n\sqrt{\zeta^2-1}$

### Step Response
$$
y(t) = K\left[1 - \frac{p_2 e^{p_1 t} - p_1 e^{p_2 t}}{p_2 - p_1}\right]
$$

- No overshoot
- Slower than critically damped
- Dominated by slower pole (closer to origin)

## Critically Damped (ζ = 1)

### Poles
Repeated pole at $s = -\omega_n$

### Step Response
$$
y(t) = K[1 - e^{-\omega_n t}(1 + \omega_n t)]
$$

- Fastest non-overshooting response
- Boundary between overdamped and underdamped

## Simulink Implementation

### Block Parameters

| Block | Key Parameters |
|-------|----------------|
| Step | Time=0, Before=0, After=1 |
| Transfer Fcn | Numerator=[K*wn²], Denominator=[1 2*zeta*wn wn²] |
| Scope | NumInputPorts=2 |

### MATLAB Script
```matlab
cd simulink/scripts
build_second_order
```

Creates `second_order_system.slx` with ωₙ=4, ζ=0.3 by default.

## Pole-Zero Map Analysis

```matlab
s = tf('s');
G = 16/(s^2 + 2.4*s + 16);  % wn=4, zeta=0.3
pzmap(G)
grid on
```

### Pole Locations for Default Parameters
- ωₙ = 4 rad/s, ζ = 0.3
- Poles: -1.2 ± j3.84
- ω_d = 3.84 rad/s
- %OS = 37%
- tp = 0.82 s
- ts = 3.33 s

## Simulink Model: second_order_system.slx

The model demonstrates:
1. Step response with overshoot measurement
2. Peak time and settling time markers
3. Comparison with theoretical values
4. Parameter sweep capability

### Running Parameter Sweep
```matlab
% Test different damping ratios
zeta_vals = [0.1, 0.3, 0.5, 0.7, 1.0, 1.5];
for zeta = zeta_vals
    set_param('second_order_system/Second-Order System', ...
        'Denominator', sprintf('[1 %g %g]', 2*zeta*4, 16));
    sim('second_order_system');
    % Analyze results
end
```

## Exercises

1. **Vary ζ**: Test ζ = 0.1, 0.3, 0.5, 0.7, 1.0, 2.0
2. **Vary ωₙ**: Test ωₙ = 1, 2, 5, 10 with fixed ζ=0.5
3. **Impulse response**: Compare with step response
4. **Initial conditions**: Set non-zero initial states
5. **Ramp response**: Analyze steady-state error to ramp
6. **Pole migration**: Plot poles as ζ varies from 0 to 2

## Design Guidelines

| Requirement | Target ζ | Target ωₙ |
|-------------|----------|-----------|
| Fast with low overshoot | 0.7 | High |
| No overshoot, fast | 1.0 | High |
| Minimal settling time | 0.707 | High |
| Specific %OS | Solve for ζ | As needed |
| Specific tp | - | π/(tp·√(1-ζ²)) |
| Specific ts | 4/(ζ·ts) | As needed |

## Summary

- **Two parameters** (ωₙ, ζ) completely characterize response
- **ζ determines shape**: oscillatory vs. exponential
- **ωₙ determines speed**: scales time axis
- **Poles** reveal stability and response type visually
- **%OS depends only on ζ** (for standard form)
- **Standard targets**: ζ=0.707 (≈5% OS), ζ=1 (critically damped)

## Next Tutorial

Proceed to Tutorial 4: PID Control for closed-loop controller design.

---

*Part of the Simulink Basic Control Tutorial series*
