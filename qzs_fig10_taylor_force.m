% =====================================================================
% fig10_taylor_force.m
% Carrella et al. (2007) - FIGURE 10
% Force-displacement of QZS mechanism with Taylor series approximations
% gamma = 2/3, alpha = 1
% Eq. 28 (cubic): F_hat(y) ~ c3*y^3
% y_hat = x_hat - x_e  (displacement about equilibrium)
%
% Derivation of Taylor coefficients (no hardcoding, all from g and a):
%   About x_e = sqrt(1-g^2), the denominator D = x^2-2*x_e*x+1
%   simplifies EXACTLY to D = g^2 + y^2.
%   F(y) = (1+2a)*y - (2a*y/g)*(1 + y^2/g^2)^(-1/2)
%   Binomial expansion of (1+u)^(-1/2), u = y^2/g^2:
%     = 1 - u/2 + 3u^2/8 - 5u^3/16 + ...
%   At QZS: 1+2a = 2a/g => linear term vanishes.
%   Coefficients of y^3, y^5, y^7:
%     c3 =  a/g^3   (= 1/(2*g^2*(1-g)) at QZS, Eq. 28)
%     c5 = -3a/(4*g^5)
%     c7 =  5a/(8*g^7)
% =====================================================================
run('parameters.m');

% Use parameters from parameters.m
g = gamma;
a = alpha;
x_e = sqrt(1 - g^2);
y_hat = linspace(-0.3, 0.3, 600);
x_hat = y_hat + x_e;

% Exact force (Eq. 9) with static offset removed
f_exact = x_hat + 2*a*(sqrt(1-g^2) - x_hat) .* ...
          (max((x_hat.^2 - 2*sqrt(1-g^2)*x_hat + 1), 1e-6).^(-0.5) - 1);
F_exact = f_exact - x_e;

% Analytical Taylor coefficients — derived from binomial expansion of
% (g^2 + y^2)^(-1/2) about equilibrium. Fully parameterised in g and a.
c3 =  a       / g^3;        % Eq. 28: equals 1/(2*g^2*(1-g)) at QZS
c5 = -3*a     / (4*g^5);    % 5th-order binomial term
c7 =  5*a     / (8*g^7);    % 7th-order binomial term

F_3rd = c3*y_hat.^3;
F_5th = c3*y_hat.^3 + c5*y_hat.^5;
F_7th = c3*y_hat.^3 + c5*y_hat.^5 + c7*y_hat.^7;

figure;
hold on;
plot(y_hat, F_exact, 'k-',  'LineWidth', lw_thick, 'DisplayName', 'Exact');
plot(y_hat, F_3rd,   'r--', 'LineWidth', lw_medium,   'DisplayName', '3rd order (Eq. 28)');
plot(y_hat, F_5th,   'b-.', 'LineWidth', lw_medium, 'DisplayName', '5th order');
plot(y_hat, F_7th,   'g:',  'LineWidth', lw_medium, 'DisplayName', '7th order');
xlabel('\hat{y} = \hat{x} - \hat{x}_e', 'FontSize', 14);
ylabel('\hat{F}', 'FontSize', 14);
title(['Force with Taylor expansions, \gamma=' num2str(g,'%.3f') ', \alpha=' num2str(a,'%.3f') ' (Carrella Fig. 10)'], 'FontSize', 13);
legend('Location', 'eastoutside'); grid on;
xlim([-0.3 0.3]); ylim([-0.2 0.2]); set(gca, 'FontSize', 12);
print_fig('results/qzs_fig10_taylor_force.png');
fprintf('carrella_figure 10 saved to results/\n');
