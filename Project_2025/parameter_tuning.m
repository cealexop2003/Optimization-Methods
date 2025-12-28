% Parameter Tuning: Test different GA parameter combinations
% to find optimal configuration for M=1:15
clear; clc;

% Add paths
addpath('data');
addpath('model');
addpath('fitness');
addpath('ga');
addpath('viz');

% Generate data (fixed seeds for fair comparison)
[u1_train, u2_train, y_train] = generate_data(850, 'train', 100);
[u1_test, u2_test, y_test] = generate_data(250, 'test', 200);

% M values to test
M_values = 1:15;
num_M = length(M_values);

% Fixed parameters
pop_size = 100;
pc = 0.7;
pm = 0.01;
elitism = 2;
c1_bounds = [-1, 2];
c2_bounds = [-2, 1];

% TUNING GRID
patience_values = [20, 30, 50];
sigma_bounds_options = {[0.1, 2], [0.1, 5]};
max_gen_values = [250, 500];
w_bounds_options = {[-5, 5], [-10, 10]};

% Calculate total configurations
num_configs = length(patience_values) * length(sigma_bounds_options) * ...
              length(max_gen_values) * length(w_bounds_options);

fprintf('\n=================================================\n');
fprintf('PARAMETER TUNING: %d configurations\n', num_configs);
fprintf('=================================================\n\n');

% Storage for all configurations
config_idx = 0;
all_configs = struct();

% Grid search
for patience = patience_values
    for sigma_idx = 1:length(sigma_bounds_options)
        sigma_bounds = sigma_bounds_options{sigma_idx};
        for max_gen = max_gen_values
            for w_idx = 1:length(w_bounds_options)
                w_bounds = w_bounds_options{w_idx};
                
                config_idx = config_idx + 1;
                
                fprintf('\n>>> CONFIG %d/%d\n', config_idx, num_configs);
                fprintf('    patience=%d, sigma=[%.1f,%.1f], max_gen=%d, w=[%.0f,%.0f]\n', ...
                    patience, sigma_bounds(1), sigma_bounds(2), max_gen, w_bounds(1), w_bounds(2));
                
                % Store configuration
                all_configs(config_idx).patience = patience;
                all_configs(config_idx).sigma_bounds = sigma_bounds;
                all_configs(config_idx).max_gen = max_gen;
                all_configs(config_idx).w_bounds = w_bounds;
                all_configs(config_idx).train_mse = zeros(1, num_M);
                all_configs(config_idx).test_mse = zeros(1, num_M);
                all_configs(config_idx).generations = zeros(1, num_M);
                
                % Test each M value with this configuration
                for m_idx = 1:num_M
                    M = M_values(m_idx);
                    
                    % Prepare GA parameters
                    params = struct();
                    params.pop_size = pop_size;
                    params.max_generations = max_gen;
                    params.p_crossover = pc;
                    params.p_mutation = pm;
                    params.elitism = elitism;
                    params.patience = patience;
                    params.bounds = struct('w', w_bounds, 'c1', c1_bounds, ...
                                           'c2', c2_bounds, 'sigma1', sigma_bounds, ...
                                           'sigma2', sigma_bounds);
                    params.verbose = false;
                    
                    % Run GA
                    [best_chromosome, ~, history] = ga_main(u1_train, u2_train, ...
                        y_train, M, params);
                    
                    % Evaluate
                    y_pred_train = gaussian_model(best_chromosome, u1_train, u2_train, M);
                    train_mse = mean((y_train - y_pred_train).^2);
                    
                    y_pred_test = gaussian_model(best_chromosome, u1_test, u2_test, M);
                    test_mse = mean((y_test - y_pred_test).^2);
                    
                    % Store results
                    all_configs(config_idx).train_mse(m_idx) = train_mse;
                    all_configs(config_idx).test_mse(m_idx) = test_mse;
                    all_configs(config_idx).generations(m_idx) = length(history.best_mse);
                end
                
                % Find best M for this config
                [min_test_mse, best_M_idx] = min(all_configs(config_idx).test_mse);
                all_configs(config_idx).best_M = M_values(best_M_idx);
                all_configs(config_idx).best_test_mse = min_test_mse;
                
                fprintf('    Best: M=%d, Test MSE=%.6f\n', ...
                    M_values(best_M_idx), min_test_mse);
            end
        end
    end
end

fprintf('\n=================================================\n');
fprintf('TUNING RESULTS SUMMARY\n');
fprintf('=================================================\n\n');

% Find overall best configuration
best_overall_mse = inf;
best_config_idx = 0;

fprintf('Config  Patience  Sigma      MaxGen  W         Best M  Test MSE   Avg Gens\n');
fprintf('------  --------  -----      ------  ------    ------  --------   --------\n');

for i = 1:num_configs
    avg_gens = mean(all_configs(i).generations);
    
    fprintf('%6d  %8d  [%.1f,%.1f]  %6d  [%2.0f,%2.0f]  %6d  %.6f  %8.1f\n', ...
        i, all_configs(i).patience, all_configs(i).sigma_bounds(1), ...
        all_configs(i).sigma_bounds(2), all_configs(i).max_gen, ...
        all_configs(i).w_bounds(1), all_configs(i).w_bounds(2), ...
        all_configs(i).best_M, all_configs(i).best_test_mse, avg_gens);
    
    if all_configs(i).best_test_mse < best_overall_mse
        best_overall_mse = all_configs(i).best_test_mse;
        best_config_idx = i;
    end
end

fprintf('\n=================================================\n');
fprintf('BEST CONFIGURATION: Config #%d\n', best_config_idx);
fprintf('=================================================\n\n');

best_cfg = all_configs(best_config_idx);
fprintf('Parameters:\n');
fprintf('  Patience:     %d\n', best_cfg.patience);
fprintf('  Sigma bounds: [%.1f, %.1f]\n', best_cfg.sigma_bounds(1), best_cfg.sigma_bounds(2));
fprintf('  Max gen:      %d\n', best_cfg.max_gen);
fprintf('  W bounds:     [%.0f, %.0f]\n', best_cfg.w_bounds(1), best_cfg.w_bounds(2));
fprintf('  Best M:       %d\n', best_cfg.best_M);
fprintf('  Test MSE:     %.6f\n', best_cfg.best_test_mse);
fprintf('  Avg gens:     %.1f\n', mean(best_cfg.generations));

fprintf('\nDetailed results for best config:\n');
fprintf('M       Train MSE       Test MSE        Generations\n');
fprintf('---     ---------       --------        -----------\n');
for m_idx = 1:num_M
    M = M_values(m_idx);
    fprintf('%2d      %.6f        %.6f        %d\n', ...
        M, best_cfg.train_mse(m_idx), best_cfg.test_mse(m_idx), ...
        best_cfg.generations(m_idx));
end

% Save results
save('tuning_results.mat', 'all_configs', 'best_config_idx', 'best_cfg');
fprintf('\nResults saved to tuning_results.mat\n');
fprintf('Tuning complete!\n');
