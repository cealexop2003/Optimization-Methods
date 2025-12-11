function [f_wrapped, counter, reset] = count_calls_wrapper(f)
% COUNT_CALLS_WRAPPER  wrapps an f and counts how many times is called
%   [fw, cnt, rst] = count_calls_wrapper(f);
%   y = fw(x);         % call of f
%   n = cnt();         % how many times is called up to now
%   rst();             % reset counter to 0 if needed

    calls = 0;  % variable for nested functions

    function y = fw(x)
        calls = calls + 1;      % increment counter on call
        y = f(x);               % actuall f call
    end

    function n = get_count()
        n = calls;              % returns number of calls up to now
    end

    function reset_count()
        calls = 0;              % set counter to 0 
    end

    % return handles for outside use
    f_wrapped = @fw;            % handle for wrapper
    counter   = @get_count;     % handle in the function that reads the counter
    reset     = @reset_count;   % handle that makes the counter 0
end
