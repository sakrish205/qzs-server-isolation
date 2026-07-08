% =====================================================================
% fig5_stiffness.m
% Carrella et al. (2007) - FIGURE 5
% Non-dimensional stiffness vs displacement, alpha = 1
% Eq. 10: K_hat = 1 + 2*alpha*[1 - g^2/(x^2-2*sqrt(1-g^2)*x+1)^(3/2)]
% QZS curve shows K=0 at equilibrium x_e = sqrt(1-g^2)
% =====================================================================
run('parameters.m');

alpha_plot = 1;
gamma_qzs = 2*alpha_plot/(2*alpha_plot+1);
% Carrella Fig. 5: gamma values with x_e all safely inside ŷ domain.
% x_e = sqrt(1-g^2): 0.4->0.917, 0.5->0.866, 2/3->0.745, 0.8->0.600
% All give non-singular stiffness curves across ŷ in [-0.5, 0.5].
gamma_vals = [0.05, 0.40, gamma_qzs, 0.95];


y_hat = linspace(-0.5, 0.5, 2000);


figure;
hold on;
for i = 1:length(gamma_vals)
    g = gamma_vals(i);
    x_e = sqrt(1 - g^2);
    x_hat = x_e + y_hat;
    
    % Eq. 10
    K_hat = 1 + 2*alpha_plot*(1 - g^2 ./ ...
            max((x_hat.^2 - 2*sqrt(1-g^2)*x_hat + 1), 1e-6).^(1.5));
    if abs(g - gamma_qzs) < 0.01
        plot(y_hat, K_hat, 'k-', 'LineWidth', lw_thick, ...
             'DisplayName', ['\gamma_{QZS} = ' num2str(g,'%.4f') ' (QZS)']);
    else
        plot(y_hat, K_hat, '--', 'LineWidth', lw_thin, ...
             'DisplayName', ['\gamma = ' num2str(g)]);
    end
end
plot([-0.5 0.5], [0 0], 'r--', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
x_e_qzs = sqrt(1 - gamma_qzs^2);
plot(0, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', ...
     'DisplayName', ['x_{e,hat} = ' num2str(x_e_qzs,'%.3f')]);
xlabel('y_{hat} = x_{hat} - x_{e,hat}','Interpreter','tex');
ylabel('K_{hat} = K / k_v','Interpreter','tex');
title(['Non-dimensional stiffness, \alpha = ' num2str(alpha_plot) ' (Carrella Fig. 5)'], 'Interpreter', 'tex');
legend('Location', 'eastoutside'); grid on;
print_fig('results/qzs_fig5_stiffness.png');
fprintf('carrella_figure 5 saved to results/\n');
