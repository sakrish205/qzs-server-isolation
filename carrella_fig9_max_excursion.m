% =====================================================================
% fig9_max_excursion.m
% Carrella et al. (2007) - FIGURE 9
% Max excursion delta_hat vs prescribed stiffness K_hat_o
% Numerical: optimise gamma in Eq.14 for each K_o
% Analytical: Eq.20 using approximate gamma_opt from Eq.19
% =====================================================================
run('parameters.m');

Ko_range = linspace(0.001, 1, 200);
delta_num = zeros(size(Ko_range));
delta_ana = zeros(size(Ko_range));

for i = 1:length(Ko_range)
    Ko = Ko_range(i);
    % Numerical: search optimal gamma that maximises delta (Eq. 14)
    best = 0;
    for g = 0.01:0.001:0.99
        inner = 1/(1 - Ko*(1-g));
        if inner > 0
            val = inner^(2/3) - 1;
            if val >= 0
                d = g*sqrt(val);
                if d > best; best = d; end
            end
        end
    end
    delta_num(i) = best;
    % Analytical: Eq.19 -> Eq.20
    g_opt = (2/3)^((Ko/2)+1);
    inner = 1/(1 - Ko*(1-g_opt));
    if inner > 0
        val = inner^(2/3) - 1;
        if val >= 0; delta_ana(i) = g_opt*sqrt(val); end
    end
end

figure;
plot(Ko_range, delta_num, 'b-', 'LineWidth', lw_thick, 'DisplayName', 'Numerical (Eq. 14)');
hold on;
plot(Ko_range, delta_ana, 'r--', 'LineWidth', lw_medium, 'DisplayName', 'Analytical (Eq. 20)');
xlabel('\hat{K}_o','FontSize',14); ylabel('\hat{\delta}_{max}','FontSize',14);
title('Maximum excursion from equilibrium (Carrella Fig. 9)','FontSize',13);
legend('Location', 'eastoutside'); grid on;
xlim([0 1]); set(gca,'FontSize',12);
print_fig('results/carrella_fig9_max_excursion.png');
fprintf('carrella_figure 9 saved to results/\n');
