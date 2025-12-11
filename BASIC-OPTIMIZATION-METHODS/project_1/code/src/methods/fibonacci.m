function [xmin, a_hist, b_hist, iters, f_calls] = fibonacci(f, a1, b1, cfg)
% FIBONACCI.
% Inputs:
%   f        : objective function handle
%   a1,b1    : initial interval [a1,b1]
%   cfg.l    : target final length (l > 0)
%   cfg.eps  : small epsilon (>0) used only at the final step
%
% Outputs:
%   xmin     : midpoint of the final interval
%   a_hist   : history of left endpoints
%   b_hist   : history of right endpoints
%   iters    : number of interval updates before the final epsilon step
%   f_calls  : total f-calls (left empty here; harness counter will fill)

    % ----------- checks -----------
    if ~isfield(cfg,'l') || ~isfield(cfg,'eps')
        error('fibonacci: cfg.l and cfg.eps are required.');
    end
    L   = cfg.l;
    eps = cfg.eps;
    if ~(isfinite(a1) && isfinite(b1) && a1 < b1)
        error('fibonacci: invalid [a1,b1].');
    end
    if ~(L > 0 && eps > 0)
        error('fibonacci: l and eps must be positive.');
    end

    % ----------- build Fibonacci numbers & pick n -----------
    L0 = b1 - a1;
    F = [1 1];                       % F1=1, F2=1
    while F(end) <= L0 / L
        F(end+1) = F(end) + F(end-1);
    end
    n = numel(F);                     % smallest n with F_n > L0/L

    % ----------- initialization (as in your book) -----------
    ak = a1;  bk = b1;
    x1 = ak + (F(n-2)/F(n)) * (bk - ak);   % x11
    x2 = ak + (F(n-1)/F(n)) * (bk - ak);   % x21
    f1 = f(x1);
    f2 = f(x2);
    k  = 1;

    a_hist = ak; 
    b_hist = bk;

    % ----------- main loop (Steps 1–4) -----------
    % We perform updates for k = 1,2,...,n-2.
    % At k == n-2 we DO NOT compute new interior points; we jump to Step 5.
    while k <= n-2
        if f1 > f2
            % ----- Step 2 -----
            % a_{k+1} = x1_k, b_{k+1} = b_k
            ak = x1;

            % reuse: x1_(k+1) = x2_k ; reuse f2
            x1 = x2;  
            f1 = f2;

            if k < n-2
                % new right interior point
                x2 = ak + (F(n-k-1)/F(n-k)) * (bk - ak);
                f2 = f(x2);   % one new evaluation
            end

        else
            % ----- Step 3 -----
            % a_{k+1} = a_k, b_{k+1} = x2_k
            bk = x2;

            % reuse: x2_(k+1) = x1_k ; reuse f1
            x2 = x1;  
            f2 = f1;

            if k < n-2
                % new left interior point
                x1 = ak + (F(n-k-2)/F(n-k)) * (bk - ak);
                f1 = f(x1);   % one new evaluation
            end
        end

        % Step 4: k = k + 1, log histories
        k = k + 1;
        a_hist(end+1) = ak; %#ok<AGROW>
        b_hist(end+1) = bk; %#ok<AGROW>
    end

    % --- Step 5 (replace the current block) ---
    x1n = x1;                 % reuse current left interior
    x2n = x1n + eps;          % small tie-break
    if x2n > bk, x2n = bk; end

    f1n = f1;                 % REUSE, do NOT recompute f(x1n)
    f2n = f(x2n);             % compute only the new one

    if f1n > f2n
        an = x1n;  bn = bk;
    else
        an = ak;   bn = x2n;
    end


    % histories include the final interval
    a_hist(end+1) = an; %#ok<AGROW>
    b_hist(end+1) = bn; %#ok<AGROW>

    % ----------- outputs -----------
    xmin   = 0.5*(an + bn);
    iters  = numel(a_hist) - 1;   % number of [a,b] updates
    f_calls = [];                 % harness_run fills via wrapper counter
end
