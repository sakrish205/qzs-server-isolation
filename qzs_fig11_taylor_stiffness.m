% =====================================================================
% fig11_taylor_stiffness.m
% Carrella et al. (2007) - FIGURE 11
% Stiffness with Taylor series approximations
% gamma = 2/3, alpha = 1
% Eq. 29: K_approx = 3*c3*y^2 + 5*c5*y^4 + 7*c7*y^6
%
% Same analytical derivation as Fig 10:
%   D = g^2 + y^2 exactly about equilibrium.
%   K(y) = dF/dy => K_approx coefficients are derivatives of F Taylor series.
%   c3 = a/g^3,  c5 = -3a/(4g^5),  c7 = 5a/(8g^7)
% =====================================================================
run('parameters.m');

g = gamma;
a = alpha;
x_e = sqrt(1 - g^2);
c3 = a / g^3;
y_hat = linspace(-0.3, 0.3, 600);
x_hat = y_hat + x_e;

% Exact stiffness (Eq. 10 with QZS params)
K_exact = 1 + 2*a*(1 - g^2 ./ ...
          max((x_hat.^2 - 2*sqrt(1-g^2)*x_hat + 1), 1e-6).^(1.5));

% Analytical Taylor coefficients (see Fig 10 derivation — same c3,c5,c7)
% Fully parameterised in g and a, no hardcoded numbers.
c3 =  a   / g^3;        % Eq. 28/29
c5 = -3*a / (4*g^5);
c7 =  5*a / (8*g^7);

% Stiffness = dF/dy => K_n = n*c_n * y^(n-1)
K_3rd = 3*c3*y_hat.^2;
K_5th = 3*c3*y_hat.^2 + 5*c5*y_hat.^4;
K_7th = 3*c3*y_hat.^2 + 5*c5*y_hat.^4 + 7*c7*y_hat.^6;

figure;
hold on;
plot(y_hat, K_exact, 'k-',  'LineWidth', lw_thick, 'DisplayName', 'Exact (Eq. 12)');
plot(y_hat, K_3rd,   'r--', 'LineWidth', lw_medium,   'DisplayName', '3rd order (Eq. 29)');
plot(y_hat, K_5th,   'b-.', 'LineWidth', lw_medium, 'DisplayName', '5th order');
plot(y_hat, K_7th,   'g:',  'LineWidth', lw_medium, 'DisplayName', '7th order');
xlabel('\hat{y} = \hat{x} - \hat{x}_e', 'FontSize', 14);
ylabel('\hat{K}', 'FontSize', 14);
title(['Stiffness with Taylor expansions, \gamma=' num2str(g,'%.3f') ', \alpha=' num2str(a,'%.3f') ' (Carrella Fig. 11)'], 'FontSize', 13);
legend('Location', 'eastoutside'); grid on;
xlim([-0.3 0.3]); ylim([0 1.2]); set(gca, 'FontSize', 12);
print_fig('results/qzs_fig11_taylor_stiffness.png');
fprintf('carrella_figure 11 saved to results/\n');
