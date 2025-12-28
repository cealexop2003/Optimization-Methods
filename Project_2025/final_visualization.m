% FINAL_VISUALIZATION - Generate plots for best model (M=8 with optimized params)
%
% Best configuration from Run 5:
%   M = 8
%   patience = 50
%   max_gen = 500
%   w_bounds = [-5, 5]
%   sigma_bounds = [0.1, 2.0]

clear; clc;

% Add paths
addpath('data');
addpath('model');
addpath('fitness');
addpath('ga');
addpath('viz');

fprintf('=== FINAL MODEL VISUALIZATION ===\n');
fprintf('Model: M=8 Gaussians (40 parameters)\n');
fprintf('Optimized GA parameters from Run 5\n\n');

%% GA Parameters (Optimized for M=8)
M = 8;
population_size = 100;
max_generations = 500;
crossover_prob = 0.7;
mutation_prob = 0.01;
patience = 50;
elitism = 2;

% Parameter bounds (optimized)
w_bounds = [-5, 5];
c1_bounds = [-1, 2];
c2_bounds = [-2, 1];
sigma_bounds = [0.1, 2.0];

%% Generate Data
fprintf('Generating data...\n');
[u1_train, u2_train, y_train] = generate_data(850, 'train');
[u1_test, u2_test, y_test] = generate_data(250, 'test');

%% Run GA for M=8
fprintf('Running GA for M=8 (this may take a minute)...\n');
tic;

% Create params structure
params.pop_size = population_size;
params.max_generations = max_generations;
params.p_crossover = crossover_prob;
params.p_mutation = mutation_prob;
params.elitism = elitism;
params.patience = patience;
params.bounds.w = w_bounds;
params.bounds.c1 = c1_bounds;
params.bounds.c2 = c2_bounds;
params.bounds.sigma1 = sigma_bounds;
params.bounds.sigma2 = sigma_bounds;

[best_chromosome, best_fitness, history] = ga_main(...
    u1_train, u2_train, y_train, M, params);

elapsed_time = toc;

%% Evaluate Final Model
y_pred_train = gaussian_model(best_chromosome, u1_train, u2_train, M);
y_pred_test = gaussian_model(best_chromosome, u1_test, u2_test, M);

train_mse = mean((y_train - y_pred_train).^2);
test_mse = mean((y_test - y_pred_test).^2);

fprintf('\n=== RESULTS ===\n');
fprintf('Training MSE: %.6f\n', train_mse);
fprintf('Test MSE:     %.6f\n', test_mse);
fprintf('Training time: %.2f seconds\n', elapsed_time);
fprintf('Generations:   %d\n', length(history.best_mse));

%% Prepare results structure for plotting
results(M).M = M;
results(M).train_mse = train_mse;
results(M).test_mse = test_mse;
results(M).chromosome = best_chromosome;
results(M).history = history;

%% Generate All Plots
fprintf('\nGenerating visualizations...\n');

% Create individual plots since we only have M=8
plot_best_model_only(results(M), u1_train, u2_train, y_train, u1_test, u2_test, y_test);

fprintf('\n✓ Done! Check the generated PNG files and figure windows.\n');
