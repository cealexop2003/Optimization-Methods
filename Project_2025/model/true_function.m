function y = true_function(u1, u2)
% TRUE_FUNCTION - The true unknown function we are trying to approximate
%
% Inputs:
%   u1 - First input (can be scalar or vector)
%   u2 - Second input (same size as u1)
%
% Output:
%   y - Output: y = sin(u1+u2) * sin(u2^2)
%
% Input ranges:
%   u1 ∈ [-1, 2]
%   u2 ∈ [-2, 1]

    y = sin(u1 + u2) .* sin(u2.^2);
end
