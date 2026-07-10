clear; clc; close all;
run('qzs_style_header.m');
% 1. Washer Geometry (Smaller size for 100kg load)
De = 40;        % Outer diameter (mm)
Di = 20;        % Inner diameter (mm)
t = 2.0;        % Thickness (mm)
h = 1.0;        % Dish height (mm)
E = 210000;     % Young's Modulus (N/mm^2)
nu = 0.3;       % Poisson's ratio

% Almen-Laszlo Constants
delta = De / Di;
K1 = (1/pi) * ( (delta - 1) / delta )^2 / ( ((delta + 1)/(delta - 1)) - (2 / log(delta)) );

% 2. Vertical Stiffness Requirements (Assuming 4 isolators per rack)
% Using rack_masses, g_accel, and delta_static loaded from parameters.m
delta_static_mm = delta_static * 1000; % Convert to mm
kv_target_total = (rack_masses * g_accel) / delta_static; 
kv_target_iso = kv_target_total / 4; % Stiffness PER isolator
kv_target_nmm = kv_target_iso / 1000; 

fprintf('--- Belleville Washer Sizing Table (Per Isolator) ---\n');
fprintf('%-10s | %-12s | %-10s | %-10s | %-10s\n', 'Mass (kg)', 'Req kv(N/mm)', 'n_series', 'n_parallel', 'Total Washers');
fprintf('------------------------------------------------------------\n');

results_table = [];
for i = 1:length(rack_masses)
    m = rack_masses(i);
    k_req = kv_target_nmm(i);
    k_single = ( (4*E) / (1-nu^2) ) * ( t^3 / (K1*(De^2)) ) * ( (h/t)^2 + 1 );
    n_p = 1;
    n_s = round(k_single / k_req);
    fprintf('%-10d | %-12.2f | %-10d | %-10d | %-10d\n', m, k_req, n_s, n_p, n_s*n_p);
    results_table = [results_table; m, k_req, n_s, n_p, n_s*n_p];
end

% 3. Visualization
m_idx = find(rack_masses == target_rack_mass);
if isempty(m_idx); m_idx = 2; end % Fallback to 2nd index (100 kg)
n_s = results_table(m_idx, 3);
n_p = results_table(m_idx, 4);

s_range = linspace(0, n_s * h, 100); 
F_stack = zeros(size(s_range));
for j = 1:length(s_range)
    s_single = s_range(j) / n_s;
    F_single = ((4*E)/(1-nu^2)) * (t^4/(K1*(De^2))) * (s_single/t) * ((h/t - s_single/t)*(h/t - s_single/(2*t)) + 1);
    F_stack(j) = n_p * F_single;
end

figure;
plot(s_range, F_stack, 'b', 'LineWidth', lw_thick, 'DisplayName', 'Stack Load-Deflection');
hold on; grid on;
% Manual lines for Octave stability
plot([delta_static_mm, delta_static_mm], [0, 2500], '--r', 'LineWidth', lw_medium, 'HandleVisibility', 'off');
text(delta_static_mm+0.2, 1000, sprintf('Operating Deflection (%dmm)', delta_static_mm), 'Color', 'r', 'Rotation', 90, 'Interpreter', 'tex');
plot([0, 20], [(rack_masses(m_idx)*g_accel)/4, (rack_masses(m_idx)*g_accel)/4], '--k', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
text(3, (rack_masses(m_idx)*g_accel)/4 + 100, sprintf('Static Load (%.1fkg/isolator)', rack_masses(m_idx)/4), 'Color', 'k', 'Interpreter', 'tex');

title(sprintf('Experiment 8: Physical Realisation (%.0fkg per Isolator, %.0fkg Rack)', ...
    target_rack_mass/n_isolators, target_rack_mass), 'Interpreter', 'tex');
xlabel('Total Deflection (mm)', 'Interpreter', 'tex');
ylabel('Vertical Force F_v (N)', 'Interpreter', 'tex');
legend('Location', 'eastoutside');
axis([0, 10, 0, 1500]);

% Save Result
print_fig('results/qzs_exp8_belleville.png');
fprintf('\nExperiment 8 completed. Plot saved to results/qzs_exp8_belleville.png\n');
