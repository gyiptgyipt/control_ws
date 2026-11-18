# Simulink Basic Control Tutorial

This directory contains a comprehensive tutorial for learning basic control systems using MATLAB Simulink.

## Directory Structure

```
simulink/
├── README.md                 # This file
├── models/                   # Pre-built Simulink models (.slx)
│   ├── first_order_system.slx
│   ├── second_order_system.slx
│   ├── pid_control.slx
│   ├── root_locus_analysis.slx
│   └── frequency_response.slx
├── scripts/                  # MATLAB scripts to build/run models programmatically
│   ├── build_first_order.m
│   ├── build_second_order.m
│   ├── build_pid_control.m
│   ├── build_root_locus.m
│   ├── build_bode_plot.m
│   └── run_all_tutorials.m
└── docs/                     # Tutorial documentation
    ├── 01_introduction.md
    ├── 02_first_order_systems.md
    ├── 03_second_order_systems.md
    ├── 04_pid_control.md
    ├── 05_root_locus.md
    ├── 06_frequency_response.md
    └── 07_advanced_topics.md
```

## Prerequisites

- MATLAB R2020a or later
- Simulink
- Control System Toolbox
- Simulink Control Design (optional, for advanced features)

## Quick Start

### Option 1: Run the Master Script (Recommended)

```matlab
cd simulink/scripts
run_all_tutorials
```

This will build all models, run simulations, and generate plots automatically.

### Option 2: Open Pre-built Models

```matlab
cd simulink/models
open_system('first_order_system')
open_system('second_order_system')
open_system('pid_control')
open_system('root_locus_analysis')
open_system('frequency_response')
```

### Option 3: Run Individual Tutorial Scripts

```matlab
cd simulink/scripts
build_first_order      % First-order system response
build_second_order     % Second-order system response
build_pid_control      % PID controller design
build_root_locus       % Root locus analysis
build_bode_plot        % Frequency response analysis
```

## Tutorial Overview

| Tutorial | Model/Script | Key Concepts |
|----------|--------------|--------------|
| 1. Introduction | N/A | Simulink basics, block libraries, simulation configuration |
| 2. First-Order Systems | `first_order_system.slx` | Time constant, step response, steady-state error |
| 3. Second-Order Systems | `second_order_system.slx` | Damping ratio, natural frequency, overshoot, settling time |
| 4. PID Control | `pid_control.slx` | P, I, D terms, tuning, Ziegler-Nichols |
| 5. Root Locus | `root_locus_analysis.slx` | Pole migration, stability margins, controller design |
| 6. Frequency Response | `frequency_response.slx` | Bode plots, gain/phase margins, bandwidth |
| 7. Advanced Topics | N/A | State-space, digital control, robust control |

## Learning Objectives

After completing this tutorial, you will be able to:

1. **Build and simulate dynamic systems** in Simulink using block diagrams
2. **Analyze first and second-order system responses** (step, impulse, ramp)
3. **Design PID controllers** using both heuristic and analytical methods
4. **Perform root locus analysis** to assess stability and design compensators
5. **Analyze frequency response** using Bode plots and Nyquist criteria
6. **Connect Simulink models** to MATLAB for advanced analysis and plotting

## Key Simulink Blocks Used

| Category | Blocks |
|----------|--------|
| **Sources** | Step, Ramp, Sine Wave, Signal Generator |
| **Sinks** | Scope, XY Graph, To Workspace, To File |
| **Continuous** | Transfer Fcn, State-Space, Integrator, Derivative |
| **Math Operations** | Sum, Gain, Product, Math Function |
| **Discrete** | Discrete Transfer Fcn, Unit Delay, Zero-Order Hold |
| **Control** | PID Controller, PID Tuner (Simulink Control Design) |

## Running Simulations Programmatically

```matlab
% Set simulation parameters
set_param(model, 'StopTime', '10', 'Solver', 'ode45');

% Run simulation
simOut = sim(model);

% Access logged data
simOut.get('yout')
simOut.get('tout')
```

## Using the PID Tuner (Simulink Control Design)

1. Open the PID control model: `open_system('pid_control')`
2. Double-click the PID Controller block
3. Click **Tune** to launch PID Tuner
4. Adjust response time, transient behavior, and robustness
5. Click **Update Block** to apply tuned parameters

## Generating Bode Plots from Simulink

```matlab
% Linearize model at operating point
op = findop(model, 0);
sys = linearize(model, op);

% Generate Bode plot
bode(sys)
grid on
```

## Root Locus Analysis

```matlab
% Define open-loop transfer function
s = tf('s');
G = 1/(s*(s+2)*(s+5));

% Plot root locus
rlocus(G)
grid on
```

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Model won't open | Ensure MATLAB path includes `simulink/models` directory |
| Simulation fails | Check solver settings (try ode45 for non-stiff, ode15s for stiff) |
| PID Tuner unavailable | Install Simulink Control Design toolbox |
| License errors | Verify Control System Toolbox license: `license('test', 'Control_Toolbox')` |

## References

1. Ogata, K. *Modern Control Engineering*, 5th Ed., Prentice Hall
2. Franklin, G.F., Powell, J.D., Emami-Naeini, A. *Feedback Control of Dynamic Systems*, 7th Ed., Pearson
3. MATLAB/Simulink Documentation: https://mathworks.com/help/simulink
4. Control System Toolbox: https://mathworks.com/help/control

## Next Steps

- Explore **Model Predictive Control** (MPC) toolbox
- Learn **H-infinity** and **mu-synthesis** for robust control
n- Try **Reinforcement Learning** for control (RL Toolbox)
- Deploy to hardware with **Simulink Real-Time** or **Embedded Coder**

---

*Generated for control_ws - Basic Control Learning with Simulink*