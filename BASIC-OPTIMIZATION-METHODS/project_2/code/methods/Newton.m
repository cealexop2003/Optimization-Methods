function [x_hist, f_hist] = Newton(x0, step_rule, epsilon, max_iters)
% NEWTON METHOD with general step rule (fixed, exact, Armijo)
%
% Inputs:
%   x0         : initial point (2x1 vector)
%   step_rule  : function handle gamma = step_rule(xk, dk)
%   epsilon    : tolerance for gradient norm
%   max_iters  : maximum number of iterations
%
% Outputs:
%   x_hist     : history of iterates
%   f_hist     : history of function values

    xk = x0;
    x_hist = xk;
    f_hist = f_xy(xk(1), xk(2));

    for k = 1:max_iters

        % Compute gradient
        gk = grad_f_xy(xk(1), xk(2));

        % Stopping condition
        if norm(gk) < epsilon
            disp("Newton converged: small gradient.");
            return;
        end

        % Compute Hessian
        Hk = hessian_f_xy(xk);

        % Solve for direction dk = -H^{-1} g
        % Use \ instead of inverse for stability
        dk = - Hk \ gk;

        % Compute step size (depends on rule)
        gamma = step_rule(xk, dk);

        % Update x
        xk = xk + gamma * dk;

        % Save history
        x_hist(:, end+1) = xk;
        f_hist(end+1) = f_xy(xk(1), xk(2));
    end

    disp("Newton: reached maximum iterations.");
end
