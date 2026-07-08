% carrella_live_animation.m
% Dynamic Digital Twin Real-Time Animation for QZS Vibration Isolator
clear; close all;
run('carrella_style_header.m');

% Simulation Parameters
m = 25;                  % Mass (kg)
kv = 49050;              % Vertical stiffness (N/m)
ko = 49050;              % Oblique stiffness (N/m)
L0 = 0.05;               % Free spring length (m)
gamma_val = 2/3;         
a = gamma_val * L0;      
x_eq = L0 * sqrt(1 - gamma_val^2); 
zeta = 0.05;             
c = 2 * zeta * sqrt(kv * m); 

f_res = @(u) kv * u + 2 * ko * (1 - L0 ./ sqrt((u + x_eq).^2 + a^2)) .* (u + x_eq);

% Excitation: 2.0 Hz seismic harmonic pulse
f_exc = 2.0;
w_exc = 2 * pi * f_exc;
PGA = 0.20 * 9.81; % 0.20g
D0 = PGA / (w_exc^2);

yg_func = @(t) D0 * sin(w_exc * t) .* (t < 6.0);
ag_func = @(t) -PGA * sin(w_exc * t) .* (t < 6.0);

% Run dynamic simulation first to get trajectory
t_end = 10;
t_span = linspace(0, t_end, 200);
ode_sys = @(t, y) [y(2); - (c/m)*y(2) - f_res(y(1))/m - ag_func(t)];
[t_out, sol] = ode45(ode_sys, t_span, [0; 0]);

u = sol(:, 1);
y_g = yg_func(t_out);
x_rack = y_g + u;

% Convert to mm for visual readability
y_g_mm = y_g * 1000;
x_rack_mm = x_rack * 1000;
u_mm = u * 1000;

% Check if graphical display is available
has_display = true;
try
    if isempty(getenv('DISPLAY')) && ispc == 0
        has_display = false;
    end
catch
    has_display = false;
end

% Set up Animation Figure
fig = figure;
set(fig, 'Position', [100, 100, 1500, 800]);

% Left Subplot: Mechanical View
subplot(1, 2, 1);
hold on; grid off;
box on;
xlim([-60, 60]);
ylim([-10, 80]);
set(gca, 'XTick', [], 'YTick', []);
title('Digital Twin: Real-Time QZS Physical Response', 'FontSize', 14, 'FontWeight', 'bold');

% Initial positions of components
y_ground = 0;
y_rack_base = 37.3; % h0 at equilibrium

% Ground base line
h_ground = plot([-50, 50], [0, 0], 'k-', 'LineWidth', 4);
% Server Rack Mass block
h_rack = rectangle('Position', [-15, y_rack_base, 30, 25], 'FaceColor', [0.9, 0.9, 0.9], 'EdgeColor', 'k', 'LineWidth', 2);
% Springs handles
h_spring_v = plot(0, 0, 'Color', [0.85, 0.325, 0.098], 'LineWidth', 3);
h_spring_l = plot(0, 0, 'Color', [0, 0.447, 0.741], 'LineWidth', 3);
h_spring_r = plot(0, 0, 'Color', [0, 0.447, 0.741], 'LineWidth', 3);
% Pivots
h_pivot_c = plot(0, y_rack_base, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 8, 'LineWidth', 1.5);

% Right Subplot: Scrolling Plot
subplot(1, 2, 2);
hold on; grid on;
h_plot_g = plot(0, 0, 'Color', [0.6, 0.6, 0.6], 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Ground (Input)');
h_plot_r = plot(0, 0, 'b-', 'LineWidth', 2.5, 'DisplayName', 'Server Rack (QZS Output)');
xlim([0, t_end]);
ylim([-12, 12]);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Displacement (mm)', 'FontSize', 12);
title('Live Phase Displacement Analysis', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northeast');

% Animation Loop
fprintf('Starting Real-Time Animation Loop...\n');

% Helper spring generator
function [xs, ys] = make_spring(p1, p2, coils, w)
    d = p2 - p1;
    L = norm(d);
    u = d / L;
    n = [-u(2), u(1)];
    t = linspace(0.15, 0.85, coils);
    xs = [p1(1)];
    ys = [p1(2)];
    for idx = 1:length(t)
        side = (-1)^idx * w;
        if idx == 1 || idx == length(t); side = 0; end
        pt = p1 + u*L*t(idx) + n*side;
        xs = [xs, pt(1)];
        ys = [ys, pt(2)];
    end
    xs = [xs, p2(1)];
    ys = [ys, p2(2)];
end

for i = 1:length(t_out)
    curr_t = t_out(i);
    curr_yg = y_g_mm(i);
    curr_rack = x_rack_mm(i);
    curr_u = u_mm(i);
    
    % Update ground line
    set(h_ground, 'YData', [curr_yg, curr_yg]);
    
    % Update server rack position
    rack_y = y_rack_base + curr_rack;
    set(h_rack, 'Position', [-15, rack_y, 30, 25]);
    
    % Update pivots
    set(h_pivot_c, 'YData', rack_y);
    
    % Update vertical spring
    [vx, vy] = make_spring([0, curr_yg], [0, rack_y], 12, 3);
    set(h_spring_v, 'XData', vx, 'YData', vy);
    
    % Update oblique springs
    [lx, ly] = make_spring([-40, 15 + curr_yg], [-15, rack_y], 10, 2.5);
    set(h_spring_l, 'XData', lx, 'YData', ly);
    
    [rx, ry] = make_spring([40, 15 + curr_yg], [15, rack_y], 10, 2.5);
    set(h_spring_r, 'XData', rx, 'YData', ry);
    
    % Update scrolling plots
    set(h_plot_g, 'XData', t_out(1:i), 'YData', y_g_mm(1:i));
    set(h_plot_r, 'XData', t_out(1:i), 'YData', x_rack_mm(1:i));
    
    if ~has_display
        % In headless terminal, compile just the final frame and exit
        if i == length(t_out)
            print_fig('results/carrella_live_animation.png');
            fprintf('Headless environment: Final frame saved to results/carrella_live_animation.png\n');
        end
    else
        drawnow;
        pause(0.02); % Control playback speed
    end
end

if has_display
    print_fig('results/carrella_live_animation.png');
    fprintf('Animation finished. Saved final frame to results/carrella_live_animation.png\n');
end
