# MathPlot - Python Control Systems Tutorial Suite

Interactive Python equivalent of the Simulink control tutorials. Uses matplotlib for plotting and ipywidgets for dynamic sliders.

## Features

| Tutorial | File | Interactive Sliders |
|----------|------|---------------------|
| First-Order Systems | `first_order.py` | K (gain), τ (time constant) |
| Second-Order Systems | `second_order.py` | K, ωₙ (natural freq), ζ (damping) |
| PID Control | `pid_control.py` | Kp, Ki, Kd |
| Root Locus | `root_locus.py` | K (gain) |
| Frequency Response | `frequency_response.py` | Kp, Ki, Kd (PID) |

## Quick Start

### 1. Install Dependencies
```bash
cd MathPlot
pip install -r requirements.txt
# Or: python run_all.py --install
```

### 2. Run Static Plots
```bash
python run_all.py
```

### 3. Run Interactive (Jupyter Notebook)
```bash
jupyter notebook
```
Then open any `.py` file and run the `interactive_*()` function:

```python
from first_order import interactive_first_order
interactive_first_order()
```

## Interactive Sliders Guide

### First-Order System
- **K (Gain)**: 0.1 → 5.0 — Scales steady-state value
- **τ (Time Constant)**: 0.1 → 5.0s — Controls speed of response

**Key Observations:**
- τ = time to reach 63.2% of final value
- Settling time (2%) ≈ 4τ
- Pole at s = -1/τ

### Second-Order System
- **K (Gain)**: 0.1 → 5.0 — DC gain
- **ωₙ (Natural Freq)**: 0.5 → 10 rad/s — Speed of oscillation
- **ζ (Damping Ratio)**: 0.0 → 2.0 — Shape of response

**Damping Regions:**
- ζ > 1: Overdamped (slow, no overshoot)
- ζ = 1: Critically damped (fastest no overshoot)
- 0 < ζ < 1: Underdamped (oscillatory, overshoot)
- ζ = 0: Undamped (sustained oscillation)
- ζ < 0: Unstable

### PID Control
- **Kp**: 0 → 50 — Proportional gain
- **Ki**: 0 → 50 — Integral gain (eliminates steady-state error)
- **Kd**: 0 → 10 — Derivative gain (reduces overshoot)

**Tuning Tips:**
1. Start with Kp only, increase until oscillation
2. Add Ki to eliminate steady-state error
3. Add Kd to damp overshoot
4. For this plant, try Kp=15, Ki=8, Kd=2

### Root Locus
- **K (Gain)**: 0 → 100 — Loop gain

**Key Points:**
- Stable for 0 < K < 70
- jω-axis crossing at K=70, ω=±3.16 rad/s
- Asymptotes at 60°, 180°, 300° from centroid -2.33
- Breakaway at s ≈ -0.88

### Frequency Response
- **Kp, Ki, Kd**: PID gains

**Observe:**
- Gain Margin (GM): How much gain increase before instability
- Phase Margin (PM): How much phase lag before instability
- Target PM ≥ 45° for robustness
- Bandwidth relates to response speed

## Requirements

- Python 3.8+
- numpy, scipy, matplotlib
- control (python-control)
- ipywidgets
- jupyter (for interactive mode)

## Comparison with Simulink

| Simulink | MathPlot (Python) |
|----------|-------------------|
| Block diagrams | Transfer functions |
| Scope blocks | matplotlib plots |
| PID Tuner | Manual sliders + margins |
| Linear Analysis | control.margin(), ctrl.bode() |
| Simulation | scipy.signal.step_response |
| Variable gain | Interactive sliders |

## Learning Path

1. **First-Order** → Understand time constant, pole location
2. **Second-Order** → Damping ratio, overshoot, natural frequency
3. **PID** → Three-term control, tuning trade-offs
4. **Root Locus** → Pole migration, stability boundaries
5. **Frequency Response** → Bode, Nyquist, robustness margins

## Tips for Dynamic Learning

1. **Move one slider at a time** to isolate effects
2. **Watch poles/zeros move** in root locus
3. **Compare time ↔ frequency domain** (step response vs Bode)
4. **Find stability boundaries** (K=70 for root locus)
5. **Try to hit specifications**: PM=60°, %OS=10%, ts=2s

## Running in VS Code

1. Install Python extension
2. Open `MathPlot` folder
3. Create `.venv` and install requirements
4. Run `python run_all.py` for static plots
5. For interactive: open in Jupyter (`jupyter notebook`)

## Files Structure

```
MathPlot/
├── README.md
├── requirements.txt
├── run_all.py              # Main runner
├── first_order.py          # Tutorial 1
├── second_order.py         # Tutorial 2
├── pid_control.py          # Tutorial 3
├── root_locus.py           # Tutorial 4
└── frequency_response.py   # Tutorial 5
```

---
*Python Control Systems Tutorial Suite - MathPlot*
