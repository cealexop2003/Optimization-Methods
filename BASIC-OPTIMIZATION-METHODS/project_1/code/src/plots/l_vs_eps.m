function l_vs_eps(results, title_str)
% L_VS_EPS  One plot that has: #f-calls to "eps" or "l" (depending on the run).
% - It reads from results.entries(harness_run):
%     .fname (f1/f2/f3), .param_name ('eps' / 'l'), .param_value, .f_calls

    E = results.entries;
    if isempty(E), warning('l_vs_eps: empty results'); return; end

    fnames = unique(string({E.fname}));     
    xlab = string(E(1).param_name);         

    figure; hold on; grid on;

    for i = 1:numel(fnames)
        mask = strcmp(string({E.fname}), fnames(i));   
        x = [E(mask).param_value];
        y = [E(mask).f_calls];

        [x_sorted, idx] = sort(x);          
        y = y(idx);

        plot(x_sorted, y, '-o', 'DisplayName', fnames(i));
    end

    xlabel(xlab); ylabel('# f-calls');
    if nargin>=2 && ~isempty(title_str), title(title_str); end
    legend('Location','best');
end
