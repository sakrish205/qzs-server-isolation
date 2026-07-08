% =====================================================================
% fig6_qzs_combinations.m
% Carrella et al. (2007) - FIGURE 6
% gamma vs alpha combinations that yield QZS
% Eq. 11b: alpha_QZS = gamma / [2*(1-gamma)]
% =====================================================================
run('parameters.m');

gamma_range = linspace(0.01, 0.99, 500);
% Eq. 11b
alpha_qzs = gamma_range ./ (2*(1 - gamma_range));

figure;
semilogy(gamma_range, alpha_qzs, 'b-', 'LineWidth', lw_thick);
hold on;
plot(gamma, alpha, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r', ...
     'DisplayName', ['Current Design: \gamma = ' num2str(gamma,'%.3f') ', \alpha = ' num2str(alpha,'%.3f')]);
xlabel('Geometric parameter \gamma = a / L_0','FontSize',14);
ylabel('Stiffness ratio \alpha = k_o / k_v','FontSize',14);
title('QZS parameter combinations (Carrella Fig. 6)','FontSize',13);
legend('QZS condition (Eq. 11)', ...
       ['Current Design: \gamma = ' num2str(gamma,'%.3f')], ...
       'Location', 'eastoutside','FontSize',12);
grid on; xlim([0 1]); ylim([0.01 100]); set(gca,'FontSize',12);
print_fig('results/carrella_fig6_qzs_combinations.png');
fprintf('carrella_figure 6 saved to results/\n');
