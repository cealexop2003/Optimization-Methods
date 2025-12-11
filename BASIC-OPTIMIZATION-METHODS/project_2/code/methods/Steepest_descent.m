function [x_hist, f_hist] = Steepest_descent(x0, step_rule, epsilon, max_iters)
% STEEPEST_DESCENT: Performs the steepest descent optimization method.
%
% Inputs:
%   x0         : initial point as a column vector [x; y]
%   step_rule  : function handle for step size rule, e.g. @(x,d) step_fixed(...)
%   epsilon    : stopping tolerance for ||grad f||
%   max_iters  : maximum number of iterations
%
% Outputs:
%   x_hist     : history of points visited by the algorithm (2 x K matrix)
%   f_hist     : history of function values f(x_k)

    % Initialize storage
    x = x0;
    x_hist = x0;
    f_hist = f_xy(x(1), x(2));

    for k = 1:max_iters

        % Compute gradient at current point
        g = grad_f_xy(x(1), x(2));

        % Check stopping condition
        if norm(g) < epsilon
            fprintf('Gradient norm below tolerance. Converged at iteration %d.\n', k);
            return;
        end

        % Steepest descent direction
        d = -g;

        % Compute step size gamma_k using the provided rule
        gamma = step_rule(x, d);

        % Update step
        x = x + gamma * d;

        % Store history
        x_hist(:, end+1) = x;
        f_hist(end+1) = f_xy(x(1), x(2));
    end

    fprintf('Reached maximum iterations (%d).\n', max_iters);

end
