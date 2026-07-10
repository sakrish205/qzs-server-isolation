% ===== parameters.m =====
% Unified configuration file for QZS Vibration Isolator Project
% Edit this file to modify rack parameters, design limits, and plotting styles.

% =====================================================================
% 1. RACK PARAMETERS & DESIGN LIMITS (Easy to Edit)
% =====================================================================
% Server rack masses to evaluate in parametric sweeps (kg)
rack_masses = [50, 100, 150]; 

% Target rack mass for single isolator analysis (kg) (e.g., in Exp 8)
target_rack_mass = 100;  % Heavy-duty 2U isolated shelf payload (m_iso = 100/4 = 25 kg per isolator)

% =====================================================================
% 2U RACK PHYSICAL DIMENSIONS (19-inch standard, EIA-310)
% =====================================================================
% 2U Rack Physical Dimensions
rack_width_mm    = 482.6;  % Full rack width (mm)
rack_usable_mm   = 450.0;  % Usable internal width (mm)
rack_height_2U   = 88.9;   % 2U chassis height (mm)

% Isolator base plate — matches rack footprint
base_plate_mm    = 482.0;  % Base plate width and depth (mm)
bolt_pattern_mm  = 465.0;  % Corner isolator bolt spacing (mm)
n_isolators      = 4;      % One QZS isolator per corner

% Per isolator mass (derived — do NOT hardcode separately)
m_iso = target_rack_mass / n_isolators;

% Static floor deflection limit (meters) - used to size vertical springs
delta_static = 0.005; % 5 mm

% Acceleration due to gravity (m/s^2)
g_accel = 9.81;

% =====================================================================
% 2. THEORETICAL DESIGN POINT (Carrella 2007)
% =====================================================================
% Geometric parameter (Eq. 16: optimal gamma = 2/3)
gamma = 2/3;

% Stiffness ratio (Eq. 11b: alpha = gamma / [2*(1-gamma)])
alpha = gamma / (2*(1 - gamma));   % = 1.0

% Spring natural length — sized for rack deployment
% Standard 2U rack clearance = 88.9mm; isolator fits in 50mm floor clearance
% a = gamma*L0 = 33.35mm, h0 = sqrt(L0^2-a^2) = 37.3mm
% Total height including 5mm deflection = 42.3mm — fits clearance
L0 = 0.05;   % 50 mm

% =====================================================================
% 3. BENCHMARK MOUNT PARAMETERS (Experiments 4, 5, 6)
% =====================================================================
% Damping ratios (zeta)
zeta_qzs = 0.05;
zeta_rubber = 0.07;
zeta_pneu = 0.03;

% Natural frequencies (Hz)
fn_qzs = 0.5;
fn_rubber = 8.0;
fn_pneu = 2.0;

% =====================================================================
% 4. PLOT LINE THICKNESS PARAMETERS (Globally Adjustable)
% =====================================================================
% Increase these values to make lines thicker across all figures
lw_thick = 3.5;       % Primary curves (e.g., QZS isolator response)
lw_medium = 2.5;      % Secondary curves (e.g., benchmark mounts)
lw_thin = 1.5;        % Reference lines, thresholds, and grids
lw_default = 2.0;     % Default line width fallback

% DPI configuration for figure prints (default 150 for speed and memory stability)
global plot_dpi;
plot_dpi = 150; 

% Global legend font size for figure exports
global legend_font_size;
legend_font_size = 24;  % doubled from 12 -- applies to all figures via print_fig
 

% Results directory
results_dir = 'results';
if ~exist(results_dir, 'dir'); mkdir(results_dir); end

disp('Theoretical and experimental parameters loaded successfully');
