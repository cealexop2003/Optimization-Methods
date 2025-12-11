% src/experiments/ex_golden.m
% Experiments for Golden-Section Search (2)

clear; clc;

% 1) Load test functions and common interval
[fs, names, a, b] = test_functions();

if ~exist(fullfile('figs'),'dir'); mkdir('figs'); end

% ================== (A) Sweep l, measure #f-calls ==================
cfg.param_name = "l";                         % we sweep l (no eps in golden section)
cfg.values     = [1e-1 5e-2 2e-2 1e-2 5e-3 3e-3];  % adjust if you want

resA = harness_run(@golden_section, fs, names, a, b, cfg);

% Plot: #f-calls vs l (one curve per f; they should coincide theoretically)
l_vs_eps(resA, '#f-calls vs l (Golden-Section)');
% Optional: log-scale on x for a clearer trend
set(gca,'XScale','log');
saveas(gcf, fullfile('figs','golden_calls_vs_l.png'));

% ================== (B) Interval history for multiple l ==============
histLs = [1e-1 2e-2 1e-2 5e-3];   % choose a few l values
cfgH.param_name = "l";
cfgH.values     = histLs;

for iF = 1:numel(fs)
    resH = harness_run(@golden_section, fs(iF), names(iF), a, b, cfgH);
    plot_interval_history(resH, sprintf('Golden-Section — interval history (%s)', names{iF}));
    saveas(gcf, fullfile('figs', sprintf('golden_interval_history_%s.png', names{iF})));
end

disp('OK: ex_golden finished. Figures saved in /figs');
