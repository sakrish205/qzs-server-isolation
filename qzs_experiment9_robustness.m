% qzs_experiment9_robustness.m
% Generates Figure 17: Robustness Sensitivity Manifold (Heatmap)
clear; close all;
run('qzs_style_header.m');

% 1. Sweeping Grid Parameters
mass_arr = linspace(80, 120, 21);    % Total payload mass (kg), sweeps +-20% of 100 kg
gamma_arr = linspace(0.95, 1.05, 21) * (2/3); % sweeps +-5% of QZS angle (2/3)

% Constants
g = 9.81;
kv = 49050;              % Vertical spring stiffness (N/m)
ko = 49050;              % Oblique spring stiffness (N/m)
L0 = 0.05;               % Free spring length (m)

[G, M] = meshgrid(gamma_arr, mass_arr);
Fn = zeros(size(G));

% 2. Solve for Equilibrium and Natural Frequency at Each Grid Point
for i = 1:size(G, 1)
    for j = 1:size(G, 2)
        gamma_val = G(i, j);
        m_iso = M(i, j) / 4; % 1/4 of total payload mass for single isolator
        a = gamma_val * L0;
        
        % Force balance equation under gravity: f_total(x_eq) - m_iso*g = 0
        % f_total(x) = kv*x + 2*ko*(1 - L0 / sqrt(x^2 + a^2)) * x
        f_eq = @(x) kv * x + 2 * ko * (1 - L0 / sqrt(x^2 + a^2)) * x - m_iso * g;
        
        % Start guess: QZS static deflection
        x0 = L0 * sqrt(1 - gamma_val^2);
        
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
clabel(C, h, 'FontSize', 12, 'FontName', 'Times New Roman');

% Format Plot
title('Figure 17: Natural Frequency (Hz) Robustness & Sensitivity Manifold', 'Interpreter', 'tex');
xlabel('Normalized Geometry \gamma / \gamma_{opt} (%)', 'Interpreter', 'tex');
ylabel('Total Payload Mass (kg)', 'Interpreter', 'tex');
grid on;

% Save result using print_fig
print_fig('results/qzs_exp9_robustness.png');
fprintf('Figure 17 robustness heatmap generated successfully.\n');
