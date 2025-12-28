% Stability Analysis: Run GA 20 times with different seeds
% to find the most robust M value
clear; clc;

% Add paths
addpath('data');
addpath('model');
addpath('fitness');
addpath('ga');
addpath('viz');

% Configuration
num_runs = 20;
M_values = 1:15;
num_M = length(M_values);

% GA parameters
pop_size = 100;
max_gen = 250;
pc = 0.7;
pm = 0.01;
elitism = 2;
patience = 30;

% Bounds
w_bounds = [-5, 5];
c1_bounds = [-1, 2];
c2_bounds = [-2, 1];
sigma_bounds = [0.1, 2];

% Storage for all runs
all_results = struct();
for run_idx = 1:num_runs
    all_results(run_idx).train_mse = zeros(1, num_M);
    all_results(run_idx).test_mse = zeros(1, num_M);
    all_results(run_idx).generations = zeros(1, num_M);
end

% Base seed multipliers (will ensure different data each run)
seed_base = 1000:1000:20000;  % [1000, 2000, ..., 20000]

fprintf('\n=================================================\n');
fprintf('STABILITY ANALYSIS: %d runs with different seeds\n', num_runs);
fprintf('=================================================\n\n');

% Main loop: 20 runs
for run_idx = 1:num_runs
    train_seed = seed_base(run_idx);
    test_seed = train_seed + 500;  % e.g., 1000 and 1500, 2000 and 2500, etc.
    
    fprintf('>>> RUN %d/%d (Train seed: %d, Test seed: %d)\n', ...
        run_idx, num_runs, train_seed, test_seed);
    
    % Generate data for this run
    [u1_train, u2_train, y_train] = generate_data(850, 'train', train_seed);
    [u1_test, u2_test, y_test] = generate_data(250, 'test', test_seed);
    
    % Combine into matrices for compatibility
    U_train = [u1_train, u2_train];
    U_test = [u1_test, u2_test];
    
    % Test each M value
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
                               'c2', c2_bounds, 'sigma1', sigma_bounds, 'sigma2', sigma_bounds);
        params.verbose = false;  % Silent mode
        
        % Run GA
        [best_chromosome, ~, ~] = ga_main(U_train(:,1), U_train(:,2), ...
            y_train, M, params);
        
        % Evaluate on train set to get MSE
        y_pred_train = gaussian_model(best_chromosome, U_train(:,1), U_train(:,2), M);
        train_mse = mean((y_train - y_pred_train).^2);
        
        % Evaluate on test set
        y_pred_test = gaussian_model(best_chromosome, U_test(:,1), U_test(:,2), M);
        test_mse = mean((y_test - y_pred_test).^2);
        
        % Store results
        all_results(run_idx).train_mse(m_idx) = train_mse;
        all_results(run_idx).test_mse(m_idx) = test_mse;
        
        fprintf('  M=%2d: Train=%.6f, Test=%.6f\n', M, train_mse, test_mse);
    end
    fprintf('\n');
end

fprintf('\n=================================================\n');
fprintf('ANALYSIS OF RESULTS\n');
fprintf('=================================================\n\n');

% Aggregate metrics
avg_train_mse = zeros(1, num_M);
avg_test_mse = zeros(1, num_M);
std_test_mse = zeros(1, num_M);
median_test_mse = zeros(1, num_M);

for m_idx = 1:num_M
    test_mse_values = [all_results.test_mse];
    test_mse_values = test_mse_values(m_idx:num_M:end);  % Extract all test MSE for this M
    
    train_mse_values = [all_results.train_mse];
    train_mse_values = train_mse_values(m_idx:num_M:end);
    
    avg_train_mse(m_idx) = mean(train_mse_values);
    avg_test_mse(m_idx) = mean(test_mse_values);
    std_test_mse(m_idx) = std(test_mse_values);
    median_test_mse(m_idx) = median(test_mse_values);
end

% Compute rankings for each run
rankings = zeros(num_runs, num_M);
for run_idx = 1:num_runs
    [~, sorted_indices] = sort(all_results(run_idx).test_mse);
    rankings(run_idx, sorted_indices) = 1:num_M;
end

% Compute statistics
win_count = zeros(1, num_M);      % How many times M was #1
top3_count = zeros(1, num_M);     % How many times M was in top 3
avg_rank = zeros(1, num_M);       % Average rank across runs

for m_idx = 1:num_M
    M = M_values(m_idx);
    ranks_for_M = rankings(:, m_idx);
    
    win_count(m_idx) = sum(ranks_for_M == 1);
    top3_count(m_idx) = sum(ranks_for_M <= 3);
    avg_rank(m_idx) = mean(ranks_for_M);
end

% Find the most robust M
[max_wins, winner_idx] = max(win_count);
winner_M = M_values(winner_idx);

% Alternative: best average rank
[min_avg_rank, best_rank_idx] = min(avg_rank);
best_rank_M = M_values(best_rank_idx);

% Alternative: best median test MSE
[~, best_median_idx] = min(median_test_mse);
best_median_M = M_values(best_median_idx);

% Print summary table
fprintf('Summary Statistics:\n');
fprintf('M\tWins\tTop-3\tAvg Rank\tMedian Test MSE\tMean Test MSE\tStd Test MSE\n');
fprintf('--\t----\t-----\t--------\t---------------\t-------------\t------------\n');
for m_idx = 1:num_M
    M = M_values(m_idx);
    fprintf('%2d\t%4d\t%5d\t%8.2f\t%15.6f\t%13.6f\t%12.6f\n', ...
        M, win_count(m_idx), top3_count(m_idx), avg_rank(m_idx), ...
        median_test_mse(m_idx), avg_test_mse(m_idx), std_test_mse(m_idx));
end

fprintf('\n=================================================\n');
fprintf('RECOMMENDED MODEL SELECTION\n');
fprintf('=================================================\n\n');

fprintf('By Win Count:\n');
fprintf('  M = %d (won %d/%d times, top-3 %d/%d times)\n', ...
    winner_M, max_wins, num_runs, top3_count(winner_idx), num_runs);

fprintf('\nBy Average Rank:\n');
fprintf('  M = %d (avg rank = %.2f)\n', best_rank_M, min_avg_rank);

fprintf('\nBy Median Test MSE:\n');
fprintf('  M = %d (median = %.6f)\n', best_median_M, median_test_mse(best_median_idx));

fprintf('\n=================================================\n');
fprintf('FINAL RECOMMENDATION: M = %d\n', winner_M);
fprintf('=================================================\n');

% Save results to mat file
save('stability_results.mat', 'all_results', 'rankings', 'win_count', ...
    'top3_count', 'avg_rank', 'median_test_mse', 'avg_test_mse', ...
    'std_test_mse', 'winner_M', 'best_rank_M', 'best_median_M');

fprintf('\nResults saved to stability_results.mat\n');
fprintf('Run complete!\n');
