# Tutorial 1: Introduction to Simulink for Control Systems

## Overview

This tutorial introduces Simulink basics for modeling and simulating dynamic systems used in control engineering.

## Learning Objectives

- Navigate the Simulink interface and block libraries
- Build block diagram models of dynamic systems
- Configure simulation parameters
- Run simulations and visualize results
- Connect Simulink with MATLAB for analysis

## Prerequisites

- MATLAB with Simulink installed
- Basic understanding of differential equations and Laplace transforms
- Familiarity with MATLAB command window

## Starting Simulink

```matlab
% Method 1: From MATLAB command window
simulink

% Method 2: From MATLAB toolstrip
% Click 'Simulink' in the Apps tab

% Method 3: Create new model programmatically
new_system('my_model')
open_system('my_model')
```

## Simulink Interface Overview

| Component | Description |
|-----------|-------------|
| **Library Browser** | Contains all blocks organized by category |
| **Model Editor** | Canvas for building block diagrams |
| **Simulink Toolstrip** | Simulation controls, modeling tools |
| **Property Inspector** | View/edit block parameters |
| **Signal Attributes** | View signal dimensions, data types |

## Key Block Libraries for Control

```matlab
% Open library browser
slLibraryBrowser
```

| Library Path | Key Blocks |
|--------------|------------|
| `simulink/Sources` | Step, Ramp, Sine Wave, Signal Generator, Constant |
| `simulink/Sinks` | Scope, XY Graph, To Workspace, To File, Display |
| `simulink/Continuous` | Transfer Fcn, State-Space, Integrator, Derivative |
| `simulink/Discrete` | Discrete Transfer Fcn, Unit Delay, Zero-Order Hold |
| `simulink/Math Operations` | Sum, Gain, Product, Math Function, Abs |
| `simulink/Control` | PID Controller, PID Tuner |
| `simulink/Signal Routing` | Mux, Demux, Switch, Multiport Switch |

## Building Your First Model

### Step 1: Create a new model
```matlab
new_system('first_model')
open_system('first_model')
```

### Step 2: Add blocks programmatically
```matlab
% Add a Step input
add_block('simulink/Sources/Step', 'first_model/Step', 'Time', '0', 'After', '1')

% Add a Transfer Function
add_block('simulink/Continuous/Transfer Fcn', 'first_model/Plant', ...
    'Numerator', '[1]', 'Denominator', '[1 2 1]')

% Add a Scope
add_block('simulink/Sinks/Scope', 'first_model/Scope', 'NumInputPorts', '2')
```

### Step 3: Connect blocks
```matlab
add_line('first_model', 'Step/1', 'Plant/1')
add_line('first_model', 'Plant/1', 'Scope/1')
add_line('first_model', 'Step/1', 'Scope/2')
```

### Step 4: Configure simulation
```matlab
set_param('first_model', 'StopTime', '10', 'Solver', 'ode45')
```

### Step 5: Run simulation
```matlab
sim('first_model')
% Or with output
simOut = sim('first_model')
```

## Simulation Configuration

### Solver Selection

| Solver | Type | Use Case |
|--------|------|----------|
| `ode45` | Variable-step, explicit | Non-stiff problems (default) |
| `ode23` | Variable-step, explicit | Less accurate, faster |
| `ode15s` | Variable-step, implicit | Stiff problems |
| `ode23s` | Variable-step, implicit | Stiff, moderate accuracy |
| `Fixed-step` | Fixed-step | Real-time, code generation |

### Key Simulation Parameters

```matlab
set_param(model, 'StopTime', '10')           % Simulation stop time
set_param(model, 'Solver', 'ode45')          % Solver type
set_param(model, 'MaxStep', '0.01')          % Maximum step size
set_param(model, 'RelTol', '1e-3')           % Relative tolerance
set_param(model, 'AbsTol', 'auto')           % Absolute tolerance
set_param(model, 'SaveOutput', 'on')         % Save output to workspace
set_param(model, 'SaveTime', 'on')           % Save time vector
set_param(model, 'OutputSaveName', 'yout')   % Output variable name
set_param(model, 'TimeSaveName', 'tout')     % Time variable name
```

## Data Logging and Visualization

### To Workspace Block
- Saves signal data to MATLAB workspace
- Supports Array, Structure, Structure with Time formats
- Can log multiple signals with Mux

### Scope Block
- Real-time visualization during simulation
- Multiple input ports for comparing signals
- Configuration: Time range, Y-limits, triggers

### Programmatic Access
```matlab
% Run and get outputs
simOut = sim(model);
t = simOut.get('tout').Values.Data;
y = simOut.get('yout').Values.Data;

% Plot in MATLAB
figure; plot(t, y); grid on;
xlabel('Time (s)'); ylabel('Amplitude');
```

## Model Management

```matlab
% Save model
save_system('first_model')
save_system('first_model', 'path/to/model')

% Close model
close_system('first_model')          % Keep in memory
close_system('first_model', 0)       % Close without saving
close_system('first_model', 1)       % Save and close

% Check if loaded
bdIsLoaded('first_model')

% Get model info
gcs % Get current system
find_system('first_model', 'BlockType', 'TransferFcn')
```

## Common Workflow

1. **Define system** mathematically (transfer function, state-space)
2. **Create model** in Simulink with appropriate blocks
3. **Configure** simulation parameters (solver, time, tolerances)
4. **Add sources** (inputs) and **sinks** (outputs/logging)
5. **Run simulation** and verify results
6. **Analyze** results in MATLAB (plots, metrics, linearization)
7. **Iterate** on design (controller tuning, parameter changes)

## Tips and Best Practices

- Use **subsystems** to organize complex models
- Label signals and blocks for clarity
- Use **Model Explorer** to manage variables
- Enable **Signal Logging** for automatic data capture
- Use **Simulation Data Inspector** for comparing runs
- Set appropriate **solver settings** for your system dynamics
- Use **Normal Mode** for simulation, **Accelerator** for speed

## Next Steps

Proceed to Tutorial 2: First-Order Systems to learn about basic system dynamics and time-domain analysis.

---

*Part of the Simulink Basic Control Tutorial series*
