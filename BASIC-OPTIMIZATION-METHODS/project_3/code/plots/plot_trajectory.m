function plot_trajectory(x_hist)
% PLOT_TRAJECTORY - Plots optimization path over the contour map.

    % Draw contours
    plot_contours();
    hold on;

    % Extract x1, x2 coordinates
    x1 = x_hist(1, :);
    x2 = x_hist(2, :);

    % Plot path
    plot(x1, x2, 'r-o', 'LineWidth', 2, 'MarkerSize', 4);

    title('Trajectory of Steepest Descent');
    hold off;

end
