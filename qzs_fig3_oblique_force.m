% =====================================================================
% fig3_oblique_force.m
% Carrella et al. (2007) - FIGURE 3
% Force-deflection characteristic of oblique springs only
% Eq. 3: f/(ko*L0) = 2*(sqrt(1-g^2) - x_hat) *
%         {[x_hat^2 - 2*sqrt(1-g^2)*x_hat + 1]^(-1/2) - 1}
% =====================================================================
run('parameters.m');

x_hat = linspace(0, 2, 500);
% Carrella Fig. 3: representative spread from near-linear to nonlinear.
% Small gamma = springs nearly horizontal (strongly nonlinear).
% Large gamma = springs near-vertical (nearly linear).
gamma_vals = [0.05, 0.40, 0.95];

figure;
hold on;
for i = 1:length(gamma_vals)
    g = gamma_vals(i);
    % Eq. 3
    f_hat = 2*(sqrt(1-g^2) - x_hat) .* ...
            (max((x_hat.^2 - 2*sqrt(1-g^2)*x_hat + 1), 1e-6).^(-0.5) - 1);
    plot(x_hat, f_hat, 'LineWidth', lw_medium, ...
         'DisplayName', ['\gamma = ' num2str(g)]);
end
xlabel('x_{hat} = x / L_0','Interpreter','tex');
ylabel('f / (k_o L_0)','Interpreter','tex');
title(['Force-deflection: oblique springs only (\gamma sweep)'], 'Interpreter', 'tex');
legend('Location', 'eastoutside'); grid on;
print_fig('results/qzs_fig3_oblique_force.png');
fprintf('carrella_figure 3 saved to results/\n');
