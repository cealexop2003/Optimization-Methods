clc; clear; close all;

addpath("functions");
addpath("methods");
addpath("steps");
addpath("plots");

epsilon = 1e-6;
max_iters = 2000;



%% ======================================
%   SECTION 1: Plot the function
% ======================================
plot_f();
plot_contours();



%% ======================================
%   SECTION 2 — GRADIENT DESCENT METHODS
% ======================================

%% ---- GD with Fixed Step ----
disp("===== GRADIENT DESCENT — FIXED STEP =====");

x0 = [1; 1];
alpha_fixed = 0.01;
step_rule_fixed = @(x, d) step_fixed(alpha_fixed);

[x_hist_fixed, f_hist_fixed] = Steepest_descent(x0, step_rule_fixed, epsilon, max_iters);

disp("Final point (GD fixed):");
disp(x_hist_fixed(:, end));
disp("Final f (GD fixed):");
disp(f_hist_fixed(end));

plot_convergence(f_hist_fixed, "GD: Convergence (Fixed Step)");
plot_trajectory(x_hist_fixed);



%% ---- GD with Exact Line Search ----
disp("===== GRADIENT DESCENT — EXACT LINE SEARCH =====");

x0 = [1; 1];
step_rule_exact = @(x, d) step_exact_line_search(x, d);

[x_hist_exact, f_hist_exact] = Steepest_descent(x0, step_rule_exact, epsilon, max_iters);

disp("Final point (GD exact):");
disp(x_hist_exact(:, end));
disp("Final f (GD exact):");
disp(f_hist_exact(end));

plot_convergence(f_hist_exact, "GD: Convergence (Exact Line Search)");
plot_trajectory(x_hist_exact);



%% ---- GD with Armijo ----
disp("===== GRADIENT DESCENT — ARMIJO =====");

x0 = [1; 1];

alpha_armijo = 1e-4;
beta_armijo  = 0.5;
s_armijo     = 1;

step_rule_armijo = @(x, d) step_armijo(x, d, @f_xy, @grad_f_xy, ...
                                       alpha_armijo, beta_armijo, s_armijo);

[x_hist_armijo, f_hist_armijo] = Steepest_descent(x0, step_rule_armijo, epsilon, max_iters);

disp("Final point (GD Armijo):");
disp(x_hist_armijo(:, end));
disp("Final f (GD Armijo):");
disp(f_hist_armijo(end));

plot_convergence(f_hist_armijo, "GD: Convergence (Armijo)");
plot_trajectory(x_hist_armijo);


%% ======================================
%   SECTION 3 — NEWTON METHODS
% ======================================

%% ---- Newton with Fixed Step ----
disp("===== NEWTON — FIXED STEP =====");



x0 = [1; 1];
alpha_newton_fixed = 1;
step_rule_fixed_newton = @(x, d) step_fixed(alpha_newton_fixed);

[x_hist_N_fixed, f_hist_N_fixed] = Newton(x0, step_rule_fixed_newton, epsilon, max_iters);

disp("Final point (Newton fixed):");
disp(x_hist_N_fixed(:, end));
disp("Final f (Newton fixed):");
disp(f_hist_N_fixed(end));

plot_convergence(f_hist_N_fixed, "Newton: Convergence (Fixed Step)");
plot_trajectory(x_hist_N_fixed);



%% ---- Newton with Exact Line Search ----
disp("===== NEWTON — EXACT LINE SEARCH =====");

x0 = [1; 1];
step_rule_exact_newton = @(x, d) step_exact_line_search(x, d);

[x_hist_N_exact, f_hist_N_exact] = Newton(x0, step_rule_exact_newton, epsilon, max_iters);

disp("Final point (Newton exact):");
disp(x_hist_N_exact(:, end));
disp("Final f (Newton exact):");
disp(f_hist_N_exact(end));

plot_convergence(f_hist_N_exact, "Newton: Convergence (Exact Line Search)");
plot_trajectory(x_hist_N_exact);



%% ---- Newton with Armijo ----
alpha_armijo = 1e-4;
beta_armijo  = 0.5;
s_armijo     = 1;
disp("===== NEWTON — ARMIJO =====");

x0 = [1; 1];

step_rule_armijo_newton = @(x,d) step_armijo(x, d, @f_xy, @grad_f_xy, alpha_armijo, beta_armijo, s_armijo);


[x_hist_N_armijo, f_hist_N_armijo] = Newton(x0, step_rule_armijo_newton, epsilon, max_iters);

disp("Final point (Newton Armijo):");
disp(x_hist_N_armijo(:, end));
disp("Final f (Newton Armijo):");
disp(f_hist_N_armijo(end));

plot_convergence(f_hist_N_armijo, "Newton: Convergence (Armijo)");
plot_trajectory(x_hist_N_armijo);




%% ======================================
%   SECTION 4 — LEVENBERG–MARQUARDT
% ======================================

disp("===== LM — FIXED STEP =====");
alpha_armijo = 1e-4;
beta_armijo  = 0.5;
s_armijo     = 1;
x0 = [1; 1];
alpha_LM_fixed = 0.01;

step_rule_LM_fixed = @(x, d) step_fixed(alpha_LM_fixed);

[x_hist_LM_fixed, f_hist_LM_fixed] = Levenberg_Marquardt(x0, step_rule_LM_fixed, epsilon, max_iters);

disp("Final point (LM fixed):");
disp(x_hist_LM_fixed(:, end));
disp("Final f (LM fixed):");
disp(f_hist_LM_fixed(end));

plot_convergence(f_hist_LM_fixed, "LM: Convergence (Fixed Step)");
plot_trajectory(x_hist_LM_fixed);



%% -------- LM with Exact Line Search --------
disp("===== LM — EXACT LINE SEARCH =====");

x0 = [1; 1];
step_rule_LM_exact = @(x, d) step_exact_line_search(x, d);

[x_hist_LM_exact, f_hist_LM_exact] = Levenberg_Marquardt(x0, step_rule_LM_exact, epsilon, max_iters);

disp("Final point (LM exact):");
disp(x_hist_LM_exact(:, end));
disp("Final f (LM exact):");
disp(f_hist_LM_exact(end));

plot_convergence(f_hist_LM_exact, "LM: Convergence (Exact Line Search)");
plot_trajectory(x_hist_LM_exact);



%% -------- LM with Armijo --------
disp("===== LM — ARMIJO =====");

x0 = [1; 1];

step_rule_LM_armijo = @(x, d) step_armijo(x, d, @f_xy, @grad_f_xy, ...
                                          alpha_armijo, beta_armijo, s_armijo);

[x_hist_LM_armijo, f_hist_LM_armijo] = Levenberg_Marquardt(x0, step_rule_LM_armijo, epsilon, max_iters);

disp("Final point (LM Armijo):");
disp(x_hist_LM_armijo(:, end));
disp("Final f (LM Armijo):");
disp(f_hist_LM_armijo(end));

plot_convergence(f_hist_LM_armijo, "LM: Convergence (Armijo)");
plot_trajectory(x_hist_LM_armijo);


