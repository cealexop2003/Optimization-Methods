% ex_bisection_derivative.m — Experiments for Derivative-based Bisection (4)

clear; clc;

% 1) Load test functions and the common interval
[fs, names, a, b] = test_functions();

% Ensure output folder exists
if ~exist('figs','dir'); mkdir('figs'); end

% ================== (A) Sweep l, measure #f-calls ==================
% We use numerical derivative (central difference) so f-calls are counted by the harness.
base.param_name = "l";                          % we sweep l (no eps here)
base.values     = [1e-1 5e-2 2e-2 1e-2 5e-3 3e-3];
base.h          = 1e-6;                         % central difference step
base.grad_tol   = 1e-12;                        % tolerance for |f'(x)| ≈ 0

merge = @(cfgFixed, cfgRun) setfield(cfgFixed, 'l', cfgRun.l); %#ok<SFLD>

% Run experiment A
resA = harness_run(@(f_in,a_in,b_in,run_cfg) ...
    bisection_derivative(f_in, a_in, b_in, merge(base, run_cfg)), ...
    fs, names, a, b, base);

% Plot: #f-calls vs l (expect ≈ 2 * ceil(log2(L0/l)) with L0 = b-a)
l_vs_eps(resA, '#f-calls vs l (Bisection with derivative)');
set(gca,'XScale','log');
saveas(gcf, fullfile('figs','bisectgrad_calls_vs_l.png'));

% ================== (B) Interval history [a_k, b_k] for multiple l ==================
histLs = [1e-1 2e-2 1e-2 5e-3];
baseH = base; baseH.values = histLs; baseH.param_name = "l";

for iF = 1:numel(fs)
    resH = harness_run(@(f_in,a_in,b_in,run_cfg) ...
        bisection_derivative(f_in, a_in, b_in, merge(baseH, run_cfg)), ...
        fs(iF), names(iF), a, b, baseH);

    plot_interval_history(resH, sprintf('Bisection (derivative) — interval history (%s)', names{iF}));
    saveas(gcf, fullfile('figs', sprintf('bisectgrad_interval_history_%s.png', names{iF})));
end

disp('OK: ex_bisection_derivative finished. Figures saved in /figs');
