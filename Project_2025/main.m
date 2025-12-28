%% Genetic Algorithm for Gaussian Basis Function Approximation
% Main script for function approximation using GA
clear all; close all; clc;

%% Add paths
addpath('data');
addpath('model');
addpath('fitness');
addpath('ga');
addpath('viz');

fprintf('=== GA-based Function Approximation ===\n\n');

%% Generate data
fprintf('Generating training and test data...\n');
[u1_train, u2_train, y_train] = generate_data(850, 'train');
[u1_test, u2_test, y_test] = generate_data(250, 'test');
fprintf('  Train: %d samples\n', length(u1_train));
fprintf('  Test:  %d samples\n\n', length(u1_test));

%% Define GA parameters
params.pop_size = 100;
params.max_generations = 250;
params.p_crossover = 0.7;
params.p_mutation = 0.01;
params.elitism = 2;
params.patience = 30;

% Parameter bounds
params.bounds.w = [-5, 5];
params.bounds.c1 = [-1, 2];
params.bounds.c2 = [-2, 1];
params.bounds.sigma1 = [0.1, 2];
params.bounds.sigma2 = [0.1, 2];

%% Run GA for different values of M
M_values = 1:15;  % Full run: M=1 to 15 Gaussians
results = struct();

fprintf('Running GA for M = 1 to 15 Gaussians...\n');
fprintf('=====================================================\n\n');

for M = M_values
    fprintf('--- M = %d ---\n', M);
    
    % Run GA
    [best_chrom, best_fit, history] = ga_main(u1_train, u2_train, y_train, M, params);
    
    % Evaluate on training set
    y_pred_train = gaussian_model(best_chrom, u1_train, u2_train, M);
    train_mse = mean((y_train - y_pred_train).^2);
    
    % Evaluate on test set
    y_pred_test = gaussian_model(best_chrom, u1_test, u2_test, M);
    test_mse = mean((y_test - y_pred_test).^2);
    
    % Store results
    results(M).M = M;
    results(M).chromosome = best_chrom;
    results(M).train_mse = train_mse;
    results(M).test_mse = test_mse;
    results(M).history = history;
    results(M).num_generations = length(history.best_mse);
    
    fprintf('  Train MSE: %.6f\n', train_mse);
    fprintf('  Test MSE:  %.6f\n', test_mse);
    fprintf('  Generations: %d\n\n', results(M).num_generations);
end

%% Find best model based on test MSE
test_mse_values = [results.test_mse];
[best_test_mse, best_M_idx] = min(test_mse_values);
best_M = M_values(best_M_idx);

fprintf('=====================================================\n');
fprintf('BEST MODEL: M = %d Gaussians\n', best_M);
fprintf('  Train MSE: %.6f\n', results(best_M).train_mse);
fprintf('  Test MSE:  %.6f\n', results(best_M).test_mse);
fprintf('=====================================================\n\n');

%% Display results table
fprintf('Summary Table:\n');
fprintf('M\tTrain MSE\tTest MSE\tGenerations\n');
fprintf('---\t---------\t--------\t-----------\n');
for M = M_values
    fprintf('%d\t%.6f\t%.6f\t%d\n', M, results(M).train_mse, ...
            results(M).test_mse, results(M).num_generations);
end
fprintf('\n');

%% Plot results
fprintf('Generating plots...\n');
plot_results(results, best_M, u1_train, u2_train, y_train, u1_test, u2_test, y_test);
fprintf('Done! Check the PNG files in the project directory.\n');
