"""
Second-Order System Interactive Tutorial
==========================================
G(s) = K*wn² / (s² + 2*zeta*wn*s + wn²)

Interactive sliders for:
- K (gain): 0.1 - 5.0
- wn (natural frequency): 0.5 - 10.0 rad/s
- zeta (damping ratio): 0.0 - 2.0
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import ipywidgets as widgets
from IPython.display import display


def second_order_response(K, wn, zeta, t_max=8):
    """Compute step response of second-order system."""
    sys = signal.TransferFunction([K * wn**2], [1, 2*zeta*wn, wn**2])
    t = np.linspace(0, t_max, 500)
    t, y = signal.step(sys, T=t)
    return t, y, sys


def plot_second_order(K=1.0, wn=4.0, zeta=0.3):
    """Plot second-order step response with key metrics."""
    t, y, sys = second_order_response(K, wn, zeta)
    
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(t, y, 'b-', linewidth=2, label='Step Response')
    
    # Steady-state line
    ax.axhline(y=K, color='k', linestyle='--', linewidth=1, label=f'Steady-state = {K:.2f}')
    
    # System classification and metrics
    if zeta > 1:
        system_type = 'OVERDAMPED'
        color = 'purple'
    elif zeta == 1:
        system_type = 'CRITICALLY DAMPED'
        color = 'green'
    elif zeta > 0:
        system_type = 'UNDERDAMPED'
        color = 'red'
        # Peak time and overshoot
        wd = wn * np.sqrt(1 - zeta**2)
        tp = np.pi / wd
        PO = 100 * np.exp(-zeta * np.pi / np.sqrt(1 - zeta**2))
        y_peak = K * (1 + PO / 100)
        ax.plot(tp, y_peak, 'ro', markersize=8, markerfacecolor='r')
        ax.axvline(x=tp, color='r', linestyle=':', linewidth=1.5)
        ax.annotate(f'Peak: {y_peak:.2f} at {tp:.2f}s', xy=(tp, y_peak), xytext=(tp+0.3, y_peak+0.1),
                    arrowprops=dict(arrowstyle='->', color='r'), fontsize=10, color='r')
        # Settling time
        ts = 4 / (zeta * wn)
        ax.axvline(x=ts, color='orange', linestyle=':', linewidth=1, alpha=0.7,
                   label=f'2% settling ≈ {ts:.1f}s')
    elif zeta == 0:
        system_type = 'UNDAMPED'
        color = 'orange'
    else:
        system_type = 'UNSTABLE'
        color = 'darkred'
    
    ax.set_xlabel('Time (s)', fontsize=12)
    ax.set_ylabel('Amplitude', fontsize=12)
    ax.set_title(f'Second-Order: K={K:.1f}, ωₙ={wn:.1f} rad/s, ζ={zeta:.2f} ({system_type})', fontsize=13)
    ax.grid(True, alpha=0.3)
    ax.legend(loc='lower right', fontsize=10)
    ax.set_xlim(0, max(8, 5/wn if wn > 0 else 8))
    y_max = max(K*1.5, max(y)*1.1) if zeta > 0 else max(y)*1.1
    ax.set_ylim(-0.2, y_max)
    
    # Pole locations
    poles = np.roots([1, 2*zeta*wn, wn**2])
    
    # Print metrics
    print(f'\nSecond-Order System Characteristics:')
    print(f'  DC Gain (K): {K:.2f}')
    print(f'  Natural Frequency (ωₙ): {wn:.2f} rad/s')
    print(f'  Damping Ratio (ζ): {zeta:.2f}')
    print(f'  System Type: {system_type}')
    print(f'  Poles:')
    for p in poles:
        print(f'    {p.real:.3f} {p.imag:+.3f}j')
    
    if 0 < zeta < 1:
        wd = wn * np.sqrt(1 - zeta**2)
        tp = np.pi / wd
        PO = 100 * np.exp(-zeta * np.pi / np.sqrt(1 - zeta**2))
        ts = 4 / (zeta * wn)
        tr = (np.pi - np.arctan(np.sqrt(1-zeta**2)/zeta)) / wd
        print(f'  Peak Time (tp): {tp:.3f} s')
        print(f'  Percent Overshoot: {PO:.1f}%')
        print(f'  Settling Time (2%): {ts:.3f} s')
        print(f'  Rise Time (0-100%): {tr:.3f} s')
        print(f'  Damped Frequency (ωd): {wd:.3f} rad/s')
    
    plt.tight_layout()
    plt.show()


def interactive_second_order():
    """Create interactive widget for second-order system."""
    K_slider = widgets.FloatSlider(value=1.0, min=0.1, max=5.0, step=0.1,
        description='Gain (K):', style={'description_width': 'initial'}, continuous_update=False)
    wn_slider = widgets.FloatSlider(value=4.0, min=0.5, max=10.0, step=0.5,
        description='Natural Freq (ωₙ):', style={'description_width': 'initial'}, continuous_update=False)
    zeta_slider = widgets.FloatSlider(value=0.3, min=0.0, max=2.0, step=0.05,
        description='Damping Ratio (ζ):', style={'description_width': 'initial'}, continuous_update=False)
    
    ui = widgets.VBox([
        widgets.HTML('<h3>Second-Order System: G(s) = Kωₙ² / (s² + 2ζωₙs + ωₙ²)</h3>'),
        K_slider, wn_slider, zeta_slider
    ])
    
    out = widgets.interactive_output(plot_second_order, {'K': K_slider, 'wn': wn_slider, 'zeta': zeta_slider})
    display(ui, out)


if __name__ == '__main__':
    plot_second_order()
