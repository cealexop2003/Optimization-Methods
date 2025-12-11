function g = grad_f_xy(x, y)
    % Gradient of f(x, y) = x^3 * exp(-x^2 - y^4)

    df_dx = (3*x.^2 - 2*x.^4) .* exp(-x.^2 - y.^4);
    df_dy = -4 * y.^3 .* x.^3 .* exp(-x.^2 - y.^4);

    g = [df_dx; df_dy];
end
