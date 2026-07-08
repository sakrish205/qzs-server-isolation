% carrella_experiment11_damping.m
% Generates Figure 18: Damping Optimization & Transmissibility Waterfall
clear; close all;
run('carrella_style_header.m');

% Parameters
m = 25;                  % Mass (kg)
kv = 49050;              % Vertical stiffness (N/m)
fn = 0.5;                % QZS natural frequency (Hz)
wn = 2 * pi * fn;
freq = linspace(0.01, 10, 1000); % Frequency sweep range (Hz)
r = freq / fn;           % Frequency ratio

% Sweeping damping ratios (zeta)
zeta_vals = [0.01, 0.05, 0.1, 0.2, 0.5];
colors = ['r', 'g', 'b', 'm', 'c'];

figure;
hold on; grid on;

for k = 1:length(zeta_vals)
    zeta = zeta_vals(k);
    % Standard QZS linearized displacement transmissibility:
    % T = sqrt( (1 + (2*zeta*r).^2) ./ ( (1 - r.^2).^2 + (2*zeta*r).^2 ) )
    T = sqrt( (1 + (2*zeta*r).^2) ./ ( (1 - r.^2).^2 + (2*zeta*r).^2 ) );
    
    % Convert to decibels (dB) for standard academic representation
    T_db = 20 * log10(T);
    
    plot(freq, T_db, 'Color', colors(k), 'LineWidth', lw_medium, ...
         'DisplayName', sprintf('\\zeta = %.2f', zeta));
end

% Visual thresholds and formatting
plot([0, 10], [0, 0], 'k--', 'LineWidth', lw_thin, 'HandleVisibility', 'off'); % 0 dB line
plot([fn*sqrt(2), fn*sqrt(2)], [-40, 20], 'k:', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(fn*sqrt(2) + 0.1, -30, 'Isolation Threshold (f_n\surd2)', 'FontSize', 12, 'Interpreter', 'tex');

title('Experiment 11: Damping Optimization and Transmissibility Waterfall', 'Interpreter', 'tex');
xlabel('Excitation Frequency (Hz)', 'Interpreter', 'tex');
ylabel('Transmissibility (dB)', 'Interpreter', 'tex');
legend('Location', 'eastoutside');
xlim([0, 5]);
ylim([-40, 20]);

% Save result
print_fig('results/carrella_exp11_damping.png');
fprintf('Experiment 11: Damping optimization completed successfully.\n');
