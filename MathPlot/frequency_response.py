"""
Frequency Response Interactive Tutorial
=======================================
Plant: G(s) = 10 / (s*(s+2)*(s+5))
With PID Controller: C(s) = Kp + Ki/s + Kd*s

Interactive sliders for:
- Kp: 0 - 30
- Ki: 0 - 20
- Kd: 0 - 5
"""

import numpy as np
import matplotlib.pyplot as plt
import control as ctrl
import ipywidgets as widgets
from IPython.display import display


def plot_bode(Kp=15, Ki=8, Kd=2):
    """Plot Bode, Nyquist for PID-controlled system."""
    # Plant
    G = ctrl.TransferFunction([10], [1, 7, 10, 0])
    # PID Controller
    C = ctrl.TransferFunction([Kd, Kp, Ki], [1, 0])
    
    # Open-loop
    L = C * G
    # Closed-loop
    T = ctrl.feedback(L, 1)
    
    # Margins
    gm, pm, wg, wp = ctrl.margin(L)
    bw = ctrl.bandwidth(T)
    
    # Frequency vector
    omega = np.logspace(-2, 2, 1000)
    
    # Open-loop frequency response
    mag_ol, phase_ol, _ = ctrl.frequency_response(L, omega)
    mag_ol_db = 20 * np.log10(mag_ol)
    phase_ol_deg = np.degrees(phase_ol)
    
    # Closed-loop frequency response
    mag_cl, phase_cl, _ = ctrl.frequency_response(T, omega)
    mag_cl_db = 20 * np.log10(mag_cl)
    
    fig = plt.figure(figsize=(14, 10))
    
    # Bode - Open-loop magnitude
    ax1 = plt.subplot(2, 2, 1)
    ax1.semilogx(omega, mag_ol_db, 'b-', linewidth=1.5)
    ax1.axhline(y=0, color='k', linestyle=':', alpha=0.5)
    if wg > 0:
        ax1.axvline(x=wg, color='r', linestyle='--', alpha=0.7, label=f'ω_gc = {wg:.2f}')
    title1 = f'Open-Loop Bode: Kp={Kp}, Ki={Ki}, Kd={Kd}'
    title1 += f'\nGM={20*np.log10(gm):.1f}dB, PM={pm:.1f}°'
    ax1.set_ylabel('Magnitude (dB)', fontsize=11)
    ax1.set_title(title1, fontsize=11)
    ax1.grid(True, which='both', alpha=0.3)
    ax1.legend(fontsize=9)
    
    # Bode - Open-loop phase
    ax2 = plt.subplot(2, 2, 2)
    ax2.semilogx(omega, phase_ol_deg, 'b-', linewidth=1.5)
    ax2.axhline(y=-180, color='k', linestyle=':', alpha=0.5)
    if wp > 0:
        ax2.axvline(x=wp, color='r', linestyle='--', alpha=0.7, label=f'ω_pc = {wp:.2f}')
    ax2.set_ylabel('Phase (deg)', fontsize=11)
    ax2.set_xlabel('Frequency (rad/s)', fontsize=11)
    ax2.grid(True, which='both', alpha=0.3)
    ax2.legend(fontsize=9)
    
    # Bode - Closed-loop
    ax3 = plt.subplot(2, 2, 3)
    ax3.semilogx(omega, mag_cl_db, 'g-', linewidth=1.5)
    ax3.axhline(y=-3, color='r', linestyle=':', alpha=0.7, label='-3 dB')
    if bw > 0:
        ax3.axvline(x=bw, color='r', linestyle='--', alpha=0.7, label=f'BW = {bw:.2f}')
    title3 = f'Closed-Loop Bode: BW = {bw:.2f} rad/s'
    ax3.set_ylabel('Magnitude (dB)', fontsize=11)
    ax3.set_xlabel('Frequency (rad/s)', fontsize=11)
    ax3.set_title(title3, fontsize=11)
    ax3.grid(True, which='both', alpha=0.3)
    ax3.legend(fontsize=9)
    
    # Nyquist
    ax4 = plt.subplot(2, 2, 4)
    # Use a wider frequency range for Nyquist
    omega_nyq = np.logspace(-3, 3, 2000)
    real, imag, _ = ctrl.frequency_response(L, omega_nyq)
    ax4.plot(real, imag, 'b-', linewidth=1.5)
    ax4.plot(real, -imag, 'b-', linewidth=1.5)
    ax4.plot(-1, 0, 'rx', markersize=12, markeredgewidth=3, label='-1 point')
    ax4.axhline(y=0, color='k', linewidth=0.5)
    ax4.axvline(x=0, color='k', linewidth=0.5)
    ax4.set_xlabel('Real', fontsize=11)
    ax4.set_ylabel('Imaginary', fontsize=11)
    ax4.set_title('Nyquist Plot', fontsize=11)
    ax4.grid(True, alpha=0.3)
    ax4.legend(fontsize=9)
    ax4.set_aspect('equal', adjustable='box')
    ax4.set_xlim(-2, 1)
    ax4.set_ylim(-1.5, 1.5)
    
    # Resonant peak
    Mp = np.max(mag_cl)
    wp_idx = np.argmax(mag_cl)
    wpr = omega[wp_idx]
    
    print(f'\nFrequency Response Analysis:')
    print(f'  Plant: G(s) = 10/(s(s+2)(s+5))')
    print(f'  PID: Kp={Kp}, Ki={Ki}, Kd={Kd}')
    print(f'\n  OPEN-LOOP MARGINS:')
    print(f'    Gain Margin: {20*np.log10(gm):.2f} dB ({gm:.2f}x)')
    print(f'    Phase Margin: {pm:.2f}°')
    print(f'    Gain Crossover (ω_gc): {wg:.3f} rad/s')
    print(f'    Phase Crossover (ω_pc): {wp:.3f} rad/s')
    print(f'\n  CLOSED-LOOP:')
    print(f'    Bandwidth: {bw:.3f} rad/s')
    print(f'    DC Gain: {ctrl.dcgain(T):.3f}')
    print(f'    Resonant Peak (Mp): {Mp:.3f} ({20*np.log10(Mp):.1f} dB) at {wpr:.3f} rad/s')
    
    plt.tight_layout()
    plt.show()


def interactive_bode():
    """Create interactive widget for frequency response."""
    Kp_slider = widgets.FloatSlider(value=15, min=0, max=30, step=1,
        description='Kp:', style={'description_width': 'initial'}, continuous_update=False)
    Ki_slider = widgets.FloatSlider(value=8, min=0, max=20, step=1,
        description='Ki:', style={'description_width': 'initial'}, continuous_update=False)
    Kd_slider = widgets.FloatSlider(value=2, min=0, max=5, step=0.5,
        description='Kd:', style={'description_width': 'initial'}, continuous_update=False)
    
    ui = widgets.VBox([
        widgets.HTML('<h3>Frequency Response: G(s) = 10/(s(s+2)(s+5)) with PID</h3>'),
        widgets.HTML('<i>C(s) = Kp + Ki/s + Kd·s</i>'),
        Kp_slider, Ki_slider, Kd_slider
    ])
    
    out = widgets.interactive_output(plot_bode, {'Kp': Kp_slider, 'Ki': Ki_slider, 'Kd': Kd_slider})
    display(ui, out)


if __name__ == '__main__':
    plot_bode()
