function plot_contours()
% PLOT_CONTOURS - Draws contour plot for f(x,y) = (1/3)x^2 + 3y^2

    % Grid (bigger range to match task constraints)
    x = linspace(-10, 10, 300);
    y = linspace(-10, 10, 300);
    [X, Y] = meshgrid(x, y);

    % Compute Z using the expression of f
    Z = (1/3)*X.^2 + 3*Y.^2;

    % Plot contours
    figure;
    contour(X, Y, Z, 30);
    colormap jet;
    colorbar;

    title('Contour plot of f(x, y) = (1/3)x^2 + 3y^2');
    xlabel('x'); 
    ylabel('y');
    axis equal;
end
