% build_root_locus.m
% Build root locus analysis model in Simulink
% Tutorial: Root Locus Analysis
%
% Root locus shows how closed-loop poles migrate as gain K varies from 0 to inf
% Key concepts:
%   - Open-loop poles: starting points (K=0)
%   - Open-loop zeros: ending points (K=inf)
%   - Asymptotes: directions for branches going to infinity
%   - Breakaway/break-in points: where loci leave/enter real axis
%   - jw-axis crossing: stability boundary
%   - Angle/Departure angles: from complex poles/zeros
%
% Plant: G(s) = 1 / (s*(s+2)*(s+5))
% Open-loop poles: 0, -2, -5
% Open-loop zeros: none
% Asymptotes: 3 branches, centroid = (0-2-5)/3 = -2.33, angles = 60, 180, 300 deg

function build_root_locus()
    % Plant transfer function
    % G(s) = K / (s*(s+2)*(s+5))  (K is the varying gain)
    num = [1];
    den = [1, 7, 10, 0];  % s*(s+2)*(s+5) = s^3 + 7s^2 + 10s
    
    model_name = 'root_locus_analysis';
    
    % Create new model
    if bdIsLoaded(model_name)
        close_system(model_name, 0);
    end
    new_system(model_name);
    open_system(model_name);
    
    % Set model parameters
    set_param(model_name, ...
        'StopTime', '10', ...
        'Solver', 'ode45', ...
        'SolverType', 'Variable-step', ...
        'MaxStep', '0.01');
    
    % Add blocks for closed-loop simulation with variable gain
    % Step reference
    add_block('simulink/Sources/Step', [model_name '/Reference'], ...
        'Time', '0', 'Before', '0', 'After', '1', 'SampleTime', '0');
    
    % Sum block
    add_block('simulink/Math Operations/Sum', [model_name '/Error Sum'], ...
        'Inputs', '|+-', 'IconShape', 'round');
    
    % Variable Gain (K)
    add_block('simulink/Math Operations/Gain', [model_name '/Variable Gain K'], ...
        'Gain', '1', 'Multiplication', 'Element-wise(K.*u)');
    
    % Plant
    add_block('simulink/Continuous/Transfer Fcn', [model_name '/Plant'], ...
        'Numerator', '[1]', 'Denominator', '[1 7 10 0]');
    
    % Scope
    add_block('simulink/Sinks/Scope', [model_name '/Scope'], ...
        'NumInputPorts', '2', 'TimeRange', 'auto', 'YMin', '-1', 'YMax', '2');
    
    % To Workspace
    add_block('simulink/Sinks/To Workspace', [model_name '/Output'], ...
        'VariableName', 'yout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Clock
    add_block('simulink/Sources/Clock', [model_name '/Clock']);
    add_block('simulink/Sinks/To Workspace', [model_name '/Time'], ...
        'VariableName', 'tout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Position blocks
    set_param([model_name '/Reference'], 'Position', [30, 80, 90, 120]);
    set_param([model_name '/Error Sum'], 'Position', [150, 70, 190, 130]);
    set_param([model_name '/Variable Gain K'], 'Position', [250, 70, 310, 130]);
    set_param([model_name '/Plant'], 'Position', [370, 70, 450, 130]);
    set_param([model_name '/Scope'], 'Position', [510, 50, 570, 150]);
    set_param([model_name '/Output'], 'Position', [510, 160, 570, 200]);
    set_param([model_name '/Clock'], 'Position', [30, 160, 90, 200]);
    set_param([model_name '/Time'], 'Position', [150, 160, 210, 200]);
    
    % Connect blocks
    add_line(model_name, 'Reference/1', 'Error Sum/1');
    add_line(model_name, 'Plant/1', 'Error Sum/2');
    add_line(model_name, 'Error Sum/1', 'Variable Gain K/1');
    add_line(model_name, 'Variable Gain K/1', 'Plant/1');
    add_line(model_name, 'Plant/1', 'Scope/1');
    add_line(model_name, 'Reference/1', 'Scope/2');
    add_line(model_name, 'Plant/1', 'Output/1');
    add_line(model_name, 'Clock/1', 'Time/1');
    
    % Save model
    save_system(model_name, fullfile('models', model_name));
    
    % ============================================================
    % ROOT LOCUS ANALYSIS (MATLAB - not Simulink)
    % ============================================================
    fprintf('Performing Root Locus Analysis...

');
    
    % Create transfer function
    s = tf('s');
    G = 1/(s*(s+2)*(s+5));
    
    % Plot root locus
    figure('Name', 'Root Locus', 'NumberTitle', 'off');
    rlocus(G);
    grid on;
    title('Root Locus: G(s) = 1/(s(s+2)(s+5))');
    
    % Get key points
    % 1. Asymptotes
    n_poles = 3;
    n_zeros = 0;
    centroid = (0 + (-2) + (-5)) / (n_poles - n_zeros);
    asymptote_angles = [60, 180, 300];
    
    % 2. Breakaway point (solve dK/ds = 0 where K = -1/G(s))
    % K = -s(s+2)(s+5) = -(s^3 + 7s^2 + 10s)
    % dK/ds = -(3s^2 + 14s + 10) = 0
    % 3s^2 + 14s + 10 = 0
    breakaway_roots = roots([3, 14, 10]);
    real_breakaway = breakaway_roots(imag(breakaway_roots) == 0);
    
    % 3. jw-axis crossing (Routh-Hurwitz)
    % Characteristic equation: s^3 + 7s^2 + 10s + K = 0
    % Routh array:
    % s^3: 1    10
    % s^2: 7    K
    % s^1: (70-K)/7  0
    % s^0: K
    % For stability: K > 0 and (70-K)/7 > 0 => K < 70
    K_critical = 70;
    % At K=70, auxiliary equation: 7s^2 + 70 = 0 => s = ±j*sqrt(10)
    w_crossing = sqrt(10);
    
    % 4. Angle of departure from complex poles (none in this case)
    
    fprintf('Root Locus Analysis Results:
');
    fprintf('  Open-loop poles: 0, -2, -5
');
    fprintf('  Open-loop zeros: none
');
    fprintf('  Number of branches: %d
', n_poles);
    fprintf('  Asymptote centroid: %.3f
', centroid);
    fprintf('  Asymptote angles: %s deg
', mat2str(asymptote_angles));
    if ~isempty(real_breakaway)
        fprintf('  Breakaway point: s = %.3f
', real_breakaway);
    end
    fprintf('  jw-axis crossing: K = %.1f, w = %.3f rad/s
', K_critical, w_crossing);
    fprintf('  Stable range: 0 < K < %.1f
', K_critical);
    
    % Simulate at different gains
    K_test = [1, 10, 35, 70, 100];
    fprintf('
Closed-loop step responses at different gains:
');
    
    figure('Name', 'Step Responses at Various Gains', 'NumberTitle', 'off');
    for i = 1:length(K_test)
        K = K_test(i);
        sys_cl = feedback(K*G, 1);
        subplot(3, 2, i);
        step(sys_cl, 10);
        grid on;
        title(sprintf('K = %.0f', K));
        
        % Get step info
        info = stepinfo(sys_cl);
        fprintf('  K=%.0f: ts=%.2f, PO=%.1f%%, ess=%.4f
', ...
            K, info.SettlingTime, info.Overshoot, 1-info.SettlingValue);
    end
    
    close_system(model_name, 0);
    fprintf('
Model saved to models/%s.slx
', model_name);
    fprintf('Use rlocus() in MATLAB for interactive analysis
');
end

% Run if called directly
if ~exist('build_root_locus', 'file') || strcmp(inputname(1), '')
    build_root_locus();
end
