% Optimized Stability Analysis: 
% For each M, use its best configuration from tuning, then run 20-seed stability
clear; clc;

% Add paths
addpath('data');
addpath('model');
addpath('fitness');
addpath('ga');
addpath('viz');

% Load tuning results to find best config for each M
fprintf('Loading tuning results...\n');
load('tuning_results.mat', 'all_configs');

% M values
M_values = 1:15;
num_M = length(M_values);

% Find best configuration for each M
fprintf('Finding best configuration for each M...\n\n');
best_configs_per_M = struct();

for m_idx = 1:num_M
    M = M_values(m_idx);
    
    % Find config with minimum test MSE for this M
    min_mse = inf;
    best_config_idx = 0;
    
    for cfg_idx = 1:length(all_configs)
        if all_configs(cfg_idx).test_mse(m_idx) < min_mse
            min_mse = all_configs(cfg_idx).test_mse(m_idx);
            best_config_idx = cfg_idx;
        end
    end
    
    % Store best config for this M
    best_cfg = all_configs(best_config_idx);
    best_configs_per_M(m_idx).M = M;
    best_configs_per_M(m_idx).config_idx = best_config_idx;
    best_configs_per_M(m_idx).patience = best_cfg.patience;
    best_configs_per_M(m_idx).sigma_bounds = best_cfg.sigma_bounds;
    best_configs_per_M(m_idx).max_gen = best_cfg.max_gen;
    best_configs_per_M(m_idx).w_bounds = best_cfg.w_bounds;
    best_configs_per_M(m_idx).best_mse = min_mse;
    
    fprintf('M=%2d: Config #%2d (patience=%d, sigma=[%.1f,%.1f], max_gen=%d, w=[%2.0f,%2.0f]), MSE=%.6f\n', ...
        M, best_config_idx, best_cfg.patience, best_cfg.sigma_bounds(1), ...
        best_cfg.sigma_bounds(2), best_cfg.max_gen, best_cfg.w_bounds(1), ...
        best_cfg.w_bounds(2), min_mse);
end

% Stability analysis with optimized configs
num_runs = 20;
seed_base = 1000:1000:20000;

% Fixed parameters
pop_size = 100;
pc = 0.7;
pm = 0.01;
elitism = 2;
c1_bounds = [-1, 2];
c2_bounds = [-2, 1];

% Storage for all runs
all_results = struct();
for run_idx = 1:num_runs
    all_results(run_idx).train_mse = zeros(1, num_M);
    all_results(run_idx).test_mse = zeros(1, num_M);
    all_results(run_idx).generations = zeros(1, num_M);
end

fprintf('\n=================================================\n');
fprintf('OPTIMIZED STABILITY ANALYSIS: %d runs\n', num_runs);
fprintf('Each M uses its own best configuration\n');
fprintf('=================================================\n\n');

% Main loop: 20 runs
for run_idx = 1:num_runs
    train_seed = seed_base(run_idx);
    test_seed = train_seed + 500;
    
    fprintf('>>> RUN %d/%d (Seeds: %d/%d)\n', run_idx, num_runs, train_seed, test_seed);
    
    % Generate data for this run
    [u1_train, u2_train, y_train] = generate_data(850, 'train', train_seed);
    [u1_test, u2_test, y_test] = generate_data(250, 'test', test_seed);
    
    % Test each M with its optimized configuration
    for m_idx = 1:num_M
        M = M_values(m_idx);
        opt_cfg = best_configs_per_M(m_idx);
        
        % Prepare GA parameters with M-specific optimal config
        params = struct();
        params.pop_size = pop_size;
        params.max_generations = opt_cfg.max_gen;
        params.p_crossover = pc;
        params.p_mutation = pm;
        params.elitism = elitism;
        params.patience = opt_cfg.patience;
        params.bounds = struct('w', opt_cfg.w_bounds, 'c1', c1_bounds, ...
                               'c2', c2_bounds, 'sigma1', opt_cfg.sigma_bounds, ...
                               'sigma2', opt_cfg.sigma_bounds);
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
        all_results(run_idx).train_mse(m_idx) = train_mse;
        all_results(run_idx).test_mse(m_idx) = test_mse;
        all_results(run_idx).generations(m_idx) = length(history.best_mse);
    end
    
    % Print summary for this run
    [min_mse, best_m_idx] = min(all_results(run_idx).test_mse);
    fprintf('  Best: M=%d, Test MSE=%.6f\n\n', M_values(best_m_idx), min_mse);
