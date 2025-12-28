function plot_best_model_only(result, u1_train, u2_train, y_train, u1_test, u2_test, y_test)
% PLOT_BEST_MODEL_ONLY - Generate visualization plots for a single best model
%
% Inputs:
%   result    - Structure with results for one M value
%   u1_train, u2_train, y_train - Training data
%   u1_test, u2_test, y_test    - Test data

    M = result.M;
    best_chromosome = result.chromosome;
    
    %% Figure 1: GA Evolution History
    figure('Name', 'GA Evolution', 'Position', [100, 100, 1000, 600]);
    
    best_history = result.history;
    generations = 1:length(best_history.best_mse);
    
    subplot(2, 1, 1);
    plot(generations, best_history.best_mse, 'b-', 'LineWidth', 2);
    hold on;
    plot(generations, best_history.avg_mse, 'r--', 'LineWidth', 1.5);
    xlabel('Generation', 'FontSize', 11);
    ylabel('MSE', 'FontSize', 11);
    title(sprintf('GA Evolution (M = %d): MSE vs Generation', M), 'FontSize', 13);
    legend('Best MSE', 'Average MSE', 'Location', 'best');
    grid on;
    
    subplot(2, 1, 2);
    plot(generations, best_history.best_fitness, 'b-', 'LineWidth', 2);
    xlabel('Generation', 'FontSize', 11);
    ylabel('Fitness', 'FontSize', 11);
    title(sprintf('GA Evolution (M = %d): Fitness vs Generation', M), 'FontSize', 13);
    grid on;
    
    %% Figure 2: True vs Predicted Surface Plot
    figure('Name', 'Surface Comparison', 'Position', [150, 150, 1200, 500]);
    
    % Create grid for plotting
    u1_grid = linspace(-1, 2, 50);
    u2_grid = linspace(-2, 1, 50);
    [U1, U2] = meshgrid(u1_grid, u2_grid);
    
    % True function
    Y_true = true_function(U1, U2);
    
    % Predicted function
    Y_pred = zeros(size(U1));
    for i = 1:length(u1_grid)
        for j = 1:length(u2_grid)
            Y_pred(j, i) = gaussian_model(best_chromosome, U1(j, i), U2(j, i), M);
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
    title(sprintf('Predicted (M = %d)', M), 'FontSize', 12);
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
    
    %% Figure 3: Prediction Scatter Plot
    figure('Name', 'Prediction Quality', 'Position', [200, 200, 1000, 500]);
    
    % Predictions
    y_pred_train = gaussian_model(best_chromosome, u1_train, u2_train, M);
    y_pred_test = gaussian_model(best_chromosome, u1_test, u2_test, M);
    
    % Training set
    subplot(1, 2, 1);
    scatter(y_train, y_pred_train, 30, 'b', 'filled', 'MarkerFaceAlpha', 0.6);
    hold on;
    plot([-1, 1], [-1, 1], 'r--', 'LineWidth', 2);  % Perfect prediction line
    xlabel('True y', 'FontSize', 11);
    ylabel('Predicted y', 'FontSize', 11);
    title(sprintf('Training Set (MSE = %.6f)', result.train_mse), 'FontSize', 12);
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
    title(sprintf('Test Set (MSE = %.6f)', result.test_mse), 'FontSize', 12);
    grid on;
    axis equal;
    xlim([min(y_test)-0.1, max(y_test)+0.1]);
    ylim([min(y_test)-0.1, max(y_test)+0.1]);
    
    fprintf('\nAll plots generated successfully!\n');
    
    %% Save figures
    saveas(1, 'best_model_ga_evolution.png');
    saveas(2, 'best_model_surface_comparison.png');
    saveas(3, 'best_model_prediction_quality.png');
    fprintf('Figures saved as PNG files.\n');
end
