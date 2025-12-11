function [xmin, a_hist, b_hist, iters, f_calls] = bisection_derivative(f, a1, b1, cfg)
% BISECTION_DERIVATIVE 
% Inputs
%   f        : objective function handle
%   a1,b1    : initial interval [a1,b1] with a1 < b1
%   cfg.l    : target final length l > 0
%   cfg.n    : (optional) total iterations; if omitted, use ceil(log2((b1-a1)/l))
%   cfg.df   : (optional) analytic derivative handle df(x). If missing, use central diff
%   cfg.h    : (optional) step for central difference (default 1e-6)
%   cfg.grad_tol : (optional) tolerance to treat df(xk) as zero (default 1e-12)
%
% Outputs
%   xmin     : midpoint of the final interval (or xk if derivative hits ~0)
%   a_hist   : history of a_k
%   b_hist   : history of b_k
%   iters    : number of [a,b] updates actually performed (<= n)
%   f_calls  : # of f-evaluations done *inside this routine* (left empty so harness counts)

    % -- basic checks --
    if ~isfield(cfg,'l'), error('bisection_derivative: cfg.l is required'); end
    Ltarget = cfg.l;
    if ~(isfinite(a1) && isfinite(b1) && a1 < b1)
        error('bisection_derivative: invalid [a1,b1].');
    end
    if ~(Ltarget > 0), error('bisection_derivative: l must be positive.'); end

    L0 = b1 - a1;

    % choose n if not provided: (1/2)^n <= l/L0  ->  n >= ceil(log2(L0/l))
    if isfield(cfg,'n') && ~isempty(cfg.n)
        n = cfg.n;
    else
        n = ceil( log2(L0 / Ltarget) );
        n = max(n, 0);   % allow n=0 when l >= L0
    end

    % derivative config
    has_df   = isfield(cfg,'df') && ~isempty(cfg.df);
    h        = get_with_default(cfg, 'h', 1e-6);
    grad_tol = get_with_default(cfg, 'grad_tol', 1e-12);

    % -- init --
    ak = a1;  bk = b1;
    a_hist = ak; b_hist = bk;
    f_calls = [];             % let the harness counter be the ground truth
    k = 1;

    % -- main loop (Steps 1..4) --
    while true
        % Step 1: xk = (ak+bk)/2 and compute derivative at xk
        xk = 0.5*(ak + bk);
        if has_df
            gk = cfg.df(xk);
        else
            % central difference (counts toward f-calls in the harness wrapper)
            fxph = f(xk + h);
            fxmh = f(xk - h);
            gk = (fxph - fxmh) / (2*h);
        end

        % If derivative is (numerically) zero, stop now (xk is minimizer)
        if abs(gk) <= grad_tol
            xmin  = xk;
            iters = k - 1;   % we didn't update [a,b] after this check
            return;
        end

        % Step 2 / Step 3: decide half-interval from the derivative sign
        if gk > 0
            % f' > 0 => minimizer is to the LEFT, keep [a_k, x_k]
            ak_new = ak;  bk_new = xk;
        else % gk < 0
            % f' < 0 => minimizer is to the RIGHT, keep [x_k, b_k]
            ak_new = xk;  bk_new = bk;
        end

        % update interval & history
        ak = ak_new;  bk = bk_new;
        a_hist(end+1) = ak; %#ok<AGROW>
        b_hist(end+1) = bk; %#ok<AGROW>

        % Step 4: check iteration budget n
        if k >= n
            xmin  = 0.5*(ak + bk);
            iters = k;
            return;
        end

        k = k + 1;
    end
end

function v = get_with_default(S, field, def)
    if isfield(S, field) && ~isempty(S.(field))
        v = S.(field);
    else
        v = def;
    end
end
