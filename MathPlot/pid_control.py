"""
PID Control Interactive Tutorial
================================
Plant: G(s) = 1 / (s*(s+2)*(s+5))
Controller: C(s) = Kp + Ki/s + Kd*s

Interactive sliders for:
- Kp: 0 - 50
- Ki: 0 - 50
- Kd: 0 - 10
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import ipywidgets as widgets
from IPython.display import display


def pid_closed_loop(Kp, Ki, Kd, sim_time=10):
    """Compute closed-loop response with PID controller."""
    # Plant: 1 / (s*(s+2)*(s+5)) = 1 / (s^3 + 7s^2 + 10s)
    plant_num = [1]
    plant_den = [1, 7, 10, 0]
    
    # PID Controller: Kp + Ki/s + Kd*s = (Kd*s^2 + Kp*s + Ki) / s
    ctrl_num = [Kd, Kp, Ki]
    ctrl_den = [1, 0]  # s
    
    # Open-loop
    ol_num = np.polymul(ctrl_num, plant_num)
    ol_den = np.polymul(ctrl_den, plant_den)
    
    # Closed-loop: OL / (1 + OL)
    cl_num = ol_num
    cl_den = np.polyadd(ol_den, ol_num)
    
    sys_cl = signal.TransferFunction(cl_num, cl_den)
    t = np.linspace(0, sim_time, 1000)
    t, y = signal.step(sys_cl, T=t)
    
    return t, y, sys_cl


def plot_pid(Kp=15, Ki=8, Kd=2):
    """Plot PID closed-loop response."""
    t, y, sys_cl = pid_closed_loop(Kp, Ki, Kd)
    
    fig, axes = plt.subplots(2, 1, figsize=(10, 8))
    
    # Output response
    ax1 = axes[0]
    ax1.plot(t, y, 'b-', linewidth=2, label='Output')
    ax1.axhline(y=1, color='k', linestyle='--', linewidth=1, label='Reference')
    
    # Metrics
    ss = y[-1]
    overshoot = max(y) - ss
    po = (overshoot / ss) * 100 if ss > 0 else 0
    
    idx_10 = np.where(y >= 0.1*ss)[0]
    idx_90 = np.where(y >= 0.9*ss)[0]
    rise_time = t[idx_90[0]] - t[idx_10[0]] if len(idx_10) > 0 and len(idx_90) > 0 else np.nan
    
    settling_idx = np.where(np.abs(y - ss) <= 0.02*ss)[0]
    settling_time = t[settling_idx[-1]] if len(settling_idx) > 0 else np.nan
    
    title_str = f'PID Closed-Loop: Kp={Kp:.1f}, Ki={Ki:.1f}, Kd={Kd:.1f}'
    title_str += f'\nPO={po:.1f}%, tr={rise_time:.2f}s, ts={settling_time:.2f}s, ess={1-ss:.4f}'
    ax1.set_ylabel('Output', fontsize=12)
    ax1.set_title(title_str, fontsize=12)
    ax1.grid(True, alpha=0.3)
    ax1.legend(loc='lower right')
    ax1.set_xlim(0, 10)
    ax1.set_ylim(-0.2, max(1.5, max(y)*1.1))
    
    # Control effort
    ax2 = axes[1]
    ctrl_num = [Kd, Kp, Ki]
    ctrl_den = [1, 0]
    plant_num = [1]
    plant_den = [1, 7, 10, 0]
    ol_num = np.polymul(ctrl_num, plant_num)
    ol_den = np.polymul(ctrl_den, plant_den)
    sens_num = ol_den
    sens_den = np.polyadd(ol_den, ol_num)
    err_num = sens_num
    err_den = np.polymul(sens_den, [1, 0])
    u_num = np.polymul(ctrl_num, err_num)
    u_den = np.polymul(ctrl_den, err_den)
    sys_u = signal.TransferFunction(u_num, u_den)
    t, u = signal.step(sys_u, T=t)
    
    ax2.plot(t, u, 'r-', linewidth=2, label='Control Effort')
    ax2.set_xlabel('Time (s)', fontsize=12)
    ax2.set_ylabel('Control Signal', fontsize=12)
    ax2.set_title(f'Max Control Effort: {max(np.abs(u)):.2f}', fontsize=12)
    ax2.grid(True, alpha=0.3)
    ax2.legend()
    ax2.set_xlim(0, 10)
    
    plt.tight_layout()
    plt.show()
    
    print(f'\nPID Performance:')
    print(f'  Kp={Kp:.1f}, Ki={Ki:.1f}, Kd={Kd:.1f}')
    print(f'  Steady-state: {ss:.4f}')
    print(f'  Overshoot: {po:.1f}%')
    print(f'  Rise time (10-90%): {rise_time:.2f}s')
    print(f'  Settling time (2%): {settling_time:.2f}s')
    print(f'  Steady-state error: {1-ss:.4f}')
    print(f'  Max control effort: {max(np.abs(u)):.2f}')


def interactive_pid():
    """Create interactive widget for PID control."""
    Kp_slider = widgets.FloatSlider(value=15, min=0, max=50, step=1,
        description='Kp:', style={'description_width': 'initial'}, continuous_update=False)
    Ki_slider = widgets.FloatSlider(value=8, min=0, max=50, step=1,
        description='Ki:', style={'description_width': 'initial'}, continuous_update=False)
    Kd_slider = widgets.FloatSlider(value=2, min=0, max=10, step=0.5,
        description='Kd:', style={'description_width': 'initial'}, continuous_update=False)
    
    ui = widgets.VBox([
        widgets.HTML('<h3>PID Control: Plant G(s) = 1/(s(s+2)(s+5))</h3>'),
        widgets.HTML('<i>C(s) = Kp + Ki/s + Kd·s</i>'),
        Kp_slider, Ki_slider, Kd_slider
    ])
    
    out = widgets.interactive_output(plot_pid, {'Kp': Kp_slider, 'Ki': Ki_slider, 'Kd': Kd_slider})
    display(ui, out)


if __name__ == '__main__':
    plot_pid()
