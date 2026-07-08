% =====================================================================
% fig4_full_system_force.m
% Carrella et al. (2007) - FIGURE 4
% Force-displacement of three-spring system, alpha = 1
% Eq. 9: f_hat = x_hat + 2*alpha*(sqrt(1-g^2) - x_hat) *
%         {[x_hat^2 - 2*sqrt(1-g^2)*x_hat + 1]^(-1/2) - 1}
% Solid line = QZS system (gamma_QZS = 2*alpha/(2*alpha+1))
% =====================================================================
run('parameters.m');

x_hat = linspace(0, 2, 500);
alpha_plot = 1;
gamma_qzs = 2*alpha_plot/(2*alpha_plot+1);  % = 2/3
% Carrella Fig. 4: representative spread bracketing QZS design point.
% gamma < gamma_QZS => positive stiffness at equil. gamma > gamma_QZS => negative.
gamma_vals = [0.05, 0.40, gamma_qzs, 0.80, 0.95];

figure;
hold on;
for i = 1:length(gamma_vals)
    g = gamma_vals(i);
    % Eq. 9
    f_hat = x_hat + 2*alpha_plot*(sqrt(1-g^2) - x_hat) .* ...
            (max((x_hat.^2 - 2*sqrt(1-g^2)*x_hat + 1), 1e-6).^(-0.5) - 1);
    if abs(g - gamma_qzs) < 0.01
        plot(x_hat, f_hat, 'k-', 'LineWidth', lw_thick, ...
             'DisplayName', ['\gamma_{QZS} = ' num2str(g,'%.4f') ' (QZS)']);
    else
        plot(x_hat, f_hat, '--', 'LineWidth', lw_thin, ...
             'DisplayName', ['\gamma = ' num2str(g)]);
    end
end
xlabel('x_{hat} = x / L_0','Interpreter','tex');
ylabel('f_{hat} = f / (k_v L_0)','Interpreter','tex');
title(['Force-displacement: \alpha = ' num2str(alpha_plot) ' (Carrella Fig. 4)'], 'Interpreter', 'tex');
legend('Location', 'eastoutside'); grid on;
print_fig('results/qzs_fig4_full_system_force.png');
fprintf('carrella_figure 4 saved to results/\n');
