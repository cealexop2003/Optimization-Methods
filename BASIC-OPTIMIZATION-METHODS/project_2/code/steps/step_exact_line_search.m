function gamma = step_exact_line_search(x, d)
% STEP_EXACT_LINE_SEARCH - Computes the exact line search step size
%   gamma = argmin_{gamma >= 0} f(x + gamma * d)
%
% Inputs:
%   x : current point (2x1 vector)(x,y)
%   d : descent direction (2x1 vector)
%
% Output:
%   gamma : step size that minimizes f(x + gamma*d)

    % Define phi(gamma) = f(x + gamma*d)
    phi = @(g) f_xy(x(1) + g*d(1), x(2) + g*d(2));

    % Minimize on a reasonable interval [0, 10]
    gamma = fminbnd(phi, 0, 1);

end
