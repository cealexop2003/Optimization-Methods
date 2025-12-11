function x_proj = proj_box(x)
% PROJ_BOX - Projects x onto the box:
%   -10 <= x1 <= 5
%   -8  <= x2 <= 12

    x_proj = zeros(2,1);

    % x1 projection
    x_proj(1) = min(max(x(1), -10), 5);

    % x2 projection
    x_proj(2) = min(max(x(2), -8), 12);
end
