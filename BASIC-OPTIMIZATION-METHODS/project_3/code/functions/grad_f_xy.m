function g = grad_f_xy(x)
% grad_f_xy Υπολογίζει το gradient της f(x)
%   ∇f(x) = [ (2/3)*x1 ; 6*x2 ]
%
%   Input:
%       x : διάνυσμα [x1, x2]
%
%   Output:
%       g : gradient (2x1 διάνυσμα)

    x1 = x(1);
    x2 = x(2);

    g = [ (2/3)*x1 ;
           6*x2   ];
end
