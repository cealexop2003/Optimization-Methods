function plot_interval_history(results, title_str)
% PLOT_INTERVAL_HISTORY  Plots a_k and b_k for different values of the swept parameter.
% Draws longer trajectories first (so shorter ones are not hidden) and highlights
% the final point of each curve.

    E = results.entries;
    if isempty(E), warning('plot_interval_history: empty results'); return; end

    % Sort so that longer histories are plotted first (shorter on top)
    lens = arrayfun(@(s) numel(s.a_hist), E);
    [~, ord] = sort(lens, 'descend');
    E = E(ord);

    figure;
    tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

    % --- Left endpoint (a_k) ---
    nexttile; hold on; grid on;
    for i = 1:numel(E)
        ak = E(i).a_hist; k = 0:numel(ak)-1;
        kstar = k(end);
        lbl = sprintf('%s = %.4g (k*=%d)', string(E(i).param_name), E(i).param_value, kstar);
        plot(k, ak, '-', 'DisplayName', lbl);
    end
    % emphasize final points
    for i = 1:numel(E)
        ak = E(i).a_hist; k = 0:numel(ak)-1;
        plot(k(end), ak(end), 'o', 'MarkerSize',8, 'MarkerFaceColor','auto', 'HandleVisibility','off');
    end
    xlabel('k'); ylabel('a_k'); title('Left endpoint'); legend('Location','best');

    % --- Right endpoint (b_k) ---
    nexttile; hold on; grid on;
    for i = 1:numel(E)
        bk = E(i).b_hist; k = 0:numel(bk)-1;
        kstar = k(end);
        lbl = sprintf('%s = %.4g (k*=%d)', string(E(i).param_name), E(i).param_value, kstar);
        plot(k, bk, '-', 'DisplayName', lbl);
    end
    % emphasize final points
    for i = 1:numel(E)
        bk = E(i).b_hist; k = 0:numel(bk)-1;
        plot(k(end), bk(end), 'o', 'MarkerSize',8, 'MarkerFaceColor','auto', 'HandleVisibility','off');
    end
    xlabel('k'); ylabel('b_k'); title('Right endpoint'); legend('Location','best');

    if nargin>=2 && ~isempty(title_str), sgtitle(title_str); end
end
