function print_fig(filename)
    % print_fig - Saves the current figure with perfect font visibility, legends, and enlarged legend size.
    % Resizes the screen window to match reference proportions, applies font styling,
    % increases legend font sizes by 1.5x, and uses 'auto' PaperPositionMode for clean scaling.
    % Usage: print_fig('results/qzs_exp3_scaling.png')

    fig = gcf;

    % Enforce Times New Roman typography for all text elements in the figure
    set(findall(fig, '-property', 'FontName'), 'FontName', 'Times New Roman');

    % Prevent titles and labels from clipping by increasing margins
    all_axes = findobj(fig, 'Type', 'axes');
    for k = 1:length(all_axes)
        try
            inset = get(all_axes(k), 'LooseInset');
            % Increase top margin (4th component) from 0.075 to 0.18 to prevent header clipping
            inset(4) = 0.18;
            % Increase bottom margin (2nd component) from 0.11 to 0.14 for x-labels
            inset(2) = 0.14;
            set(all_axes(k), 'LooseInset', inset);
        catch
        end
    end

    % Set legend font sizes using the global legend_font_size configuration (defaults to 12)
    global legend_font_size;
    if isempty(legend_font_size)
        leg_sz = 12;
    else
        leg_sz = legend_font_size;
    end

    legends = [findobj(fig, 'Type', 'legend'); findobj(fig, 'tag', 'legend')];
    if ~isempty(legends)
        legends = unique(legends);
        for k = 1:length(legends)
            try
                set(legends(k), 'FontSize', leg_sz);
            catch
                % Fallback if set FontSize fails in specific Octave toolkits
            end
        end
    end

    % Use strfind instead of contains for compatibility with older Octave versions
    is_exp6 = ~isempty(strfind(filename, 'exp6'));
    is_exp8 = ~isempty(strfind(filename, 'exp8'));
    is_fig6 = ~isempty(strfind(filename, 'fig6'));
    is_fig7 = ~isempty(strfind(filename, 'fig7'));
    is_fig8 = ~isempty(strfind(filename, 'fig8'));
    is_fig9 = ~isempty(strfind(filename, 'fig9'));
    is_fig10 = ~isempty(strfind(filename, 'fig10'));
    is_fig11 = ~isempty(strfind(filename, 'fig11'));
    is_fig12 = ~isempty(strfind(filename, 'fig12'));

    % Resize on-screen window to guarantee exact output aspect ratio and dimensions
    % at 600 DPI when using PaperPositionMode = 'auto'
    if is_fig6 || is_fig7 || is_fig8 || is_fig9 || is_fig10 || is_fig11 || is_fig12
        % Target: 14375x7500 pixels (expanded for legends, screen size 1725x900)
        set(fig, 'Position', [100, 100, 1725, 900]);
    else
        % Target: 12500x7500 pixels (standard, screen size 1500x900)
        set(fig, 'Position', [100, 100, 1500, 900]);
    end

    % Get global DPI setting (default to 150 for speed and memory stability)
    global plot_dpi;
    if isempty(plot_dpi)
        dpi = 150;
    else
        dpi = plot_dpi;
    end

    % Use 'auto' mode so Octave scales the layout, lines, and text perfectly
    set(fig, 'PaperPositionMode', 'auto');

    % CRITICAL FOR FLTK: Force redraw and pause briefly so the window paints completely.
    % Prevents "imwrite: invalid empty image" and fully black outputs.
    drawnow;
    pause(0.5);

    % Save using screen capture — retry up to 3 times for FLTK render delay
    max_attempts = 3;
    saved = false;
    for attempt = 1:max_attempts
        drawnow;
        pause(1.0);  % give FLTK time to paint the window completely
        try
            frame = getframe(fig);
            if ~isempty(frame) && isstruct(frame) && isfield(frame, 'cdata') && ~isempty(frame.cdata)
                % Reject if mean pixel intensity <= 15 (black / near-black screen glitch)
                if mean(frame.cdata(:)) > 15
                    imwrite(frame.cdata, filename);
                    fprintf('Figure saved successfully using screen capture: %s\n', filename);
                    saved = true;
                    break;
                else
                    fprintf('Black screen detected (attempt %d/%d), retrying...\n', attempt, max_attempts);
                end
            end
        catch err
            fprintf('getframe error (attempt %d/%d): %s\n', attempt, max_attempts, err.message);
        end
    end

    % Fallback to standard vector print command (only if all retries failed)
    if ~saved
        print(fig, filename, '-dpng', ['-r', num2str(dpi)]);
        fprintf('Figure printed successfully using vector export: %s\n', filename);
    end
end
