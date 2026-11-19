"""
First-Order System Interactive Tutorial
========================================
G(s) = K / (tau*s + 1)

Interactive sliders for:
- K (gain): 0.1 - 5.0
- tau (time constant): 0.1 - 5.0 s
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import ipywidgets as widgets
from IPython.display import display


def first_order_response(K, tau, t_max=10):
    """Compute step response of first-order system."""
    sys = signal.TransferFunction([K], [tau, 1])
    t = np.linspace(0, t_max, 500)
    t, y = signal.step(sys, T=t)
    return t, y, sys


def plot_first_order(K=2.0, tau=1.5):
    """Plot first-order step response with key metrics."""
    t, y, sys = first_order_response(K, tau)
    
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(t, y, 'b-', linewidth=2, label='Step Response')
    
    # Steady-state line
    ss = K
    ax.axhline(y=ss, color='k', linestyle='--', linewidth=1, label=f'Steady-state = {ss:.2f}')
    
    # 63.2% point (time constant)
    y_63 = 0.632 * ss
    ax.axhline(y=y_63, color='r', linestyle=':', linewidth=1.5, label=f'63.2% = {y_63:.2f}')
    ax.axvline(x=tau, color='r', linestyle=':', linewidth=1.5)
    ax.plot(tau, y_63, 'ro', markersize=8, markerfacecolor='r')
    ax.annotate(f'$\\tau$ = {tau:.2f}s', xy=(tau, y_63), xytext=(tau+0.5, y_63+0.2),
                arrowprops=dict(arrowstyle='->', color='r'), fontsize=11, color='r')
    
    # Settling time markers
    ax.axvline(x=3*tau, color='g', linestyle=':', linewidth=1, alpha=0.7, label=f'5% settling ≈ {3*tau:.1f}s')
    ax.axvline(x=4*tau, color='orange', linestyle=':', linewidth=1, alpha=0.7, label=f'2% settling ≈ {4*tau:.1f}s')
    
    ax.set_xlabel('Time (s)', fontsize=12)
    ax.set_ylabel('Amplitude', fontsize=12)
    ax.set_title(f'First-Order System: G(s) = {K:.1f} / ({tau:.1f}s + 1)', fontsize=14)
    ax.grid(True, alpha=0.3)
    ax.legend(loc='lower right', fontsize=10)
    ax.set_xlim(0, max(10, 5*tau))
    ax.set_ylim(-0.2, ss*1.2)
    
    # Print metrics
    print(f'\nFirst-Order System Characteristics:')
    print(f'  Gain (K): {K:.2f}')
    print(f'  Time Constant (τ): {tau:.2f} s')
    print(f'  Steady-state value: {ss:.2f}')
    print(f'  63.2% rise time (τ): {tau:.2f} s')
    print(f'  Settling time (5%): {3*tau:.2f} s')
    print(f'  Settling time (2%): {4*tau:.2f} s')
    print(f'  Pole location: s = {-1/tau:.3f}')
    
    plt.tight_layout()
    plt.show()


def interactive_first_order():
    """Create interactive widget for first-order system."""
    K_slider = widgets.FloatSlider(
        value=2.0, min=0.1, max=5.0, step=0.1,
        description='Gain (K):', style={'description_width': 'initial'},
        continuous_update=False
    )
    tau_slider = widgets.FloatSlider(
        value=1.5, min=0.1, max=5.0, step=0.1,
        description='Time Constant (τ):', style={'description_width': 'initial'},
        continuous_update=False
    )
    
    ui = widgets.VBox([
        widgets.HTML('<h3>First-Order System: G(s) = K / (τs + 1)</h3>'),
        K_slider,
        tau_slider
    ])
    
    out = widgets.interactive_output(plot_first_order, {'K': K_slider, 'tau': tau_slider})
    display(ui, out)


if __name__ == '__main__':
    # Static demo
    plot_first_order()
    # For interactive in Jupyter, run: interactive_first_order()
