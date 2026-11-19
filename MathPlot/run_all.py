"""
MathPlot - Python Control Systems Tutorial Suite
=================================================
Run all tutorials with interactive sliders.

Usage:
    python run_all.py          # Static plots
    jupyter notebook           # For interactive sliders
"""

import sys
import subprocess


def run_static():
    """Run all tutorials with default parameters (static plots)."""
    print('=' * 60)
    print('MathPlot - Control Systems Tutorial Suite (Static)')
    print('=' * 60)
    
    # Import and run each tutorial
    from first_order import plot_first_order
    from second_order import plot_second_order
    from pid_control import plot_pid
    from root_locus import plot_root_locus
    from frequency_response import plot_bode
    
    print('\n[1/5] First-Order System')
    plot_first_order()
    
    print('\n[2/5] Second-Order System')
    plot_second_order()
    
    print('\n[3/5] PID Control')
    plot_pid()
    
    print('\n[4/5] Root Locus')
    plot_root_locus()
    
    print('\n[5/5] Frequency Response')
    plot_bode()
    
    print('\n' + '=' * 60)
    print('All tutorials completed!')
    print('For interactive sliders, run: jupyter notebook')
    print('Then open any .py file and run the interactive_*() function')
    print('=' * 60)


def install_requirements():
    """Install required packages."""
    try:
        import control
        import ipywidgets
        print('All packages already installed.')
    except ImportError:
        print('Installing requirements...')
        subprocess.run([sys.executable, '-m', 'pip', 'install', '-r', 'requirements.txt'])
        print('Done!')


def main():
    if len(sys.argv) > 1 and sys.argv[1] == '--install':
        install_requirements()
    else:
        run_static()


if __name__ == '__main__':
    main()
