% carrella_experiment12_failure_random.m
% Generates Figure 19: QZS Snap-Through Failure Limits and PSD Performance
clear; close all;
run('carrella_style_header.m');

% 1. Sweeping Ground Acceleration for Snap-Through Bifurcation
pga_vals = linspace(0.1, 3.0, 15); % PGA values in g's
peak_disp = zeros(size(pga_vals));

m = 25;                  
kv = 49050;              
ko = 49050;              
L0 = 0.05;               
gamma_val = 2/3;         
a = gamma_val * L0;      
x_eq = L0 * sqrt(1 - gamma_val^2); 
zeta = 0.05;             
c = 2 * zeta * sqrt(kv * m); 

f_res = @(u) kv * u + 2 * ko * (1 - L0 ./ sqrt((u + x_eq).^2 + a^2)) .* (u + x_eq);

fprintf('Running Snap-Through Simulation Sweep...\n');
for k = 1:length(pga_vals)
    pga = pga_vals(k) * 9.81; % Convert to m/s^2
    % Short harmonic pulse to test stability
    w_exc = 2 * pi * 2.5; 
    ag_func = @(t) pga * sin(w_exc * t) .* (t < 5.0);
    
    ode_sys = @(t, y) [y(2); - (c/m)*y(2) - f_res(y(1))/m - ag_func(t)];
    [t, sol] = ode45(ode_sys, [0, 8.0], [0; 0]);
    
    peak_disp(k) = max(abs(sol(:, 1))) * 1000; % peak deflection in mm
end

% 2. Power Spectral Density (PSD) Analysis for Random Excitation
% Generating random hum as a sum of sinusoids between 10 Hz and 50 Hz with random phases
fs = 500; % Sampling rate (Hz)
t_rand = 0:1/fs:10;
ag_rand = zeros(size(t_rand));
num_freqs = 30;
freqs = linspace(10, 50, num_freqs);
rand('state', 42); % Seed for reproducible random phases in Octave
for k = 1:num_freqs
    phi = 2 * pi * rand();
    ag_rand = ag_rand + 0.15 * sin(2 * pi * freqs(k) * t_rand + phi);
end

% Solve linear and non-linear response to random hum
ode_sys_rand = @(t, y) [y(2); - (c/m)*y(2) - f_res(y(1))/m - interp1(t_rand, ag_rand, max(0, min(t, 10)))];
[t_out, sol_rand] = ode45(ode_sys_rand, [0, 10.0], [0; 0]);

% Resample outputs for FFT
u_rand = interp1(t_out, sol_rand(:, 1), t_rand)';
ar_rand = - (c/m)*sol_rand(:, 2) - f_res(sol_rand(:, 1))/m; % Rack acceleration
ar_rand_resamp = interp1(t_out, ar_rand, t_rand)';

% Compute PSD using FFT
N = length(t_rand);
f_fft = (0:N-1)*(fs/N);
fft_in = fft(ag_rand)/N;
fft_out = fft(ar_rand_resamp)/N;

psd_in = abs(fft_in).^2;
psd_out = abs(fft_out).^2;

% Keep only positive frequencies
keep_idx = 1:floor(N/2);
f_fft = f_fft(keep_idx);
psd_in_db = 10 * log10(psd_in(keep_idx) + 1e-10);
psd_out_db = 10 * log10(psd_out(keep_idx) + 1e-10);

% 3. Visualization
figure;

% Subplot 1: Snap-through Bifurcation
subplot(2, 1, 1);
plot(pga_vals, peak_disp, 'ro-', 'LineWidth', 2.0, 'MarkerFaceColor', 'r');
hold on; grid on;
plot([0.1, 3.0], [18.5, 18.5], 'k--', 'LineWidth', 1.5);
text(0.5, 20.5, 'Stability Excursion Limit (18.5 mm)', 'Color', 'k', 'FontSize', 10);
title('Figure 19a: Peak Rack Excursion vs. Base Acceleration (Snap-Through Threshold)', 'Interpreter', 'tex');
xlabel('Base Acceleration PGA (g)', 'Interpreter', 'tex');
ylabel('Peak Deflection (mm)', 'Interpreter', 'tex');
xlim([0.1, 3.0]);
ylim([0, 45]);

% Subplot 2: Random PSD Attenuation
subplot(2, 1, 2);
plot(f_fft, psd_in_db, 'Color', [0.6, 0.6, 0.6], 'LineWidth', 1.5, 'DisplayName', 'Floor Hum Acceleration (Input)');
hold on; grid on;
plot(f_fft, psd_out_db, 'b-', 'LineWidth', 2.0, 'DisplayName', 'Server Rack Acceleration (QZS Output)');
title('Figure 19b: Power Spectral Density (PSD) Random Vibration Attenuation', 'Interpreter', 'tex');
xlabel('Frequency (Hz)', 'Interpreter', 'tex');
ylabel('Power Spectral Density (dB/Hz)', 'Interpreter', 'tex');
legend('Location', 'northeast');
xlim([2, 100]);
ylim([-90, -10]);

% Save result
print_fig('results/carrella_exp12_failure_random.png');
fprintf('Experiment 12: Failure limit and PSD completed successfully.\n');
