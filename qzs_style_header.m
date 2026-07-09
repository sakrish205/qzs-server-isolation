% =====================================================================
% qzs_style_header.m
% Global styling for Elsevier-standard publication figures
% Adjusted for EastOutside legends as requested by the user.
% =====================================================================

% Run the base configuration to load all parameters
run('parameters.m');

% 1. Typography & Font Sizes
set(0, 'DefaultTextFontName', 'Times New Roman');
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultAxesFontSize', 18);
set(0, 'DefaultTextFontSize', 18);
set(0, 'DefaultTextInterpreter', 'tex');
if ~exist('OCTAVE_VERSION', 'builtin')
    % MATLAB-only properties; Octave's root graphics object does not support these
    set(0, 'DefaultAxesLabelFontSizeMultiplier', 1.2);
    set(0, 'DefaultAxesTitleFontSizeMultiplier', 1.3);
    set(0, 'DefaultLegendFontSize', 16);
end

% 2. Line & Element Styling
set(0, 'DefaultLineLineWidth', lw_default);
set(0, 'DefaultAxesLineWidth', 1.0);
set(0, 'DefaultAxesBox', 'on');
set(0, 'DefaultAxesTickDir', 'in');
set(0, 'DefaultAxesTickLength', [0.015, 0.015]);

% 3. Grayscale-Friendly Color Palette
new_colors = [
    0.000, 0.447, 0.741; % Blue
    0.850, 0.325, 0.098; % Rust
    0.466, 0.674, 0.188; % Green
    0.494, 0.184, 0.556; % Purple
    0.929, 0.694, 0.125  % Gold
];
set(0, 'DefaultAxesColorOrder', new_colors);

% 4. Figure Size (Wider to accommodate EastOutside legends)
set(0, 'DefaultFigureUnits', 'pixels');
set(0, 'DefaultFigurePosition', [100, 100, 1500, 900]);

% 5. Print Utility Function
% Use this to save all figures to ensure 600 DPI and consistent width
% Usage: print_fig('results/my_figure.png')
% Note: In scripts, this behaves as a command. In Octave, we keep it separate
% or define it in a way that doesn't break the script flow.
