% qzs_fig2_vector.m
% Generates Figure 2: Vector Geometry and Variable Definition of the QZS System
clear; close all;
run('qzs_style_header.m');

% Figure setup
figure;
hold on; grid off;
set(gca, 'Color', 'w');

% Define coordinate values
a_val = 3.5;
z0_val = 4.0;
z_val = 2.0;

% Draw main axes lines
plot([-1, 5], [0, 0], 'k-', 'LineWidth', 2.5); % Horizontal pivot axis
plot([0, 0], [-1, 5.5], 'k-', 'LineWidth', 2.5); % Vertical guide axis

% Draw free state (dashed line)
plot([a_val, 0], [0, z0_val], 'k--', 'LineWidth', 2.5);

% Draw compressed state (solid blue line)
plot([a_val, 0], [0, z_val], 'b-', 'LineWidth', 3.5);

% Draw joints
plot(a_val, 0, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);
plot(0, z0_val, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 10, 'LineWidth', 2);
plot(0, z_val, 'ko', 'MarkerFaceColor', 'r', 'MarkerSize', 10, 'LineWidth', 2);

% Draw dimension lines for x (vertical displacement)
plot([-0.3, -0.3], [z_val, z0_val], 'k-', 'LineWidth', 1.5);
plot([-0.5, -0.1], [z_val, z_val], 'k-', 'LineWidth', 1.5);
plot([-0.5, -0.1], [z0_val, z0_val], 'k-', 'LineWidth', 1.5);

% Draw dimension line for a (horizontal pivot spacing)
plot([0, a_val], [-0.5, -0.5], 'k-', 'LineWidth', 1.5);
plot([0, 0], [-0.7, -0.3], 'k-', 'LineWidth', 1.5);
plot([a_val, a_val], [-0.7, -0.3], 'k-', 'LineWidth', 1.5);

% Angle indicator arc for theta
t_theta = linspace(pi, pi - atan2(z_val, a_val), 30);
plot(a_val + 0.8 * cos(t_theta), 0.8 * sin(t_theta), 'k-', 'LineWidth', 1.5);

% Text Labels (Huge, bold, Times New Roman - shifted to prevent overlapping)
text(2.0, 2.6, 'L_0 (Free State)', 'FontSize', 22, 'FontWeight', 'bold', 'Color', [0.4, 0.4, 0.4]);
text(1.0, 0.6, 'L (Compressed State)', 'FontSize', 22, 'FontWeight', 'bold', 'Color', [0, 0.447, 0.741]);
text(-0.8, (z_val + z0_val)/2, 'x', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(a_val/2, -0.8, 'a', 'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(2.5, 0.2, '\theta', 'FontSize', 24, 'FontWeight', 'bold');

text(a_val, -0.4, 'Pivot (a, 0)', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
text(-0.3, z0_val, 'z_0', 'FontSize', 22, 'FontWeight', 'bold', 'HorizontalAlignment', 'right');
text(-0.3, z_val, 'z', 'FontSize', 22, 'FontWeight', 'bold', 'HorizontalAlignment', 'right');
text(0.1, 5.2, 'Vertical Axis', 'FontSize', 18, 'FontWeight', 'bold');
text(4.8, -0.3, 'Pivot Line', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'right');

% Limits and format
xlim([-1.5, 5.5]);
ylim([-1.5, 6.0]);
axis off;

title('Figure 2: Vector Geometry and Variable Definition of the QZS System', 'FontSize', 20, 'FontWeight', 'bold');

% Save result using print_fig
print_fig('results/qzs_fig2_vector.png');
fprintf('Figure 2 vector schematic generated successfully.\n');
