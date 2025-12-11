function gamma = step_fixed(~, ~, alpha)
% STEP_FIXED - Returns a constant step size (fixed gamma).
%
% Inputs:
%   ~     : current point x (not used)
%   ~     : descent direction d (not used)
%   alpha : the constant step size γ > 0
%
% Output:
%   gamma : the returned constant step size

    gamma = alpha;

end
