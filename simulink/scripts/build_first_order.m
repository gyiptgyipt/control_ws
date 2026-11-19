function build_first_order()
% build_first_order.m
% Build and simulate a first-order system in Simulink
% Tutorial: First-Order System Response
%
% System: G(s) = K / (tau*s + 1)
% Step response characteristics:
%   - Time constant (tau): time to reach 63.2% of final value
%   - Steady-state value: K * step_amplitude
%   - Settling time (2%): ~4*tau

    % Parameters
    K = 2;          % System gain
    tau = 1.5;      % Time constant (seconds)
    step_amplitude = 1;
    sim_time = 10;  % Simulation time (seconds)
    
    model_name = 'first_order_system';
    
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
        'Time', '0', 'Before', '0', 'After', num2str(step_amplitude), 'SampleTime', '0');
    
    % Transfer function: K/(tau*s + 1)
    add_block('simulink/Continuous/Transfer Fcn', [model_name '/First-Order System'], ...
        'Numerator', num2str(K), 'Denominator', sprintf('[%g %g]', tau, 1));
    
    % Scope for visualization
    add_block('simulink/Sinks/Scope', [model_name '/Scope'], ...
        'NumInputPorts', '2', 'TimeRange', 'auto', 'YMin', '-0.5', 'YMax', '3');
    
    % To Workspace for data logging
    add_block('simulink/Sinks/To Workspace', [model_name '/To Workspace'], ...
        'VariableName', 'yout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Clock for time vector
    add_block('simulink/Sources/Clock', [model_name '/Clock']);
    add_block('simulink/Sinks/To Workspace', [model_name '/Time'], ...
        'VariableName', 'tout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Sum block for reference (optional - for closed-loop later)
    add_block('simulink/Math Operations/Sum', [model_name '/Sum'], ...
        'Inputs', '|+', 'IconShape', 'round');
    
    % Position blocks
    set_param([model_name '/Step Input'], 'Position', [50, 80, 110, 120]);
    set_param([model_name '/Sum'], 'Position', [180, 70, 220, 130]);
    set_param([model_name '/First-Order System'], 'Position', [280, 70, 400, 130]);
    set_param([model_name '/Scope'], 'Position', [450, 50, 510, 150]);
    set_param([model_name '/To Workspace'], 'Position', [450, 160, 510, 200]);
    set_param([model_name '/Clock'], 'Position', [50, 160, 110, 200]);
    set_param([model_name '/Time'], 'Position', [180, 160, 240, 200]);
    
    % Connect blocks
    add_line(model_name, 'Step Input/1', 'Sum/1');
    add_line(model_name, 'Sum/1', 'First-Order System/1');
    add_line(model_name, 'First-Order System/1', 'Scope/1');
    add_line(model_name, 'First-Order System/1', 'To Workspace/1');
    add_line(model_name, 'Clock/1', 'Time/1');
    
    % Save model
    save_system(model_name, fullfile('models', model_name));
    
    % Run simulation
    fprintf('Running simulation for %s...\n', model_name);
    simOut = sim(model_name);
    
    % Extract and plot results
    t = simOut.get('tout').Values.Data;
    y = simOut.get('yout').Values.Data;
    
    figure('Name', 'First-Order System Step Response', 'NumberTitle', 'off');
    plot(t, y, 'b-', 'LineWidth', 2); hold on;
    plot([0, sim_time], [K*step_amplitude, K*step_amplitude], 'k--', 'LineWidth', 1);
    plot([tau, tau], [0, K*step_amplitude*0.632], 'r:', 'LineWidth', 1.5);
    plot(tau, K*step_amplitude*0.632, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
    xlabel('Time (s)'); ylabel('Amplitude');
    title(sprintf('First-Order System: K=%.1f, \\tau=%.1f s', K, tau));
    legend('Response', 'Steady-state', sprintf('\\tau = %.1f s (63.2%%)', tau), 'Location', 'southeast');
    grid on;
    
    % Print key metrics
    fprintf('\nFirst-Order System Characteristics:\n');
    fprintf('  Gain (K): %.2f\n', K);
    fprintf('  Time Constant (tau): %.2f s\n', tau);
    fprintf('  Steady-state value: %.2f\n', K*step_amplitude);
    fprintf('  63.2%% rise time: %.2f s\n', tau);
    fprintf('  Settling time (2%%): %.2f s\n', 4*tau);
    fprintf('  Settling time (5%%): %.2f s\n', 3*tau);
    
    close_system(model_name, 0);
    fprintf('\nModel saved to models/%s.slx\n', model_name);
end
