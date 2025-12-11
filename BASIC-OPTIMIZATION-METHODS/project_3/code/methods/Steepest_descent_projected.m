function [x_hist, f_hist] = step_projected(x0, s, gamma, epsilon, max_iters)
% PROJECTED STEEPEST DESCENT with relaxation gamma:
%   y_k = x_k - s * grad f(x_k)
%   x'_k = Proj(y_k)
%   x_{k+1} = x_k + gamma * (x'_k - x_k)

    x = x0;
    x_hist = x;
    f_hist = f_xy(x);

    for k = 1:max_iters

        % Compute gradient
        g = grad_f_xy(x);

        % Stop if ∥g∥ < ε
        if norm(g) < epsilon
            fprintf("Converged at iteration %d\n", k);
            return;
        end

        % Free (unconstrained) step
        y = x - s * g;

        % Projection onto box
        x_proj = proj_box(y);

        % Relaxed update: x_{k+1} = x_k + gamma(x_proj - x_k)
        x = x + gamma * (x_proj - x);

        % Save history
        x_hist(:, end+1) = x;
        f_hist(end+1) = f_xy(x);

    end

    fprintf("Reached max iterations.\n");
end
