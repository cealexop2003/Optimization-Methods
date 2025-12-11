function [x_hist, f_hist] = Steepest_descent(x0, step_rule, epsilon, max_iters)
% STEEPEST_DESCENT: Performs the steepest descent optimization method.
%
% Inputs:
%   x0         : initial point as a column vector [x1; x2]
%   step_rule  : function handle for step size rule, e.g. @(x,d) step_fixed(...)
%   epsilon    : stopping tolerance for ||grad f||
%   max_iters  : maximum number of iterations
%
% Outputs:
%   x_hist     : history of points visited (2 x K)
%   f_hist     : history of f(x_k)

    % Initialization
    x = x0;
    x_hist = x0;
    f_hist = f_xy(x);

    for k = 1:max_iters

        % Compute gradient at current point
        g = grad_f_xy(x);

        % Check stopping condition
        if norm(g) < epsilon
            fprintf('Gradient norm below tolerance. Converged at iteration %d.\n', k);
            return;
        end

        % Descent direction
        d = -g;

        % Step size γ_k from rule
        gamma = step_rule(x, d);

        % Update
        x = x + gamma * d;

        % Store history
        x_hist(:, end+1) = x;
        f_hist(end+1) = f_xy(x);
    end

    fprintf('Reached maximum iterations (%d).\n', max_iters);
end
