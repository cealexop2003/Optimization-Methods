function plot_results(results, best_M, u1_train, u2_train, y_train, u1_test, u2_test, y_test)
% PLOT_RESULTS - Generate visualization plots for GA results
%
% Inputs:
%   results   - Structure array with results for each M
%   best_M    - Best M value (number of Gaussians)
%   u1_train, u2_train, y_train - Training data
%   u1_test, u2_test, y_test    - Test data

    M_values = [results.M];
    train_mse_values = [results.train_mse];
    test_mse_values = [results.test_mse];
    
    %% Figure 1: MSE vs M (Model Selection)
    figure('Name', 'Model Selection', 'Position', [100, 100, 800, 500]);
    
    plot(M_values, train_mse_values, 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
    hold on;
    plot(M_values, test_mse_values, 'r-s', 'LineWidth', 2, 'MarkerSize', 8);
    plot(best_M, results(best_M).test_mse, 'g*', 'MarkerSize', 15, 'LineWidth', 2);
    
    xlabel('Number of Gaussians (M)', 'FontSize', 12);
    ylabel('MSE', 'FontSize', 12);
    title('Model Selection: MSE vs Number of Gaussians', 'FontSize', 14);
    legend('Train MSE', 'Test MSE', sprintf('Best M = %d', best_M), 'Location', 'best');
    grid on;
    set(gca, 'FontSize', 11);
    
    %% Figure 2: Evolution History for Best M
    figure('Name', 'GA Evolution', 'Position', [150, 150, 1000, 600]);
    
    best_history = results(best_M).history;
    generations = 1:length(best_history.best_mse);
    
    subplot(2, 1, 1);
    plot(generations, best_history.best_mse, 'b-', 'LineWidth', 2);
    hold on;
    plot(generations, best_history.avg_mse, 'r--', 'LineWidth', 1.5);
    xlabel('Generation', 'FontSize', 11);
    ylabel('MSE', 'FontSize', 11);
    title(sprintf('GA Evolution (M = %d): MSE vs Generation', best_M), 'FontSize', 13);
    legend('Best MSE', 'Average MSE', 'Location', 'best');
    grid on;
    
    subplot(2, 1, 2);
    plot(generations, best_history.best_fitness, 'b-', 'LineWidth', 2);
    xlabel('Generation', 'FontSize', 11);
    ylabel('Fitness', 'FontSize', 11);
    title(sprintf('GA Evolution (M = %d): Fitness vs Generation', best_M), 'FontSize', 13);
    grid on;
    
    %% Figure 3: True vs Predicted Surface Plot
    figure('Name', 'Surface Comparison', 'Position', [200, 200, 1200, 500]);
    
    % Create grid for plotting
    u1_grid = linspace(-1, 2, 50);
    u2_grid = linspace(-2, 1, 50);
    [U1, U2] = meshgrid(u1_grid, u2_grid);
    
    % True function
    Y_true = true_function(U1, U2);
    
    % Predicted function
    best_chromosome = results(best_M).chromosome;
    Y_pred = zeros(size(U1));
    for i = 1:length(u1_grid)
        for j = 1:length(u2_grid)
            Y_pred(j, i) = gaussian_model(best_chromosome, U1(j, i), U2(j, i), best_M);
        end
    end
    
    % Plot true function
    subplot(1, 3, 1);
    surf(U1, U2, Y_true, 'EdgeColor', 'none');
    xlabel('u_1', 'FontSize', 11);
    ylabel('u_2', 'FontSize', 11);
    zlabel('y', 'FontSize', 11);
    title('True Function', 'FontSize', 12);
    colorbar;
    view(45, 30);
    
    % Plot predicted function
    subplot(1, 3, 2);
    surf(U1, U2, Y_pred, 'EdgeColor', 'none');
    xlabel('u_1', 'FontSize', 11);
    ylabel('u_2', 'FontSize', 11);
    zlabel('y', 'FontSize', 11);
    title(sprintf('Predicted (M = %d)', best_M), 'FontSize', 12);
    colorbar;
    view(45, 30);
    
    % Plot error
    subplot(1, 3, 3);
    error_surface = abs(Y_true - Y_pred);
    surf(U1, U2, error_surface, 'EdgeColor', 'none');
    xlabel('u_1', 'FontSize', 11);
    ylabel('u_2', 'FontSize', 11);
    zlabel('|Error|', 'FontSize', 11);
    title('Absolute Error', 'FontSize', 12);
    colorbar;
    view(45, 30);
    
    %% Figure 4: Prediction Scatter Plot
    figure('Name', 'Prediction Quality', 'Position', [250, 250, 1000, 500]);
    
    % Predictions
    y_pred_train = gaussian_model(best_chromosome, u1_train, u2_train, best_M);
    y_pred_test = gaussian_model(best_chromosome, u1_test, u2_test, best_M);
    
    % Training set
    subplot(1, 2, 1);
    scatter(y_train, y_pred_train, 30, 'b', 'filled', 'MarkerFaceAlpha', 0.6);
    hold on;
    plot([-1, 1], [-1, 1], 'r--', 'LineWidth', 2);  % Perfect prediction line
    xlabel('True y', 'FontSize', 11);
    ylabel('Predicted y', 'FontSize', 11);
    title(sprintf('Training Set (MSE = %.6f)', results(best_M).train_mse), 'FontSize', 12);
    grid on;
    axis equal;
    xlim([min(y_train)-0.1, max(y_train)+0.1]);
    ylim([min(y_train)-0.1, max(y_train)+0.1]);
    
    % Test set
    subplot(1, 2, 2);
    scatter(y_test, y_pred_test, 30, 'r', 'filled', 'MarkerFaceAlpha', 0.6);
    hold on;
    plot([-1, 1], [-1, 1], 'r--', 'LineWidth', 2);
    xlabel('True y', 'FontSize', 11);
    ylabel('Predicted y', 'FontSize', 11);
    title(sprintf('Test Set (MSE = %.6f)', results(best_M).test_mse), 'FontSize', 12);
    grid on;
    axis equal;
    xlim([min(y_test)-0.1, max(y_test)+0.1]);
    ylim([min(y_test)-0.1, max(y_test)+0.1]);
    
    fprintf('All plots generated successfully!\n');
    
    %% Save figures
    saveas(1, 'figure1_model_selection.png');
    saveas(2, 'figure2_ga_evolution.png');
    saveas(3, 'figure3_surface_comparison.png');
    saveas(4, 'figure4_prediction_quality.png');
    fprintf('Figures saved as PNG files in the current directory.\n');
end
