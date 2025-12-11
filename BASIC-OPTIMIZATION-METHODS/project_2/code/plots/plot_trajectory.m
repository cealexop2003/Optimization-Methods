function plot_trajectory(x_hist)
% PLOT_TRAJECTORY - Plots the path of x_k on top of the contour plot of f.
%
% Input:
%   x_hist : matrix 2 x K, containing all points visited by the algorithm

    % Create grid
    x = linspace(-3, 3, 300);
    y = linspace(-3, 3, 300);
    [X, Y] = meshgrid(x, y);
    Z = f_xy(X, Y);

    % Plot contours
    figure;
    contour(X, Y, Z, 30); hold on;
    colormap jet;

    % Plot trajectory
    plot(x_hist(1,:), x_hist(2,:), 'r-o', 'LineWidth', 2, 'MarkerSize', 5);

    xlabel('x');
    ylabel('y');
    title('Trajectory of iterates on contour plot');
    grid on;
    hold off;

end
