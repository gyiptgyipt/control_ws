# Tutorial 5: Root Locus Analysis

## Overview

Root locus is a graphical method for analyzing how closed-loop poles move as a system parameter (typically gain K) varies. It's essential for stability analysis and compensator design.

## Learning Objectives

- Understand root locus construction rules
- Analyze stability from root locus
- Design gain and compensators using root locus
- Use MATLAB rlocus() and rlocfind()
- Interpret Simulink models with variable gain

## Root Locus Fundamentals

### Closed-Loop Characteristic Equation

$$
1 + K G(s)H(s) = 0
$$

Where G(s)H(s) is the open-loop transfer function.

### Root Locus Definition

The root locus is the set of all closed-loop pole locations as K varies from 0 to ∞.

### Angle and Magnitude Conditions

For a point s to be on the root locus:
- **Angle condition**: ∠G(s)H(s) = ±180°(2k+1)
- **Magnitude condition**: |K·G(s)H(s)| = 1

## Construction Rules

| Rule | Description |
|------|-------------|
| **1. Branches** | Number of branches = number of open-loop poles |
| **2. Start/End** | Starts at poles (K=0), ends at zeros (K=∞) |
| **3. Real Axis** | Segment on real axis if odd number of poles+zeros to the right |
| **4. Asymptotes** | n-m branches go to infinity along asymptotes |
| **5. Breakaway** | Loci leave real axis where dK/ds = 0 |
| **6. jω Crossing** | Find K where loci cross imaginary axis (Routh) |
| **7. Departure/Arrival** | Angles from complex poles/zeros |
| **8. Test Points** | Evaluate angle condition for candidate points |

### Asymptotes

**Centroid:**
$$
\sigma_a = \frac{\sum \text{poles} - \sum \text{zeros}}{n - m}
$$

**Angles:**
$$
\theta_a = \frac{(2k+1)180°}{n - m}, \quad k = 0, 1, ..., n-m-1
$$

## Example: G(s) = 1/(s(s+2)(s+5))

### Open-Loop
- Poles: 0, -2, -5 (n=3)
- Zeros: none (m=0)
- 3 branches

### Asymptotes
- Centroid: σ_a = (0 - 2 - 5)/3 = -2.33
- Angles: 60°, 180°, 300°

### Breakaway Point
Solve dK/ds = 0 where K = -1/G(s) = -s(s+2)(s+5)
$$
\frac{d}{ds}[-s(s+2)(s+5)] = -(3s^2 + 14s + 10) = 0
$$
Breakaway at s = -0.88 (between 0 and -2)

### jω-Axis Crossing (Routh-Hurwitz)

Characteristic equation: s³ + 7s² + 10s + K = 0

| s³ | 1 | 10 |
| s² | 7 | K |
| s¹ | (70-K)/7 | 0 |
| s⁰ | K | |

For stability: K > 0 and (70-K)/7 > 0 → **0 < K < 70**

At K = 70: auxiliary equation 7s² + 70 = 0 → s = ±j√10 ≈ ±j3.16

### Departure Angles
No complex poles, so no departure angles needed.

## Root Locus in MATLAB

### Basic Plot
```matlab
s = tf('s');
G = 1/(s*(s+2)*(s+5));
rlocus(G)
grid on
```

### Interactive Gain Selection
```matlab
[K, poles] = rlocfind(G)
% Click on locus to select desired pole location
```

### SISO Design Tool
```matlab
sisotool(G)
% Or from Simulink: Control Design > SISO Design Tool
```

### Step Response at Selected Gain
```matlab
K = 10;  % Selected gain
sys_cl = feedback(K*G, 1);
step(sys_cl)
stepinfo(sys_cl)
```

## Compensator Design Using Root Locus

### Lead Compensator
Adds phase lead (improves stability, speeds up response)
$$
C_{lead}(s) = K_c \frac{s + z}{s + p}, \quad z < p
$$
- Zero closer to origin than pole
- Adds positive phase
- Increases bandwidth

### Lag Compensator
Improves steady-state error (increases low-frequency gain)
$$
C_{lag}(s) = K_c \frac{s + z}{s + p}, \quad z > p
$$
- Pole closer to origin than zero
- Adds negative phase (must place carefully)
- Increases DC gain

### Lead-Lag Compensator
Combines both effects
$$
C(s) = K_c \frac{(s + z_1)(s + z_2)}{(s + p_1)(s + p_2)}
$$

## Simulink Implementation

### Variable Gain Model
The model `root_locus_analysis.slx` includes:
- Adjustable Gain block for K
- Plant: 1/(s(s+2)(s+5))
- Closed-loop configuration
- Step response visualization

### Running the Model
```matlab
open_system('root_locus_analysis')
% Modify Gain block value
set_param('root_locus_analysis/Variable Gain K', 'Gain', '10')
sim('root_locus_analysis')
```

### Parameter Sweep
```matlab
K_vals = [1, 5, 10, 35, 70, 100];
for K = K_vals
    set_param('root_locus_analysis/Variable Gain K', 'Gain', num2str(K));
    simOut = sim('root_locus_analysis');
    % Analyze step response
end
```

## Stability Analysis

### Gain Margin
From root locus: distance from jω-axis crossing to origin in K-space
- For this system: K_margin = 70
- Gain can increase 70× before instability

### Phase Margin
Not directly visible on root locus; use Bode plot

### Relative Stability
- Dominant poles: closest to imaginary axis
- Damping ratio from pole angle: ζ = cos(θ)
- Natural frequency: distance from origin

## Design Examples

### Example 1: Design for ζ = 0.707
```matlab
s = tf('s');
G = 1/(s*(s+2)*(s+5));
rlocus(G)
% Click on locus where angle = 45° (zeta=0.707)
[K, poles] = rlocfind(G)
```
Result: K ≈ 16, dominant poles at -1.6 ± j1.6

### Example 2: Lead Compensator for Faster Response
Target: ts < 1s, %OS < 20%
- Desired dominant poles: ζ=0.5, ωₙ=8 → -4 ± j6.9
- Add lead compensator to pull locus through desired point
```matlab
C_lead = 2*(s+3)/(s+10);  % Design by hand or sisotool
rlocus(C_lead*G)
```

## Root Locus vs. Other Methods

| Method | Advantage | Best For |
|--------|-----------|----------|
| Root Locus | Visual pole migration, intuitive | Gain selection, lead/lag design |
| Bode/Nyquist | Frequency domain, margins | Robustness, noise analysis |
| State Space | MIMO, optimal control | Modern control, observers |
| PID Tuner | Automated, interactive | Quick PID tuning |

## Exercises

1. **Plot root locus** for G(s) = 1/(s(s+1)(s+10))
2. **Find K** for ζ = 0.5, ζ = 0.707, ζ = 1.0
3. **Design lead compensator** to achieve ts < 2s
4. **Design lag compensator** to reduce steady-state error 10×
5. **Analyze effect** of adding zero at -1, -3, -10
6. **Compare** root locus with PID Tuner results

## Summary

- **Root locus** shows closed-loop pole migration with gain
- **Rules** allow quick sketching and analysis
- **Stability range** found from jω-axis crossing
- **Dominant poles** determine transient response
- **Compensators** (lead/lag) reshape locus for specifications
- **MATLAB tools**: rlocus(), rlocfind(), sisotool()

## Next Tutorial

Proceed to Tutorial 6: Frequency Response Analysis for Bode plots, Nyquist, and robustness.

---

*Part of the Simulink Basic Control Tutorial series*
