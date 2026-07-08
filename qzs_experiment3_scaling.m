% =====================================================================
% qzs_experiment3_scaling.m
% Experiment 3: Static Parametric Study - Natural Frequency Scaling
% Purpose: Scale QZS theory for 50kg, 100kg, and 150kg server racks.
% =====================================================================
clear; clc; close all;
run('qzs_style_header.m');

% 1. Design Point (from Carrella 2007 via parameters.m)
gamma_design = gamma;     % Optimal geometry
alpha_design = alpha;     % Optimal stiffness ratio

% 2. Sweep Actual Geometry (Installation Sensitivity)
gamma_actual = linspace(0.4, 0.9, 1000); 

figure;
hold on; grid on;

colors = {'b', 'r', [0, 0.5, 0]};
markers = {'o', 's', '^'};
marker_indices = round(linspace(1, length(gamma_actual), 15));

for i = 1:length(rack_masses)
    m = rack_masses(i);
    
    % Size springs for this mass to satisfy static deflection
    kv = (m * g_accel) / delta_static;
    ko = alpha_design * kv;
    
    % Calculate dimensional stiffness K_total for varying actual gamma
    fn = zeros(size(gamma_actual));
    for j = 1:length(gamma_actual)
        gam = gamma_actual(j);
        x_e = sqrt(1 - gam^2);
        K_nd = 1 + 2*alpha_design*(1 - gam^2 / ...
            max((x_e^2 - 2*sqrt(1-gam^2)*x_e + 1), 1e-10)^1.5);
        K_total_j = kv * K_nd;
        if K_total_j > 0
            fn(j) = (1/(2*pi))*sqrt(K_total_j/m);
        else
            fn(j) = 0;
        end
    end
    
    % Use distinct line styles and widths for visibility, scaled with parameters
    valid = fn > 0;
    styles = {'-', '--', ':'};
    widths = [lw_thick, lw_medium, lw_thin];
    plot(gamma_actual(valid), fn(valid), 'LineStyle', styles{i}, 'Color', colors{i}, ...
        'LineWidth', widths(i), 'DisplayName', sprintf('Rack Mass: %d kg', m));
    
    % Add markers
    plot(gamma_actual(marker_indices), fn(marker_indices), markers{i}, ...
        'Color', colors{i}, 'MarkerFaceColor', 'w', 'HandleVisibility', 'off');
end

% 3. Seismic Isolation Target (1 Hz) (Manual line for Octave stability)
plot([0.4, 0.9], [1.0, 1.0], '--k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(0.42, 1.2, '1 Hz Isolation Threshold', 'Color', 'k', 'Interpreter', 'tex');

% 5. Format Plot
title(['Experiment 3: Natural Frequency vs. Installation Geometry (\gamma)', char(10), ...
    'Design Point: \alpha = 1.0, \delta_{static} = 5mm'], 'Interpreter', 'tex');
xlabel('Geometric Parameter \gamma (a/L_0)', 'Interpreter', 'tex');
axis tight;
ylabel('System Natural Frequency f_n (Hz)', 'Interpreter', 'tex');
% Mass-invariant property: fn = sqrt(kv*K_nd/m)
% Since kv = m*g/delta, fn = sqrt(g*K_nd/delta) — independent of m
% Proven analytically by Wang et al. 2020
legend('Location', 'eastoutside');
xlim([0.4, 0.9]);
ylim([0, 12]);

% Annotate QZS Point
plot(gamma_design, 0, 'kp', 'MarkerSize', 15, 'MarkerFaceColor', 'y', 'DisplayName', 'Optimal QZS Point');

% 6. Save Result
print_fig('results/qzs_exp3_scaling.png');