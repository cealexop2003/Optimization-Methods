function [xmin, a_hist, b_hist, iters, f_calls] = dichotomous(f, a1, b1, cfg)
% DICHOTOMOUS 
% Inputs:
%   f   : function for minimazation (function handle)
%   a1, b1 : starting searching in [a1,b1]
%   cfg : struct with fields
%         - eps : ε > 0 
%         - l   : l > 0 
%
% Outputs:
%   xmin   : prediction position min 
%   a_hist : [a_k]
%   b_hist : [b_k] 
%   iters  : number of iterations k-1
%   f_calls: number of calls of f 

    % ---Initialization---
    eps = cfg.eps;      % ε > 0
    L   = cfg.l;        % l > 0

    ak = a1;            % a_1
    bk = b1;            % b_1
    k  = 1;             % k = 1

    a_hist = ak;       
    b_hist = bk;

    % --- Steps 1/2 ---
    while true
        % Step 1: Break condition
        if (bk - ak) < L
            break;      
        end

        % x1_k, x2_k around dichotomus
        x1k = (ak + bk)/2 - eps;
        x2k = (ak + bk)/2 + eps;

        % Step 2: Compare f(x1_k) and f(x2_k)
        if f(x1k) < f(x2k)
            % a_{k+1} = a_k, b_{k+1} = x2_k
            a_next = ak;
            b_next = x2k;
        else
            % a_{k+1} = x1_k, b_{k+1} = b_k
            a_next = x1k;
            b_next = bk;
        end

        k  = k + 1;
        ak = a_next;
        bk = b_next;

        a_hist(end+1) = ak; %#ok<AGROW>
        b_hist(end+1) = bk; %#ok<AGROW>
    end

    % --- Outputs ---
    xmin    = (ak + bk)/2;   % position
    iters   = k - 1;         % number of iterations
    f_calls = 2 * iters;     
end
