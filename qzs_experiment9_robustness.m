% qzs_experiment9_robustness.m
% Generates Figure 17: Robustness Sensitivity Manifold (Heatmap)
clear; close all;
run('parameters.m');
mass_arr   = linspace(0.8, 1.2, 21) * target_rack_mass; % ±20% sweep (kg)
gamma_arr  = linspace(0.95, 1.05, 21) * (2/3);           % ±5% of QZS angle

% Constants (parametric)
m_iso_target = target_rack_mass / n_isolators;
kv = (m_iso_target * g_accel) / delta_static; % Vertical spring stiffness (N/m)
ko = alpha * kv;                               % Oblique spring stiffness (N/m)
L0 = 0.05;               % Free spring length (m)

[G, M] = meshgrid(gamma_arr, mass_arr);
Fn = zeros(size(G));

% 2. Solve for Equilibrium and Natural Frequency at Each Grid Point
for i = 1:size(G, 1)
    for j = 1:size(G, 2)
        gamma_val = G(i, j);
        m_iso = M(i, j) / n_isolators; % Mass per corner isolator
        a = gamma_val * L0;
        
        % Force balance equation under gravity with vertical spring pre-compression (delta_static) included
        f_eq = @(x) kv * (delta_static + x) + 2 * ko * (1 - L0 / sqrt(x^2 + a^2)) * x - m_iso * g_accel;
        
        % Start guess: equilibrium is near 0
        x0 = 0.0;
        
        try
            x_eq = fzero(f_eq, x0);
            
            % Compute tangent stiffness at equilibrium
            K_eq = kv + 2 * ko * (1 - L0 / sqrt(x_eq^2 + a^2) + L0 * x_eq^2 / (x_eq^2 + a^2)^1.5);
            
            if K_eq >= 0
                Fn(i, j) = (1 / (2 * pi)) * sqrt(K_eq / m_iso);
            else
                Fn(i, j) = 0; % Unstable / snap-through region
            end
        catch
            Fn(i, j) = 0; % Solver failure fallback
        end
    end
end

% 3. Visualization
figure;
[C, h] = contourf(G / (2/3) * 100, M, Fn, 15, 'LineWidth', 1.0);
colorbar;
colormap('jet');
clabel(C, h, 'FontSize', 20, 'FontName', 'Times New Roman');

% 1 Hz isolation boundary contour (improvement)
hold on;
[C1, h1] = contour(G / (2/3) * 100, M, Fn, [1 1], 'w-', 'LineWidth', 2.5);
clabel(C1, h1, 'FontSize', 20, 'Color', 'w', 'FontWeight', 'bold');
text(101.5, 82, '1 Hz boundary', 'Color', 'w', 'FontSize', 20, 'FontWeight', 'bold', 'Interpreter', 'tex');

% Format Plot
title('Figure 17: Natural Frequency (Hz) Robustness & Sensitivity Manifold', 'Interpreter', 'tex');
xlabel('Normalized Geometry \gamma / \gamma_{opt} (%)', 'Interpreter', 'tex');
ylabel('Total Payload Mass (kg)', 'Interpreter', 'tex');
grid on;

% Save result using print_fig
print_fig('results/qzs_exp9_robustness.png');
fprintf('Figure 17 robustness heatmap generated successfully.\n');
