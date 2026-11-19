"""
Root Locus Interactive Tutorial
================================
Plant: G(s) = 1 / (s*(s+2)*(s+5))

Interactive slider for:
- K (gain): 0 - 100
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import control as ctrl
import ipywidgets as widgets
from IPython.display import display


def plot_root_locus(K=1):
    """Plot root locus with selected gain."""
    # Plant
    sys = ctrl.TransferFunction([1], [1, 7, 10, 0])  # s(s+2)(s+5)
    
    fig, axes = plt.subplots(1, 2, figsize=(14, 6))
    
    # Root locus
    ax1 = axes[0]
    # Compute root locus
    klist = np.logspace(-2, 2, 500)
    poles_list = []
    for k in klist:
        cl_poles = np.roots([1, 7, 10, k])
        poles_list.append(cl_poles)
    poles_array = np.array(poles_list)
    
    # Plot locus branches
    for i in range(3):
        ax1.plot(poles_array[:, i].real, poles_array[:, i].imag, 'b-', alpha=0.5, linewidth=1)
    
    # Open-loop poles (K=0)
    ol_poles = [0, -2, -5]
    ax1.plot(ol_poles, [0, 0, 0], 'bx', markersize=12, markeredgewidth=2, label='Open-loop poles (K=0)')
    
    # Selected gain closed-loop poles
    cl_poles_k = np.roots([1, 7, 10, K])
    ax1.plot(cl_poles_k.real, cl_poles_k.imag, 'ro', markersize=10, markerfacecolor='r', label=f'Closed-loop poles (K={K})')
    
    # Asymptotes
    centroid = -7/3
    ax1.axvline(x=centroid, color='gray', linestyle='--', alpha=0.5)
    for angle in [60, 180, 300]:
        theta = np.deg2rad(angle)
        x_end = centroid + 10 * np.cos(theta)
        y_end = 10 * np.sin(theta)
        ax1.plot([centroid, x_end], [0, y_end], 'gray', linestyle='--', alpha=0.3)
    
    # jw-axis crossing
    ax1.axhline(y=0, color='k', linewidth=0.5)
    ax1.axvline(x=0, color='k', linewidth=0.5)
    ax1.axvline(x=-np.sqrt(10), color='green', linestyle=':', alpha=0.7, label=f'Stability boundary (K=70)')
    ax1.axvline(x=np.sqrt(10), color='green', linestyle=':', alpha=0.7)
    
    ax1.set_xlabel('Real Axis', fontsize=12)
    ax1.set_ylabel('Imaginary Axis', fontsize=12)
    ax1.set_title(f'Root Locus: G(s) = 1/(s(s+2)(s+5))', fontsize=13)
    ax1.grid(True, alpha=0.3)
    ax1.legend(loc='upper left', fontsize=9)
    ax1.set_xlim(-8, 3)
    ax1.set_ylim(-8, 8)
    ax1.set_aspect('equal', adjustable='box')
    
    # Step responses at different gains
    ax2 = axes[1]
    K_test = [1, 5, 10, 35, 70, 100]
    for k in K_test:
        sys_cl = ctrl.TransferFunction([k], [1, 7, 10, k])
        t = np.linspace(0, 10, 500)
        t, y = ctrl.step_response(sys_cl, t)
        label = f'K={k}'
        if k == K:
            ax2.plot(t, y, linewidth=3, label=label + ' ← selected')
        else:
            ax2.plot(t, y, linewidth=1, alpha=0.6, label=label)
    ax2.axhline(y=1, color='k', linestyle='--', linewidth=0.5)
    ax2.set_xlabel('Time (s)', fontsize=12)
    ax2.set_ylabel('Amplitude', fontsize=12)
    ax2.set_title('Step Responses at Various Gains', fontsize=13)
    ax2.grid(True, alpha=0.3)
    ax2.legend(loc='lower right', fontsize=8)
    ax2.set_xlim(0, 10)
    ax2.set_ylim(-0.5, 2)
    
    # Stability info
    stable = all(p.real < 0 for p in cl_poles_k)
    status = 'STABLE ✓' if stable else 'UNSTABLE ✗'
    
    print(f'\nRoot Locus Analysis (K={K}):')
    print(f'  Open-loop poles: {ol_poles}')
    print(f'  Closed-loop poles:')
    for p in cl_poles_k:
        print(f'    {p.real:.3f} {p.imag:+.3f}j')
    print(f'  System: {status}')
    print(f'  Asymptote centroid: {centroid:.3f}')
    print(f'  Asymptote angles: 60°, 180°, 300°')
    print(f'  jω-axis crossing: K=70 at ω=±{np.sqrt(10):.2f} rad/s')
    print(f'  Stable range: 0 < K < 70')
    
    plt.tight_layout()
    plt.show()


def interactive_root_locus():
    """Create interactive widget for root locus."""
    K_slider = widgets.FloatSlider(value=1, min=0, max=100, step=1,
        description='Gain (K):', style={'description_width': 'initial'}, continuous_update=False)
    
    ui = widgets.VBox([
        widgets.HTML('<h3>Root Locus: G(s) = 1/(s(s+2)(s+5))</h3>'),
        widgets.HTML('<i>Closed-loop: 1 + K·G(s) = 0 → s³ + 7s² + 10s + K = 0</i>'),
        K_slider
    ])
    
    out = widgets.interactive_output(plot_root_locus, {'K': K_slider})
    display(ui, out)


if __name__ == '__main__':
    plot_root_locus()
