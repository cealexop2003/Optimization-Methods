function [xmin, a_hist, b_hist, iters, f_calls] = golden_section(f, a1, b1, cfg)
% GOLDEN_SECTION.
% Inputs:
%   f      : objective (function handle)
%   a1,b1  : initial interval [a1,b1]
%   cfg.l  : target final length l > 0
%
% Outputs:
%   xmin    : midpoint of the final interval
%   a_hist  : history of left endpoints a_k
%   b_hist  : history of right endpoints b_k
%   iters   : number of iterations performed
%   f_calls : number of f evaluations (2 at init + 1 per iteration)

    if ~isfield(cfg,'l'), error('golden_section: cfg.l (target length) is required'); end
    L = cfg.l;
    if ~(isfinite(a1) && isfinite(b1) && a1 < b1)
        error('golden_section: invalid initial interval [a1,b1].');
    end
    if ~(L > 0)
        error('golden_section: l must be positive.');
    end

    % --- Initialization (as in your book) ---
    gamma = (sqrt(5)-1)/2;                 % ≈ 0.618
    ak = a1;  bk = b1;
    x1 = ak + (1 - gamma)*(bk - ak);
    x2 = ak + gamma*(bk - ak);
    f1 = f(x1);
    f2 = f(x2);
    k  = 1;

    a_hist = ak; b_hist = bk;

    % --- Main loop (Step 1 / Step 2 / Step 3) ---
    while (bk - ak) > L
        % Step 1: termination check is above in the while-condition

        if f1 > f2
            % ---- Step 2 in your spec ----
            % a_{k+1} = x1_k, b_{k+1} = b_k
            ak = x1;                  % shift left bound up to x1
            % reuse the right interior point:
            % x2_(k+1) = a_(k+1) + gamma*(b_(k+1)-a_(k+1))
            % x1_(k+1) = x2_k (reuse)
            x1 = x2;
            f1 = f2;                  % reuse f(x2)
            x2 = ak + gamma*(bk - ak);
            f2 = f(x2);               % one new evaluation
        else
            % ---- Step 3 in your spec ----
            % a_{k+1} = a_k, b_{k+1} = x2_k
            bk = x2;                  % shift right bound down to x2
            % reuse the left interior point:
            % x1_(k+1) = a_(k+1) + (1-gamma)*(b_(k+1)-a_(k+1))
            % x2_(k+1) = x1_k (reuse)
            x2 = x1;
            f2 = f1;                  % reuse f(x1)
            x1 = ak + (1 - gamma)*(bk - ak);
            f1 = f(x1);               % one new evaluation
        end

        k = k + 1;
        a_hist(end+1) = ak; %#ok<AGROW>
        b_hist(end+1) = bk; %#ok<AGROW>
    end

    xmin   = 0.5*(ak + bk);
    iters  = k - 1;
    % two f-evals at initialization + one per loop iteration:
    f_calls = 2 + iters;
end
