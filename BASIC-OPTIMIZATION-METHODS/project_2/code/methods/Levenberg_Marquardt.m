function [x_hist, f_hist] = Levenberg_Marquardt(x0, step_rule, epsilon, max_iters)

    xk = x0;
    x_hist = xk;
    f_hist = f_xy(xk(1), xk(2));

    for k = 1:max_iters
        
        % --- Gradient ---
        gk = grad_f_xy(xk(1), xk(2));
        if norm(gk) < epsilon
            disp("LM converged.");
            return;
        end

        % --- Hessian ---
        Hk = hessian_f_xy(xk);

        % --- Make H + muI positive definite ---
        mu = 1e-3;
        I = eye(2);
        while min(eig(Hk + mu*I)) <= 0
            mu = mu * 10;
        end

        % --- Direction ---
        dk = -(Hk + mu*I) \ gk;

        % --- Step size γ_k based on chosen rule ---
        gamma = step_rule(xk, dk);

        % --- Update ---
        xk = xk + gamma * dk;

        % Store
        x_hist(:, end+1) = xk;
        f_hist(end+1) = f_xy(xk(1), xk(2));
    end

    disp("LM reached max iterations.");
end
