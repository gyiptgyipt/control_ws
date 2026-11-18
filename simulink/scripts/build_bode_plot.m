% build_bode_plot.m
% Build frequency response analysis model in Simulink
% Tutorial: Frequency Response Analysis (Bode Plots)
%
% Frequency response shows system behavior to sinusoidal inputs
% Key concepts:
%   - Bode plot: Magnitude (dB) and Phase (deg) vs Frequency (log scale)
%   - Gain margin: How much gain can increase before instability
%   - Phase margin: How much phase lag can be added before instability
%   - Bandwidth: Frequency where magnitude drops -3dB
%   - Resonant peak: Maximum magnitude (indicates damping)
%   - Crossover frequencies: wcg (gain=0dB), wcp (phase=-180deg)
%
% Plant: G(s) = 10 / (s*(s+2)*(s+5))
% With PID controller for demonstration

function build_bode_plot()
    % Plant parameters
    % G(s) = 10 / (s*(s+2)*(s+5))  (Type 1, DC gain = inf for step)
    plant_num = [10];
    plant_den = [1, 7, 10, 0];
    
    % PID Controller for closed-loop demo
    Kp = 15; Ki = 8; Kd = 2;
    
    model_name = 'frequency_response';
    
    % Create new model
    if bdIsLoaded(model_name)
        close_system(model_name, 0);
    end
    new_system(model_name);
    open_system(model_name);
    
    % Set model parameters
    set_param(model_name, ...
        'StopTime', '30', ...
        'Solver', 'ode45', ...
        'SolverType', 'Variable-step', ...
        'MaxStep', '0.01');
    
    % Add blocks for sine sweep simulation
    % Sine Wave source (for frequency sweep, we'll use multiple simulations)
    add_block('simulink/Sources/Sine Wave', [model_name '/Sine Input'], ...
        'Amplitude', '1', 'Bias', '0', 'Frequency', '1', 'Phase', '0', 'SampleTime', '0');
    
    % Sum block
    add_block('simulink/Math Operations/Sum', [model_name '/Error Sum'], ...
        'Inputs', '|+-', 'IconShape', 'round');
    
    % PID Controller
    add_block('simulink/Continuous/PID Controller', [model_name '/PID Controller'], ...
        'P', num2str(Kp), 'I', num2str(Ki), 'D', num2str(Kd), ...
        'N', '100');
    
    % Plant
    add_block('simulink/Continuous/Transfer Fcn', [model_name '/Plant'], ...
        'Numerator', '[10]', 'Denominator', '[1 7 10 0]');
    
    % Scope
    add_block('simulink/Sinks/Scope', [model_name '/Scope'], ...
        'NumInputPorts', '2', 'TimeRange', 'auto', 'YMin', '-2', 'YMax', '2');
    
    % To Workspace
    add_block('simulink/Sinks/To Workspace', [model_name '/Output'], ...
        'VariableName', 'yout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    add_block('simulink/Sinks/To Workspace', [model_name '/Input'], ...
        'VariableName', 'uin', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Clock
    add_block('simulink/Sources/Clock', [model_name '/Clock']);
    add_block('simulink/Sinks/To Workspace', [model_name '/Time'], ...
        'VariableName', 'tout', 'SaveFormat', 'Array', 'SampleTime', '-1');
    
    % Position blocks
    set_param([model_name '/Sine Input'], 'Position', [30, 80, 110, 120]);
    set_param([model_name '/Error Sum'], 'Position', [180, 70, 220, 130]);
    set_param([model_name '/PID Controller'], 'Position', [280, 60, 400, 140]);
    set_param([model_name '/Plant'], 'Position', [460, 70, 540, 130]);
    set_param([model_name '/Scope'], 'Position', [600, 40, 660, 160]);
    set_param([model_name '/Output'], 'Position', [600, 170, 660, 210]);
    set_param([model_name '/Input'], 'Position', [600, 220, 660, 260]);
    set_param([model_name '/Clock'], 'Position', [30, 160, 90, 200]);
    set_param([model_name '/Time'], 'Position', [180, 160, 240, 200]);
    
    % Connect blocks
    add_line(model_name, 'Sine Input/1', 'Error Sum/1');
    add_line(model_name, 'Plant/1', 'Error Sum/2');
    add_line(model_name, 'Error Sum/1', 'PID Controller/1');
    add_line(model_name, 'PID Controller/1', 'Plant/1');
    add_line(model_name, 'Plant/1', 'Scope/1');
    add_line(model_name, 'Sine Input/1', 'Scope/2');
    add_line(model_name, 'Plant/1', 'Output/1');
    add_line(model_name, 'Sine Input/1', 'Input/1');
    add_line(model_name, 'Clock/1', 'Time/1');
    
    % Save model
    save_system(model_name, fullfile('models', model_name));
    
    % ============================================================
    % FREQUENCY RESPONSE ANALYSIS (MATLAB)
    % ============================================================
    fprintf('Performing Frequency Response Analysis...

');
    
    % Create transfer functions
    s = tf('s');
    G = 10/(s*(s+2)*(s+5));
    C = pid(Kp, Ki, Kd);
    
    % Open-loop transfer function
    L = C*G;
    
    % Closed-loop transfer function
    T = feedback(L, 1);
    
    % Bode plot of open-loop
    figure('Name', 'Open-Loop Bode Plot', 'NumberTitle', 'off');
    bode(L);
    grid on;
    title('Open-Loop Bode: L(s) = C(s)G(s)');
    
    % Gain and phase margins
    [Gm, Pm, Wcg, Wcp] = margin(L);
    
    % Bode plot of closed-loop
    figure('Name', 'Closed-Loop Bode Plot', 'NumberTitle', 'off');
    bode(T);
    grid on;
    title('Closed-Loop Bode: T(s) = L(s)/(1+L(s))');
    
    % Bandwidth
    bw = bandwidth(T);
    
    % DC gain
    dc_gain = dcgain(T);
    
    % Resonant peak
    [mag, w] = bode(T, logspace(-2, 2, 1000));
    mag = squeeze(mag);
    [Mp, idx] = max(mag);
    wp = w(idx);
    
    fprintf('Frequency Response Analysis Results:
');
    fprintf('  Plant: G(s) = 10/(s(s+2)(s+5))
');
    fprintf('  Controller: PID (Kp=%.1f, Ki=%.1f, Kd=%.1f)
', Kp, Ki, Kd);
    fprintf('
');
    fprintf('  OPEN-LOOP MARGINS:
');
    fprintf('    Gain Margin: %.2f dB (%.2f x)
', 20*log10(Gm), Gm);
    fprintf('    Phase Margin: %.2f deg
', Pm);
    fprintf('    Gain Crossover (wcg): %.3f rad/s
', Wcg);
    fprintf('    Phase Crossover (wcp): %.3f rad/s
', Wcp);
    fprintf('
');
    fprintf('  CLOSED-LOOP CHARACTERISTICS:
');
    fprintf('    Bandwidth: %.3f rad/s
', bw);
    fprintf('    DC Gain: %.3f
', dc_gain);
    fprintf('    Resonant Peak (Mp): %.3f (%.2f dB) at %.3f rad/s
', Mp, 20*log10(Mp), wp);
    
    % Nyquist plot
    figure('Name', 'Nyquist Plot', 'NumberTitle', 'off');
    nyquist(L);
    grid on;
    title('Nyquist Plot of Open-Loop L(s)');
    
    % Nichols chart
    figure('Name', 'Nichols Chart', 'NumberTitle', 'off');
    nichols(L);
    grid on;
    title('Nichols Chart of Open-Loop L(s)');
    
    % Simulate sinusoidal response at key frequencies
    fprintf('
Sinusoidal steady-state response at key frequencies:
');
    test_freqs = [0.1, 1, Wcg, 10, 100];
    for w = test_freqs
        % Simulate for 20 seconds at this frequency
        set_param([model_name '/Sine Input'], 'Frequency', num2str(w));
        set_param(model_name, 'StopTime', num2str(max(20, 10*2*pi/w)));
        simOut = sim(model_name);
        
        t = simOut.get('tout').Values.Data;
        y = simOut.get('yout').Values.Data;
        u = simOut.get('uin').Values.Data;
        
        % Use last few cycles for steady-state
        idx = t > (t(end) - 4*2*pi/w);
        if any(idx)
            y_ss = y(idx);
            u_ss = u(idx);
            mag_ratio = (max(y_ss)-min(y_ss))/(max(u_ss)-min(u_ss))/2;
            % Phase estimation (simplified)
            fprintf('  w=%.2f rad/s: |G|=%.3f (%.2f dB)
', w, mag_ratio, 20*log10(mag_ratio));
        end
    end
    
    close_system(model_name, 0);
    fprintf('
Model saved to models/%s.slx
', model_name);
    fprintf('Use bode(), margin(), bandwidth() in MATLAB for analysis
');
end

% Run if called directly
if ~exist('build_bode_plot', 'file') || strcmp(inputname(1), '')
    build_bode_plot();
end
