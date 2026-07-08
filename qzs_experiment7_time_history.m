% qzs_experiment7_time_history.m
% Generates Figure 16 (Time-History Response Plot for a 30s Seismic Event)
clear; close all;
run('qzs_style_header.m');

% 1. System Parameters (Loaded from parameters.m)
% For a single isolator supporting 1/4 of a 100 kg rack:
m = 25;                  % Payload mass (kg)
kv = 49050;              % Vertical spring stiffness (N/m)
ko = 49050;              % Oblique spring stiffness (N/m)
L0 = 0.05;               % Free spring length (m)
gamma_val = 2/3;         % QZS geometric parameter
a = gamma_val * L0;      % Horizontal pivot distance (m)
x_eq = L0 * sqrt(1 - gamma_val^2); % Static deflection at equilibrium (m)
zeta = 0.05;             % Damping ratio (5%)
c = 2 * zeta * sqrt(kv * m); % Damping coefficient (N-s/m)

% 2. Ground Motion Definition (Synthetic IS 1893 seismic pulse)
t_end = 30;              % Simulation duration (s)
f_dom = 2.5;             % Dominant seismic frequency (Hz)
omega1 = 2 * pi * f_dom;
omega2 = pi / t_end;

% Calculate D0 to achieve exactly 0.24g peak ground acceleration (Zone III MCE)
PGA_target = 0.24 * 9.81; % 2.3544 m/s^2
D0 = PGA_target / (omega1^2); % Amplitude of displacement (m)

% Ground displacement y_g(t) and acceleration a_g(t) functions
yg_func = @(t) D0 * sin(omega1 * t) .* sin(omega2 * t);
ag_func = @(t) -0.5 * D0 * ( (omega1 - omega2)^2 * cos((omega1 - omega2)*t) - (omega1 + omega2)^2 * cos((omega1 + omega2)*t) );

% 3. Relative Restoring Force Function
% f_res(u) = kv*u + 2*ko*(1 - L0 / sqrt((u + x_eq)^2 + a^2)) * (u + x_eq)
f_res = @(u) kv * u + 2 * ko * (1 - L0 ./ sqrt((u + x_eq).^2 + a^2)) .* (u + x_eq);

% 4. State-Space ODE Formulation
% y = [u; u_dot]
ode_sys = @(t, y) [y(2); - (c/m)*y(2) - f_res(y(1))/m - ag_func(t)];

% 5. Numerical Simulation (ode45)
t_span = linspace(0, t_end, 3000);
[t, sol] = ode45(ode_sys, t_span, [0; 0]);

% Extract relative displacement and compute absolute displacements
u = sol(:, 1); % Relative displacement (m)
y_g = yg_func(t); % Ground displacement (m)
x_rack = y_g + u; % Absolute rack displacement (m)

% Convert to millimeters for presentation
y_g_mm = y_g * 1000;
x_rack_mm = x_rack * 1000;

% 6. Visualization
figure;
plot(t, y_g_mm, 'Color', [0.6, 0.6, 0.6], 'LineStyle', '--', 'LineWidth', lw_medium, 'DisplayName', 'Ground Displacement (Input)');
hold on; grid on;
plot(t, x_rack_mm, 'b-', 'LineWidth', lw_thick, 'DisplayName', 'Absolute Server Rack Displacement (QZS)');

% Format Plot
title('Figure 16: Transient Displacement of the Server Rack during a 30s Seismic Event', 'Interpreter', 'tex');
xlabel('Time (s)', 'Interpreter', 'tex');
ylabel('Displacement (mm)', 'Interpreter', 'tex');
legend('Location', 'eastoutside');
xlim([0, 30]);
ylim([-15, 15]);

% Save result using print_fig
print_fig('results/qzs_exp7_time_history.png');
fprintf('Figure 16 transient time-history response generated successfully.\n');
