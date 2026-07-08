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

f_res = @(u) kv * u + 2 * ko * (1 - L0 ./ sqrt(u.^2 + a^2)) .* u;

% Excitation: 2.0 Hz seismic harmonic pulse
f_exc = 2.0;
w_exc = 2 * pi * f_exc;
PGA = 0.03 * 9.81; % 0.03g (small displacement to stay inside QZS isolation basin)
D0 = PGA / (w_exc^2);

yg_func = @(t) D0 * sin(w_exc * t) .* (t < 6.0);
ag_func = @(t) -PGA * sin(w_exc * t) .* (t < 6.0);

% Run dynamic simulation first to get trajectory
t_end = 10;
t_span = linspace(0, t_end, 300);
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
ylim([-15, 55]);
set(gca, 'XTick', [], 'YTick', []);
title('Digital Twin: Real-Time QZS Physical Response', 'FontSize', 14, 'FontWeight', 'bold');

% Initial positions of components
ground_y = 0;             % FIX 2: ground is fixed for the whole animation
y_rack_base = 15;         % h0 at equilibrium (horizontal spring plane)

% FIX 1: rack height reduced to 25% of the original (25 -> 6.25)
rack_width  = 30;
rack_height = 6.25;

% Ground base line (drawn once, never updated again -> stays fixed)
h_ground = plot([-50, 50], [ground_y, ground_y], 'k-', 'LineWidth', 4);

% Server Rack Mass block (shorter box)
h_rack = rectangle('Position', [-rack_width/2, y_rack_base, rack_width, rack_height], ...
    'FaceColor', [0.9, 0.9, 0.9], 'EdgeColor', 'k', 'LineWidth', 2);

% Vent-slot handles for the rack (cosmetic, updated each frame)
% NOTE: use a plain numeric array of handles instead of gobjects(),
% since gobjects() is MATLAB-only and undefined in Octave.
n_slots = 5;
slot_x = linspace(-rack_width/2 + 4, rack_width/2 - 4, n_slots);
h_slots = zeros(1, n_slots);
for k = 1:n_slots
    h_slots(k) = plot([slot_x(k), slot_x(k)], [0, 0], 'Color', [0.55 0.55 0.55], 'LineWidth', 1.2);
end

% Fixed vertical support columns: these are the physical anchors for the
% two oblique springs. They are drawn once and never move; the springs'
% top-of-wall endpoint below is set to exactly (x, wall_height) so the
% spring always terminates precisely on the line, with no visual gap.
wall_height = 15; % same y-level as the oblique spring anchor points
h_wall_l = plot([-40, -40], [ground_y, wall_height], 'Color', [0.3 0.3 0.3], 'LineWidth', 3);
h_wall_r = plot([40, 40], [ground_y, wall_height], 'Color', [0.3 0.3 0.3], 'LineWidth', 3);

% Moving vertical marker for the ground excitation point. The horizontal
% ground line (h_ground) stays fixed, but the actual base of the vertical
% spring moves with curr_yg -- this short vertical segment visually
% connects the fixed ground line to that moving point, and the spring's
% bottom endpoint is pinned to its tip every frame (no floating gap).
h_ground_marker = plot([0, 0], [ground_y, ground_y], 'Color', [0.4 0.4 0.4], 'LineWidth', 3);

% Springs handles
h_spring_v = plot(0, 0, 'Color', [0.85, 0.325, 0.098], 'LineWidth', 2);
h_spring_l = plot(0, 0, 'Color', [0, 0.447, 0.741], 'LineWidth', 2);
h_spring_r = plot(0, 0, 'Color', [0, 0.447, 0.741], 'LineWidth', 2);
% Pivots
h_pivot_c = plot(0, y_rack_base, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 8, 'LineWidth', 1.5);

% Right Subplot: Scrolling Plot
subplot(1, 2, 2);
hold on; grid on;
h_plot_g = plot(0, 0, 'Color', [0.6, 0.6, 0.6], 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'Ground (Input)');
h_plot_r = plot(0, 0, 'b-', 'LineWidth', 2.5, 'DisplayName', 'Server Rack (QZS Output)');
xlim([0, t_end]);
ylim([-3, 3]);
xlabel('Time (s)', 'FontSize', 12);
ylabel('Displacement (mm)', 'FontSize', 12);
title('Live Phase Displacement Analysis', 'FontSize', 14, 'FontWeight', 'bold');
legend('Location', 'northeast');

% Animation Loop
fprintf('Starting Real-Time Animation Loop...\n');

% Helper spring generator
% FIX 3: produces a smooth sinusoidal coil (continuously deforming with
% the endpoints) instead of a fixed zig-zag pattern that just gets
% rigidly translated every frame.
function [xs, ys] = make_spring(p1, p2, ncoil, r)
    d = p2 - p1;
    L = norm(d);
    if L < eps
        L = eps;
    end
    u = d / L;
    n = [-u(2), u(1)];

    lead = 0.08 * L;          % short straight lead-in / lead-out
    body = L - 2 * lead;      % coiled region length

    t = linspace(0, 1, ncoil * 30);
    wave = r * sin(2 * pi * ncoil * t);

    start_body = p1 + u * lead;
    end_body   = p2 - u * lead;

    pts = start_body + u .* (body * t)' + n .* wave';

    xs = [p1(1), start_body(1), pts(:, 1)', end_body(1), p2(1)];
    ys = [p1(2), start_body(2), pts(:, 2)', end_body(2), p2(2)];
end

for i = 1:length(t_out)
    curr_t = t_out(i);
    curr_yg = y_g_mm(i);
    curr_rack = x_rack_mm(i);
    curr_u = u_mm(i);

    % NOTE: h_ground is intentionally never updated -> floor stays fixed.

    % Update server rack position
    rack_y = y_rack_base + curr_rack;
    set(h_rack, 'Position', [-rack_width/2, rack_y, rack_width, rack_height]);

    % Update vent slots to track the rack
    for k = 1:n_slots
        set(h_slots(k), 'XData', [slot_x(k), slot_x(k)], ...
            'YData', [rack_y + 0.15*rack_height, rack_y + 0.85*rack_height]);
    end

    % Update pivots
    set(h_pivot_c, 'YData', rack_y);

    % Update the moving ground-excitation marker (vertical tick at x=0).
    % Its base stays pinned to the fixed ground line; its tip is the true
    % excitation point that the vertical spring attaches to.
    base_y = ground_y + curr_yg;
    set(h_ground_marker, 'XData', [0, 0], 'YData', [ground_y, base_y]);

    % Vertical spring: bottom endpoint is fixed to the marker tip (base_y)
    % every frame, so there is never a visual gap between them.
    [vx, vy] = make_spring([0, base_y], [0, rack_y], 8, 3);
    set(h_spring_v, 'XData', vx, 'YData', vy);

    % Oblique springs: bottom endpoints are fixed to the top of the two
    % stationary wall columns (h_wall_l / h_wall_r), only the rack-side
    % end moves, so the spring always meets the wall line exactly.
    [lx, ly] = make_spring([-40, wall_height], [-rack_width/2, rack_y], 7, 2);
    set(h_spring_l, 'XData', lx, 'YData', ly);

    [rx, ry] = make_spring([40, wall_height], [rack_width/2, rack_y], 7, 2);
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
        pause(0.033); % Control playback speed to match real-time (10s animation / 300 steps)
    end
end

if has_display
    print_fig('results/carrella_live_animation.png');
    fprintf('Animation finished. Saved final frame to results/carrella_live_animation.png\n');
end