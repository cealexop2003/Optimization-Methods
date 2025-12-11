function [fs, names, a, b] = test_functions()
% TEST_FUNCTIONS — define f1, f2, f3 and [a,b].
    a = -1; 
    b = 3;

% f1(x) = 5^x + (2 − cos x)^2
    f1 = @(x) 5.^x + (2 - cos(x)).^2;

% f2(x) = (x − 1)^2 + e^(x−5) * sin(x + 3)
    f2 = @(x) (x - 1).^2 + exp(x - 5) .* sin(x + 3);

% f3(x) = e^(−3x) − (sin(x − 2) − 2)^2
    f3 = @(x) exp(-3.*x) - (sin(x - 2) - 2).^2;


    fs    = {f1, f2, f3};
    names = { ...
        'f1: 5^x + (2 - cos x)^2', ...
        'f2: (x-1)^2 + e^{x-5}·sin(x+3)', ...
        'f3: e^{-3x} - (sin(x-2)-2)^2' ...
    };
end
