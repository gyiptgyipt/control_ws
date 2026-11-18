% build_pid_control.m
% Build and simulate PID control system in Simulink
% Tutorial: PID Controller Design
%
% Plant: G(s) = 1 / (s*(s+2)*(s+5))  (Type 1 system)
% Controller: PID with tunable parameters
%
% PID Controller: C(s) = Kp + Ki/s + Kd*s
%   - Kp: Proportional gain (reduces rise time, increases overshoot)
%   - Ki: Integral gain (eliminates steady-state error, may cause oscillation)
%   - Kd: Derivative gain (reduces overshoot, improves stability)
%
% Tuning methods demonstrated:
%   1. Manual tuning
%   2. Ziegler-Nichols (step response method)
%   3. Ziegler-Nichols (ultimate gain method)
%   4. PID Tuner (Simulink Control Design)

function build_pid_control()
    % Plant parameters
    % G(s) = 1 / (s*(s+2)*(s+5)) = 1 / (s^3 + 7s^2 + 10s)
    plant_num = [1];
    plant_den = [1, 7, 10, 0];
    
    % PID gains (initial manual tune)
    Kp = 15;
    Ki = 8;
    Kd = 2;
    
    sim_time = 10;
    model_name = 'pid_control';
    
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
    % Step reference
    add_block('simulink/Sources/Step', [model_name '/Reference'], ...
        'Time', '0', 'Before', '0', 'After', '1', 'SampleTime', '0');
    
    % Sum block (error = reference - feedback)
    add_block('simulink/Math Operations/Sum', [model_name '/Error Sum'], ...
        'Inputs', '|+-', 'IconShape', 'round');
    
    % PID Controller
    add_block('simulink/Continuous/PID Controller', [model_name '/PID Controller'], ...
        'P', num2str(Kp), 'I', num2str(Ki), 'D', num2str(Kd), ...
        'N', '100', 'InitialConditionForIntegrator', '0', ...
        'InitialConditionForFilter', '0', 'FilterCoefficient', '100');
    
    % Plant: Transfer Fcn
    add_block('simulink/Continuous/Transfer Fcn', [model_name '/Plant'], ...
        'Numerator', '[1]', 'Denominator', '[1 7 10 0]');
    
    % Scope
    add_block('simulink/Sinks/Scope', [model_name '/Scope'], ...
        'NumInputPorts', '3', 'TimeRange', 'auto', 'YMin', '-0.5', 'YMax', '1.5');
    
    % To Workspace
    add_block('simulink/Sinks/To Workspace', [model_name '/Output'], ...
        'VariableName', 'yout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    add_block('simulink/Sinks/To Workspace', [model_name '/Control'], ...
        'VariableName', 'uout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    add_block('simulink/Sinks/To Workspace', [model_name '/Error'], ...
        'VariableName', 'eout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Clock
    add_block('simulink/Sources/Clock', [model_name '/Clock']);
    add_block('simulink/Sinks/To Workspace', [model_name '/Time'], ...
        'VariableName', 'tout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Position blocks
    set_param([model_name '/Reference'], 'Position', [30, 80, 90, 120]);
    set_param([model_name '/Error Sum'], 'Position', [150, 70, 190, 130]);
    set_param([model_name '/PID Controller'], 'Position', [250, 60, 370, 140]);
    set_param([model_name '/Plant'], 'Position', [430, 70, 510, 130]);
    set_param([model_name '/Scope'], 'Position', [570, 30, 630, 170]);
    set_param([model_name '/Output'], 'Position', [570, 180, 630, 220]);
    set_param([model_name '/Control'], 'Position', [570, 230, 630, 270]);
    set_param([model_name '/Error'], 'Position', [570, 280, 630, 320]);
    set_param([model_name '/Clock'], 'Position', [30, 180, 90, 220]);
    set_param([model_name '/Time'], 'Position', [150, 180, 210, 220]);
    
    % Connect blocks
    add_line(model_name, 'Reference/1', 'Error Sum/1');
    add_line(model_name, 'Plant/1', 'Error Sum/2');
    add_line(model_name, 'Error Sum/1', 'PID Controller/1');
    add_line(model_name, 'PID Controller/1', 'Plant/1');
    add_line(model_name, 'Plant/1', 'Scope/1');
    add_line(model_name, 'Reference/1', 'Scope/2');
    add_line(model_name, 'PID Controller/1', 'Scope/3');
    add_line(model_name, 'Plant/1', 'Output/1');
    add_line(model_name, 'PID Controller/1', 'Control/1');
    add_line(model_name, 'Error Sum/1', 'Error/1');
    add_line(model_name, 'Clock/1', 'Time/1');
    
    % Save model
    save_system(model_name, fullfile('models', model_name));
    
    % Run simulation
    fprintf('Running PID control simulation...
');
    simOut = sim(model_name);
    
    % Extract results
    t = simOut.get('tout').Values.Data;
    y = simOut.get('yout').Values.Data;
    u = simOut.get('uout').Values.Data;
    e = simOut.get('eout').Values.Data;
    
    % Calculate performance metrics
    steady_state = y(end);
    overshoot = max(y) - steady_state;
    percent_overshoot = (overshoot / steady_state) * 100;
    
    % Rise time (10% to 90%)
    idx_10 = find(y >= 0.1*steady_state, 1);
    idx_90 = find(y >= 0.9*steady_state, 1);
    if ~isempty(idx_10) && ~isempty(idx_90)
        rise_time = t(idx_90) - t(idx_10);
    else
        rise_time = NaN;
    end
    
    % Settling time (2%)
    settling_idx = find(abs(y - steady_state) <= 0.02*steady_state, 1, 'last');
    if ~isempty(settling_idx)
        settling_time = t(settling_idx);
    else
        settling_time = NaN;
    end
    
    % Steady-state error
    ss_error = 1 - steady_state;
    
    % Plot results
    figure('Name', 'PID Control Response', 'NumberTitle', 'off');
    
    subplot(2,1,1);
    plot(t, y, 'b-', 'LineWidth', 2); hold on;
    plot(t, ones(size(t)), 'k--', 'LineWidth', 1);
    xlabel('Time (s)'); ylabel('Output');
    title(sprintf('Closed-Loop Response (Kp=%.1f, Ki=%.1f, Kd=%.1f)', Kp, Ki, Kd));
    legend('Output', 'Reference', 'Location', 'southeast');
    grid on;
    
    subplot(2,1,2);
    plot(t, u, 'r-', 'LineWidth', 2); hold on;
    xlabel('Time (s)'); ylabel('Control Effort');
    title('Control Signal');
    grid on;
    
    % Print metrics
    fprintf('
PID Control Performance:
');
    fprintf('  Kp = %.2f, Ki = %.2f, Kd = %.2f
', Kp, Ki, Kd);
    fprintf('  Steady-state value: %.4f
', steady_state);
    fprintf('  Steady-state error: %.4f
', ss_error);
    fprintf('  Percent overshoot: %.2f%%
', percent_overshoot);
    fprintf('  Rise time (10-90%%): %.3f s
', rise_time);
    fprintf('  Settling time (2%%): %.3f s
', settling_time);
    fprintf('  Max control effort: %.3f
', max(abs(u)));
    
    % Ziegler-Nichols tuning suggestions
    fprintf('
Ziegler-Nichols Tuning Rules (for reference):
');
    fprintf('  Step Response Method:
');
    fprintf('    Kp = 1.2*(L/T), Ki = Kp/(2*L), Kd = Kp*0.5*L
');
    fprintf('  Ultimate Gain Method:
');
    fprintf('    Kp = 0.6*Ku, Ki = 1.2*Ku/Tu, Kd = 0.075*Ku*Tu
');
    
    close_system(model_name, 0);
    fprintf('
Model saved to models/%s.slx
', model_name);
    fprintf('Open PID Tuner: double-click PID Controller block -> Tune
');
end

% Run if called directly
if true  % Run when script is executed directly
    build_pid_control();
end
