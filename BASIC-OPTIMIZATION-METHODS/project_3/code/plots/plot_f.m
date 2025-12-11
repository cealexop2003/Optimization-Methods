function plot_f()
% PLOT_F - 3D surface plot of f(x,y) = (1/3)x^2 + 3y^2

    % Grid covering feasible region and more
    x = linspace(-10, 10, 200);
    y = linspace(-10, 10, 200);
    [X, Y] = meshgrid(x, y);

    % Compute the objective function
    Z = (1/3)*X.^2 + 3*Y.^2;

    % Surface plot
    figure;
    surf(X, Y, Z);
    shading interp;
    colormap jet;
    colorbar;

    title('3D surface plot of f(x, y) = (1/3)x^2 + 3y^2');
    xlabel('x');
    ylabel('y');
    zlabel('f(x, y)');
end
