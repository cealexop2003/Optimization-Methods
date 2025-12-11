function H = hessian_f_xy(x)
    % Hessian of f(x,y) = x^3 * exp(-x^2 - y^4)

    X = x(1);
    Y = x(2);

    E = exp(-(X.^2) - (Y.^4));

    % f_xx
    f_xx = (6*X - 14*X^3 + 4*X^5) * E;

    % f_yy
    f_yy = (-12*X^3*Y^2 + 16*X^3*Y^6) * E;

    % f_xy
    f_xy = (4*X^2 * Y^3 * (2*X^2 - 3)) * E;

    % Hessian
    H = [f_xx, f_xy;
         f_xy, f_yy];
end
