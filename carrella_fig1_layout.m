% carrella_fig1_layout.m
% Generates Figure 1: Mechanical Layout Visualization of the QZS Mechanism
clear; close all;
run('carrella_style_header.m');

% Figure setup
figure;
hold on; grid off;
set(gca, 'Color', 'w');

% Helper function to generate spring zigzag coordinates
function [xs, ys] = get_spring_points(p1, p2, num_coils, width)
    d = p2 - p1;
    L = norm(d);
    u = d / L;              % Unit vector along spring axis
    n = [-u(2), u(1)];      % Normal unit vector
    
    lead_frac = 0.15;
    t = linspace(0, 1, 2*num_coils + 2);
    
    xs = p1(1) + u(1)*L*lead_frac;
    ys = p1(2) + u(2)*L*lead_frac;
    
    for i = 1:length(t)
        frac = lead_frac + (1 - 2*lead_frac)*t(i);
        side = (-1)^i * width;
        if i == 1 || i == length(t)
            side = 0;
        end
        pt = p1 + u*L*frac + n*side;
        xs = [xs, pt(1)];
        ys = [ys, pt(2)];
    end
    
    xs = [p1(1), xs, p2(1)];
    ys = [p1(2), ys, p2(2)];
end

% Draw ground hatching
gx = linspace(-5, 5, 20);
for i = 1:length(gx)
    plot([gx(i), gx(i)-0.2], [0, -0.3], 'k-', 'LineWidth', 1.5);
end
plot([-5.5, 5.5], [0, 0], 'k-', 'LineWidth', 3); % Ground line

% Draw left wall hatching
wy = linspace(0.5, 4.5, 10);
for i = 1:length(wy)
    plot([-4, -4.3], [wy(i), wy(i)-0.2], 'k-', 'LineWidth', 1.5);
end
plot([-4, -4], [0.3, 4.7], 'k-', 'LineWidth', 3); % Left wall line

% Draw right wall hatching
for i = 1:length(wy)
    plot([4, 4.3], [wy(i), wy(i)-0.2], 'k-', 'LineWidth', 1.5);
end
plot([4, 4], [0.3, 4.7], 'k-', 'LineWidth', 3); % Right wall line

% Draw springs
% 1. Vertical spring (kv) - from ground (0,0) to rack bottom-center (0, 2.5)
[vkx, vky] = get_spring_points([0, 0], [0, 2.5], 8, 0.3);
plot(vkx, vky, 'Color', [0.85, 0.325, 0.098], 'LineWidth', 3);

% 2. Left oblique spring (ko) - from left wall pivot (-4, 1.5) to rack bottom-left corner (-1.2, 2.5)
[lkx, lky] = get_spring_points([-4, 1.5], [-1.2, 2.5], 8, 0.3);
plot(lkx, lky, 'Color', [0, 0.447, 0.741], 'LineWidth', 3);

% 3. Right oblique spring (ko) - from right wall pivot (4, 1.5) to rack bottom-right corner (1.2, 2.5)
[rkx, rky] = get_spring_points([4, 1.5], [1.2, 2.5], 8, 0.3);
plot(rkx, rky, 'Color', [0, 0.447, 0.741], 'LineWidth', 3);

% Draw server rack (mass m) - centered at 0, y from 2.5 to 4.3
rectangle('Position', [-1.2, 2.5, 2.4, 1.8], 'FaceColor', [0.9, 0.9, 0.9], 'EdgeColor', 'k', 'LineWidth', 3);

% Draw pivot joints (circles)
plot(0, 0, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);
plot(-4, 1.5, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);
plot(4, 1.5, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);
plot(-1.2, 2.5, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);
plot(1.2, 2.5, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);
plot(0, 2.5, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);

% Draw dashed centerline and dimension lines
plot([0, 0], [0, 5], 'k--', 'LineWidth', 1.5);
plot([0, 4], [1.5, 1.5], 'k:', 'LineWidth', 1.5); % Horizontal reference line at y=1.5
plot([-4, 4], [2.5, 2.5], 'k:', 'LineWidth', 1.2); % Horizontal line at y=2.5

% Draw vertical guides (dashed)
plot([-1.2, -1.2], [0, 5], 'k--', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5);
plot([1.2, 1.2], [0, 5], 'k--', 'Color', [0.5, 0.5, 0.5], 'LineWidth', 1.5);

% Draw angle indicator arc for theta at right wall pivot (4, 1.5)
t_theta = linspace(pi, pi - atan2(1, 2.8), 30);
plot(4 + 1.0 * cos(t_theta), 1.5 + 1.0 * sin(t_theta), 'k-', 'LineWidth', 1.5);

% Text Labels (Huge, bold, Times New Roman - shifted to prevent overlapping)
text(0, 3.4, {'m', 'Server Rack'}, 'FontSize', 22, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
     'BackgroundColor', [0.9, 0.9, 0.9]);
text(0.5, 1.0, 'k_v', 'FontSize', 24, 'FontWeight', 'bold', 'Color', [0.85, 0.325, 0.098]);
text(-2.8, 2.5, 'k_o', 'FontSize', 24, 'FontWeight', 'bold', 'Color', [0, 0.447, 0.741]);
text(2.6, 2.5, 'k_o', 'FontSize', 24, 'FontWeight', 'bold', 'Color', [0, 0.447, 0.741]);
text(2.7, 1.65, '\theta', 'FontSize', 22, 'FontWeight', 'bold');
text(2.0, 1.1, 'a', 'FontSize', 22, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(1.4, 4.6, 'Vertical Guide', 'FontSize', 16, 'FontWeight', 'bold', 'Color', [0.3, 0.3, 0.3]);

% Limits and format
xlim([-6, 6]);
ylim([-0.5, 5.5]);
axis off;

title('Figure 1: Mechanical Layout Visualization of the QZS Mechanism', 'FontSize', 20, 'FontWeight', 'bold');

% Save result using print_fig
print_fig('results/carrella_fig1_layout.png');
fprintf('Figure 1 layout schematic generated successfully.\n');
