% Experiments for Fibonacci search (3)

clear; clc;

[fs, names, a, b] = test_functions();
if ~exist('figs','dir'), mkdir('figs'); end

% (A) Sweep l, fixed eps (only Fibonacci uses eps at the final step)
cfg.param_name = "l";
cfg.values     = [1e-1 5e-2 2e-2 1e-2 5e-3 3e-3];
cfg.eps        = 1e-3;   % small tie-breaker at Step 5

resA = harness_run(@fibonacci, fs, names, a, b, cfg);
l_vs_eps(resA, '#f-calls vs l (Fibonacci)');
set(gca,'XScale','log');
saveas(gcf, fullfile('figs','fibonacci_calls_vs_l.png'));

% (B) Interval history (same f, multiple l)
histLs = [1e-1 2e-2 1e-2 5e-3];
cfgH.param_name = "l";
cfgH.values     = histLs;
cfgH.eps        = 1e-3;

for iF = 1:numel(fs)
    resH = harness_run(@fibonacci, fs(iF), names(iF), a, b, cfgH);
    plot_interval_history(resH, sprintf('Fibonacci — interval history (%s)', names{iF}));
    saveas(gcf, fullfile('figs', sprintf('fibonacci_interval_history_%s.png', names{iF})));
end

disp('OK: ex_fibonacci finished. Figures saved in /figs');
