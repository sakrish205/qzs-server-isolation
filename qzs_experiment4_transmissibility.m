% =====================================================================
% qzs_experiment4_transmissibility.m
% Experiment 4: Dynamic Transmissibility Analysis (Analytical)
% =====================================================================
clear; clc; close all;
run('qzs_style_header.m');

% 1. System Parameters (Loaded via parameters.m)
% Using target_rack_mass = 100 kg, zeta, and fn values from parameters.m

% 2. Frequency Range
freqs = logspace(log10(0.1), log10(50), 200);
T_qzs = zeros(size(freqs));
T_rubber = zeros(size(freqs));
T_pneu = zeros(size(freqs));

for i = 1:length(freqs)
    f = freqs(i);
    % QZS Analytical
    r_q = f / fn_qzs;
    T_qzs(i) = sqrt( (1 + (2*zeta_qzs*r_q)^2) / ((1-r_q^2)^2 + (2*zeta_qzs*r_q)^2) );
    % Rubber Analytical
    r_r = f / fn_rubber;
    T_rubber(i) = sqrt( (1 + (2*zeta_rubber*r_r)^2) / ((1-r_r^2)^2 + (2*zeta_rubber*r_r)^2) );
    % Pneumatic Analytical
    r_p = f / fn_pneu;
    T_pneu(i) = sqrt( (1 + (2*zeta_pneu*r_p)^2) / ((1-r_p^2)^2 + (2*zeta_pneu*r_p)^2) );
end

% 3. Visualization
figure;
loglog(freqs, T_qzs, 'b', 'LineWidth', lw_thick, 'DisplayName', sprintf('QZS Isolator (f_n=%.1fHz)', fn_qzs));
hold on; grid on;
loglog(freqs, T_rubber, 'r--', 'LineWidth', lw_medium, 'DisplayName', sprintf('Rubber Mount (f_n=%.1fHz)', fn_rubber));
loglog(freqs, T_pneu, 'g-.', 'LineWidth', lw_medium, 'DisplayName', sprintf('Pneumatic Mount (f_n=%.1fHz)', fn_pneu));
% Passive Threshold (Manual line for Octave stability)
loglog([0.1, 50], [1.0, 1.0], 'k:', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(12.0, 1.5, 'Passive Threshold', 'Color', 'k', 'Interpreter', 'tex');

title('Experiment 4: Transmissibility Comparison (Analytical Benchmark)', 'Interpreter', 'tex');
xlabel('Excitation Frequency (Hz)', 'Interpreter', 'tex');
ylabel('Transmissibility T = |X| / |Y|', 'Interpreter', 'tex');
xlim([0.1, 50]); ylim([1e-6, 50]);
legend('Location', 'eastoutside');

% Save Result
print_fig('results/qzs_exp4_transmissibility.png');
fprintf('Experiment 4 completed.\n');
