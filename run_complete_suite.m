% =====================================================================
% run_complete_suite.m
% Complete reproduction and validation suite for Carrella QZS project.
% Runs both the paper figures (3-12) and the new experiment benchmarks.
% =====================================================================
clear; clc; close all;

% Use a robust graphics toolkit selection for headless rendering (prefer qt over fltk/gnuplot)
if exist('OCTAVE_VERSION', 'builtin')
    available_toolkits = graphics_toolkit();
    if any(strcmp(available_toolkits, 'qt'))
        graphics_toolkit('qt');
    elseif any(strcmp(available_toolkits, 'fltk'))
        graphics_toolkit('fltk');
    else
        graphics_toolkit('gnuplot');
    end
end

fprintf('=== Starting Complete Carrella QZS Figure Suite ===\n');

% Create results directory
if ~exist('results', 'dir'); mkdir('results'); end

% 1. Paper Figures (Carrella 2007)
fprintf('\n--- Generating Paper Figures 1-12 ---\n');
run('qzs_fig1_layout.m'); close all;
run('qzs_fig2_vector.m'); close all;
run('qzs_fig3_oblique_force.m'); close all;
run('qzs_fig4_full_system_force.m'); close all;
run('qzs_fig5_stiffness.m'); close all;
run('qzs_fig6_qzs_combinations.m'); close all;
run('qzs_fig7_qzs_stiffness.m'); close all;
run('qzs_fig8_excursion.m'); close all;
run('qzs_fig9_max_excursion.m'); close all;
run('qzs_fig10_taylor_force.m'); close all;
run('qzs_fig11_taylor_stiffness.m'); close all;
run('qzs_fig12_approx_error.m'); close all;

% 2. Engineering Experiments (Novelty Benchmarks)
fprintf('\n--- Generating Engineering Benchmark Figures ---\n');
run('qzs_experiment3_scaling.m'); close all;
run('qzs_experiment4_transmissibility.m'); close all;
run('qzs_experiment5_seismic.m'); close all;
run('qzs_experiment6_vc_mapping.m'); close all;
run('qzs_experiment7_time_history.m'); close all;
run('qzs_experiment8_belleville.m'); close all;
run('qzs_experiment9_robustness.m'); close all;
run('qzs_experiment11_damping.m'); close all;
run('qzs_experiment12_failure_random.m'); close all;
run('qzs_live_animation.m'); close all;

fprintf('\n=== Full Suite Execution Complete ===\n');
fprintf('All high-resolution figures saved to results/ folder.\n');