end

fprintf('\n=================================================\n');
fprintf('ANALYSIS OF RESULTS\n');
fprintf('=================================================\n\n');

% Aggregate metrics
avg_test_mse = zeros(1, num_M);
std_test_mse = zeros(1, num_M);
median_test_mse = zeros(1, num_M);

for m_idx = 1:num_M
    test_mse_values = [all_results.test_mse];
    test_mse_values = test_mse_values(m_idx:num_M:end);
    
    avg_test_mse(m_idx) = mean(test_mse_values);
    std_test_mse(m_idx) = std(test_mse_values);
    median_test_mse(m_idx) = median(test_mse_values);
end

% Compute rankings
rankings = zeros(num_runs, num_M);
for run_idx = 1:num_runs
    [~, sorted_indices] = sort(all_results(run_idx).test_mse);
    rankings(run_idx, sorted_indices) = 1:num_M;
end

% Statistics
win_count = zeros(1, num_M);
top3_count = zeros(1, num_M);
avg_rank = zeros(1, num_M);

for m_idx = 1:num_M
    ranks_for_M = rankings(:, m_idx);
    win_count(m_idx) = sum(ranks_for_M == 1);
    top3_count(m_idx) = sum(ranks_for_M <= 3);
    avg_rank(m_idx) = mean(ranks_for_M);
end

% Find winner
[max_wins, winner_idx] = max(win_count);
winner_M = M_values(winner_idx);

fprintf('Summary Statistics (with optimized configs per M):\n');
fprintf('M\tWins\tTop-3\tAvg Rank\tMedian MSE\tMean MSE\tStd MSE\n');
fprintf('--\t----\t-----\t--------\t----------\t--------\t-------\n');
for m_idx = 1:num_M
    M = M_values(m_idx);
    fprintf('%2d\t%4d\t%5d\t%8.2f\t%10.6f\t%8.6f\t%7.6f\n', ...
        M, win_count(m_idx), top3_count(m_idx), avg_rank(m_idx), ...
        median_test_mse(m_idx), avg_test_mse(m_idx), std_test_mse(m_idx));
end

fprintf('\n=================================================\n');
fprintf('FINAL RECOMMENDATION\n');
fprintf('=================================================\n\n');

fprintf('By Win Count:\n');
fprintf('  M = %d (won %d/%d times, top-3 %d/%d times)\n', ...
    winner_M, max_wins, num_runs, top3_count(winner_idx), num_runs);

fprintf('\nBy Median MSE:\n');
[~, best_median_idx] = min(median_test_mse);
fprintf('  M = %d (median = %.6f)\n', M_values(best_median_idx), median_test_mse(best_median_idx));

fprintf('\nBy Average Rank:\n');
[~, best_rank_idx] = min(avg_rank);
fprintf('  M = %d (avg rank = %.2f)\n', M_values(best_rank_idx), avg_rank(best_rank_idx));

fprintf('\n=================================================\n');
fprintf('RECOMMENDED MODEL: M = %d\n', winner_M);
fprintf('With optimized configuration:\n');
opt_winner = best_configs_per_M(winner_idx);
fprintf('  Patience:     %d\n', opt_winner.patience);
fprintf('  Sigma bounds: [%.1f, %.1f]\n', opt_winner.sigma_bounds(1), opt_winner.sigma_bounds(2));
fprintf('  Max gen:      %d\n', opt_winner.max_gen);
fprintf('  W bounds:     [%.0f, %.0f]\n', opt_winner.w_bounds(1), opt_winner.w_bounds(2));
fprintf('  Median MSE:   %.6f\n', median_test_mse(winner_idx));
fprintf('=================================================\n');

% Save results
save('optimized_stability_results.mat', 'all_results', 'rankings', ...
    'best_configs_per_M', 'win_count', 'top3_count', 'avg_rank', ...
    'median_test_mse', 'avg_test_mse', 'std_test_mse', 'winner_M');

fprintf('\nResults saved to optimized_stability_results.mat\n');
fprintf('Run complete!\n');
