% =====================================================================
% qzs_experiment6_vc_mapping.m
% Experiment 6: VC Criteria Mapping (BBN Gordon 1999)
% Purpose: Map velocity response against international benchmarks.
% =====================================================================
clear; clc; close all;
run('qzs_style_header.m');

% 1. Frequency Range
freqs = logspace(log10(1), log10(100), 200);

% 2. System Parameters (Consistent with Exp 4/5, loaded from parameters.m)

% Base acceleration — IS 1893 Zone III MCE (consistent with Exp 5: Z*I = 0.24g)
Z = 0.16; I = 1.5;
PGA_design = Z * I;                        % = 0.24g MCE
A_base_g = PGA_design * ones(size(freqs)); % Flat spectrum for VC sensitivity analysis

% Transmissibility
r_rubber = freqs ./ fn_rubber;
T_rubber = sqrt( (1 + (2*zeta_rubber*r_rubber).^2) ./ ((1-r_rubber.^2).^2 + (2*zeta_rubber*r_rubber).^2) );

r_qzs = freqs ./ fn_qzs;
T_qzs = sqrt( (1 + (2*zeta_qzs*r_qzs).^2) ./ ((1-r_qzs.^2).^2 + (2*zeta_qzs*r_qzs).^2) );

% Absolute Acceleration (g)
a_rubber = A_base_g .* T_rubber;
a_qzs = A_base_g .* T_qzs;

% 3. Convert to Velocity (micrometers per second)
% v = (a * 9.81) / (2*pi*f) * 10^6
v_rubber = (a_rubber * 9.81) ./ (2 * pi * freqs) * 1e6;
v_qzs = (a_qzs * 9.81) ./ (2 * pi * freqs) * 1e6;

% 4. Visualization
figure;
loglog(freqs, v_rubber, 'r--', 'LineWidth', lw_medium, 'DisplayName', 'Rubber Mount');
hold on; grid on;
loglog(freqs, v_qzs, 'b', 'LineWidth', lw_thick, 'DisplayName', 'QZS Isolator');

% VC Levels (BBN Gordon 1999) (Manual lines for Octave stability)
loglog([1, 100], [100, 100], '-k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(1.2, 110, 'Workshop (100 \mum/s)', 'Interpreter', 'tex');
loglog([1, 100], [50, 50], ':k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(1.2, 55, 'VC-A (50 \mum/s)', 'Interpreter', 'tex');
loglog([1, 100], [25, 25], '--k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(1.2, 27, 'VC-B (25 \mum/s)', 'Interpreter', 'tex');
loglog([1, 100], [12.5, 12.5], '-.k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(1.2, 14, 'VC-C (12.5 \mum/s)', 'Interpreter', 'tex');
loglog([1, 100], [6.25, 6.25], ':k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(1.2, 7, 'VC-D (6.25 \mum/s)', 'Interpreter', 'tex');
loglog([1, 100], [1.56, 1.56], '--k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(1.2, 1.8, 'VC-E (1.56 \mum/s)', 'Interpreter', 'tex');

% Format Plot
title('Experiment 6: Vibration Criterion (VC) Mapping', 'Interpreter', 'tex');
xlabel('Frequency (Hz)', 'Interpreter', 'tex');
axis tight;
ylabel('Velocity (\mum/s)', 'Interpreter', 'tex');
xlim([1, 100]);
ylim([1, 1000]);
legend('Location', 'eastoutside');

% Save Result
print_fig('results/qzs_exp6_vc_mapping.png');
fprintf('Experiment 6 completed.\n');
