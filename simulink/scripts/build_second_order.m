% build_second_order.m
% Build and simulate a second-order system in Simulink
% Tutorial: Second-Order System Response
%
% System: G(s) = K*wn^2 / (s^2 + 2*zeta*wn*s + wn^2)
% Key parameters:
%   - wn: Natural frequency (rad/s)
%   - zeta: Damping ratio
%   - K: DC gain
%
% Response characteristics based on zeta:
%   - zeta > 1: Overdamped (two real poles)
%   - zeta = 1: Critically damped (repeated real poles)
%   - 0 < zeta < 1: Underdamped (complex conjugate poles)
%   - zeta = 0: Undamped (pure oscillation)
%   - zeta < 0: Unstable
%
% Performance metrics (for 0 < zeta < 1):
%   - Peak time: tp = pi / (wn*sqrt(1-zeta^2))
%   - Percent overshoot: PO = 100*exp(-zeta*pi/sqrt(1-zeta^2))
%   - Settling time (2%%): ts = 4 / (zeta*wn)
%   - Rise time (10-90%%): tr approx 1.8/wn for zeta=0.5

function build_second_order()
    % Parameters
    K = 1;          % DC gain
    wn = 4;         % Natural frequency (rad/s)
    zeta = 0.3;     % Damping ratio
    sim_time = 8;   % Simulation time (seconds)
    
    model_name = 'second_order_system';
    
    % Create new model
    if bdIsLoaded(model_name)
        close_system(model_name, 0);
    end
    new_system(model_name);
    open_system(model_name);
    
    % Set model parameters
    set_param(model_name, ...
        'StopTime', num2str(sim_time), ...
        'Solver', 'ode45', ...
        'SolverType', 'Variable-step', ...
        'MaxStep', '0.01');
    
    % Add blocks
    % Step input
    add_block('simulink/Sources/Step', [model_name '/Step Input'], ...
        'Time', '0', 'Before', '0', 'After', '1', 'SampleTime', '0');
    
    % Transfer function: K*wn^2 / (s^2 + 2*zeta*wn*s + wn^2)
    num = sprintf('%g', K*wn^2);
    den = sprintf('[1 %g %g]', 2*zeta*wn, wn^2);
    add_block('simulink/Continuous/Transfer Fcn', [model_name '/Second-Order System'], ...
        'Numerator', num, 'Denominator', den);
    
    % Scope
    add_block('simulink/Sinks/Scope', [model_name '/Scope'], ...
        'NumInputPorts', '2', 'TimeRange', 'auto', 'YMin', '-0.5', 'YMax', '2');
    
    % To Workspace
    add_block('simulink/Sinks/To Workspace', [model_name '/To Workspace'], ...
        'VariableName', 'yout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Clock
    add_block('simulink/Sources/Clock', [model_name '/Clock']);
    add_block('simulink/Sinks/To Workspace', [model_name '/Time'], ...
        'VariableName', 'tout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Position blocks
    set_param([model_name '/Step Input'], 'Position', [50, 80, 110, 120]);
    set_param([model_name '/Second-Order System'], 'Position', [180, 70, 320, 130]);
    set_param([model_name '/Scope'], 'Position', [380, 50, 440, 150]);
    set_param([model_name '/To Workspace'], 'Position', [380, 160, 440, 200]);
    set_param([model_name '/Clock'], 'Position', [50, 160, 110, 200]);
    set_param([model_name '/Time'], 'Position', [180, 160, 240, 200]);
    
    % Connect blocks
    add_line(model_name, 'Step Input/1', 'Second-Order System/1');
    add_line(model_name, 'Second-Order System/1', 'Scope/1');
    add_line(model_name, 'Second-Order System/1', 'To Workspace/1');
    add_line(model_name, 'Clock/1', 'Time/1');
    
    % Save model
    save_system(model_name, fullfile('models', model_name));
    
    % Run simulation
    fprintf('Running simulation for %s...
', model_name);
    simOut = sim(model_name);
    
    % Extract results
    t = simOut.get('tout').Values.Data;
    y = simOut.get('yout').Values.Data;
    
    % Calculate theoretical metrics
    if zeta < 1 && zeta > 0
        wd = wn*sqrt(1-zeta^2);
        tp = pi/wd;
        PO = 100*exp(-zeta*pi/sqrt(1-zeta^2));
        ts = 4/(zeta*wn);
        tr = (pi - atan(sqrt(1-zeta^2)/zeta))/wd; % 0-100% rise time
    else
        tp = NaN; PO = NaN; ts = NaN; tr = NaN;
    end
    
    % Plot
    figure('Name', 'Second-Order System Step Response', 'NumberTitle', 'off');
    plot(t, y, 'b-', 'LineWidth', 2); hold on;
    plot([0, sim_time], [K, K], 'k--', 'LineWidth', 1);
    if ~isnan(PO)
        y_peak = K*(1 + PO/100);
        plot(tp, y_peak, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
        plot([tp, tp], [0, y_peak], 'r:', 'LineWidth', 1.5);
    end
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('Second-Order System: K=%.1f, \\omega_n=%.1f rad/s, \\zeta=%.2f', K, wn, zeta));
    legend('Response', 'Steady-state', 'Peak', 'Location', 'southeast');
    grid on;
    
    % Print key metrics
    fprintf('
Second-Order System Characteristics:
');
    fprintf('  DC Gain (K): %.2f
', K);
    fprintf('  Natural Frequency (wn): %.2f rad/s
', wn);
    fprintf('  Damping Ratio (zeta): %.2f
', zeta);
    
    % Pole locations
    poles = roots([1, 2*zeta*wn, wn^2]);
    fprintf('  Poles: ');
    for i = 1:length(poles)
        fprintf('%.3f%+.3fi ', real(poles(i)), imag(poles(i)));
    end
    fprintf('
');
    
    if zeta > 1
        fprintf('  System: OVERDAMPED (two real poles)
');
    elseif zeta == 1
        fprintf('  System: CRITICALLY DAMPED (repeated real poles)
');
    elseif zeta > 0
        fprintf('  System: UNDERDAMPED (complex conjugate poles)
');
        fprintf('  Peak Time (tp): %.3f s
', tp);
        fprintf('  Percent Overshoot (%%OS): %.1f%%
', PO);
        fprintf('  Settling Time (2%%): %.3f s
', ts);
        fprintf('  Rise Time (0-100%%): %.3f s
', tr);
        fprintf('  Damped Frequency (wd): %.3f rad/s
', wd);
    elseif zeta == 0
        fprintf('  System: UNDAMPED (pure oscillation)
');
    else
        fprintf('  System: UNSTABLE (zeta < 0)
');
    end
    
    close_system(model_name, 0);
    fprintf('
Model saved to models/%s.slx
', model_name);
end

% Run if called directly
if ~exist('build_second_order', 'file') || strcmp(inputname(1), '')
    build_second_order();
end
