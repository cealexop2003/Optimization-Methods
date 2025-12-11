function plot_contours()
    % Define grid
    x = linspace(-3, 3, 300);
    y = linspace(-3, 3, 300);
    [X, Y] = meshgrid(x, y);

    % Compute the function values
    Z = f_xy(X, Y);

    % Contour plot
    figure;
    contour(X, Y, Z, 30);   % 30 contour levels
    colormap jet;
    colorbar;
    title('Contour plot of f(x, y) = x^3 e^{-x^2 - y^2}');
    xlabel('x');
    ylabel('y');
    axis equal;
end
