function results = harness_run(method_fn, fs, names, a, b, cfg)
% INPUTS
%   method_fn : handle for the method we are using
%   fs        : cell {f1,f2,f3}
%   names     : cellstr/strings with names ("f1","f2","f3")
%   a,b       : [a, b]
%   cfg       : a struct with fields:
%                 - param_name : "eps" or "l" 
%                - values     : the values we check for each param(l or
%                eps)
%               + constants: cfg.l when we check for eps and vice versa

    entries = struct([]);      % array of structs
    idx = 1;                   

    for iF = 1:numel(fs)                      % loop for every function we test(f1, f2, f3)
        f = fs{iF}; fname = string(names{iF});

        for v = cfg.values(:).'               % for every value of the parameter we check(l or eps)
            run_cfg = cfg;                    % copy of cfg
            run_cfg.(cfg.param_name) = v;     % give copy of cfg the current value(eps or l)

            [f_cnt, counter, reset] = count_calls_wrapper(f); 
            reset();                          

            % call the function
            [xmin, a_hist, b_hist, iters, f_calls] = method_fn(f_cnt, a, b, run_cfg);

            % if the method didnt give count get it from the counter
            % directly
            if ~isscalar(f_calls) || isempty(f_calls)
                f_calls = counter();
            end

            % save results
            entries(idx).fname       = fname;
            entries(idx).param_name  = cfg.param_name;
            entries(idx).param_value = v;
            entries(idx).xmin        = xmin;
            entries(idx).iters       = iters;
            entries(idx).f_calls     = f_calls;
            entries(idx).a_hist      = a_hist;
            entries(idx).b_hist      = b_hist;
            idx = idx + 1;
        end
    end

    results.entries = entries;  % all the runs in a struct array
end
