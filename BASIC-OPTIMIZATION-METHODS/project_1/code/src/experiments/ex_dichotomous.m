clear; clc;

% 1) functions and [a, b]
[fs, names, a, b] = test_functions();

% ============ (A) Constant l = 0.01, run through eps ============
cfgA.param_name = "eps";
cfgA.values     = [4e-3 3e-3 2e-3 1e-3];   
cfgA.l          = 1e-2;                    

resA = harness_run(@dichotomous, fs, names, a, b, cfgA);
l_vs_eps(resA, '#f-calls vs \epsilon (l = 0.01 fixed)');
if ~exist(fullfile('figs'),'dir'); mkdir('figs'); end
saveas(gcf, fullfile('figs','dichotomous_calls_vs_eps_l001.png'));

% ============ (B)Constant eps = 0.001, run through l ============
cfgB.param_name = "l";
% l > 2*eps = 0.002 
cfgB.values     = [1e-1 5e-2 2e-2 1e-2 5e-3 3e-3];
cfgB.eps        = 1e-3;                     % const eps

resB = harness_run(@dichotomous, fs, names, a, b, cfgB);
l_vs_eps(resB, '#f-calls vs l (\epsilon = 0.001 fixed)');
saveas(gcf, fullfile('figs','dichotomous_calls_vs_l_eps0001.png'));

% ============ (C) Ιστορία άκρων [a_k, b_k] vs k ============
histLs = [1e-1 2e-2 1e-2 5e-3];   % some l values
epsH   = 1e-3;

for iF = 1:numel(fs)
    cfgH.param_name = "l";
    cfgH.values     = histLs;
    cfgH.eps        = epsH;

    % Run for the specific f_i
    resH = harness_run(@dichotomous, fs(iF), names(iF), a, b, cfgH);

    plot_interval_history(resH, sprintf('Dichotomous — interval history (%s)', names{iF}));
    saveas(gcf, fullfile('figs', sprintf('dichotomous_interval_history_%s.png', names{iF})));
end

disp('OK: ex_dichotomous finished. Figures saved in /figs');
