
% =====================================================================
% carrella_experiment5_seismic.m
% Experiment 5: IS 1893 Seismic Response Analysis
% Purpose: Verify protection under Indian Seismic Standard Zone III.
% =====================================================================
clear; clc; close all;
run('carrella_style_header.m');

% 1. IS 1893 Part 1 (2016) Parameters
Z = 0.16;       % Zone Factor (Zone III)
I = 1.5;        % Importance Factor (Data Center)
R = 3.0;        % Response Reduction Factor (Standard Rack)
% PGA_design is defined below at line 33 as Z*I for MCE intensity

freqs = linspace(1, 33, 200); % Seismic band (Hz)
Periods = 1 ./ freqs;

% Spectral Acceleration Sa/g for Medium Soil (Type II)
Sag = zeros(size(Periods));
for i = 1:length(Periods)
    T = Periods(i);
    if T < 0.1
        Sag(i) = 1 + 15*T;
    elseif T <= 0.4
        Sag(i) = 2.5;
    else
        Sag(i) = 1.0 / T;
    end
end

% Base Acceleration (g) - IS 1893 Design Spectrum (DBE)
PGA_design = (Z * I) / 2;  % Design Basis Earthquake (DBE) intensity (0.12g)
A_base = Sag * PGA_design; % Resulting base acceleration spectrum in g

% 2. Isolator Transmissibility (Analytical simplified for speed)
% Note: We use parameters loaded from parameters.m

r_rubber = freqs ./ fn_rubber;
T_rubber = sqrt( (1 + (2*zeta_rubber*r_rubber).^2) ./ ((1-r_rubber.^2).^2 + (2*zeta_rubber*r_rubber).^2) );

r_qzs = freqs ./ fn_qzs;
T_qzs = sqrt( (1 + (2*zeta_qzs*r_qzs).^2) ./ ((1-r_qzs.^2).^2 + (2*zeta_qzs*r_qzs).^2) );

% 3. Rack Response (g)
A_rubber = A_base .* T_rubber;
A_qzs = A_base .* T_qzs;

% 4. Visualization
figure;
plot(freqs, A_base, 'k', 'LineWidth', lw_thin, 'DisplayName', 'IS 1893 Input Spectrum');
hold on; grid on;
plot(freqs, A_rubber, 'r--', 'LineWidth', lw_medium, 'DisplayName', 'Rubber Mount Response');
plot(freqs, A_qzs, 'b', 'LineWidth', lw_thick, 'DisplayName', 'QZS Isolator Response');

% Damage Threshold (Manual line for Octave stability)
plot([1, 33], [0.5, 0.5], ':r', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(20.0, 0.55, 'Server Damage Threshold (0.5g)', 'Color', 'r', 'Interpreter', 'tex');

% Format Plot
title(['Experiment 5: IS 1893 Seismic Response (Zone III, Medium Soil Type II)', char(10), ...
    'Comparison of Rack Acceleration vs. Safety Threshold'], 'Interpreter', 'tex');
xlabel('Frequency (Hz)', 'Interpreter', 'tex');
ylabel('Absolute Acceleration (g)', 'Interpreter', 'tex');
legend('Location', 'eastoutside');
axis([1, 33, 0, 2.5]); % Forced at end to prevent clipping

% Save Result
print_fig('results/carrella_exp5_seismic.png');
fprintf('Experiment 5 completed.\n');
