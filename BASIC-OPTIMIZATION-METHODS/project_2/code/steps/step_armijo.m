function gamma = step_armijo(xk, dk, f, grad_f, alpha, beta, s)
% STEP_ARMIJO - Backtracking line search using Armijo condition.
% Works for Steepest Descent, Newton, Levenberg-Marquardt.

    % Current function value
    fk = f(xk(1), xk(2));

    % Current gradient
    gk = grad_f(xk(1), xk(2));

    % Directional derivative gᵀ d
    slope = gk' * dk;

    % Safety check: direction must be descent
    if slope >= 0
        warning('Armijo: direction is not a descent direction.');
    end

    % Backtracking
    m = 0;
    while true

        gamma = s * beta^m;      % Reduced step size
        x_new = xk + gamma * dk; % Candidate step

        % Armijo condition
        if f(x_new(1), x_new(2)) <= fk + alpha * gamma * slope
            break;
        end

        m = m + 1;

        % Prevent infinite loops
        if m > 60
            warning('Armijo: too many reductions, stopping.');
            break;
        end
    end

end
