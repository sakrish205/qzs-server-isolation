% =====================================================================
% fig12_approx_error.m
% Carrella et al. (2007) - FIGURE 12
% Error in cubic stiffness approximation evaluated at max excursion
% Eq. 30: error(%) = |1 - K_approx/K_exact| * 100
% K_approx = Eq.29, K_exact = Eq.12, evaluated at delta for each K_o
% =====================================================================
run('parameters.m');

Ko_range = linspace(0.01, 1, 200);
error_pct = zeros(size(Ko_range));

g = gamma;
a = alpha;
x_e = sqrt(1 - g^2);
c3 = a / g^3;

for i = 1:length(Ko_range)
    Ko = Ko_range(i);
    % Eq. 14: max excursion at stiffness Ko (exact inversion of stiffness eqn)
    inner = 1 / (1 - Ko*(1 - g));
    if inner > 0
        val = inner^(2/3) - 1;
        if val >= 0
            delta = g * sqrt(val);
            y_val  = delta;
            x_val  = x_e + delta;
            % Exact stiffness at that excursion (Eq. 10/12)
            den      = max((x_val^2 - 2*sqrt(1-g^2)*x_val + 1), 1e-6)^(1.5);
            K_exact  = 1 + 2*a*(1 - g^2 / den);
            % Approximate stiffness (Eq. 29)
            K_approx = 3*c3*y_val^2;
            if K_exact ~= 0
                error_pct(i) = abs(1 - K_approx/K_exact)*100;
            end
        end
    end
end

figure;
plot(Ko_range, error_pct, 'b-', 'LineWidth', lw_thick, 'DisplayName', 'Cubic approximation error');
xlabel('\hat{K}_o','FontSize',14);
ylabel('Error (%)','FontSize',14);
legend('Location', 'eastoutside');
title('Error in cubic stiffness approximation (Carrella Fig. 12)','FontSize',13);
grid on; xlim([0 1]); set(gca,'FontSize',12);
print_fig('results/qzs_fig12_approx_error.png');
fprintf('carrella_figure 12 saved to results/\n');
