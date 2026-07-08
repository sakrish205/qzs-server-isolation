% =====================================================================
% fig7_qzs_stiffness.m
% Carrella et al. (2007) - FIGURE 7
% Stiffness for different QZS parameter combos (gamma,alpha linked by Eq.11)
% Eq. 12: K_QZS evaluated with QZS constraint
% =====================================================================
run('parameters.m');

y_hat = linspace(-0.5, 0.5, 2000);
% Carrella Fig. 7: three QZS parameter pairs spanning low/mid/high alpha.
% Each pair satisfies Eq. 11b: alpha = gamma/(2*(1-gamma)).
gamma_qzs_vals = [0.05, 0.40, 0.95];
styles = {'-', '--', '-.'};

figure;
hold on;
for i = 1:length(gamma_qzs_vals)
    g = gamma_qzs_vals(i);
    a = g / (2*(1-g));  % Eq. 11b
    x_e = sqrt(1 - g^2);
    x_hat = x_e + y_hat;
    % Eq. 12 (= Eq. 10 with QZS constraint applied)
    K_hat = 1 + 2*a*(1 - g^2 ./ ...
            max((x_hat.^2 - 2*sqrt(1-g^2)*x_hat + 1), 1e-6).^(1.5));
    plot(y_hat, K_hat, styles{i}, 'LineWidth', lw_medium, ...
         'DisplayName', ['\gamma = ' num2str(g,'%.2f') ', \alpha = ' num2str(a,'%.2f')]);
end
plot([-0.5 0.5], [0 0], 'r--', 'LineWidth', lw_thin, 'HandleVisibility', 'off');
plot([-0.5 0.5], [1 1], 'k:', 'LineWidth', lw_thin, 'DisplayName', '\hat{K} = 1');
xlabel('\hat{y}','FontSize',14); ylabel('\hat{K}_{QZS}','FontSize',14);
title('Stiffness for QZS combos (Carrella Fig. 7)','FontSize',13);
legend('Location', 'eastoutside'); grid on;
xlim([-0.5 0.5]); ylim([-2 6]); set(gca,'FontSize',12);
print_fig('results/qzs_fig7_qzs_stiffness.png');
fprintf('carrella_figure 7 saved to results/\n');
