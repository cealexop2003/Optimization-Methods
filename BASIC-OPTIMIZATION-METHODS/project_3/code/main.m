%% ======================================
%   MAIN SCRIPT — WORK 3
%   Steepest Descent + Projected Steepest Descent
% ======================================

clc; clear; close all;

% Add paths
addpath("functions");
addpath("methods");
addpath("steps");
addpath("plots");

disp("=== WORK 3 STARTED ===");


%% ======================================
%   SECTION 1: PLOT THE OBJECTIVE FUNCTION f(x,y)
% ======================================

disp("Plotting 3D surface of f(x,y)...");
plot_f();

disp("Plotting contour map of f(x,y)...");
plot_contours();

disp("Function plots completed.");



%% ======================================
%   SECTION 2 — TOPIC 1
%   Unconstrained Steepest Descent (fixed step sizes)
% ======================================

epsilon = 0.001;
max_iters = 2000;

% Initial point (any ≠ (0,0))
x0 = [2; 3];

disp("=== TOPIC 1: UNCONSTRAINED STEEPEST DESCENT ===");
%{

%% ---------- CASE 1: gamma = 0.1 ----------
gamma = 0.1;
step_rule = @(x, d) step_fixed(x, d, gamma);

[x_hist_01, f_hist_01] = Steepest_descent(x0, step_rule, epsilon, max_iters);

plot_convergence(f_hist_01, "Steepest Descent — γ = 0.1");
plot_trajectory(x_hist_01);

%}
%{
%% ---------- CASE 2: gamma = 0.3 ----------
gamma = 0.3;
step_rule = @(x, d) step_fixed(x, d, gamma);

[x_hist_03, f_hist_03] = Steepest_descent(x0, step_rule, epsilon, max_iters);

plot_convergence(f_hist_03, "Steepest Descent — γ = 0.3");
plot_trajectory(x_hist_03);

%}
%{
%% ---------- CASE 3: gamma = 3 (divergence expected) ----------
gamma = 3;
step_rule = @(x, d) step_fixed(x, d, gamma);

[x_hist_3, f_hist_3] = Steepest_descent(x0, step_rule, epsilon, max_iters);

plot_convergence(f_hist_3, "Steepest Descent — γ = 3 (DIVERGENCE)");
plot_trajectory(x_hist_3);
%}
%{
%% ---------- CASE 4: gamma = 5 (divergence expected) ----------
gamma = 5;
step_rule = @(x, d) step_fixed(x, d, gamma);

[x_hist_5, f_hist_5] = Steepest_descent(x0, step_rule, epsilon, max_iters);

plot_convergence(f_hist_5, "Steepest Descent — γ = 5 (DIVERGENCE)");
plot_trajectory(x_hist_5);

%}
%{
%% ======================================
%   SECTION 3 — TOPIC 2
%   Projected Steepest Descent
% ======================================

disp("=== TOPIC 2: PROJECTED STEEPEST DESCENT ===");

epsilon = 0.01;       % as required by Topic 2
max_iters = 2000;

s = 5;                % free step before projection
gamma = 0.5;          % relaxation parameter
x0 = [5; -5];         % starting point

fprintf("Topic 2 parameters:\n  s = %.2f\n  gamma = %.2f\n  x0 = (%.2f, %.2f)\n", ...
        s, gamma, x0(1), x0(2));

% Run the PSD method
[x_hist_proj, f_hist_proj] = step_projected(x0, s, gamma, epsilon, max_iters);

fprintf("Final point (Topic 2): (%.4f, %.4f)\n", x_hist_proj(1,end), x_hist_proj(2,end));
fprintf("Final f value (Topic 2): %.6f\n", f_hist_proj(end));


%% ---------- PLOTS FOR TOPIC 2 ----------

% Trajectory on contour plot
plot_contours();
hold on;
plot(x_hist_proj(1,:), x_hist_proj(2,:), 'r.-', 'LineWidth', 2, 'MarkerSize', 12);
title("Trajectory — Projected Steepest Descent (s=5, γ=0.5)");
hold off;

% Convergence
plot_convergence(f_hist_proj, "Projected Steepest Descent — s=5, γ=0.5");

% Separate trajectory
plot_trajectory(x_hist_proj);
%}
%{
disp("=== WORK 3 COMPLETED ===");

%% ======================================
%   SECTION 4 — TOPIC 3
%   Projected Steepest Descent (s=15, γ=0.1)
% ======================================

disp("=== TOPIC 3: PROJECTED STEEPEST DESCENT (s=15, γ=0.1) ===");

epsilon = 0.01;
max_iters = 2000;

s = 15;               % very large free step
gamma = 0.1;          % small relaxation
x0 = [-5; 10];        % starting point

fprintf("Topic 3 parameters:\n  s = %.2f\n  gamma = %.2f\n  x0 = (%.2f, %.2f)\n", ...
        s, gamma, x0(1), x0(2));

[x_hist_T3, f_hist_T3] = step_projected(x0, s, gamma, epsilon, max_iters);

fprintf("Final point (Topic 3): (%.4f, %.4f)\n", x_hist_T3(1,end), x_hist_T3(2,end));
fprintf("Final f value (Topic 3): %.6f\n", f_hist_T3(end));


% ---------- PLOTS FOR TOPIC 3 ----------
plot_contours();
hold on;
plot(x_hist_T3(1,:), x_hist_T3(2,:), 'r.-', 'LineWidth', 2, 'MarkerSize', 12);
title("Trajectory — Projected SD (Topic 3: s=15, γ=0.1)");
hold off;

plot_convergence(f_hist_T3, "Projected Steepest Descent — Topic 3 (s=15, γ=0.1)");

plot_trajectory(x_hist_T3);

%}
%{
%% ======================================
%   SECTION 5 — TOPIC 4
%   Projected Steepest Descent (s=0.1, γ=0.2)
% ======================================

disp("=== TOPIC 4: PROJECTED STEEPEST DESCENT (s=0.1, γ=0.2) ===");

epsilon = 0.01;
max_iters = 2000;

s = 0.1;               % very small free step
gamma = 0.2;           % small relaxation
x0 = [8; -10];         % starting point

fprintf("Topic 4 parameters:\n  s = %.2f\n  gamma = %.2f\n  x0 = (%.2f, %.2f)\n", ...
        s, gamma, x0(1), x0(2));

[x_hist_T4, f_hist_T4] = step_projected(x0, s, gamma, epsilon, max_iters);

fprintf("Final point (Topic 4): (%.4f, %.4f)\n", x_hist_T4(1,end), x_hist_T4(2,end));
fprintf("Final f value (Topic 4): %.6f\n", f_hist_T4(end));


% ---------- PLOTS FOR TOPIC 4 ----------
plot_contours();
hold on;
plot(x_hist_T4(1,:), x_hist_T4(2,:), 'r.-', 'LineWidth', 2, 'MarkerSize', 12);
title("Trajectory — Projected SD (Topic 4: s=0.1, γ=0.2)");
hold off;

plot_convergence(f_hist_T4, "Projected Steepest Descent — Topic 4 (s=0.1, γ=0.2)");

plot_trajectory(x_hist_T4);



disp("=== ALL TOPICS COMPLETED ===");
%}

