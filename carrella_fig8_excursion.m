% =====================================================================
% fig8_excursion.m
% Carrella et al. (2007) - FIGURE 8
% Excursion delta_hat vs gamma_QZS for various K_hat_o
% Eq. 14: delta = gamma * sqrt{[1/(1-Ko*(1-gamma))]^(2/3) - 1}
% =====================================================================
run('parameters.m');

gamma_range = linspace(0.01, 0.99, 500);
Ko_vals = [0.01, 0.1, 0.5, 1.0];

figure;
hold on;
styles = {'-','--','-.',':'};
for i = 1:length(Ko_vals)
    Ko = Ko_vals(i);
    delta_hat = zeros(size(gamma_range));
    for j = 1:length(gamma_range)
        g = gamma_range(j);
        % Eq. 14
        inner = 1/(1 - Ko*(1-g));
        if inner > 0
            val = inner^(2/3) - 1;
            if val >= 0; delta_hat(j) = g*sqrt(val);
            else; delta_hat(j) = NaN; end
        else; delta_hat(j) = NaN;
        end
    end
    plot(gamma_range, delta_hat, styles{i}, 'LineWidth', lw_medium, ...
         'DisplayName', ['\hat{K}_o = ' num2str(Ko)]);
end
xlabel('\gamma_{QZS}','FontSize',14); ylabel('\hat{\delta}','FontSize',14);
title('Excursion from equilibrium (Carrella Fig. 8)','FontSize',13);
legend('Location', 'eastoutside'); grid on;
xlim([0 1]); set(gca,'FontSize',12);
print_fig('results/carrella_fig8_excursion.png');
fprintf('carrella_figure 8 saved to results/\n');
