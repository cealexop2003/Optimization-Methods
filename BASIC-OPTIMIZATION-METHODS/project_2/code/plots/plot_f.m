function plot_f()
    % Define grid
    x = linspace(-3, 3, 200);
    y = linspace(-3, 3, 200);
    [X, Y] = meshgrid(x, y);

    % Compute the function values
    Z = f_xy(X, Y);

    % Surface plot
    figure;
    surf(X, Y, Z);
    shading interp;      % Smooth shading
    colormap jet;        % Color map
    title('Surface plot of f(x, y) = x^3 e^{-x^2 - y^4}');
    xlabel('x');
    ylabel('y');
    zlabel('f(x,y)');
end
