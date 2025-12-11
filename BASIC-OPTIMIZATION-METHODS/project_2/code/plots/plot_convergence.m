function plot_convergence(f_hist, title_text)
% PLOT_CONVERGENCE - Plots f(x_k) versus iteration number.
%
% Inputs:
%   f_hist     : vector of function values at each iteration
%   title_text : title to appear above the plot

    figure;
    plot(0:length(f_hist)-1, f_hist, 'LineWidth', 2);
    xlabel('Iteration k');
    ylabel('f(x_k)');
    title(title_text);
    grid on;

end
