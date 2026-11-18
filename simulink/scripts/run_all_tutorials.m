% run_all_tutorials.m
% Master script to run all Simulink control tutorials
% This script builds all models, runs simulations, and generates plots

function run_all_tutorials()
    fprintf('============================================================\n');
    fprintf('SIMULINK BASIC CONTROL TUTORIAL - RUNNING ALL MODULES\n');
    fprintf('============================================================\n\n');
    
    % Ensure we're in the right directory
    script_dir = fileparts(mfilename('fullpath'));
    cd(script_dir);
    
    % Add models directory to path
    addpath(fullfile(script_dir, 'models'));
    
    try
        % Tutorial 1: First-Order Systems
        fprintf('\n[1/5] First-Order System Response\n');
        fprintf('----------------------------------------\n');
        build_first_order();
        
        % Tutorial 2: Second-Order Systems
        fprintf('\n[2/5] Second-Order System Response\n');
        fprintf('----------------------------------------\n');
        build_second_order();
        
        % Tutorial 3: PID Control
        fprintf('\n[3/5] PID Controller Design\n');
        fprintf('----------------------------------------\n');
        build_pid_control();
        
        % Tutorial 4: Root Locus Analysis
        fprintf('\n[4/5] Root Locus Analysis\n');
        fprintf('----------------------------------------\n');
        build_root_locus();
        
        % Tutorial 5: Frequency Response
        fprintf('\n[5/5] Frequency Response Analysis\n');
        fprintf('----------------------------------------\n');
        build_bode_plot();
        
        fprintf('\n============================================================\n');
        fprintf('ALL TUTORIALS COMPLETED SUCCESSFULLY!\n');
        fprintf('============================================================\n');
        fprintf('\nGenerated files in simulink/models/:\n');
        fprintf('  - first_order_system.slx\n');
        fprintf('  - second_order_system.slx\n');
        fprintf('  - pid_control.slx\n');
        fprintf('  - root_locus_analysis.slx\n');
        fprintf('  - frequency_response.slx\n');
        fprintf('\nOpen any model with: open_system(''model_name'')\n');
        fprintf('Or run individual scripts from simulink/scripts/\n');
        
    catch ME
        fprintf('\nERROR: %s\n', ME.message);
        fprintf('Stack trace:\n%s\n', ME.stack);
    end
end

% Run if called directly
if ~exist('run_all_tutorials', 'file') || strcmp(inputname(1), '')
    run_all_tutorials();
end
