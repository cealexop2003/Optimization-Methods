function y_hat = gaussian_model(chromosome, u1, u2, M)
% GAUSSIAN_MODEL - Compute model output from chromosome
%
% Inputs:
%   chromosome - Parameter vector (5*M x 1) containing:
%                [w1, c1_1, c2_1, sigma1_1, sigma2_1, 
%                 w2, c1_2, c2_2, sigma1_2, sigma2_2, 
%                 ...,
%                 wM, c1_M, c2_M, sigma1_M, sigma2_M]
%   u1         - First input vector (N x 1)
%   u2         - Second input vector (N x 1)
%   M          - Number of Gaussian basis functions
%
% Output:
%   y_hat - Predicted output (N x 1): y_hat = sum(w_k * G_k(u1,u2))
%
% Gaussian basis function:
%   G_k(u1,u2) = exp(-(u1-c1_k)^2/(2*sigma1_k^2) - (u2-c2_k)^2/(2*sigma2_k^2))

    N = length(u1);  % Number of data points
    y_hat = zeros(N, 1);  % Initialize output
    
    % Loop over each Gaussian
    for k = 1:M
        % Extract parameters for the k-th Gaussian
        idx = 5*(k-1) + 1;  % Starting index for k-th Gaussian
        w_k      = chromosome(idx);
        c1_k     = chromosome(idx + 1);
        c2_k     = chromosome(idx + 2);
        sigma1_k = chromosome(idx + 3);
        sigma2_k = chromosome(idx + 4);
        
        % Compute Gaussian basis function
        G_k = exp(-((u1 - c1_k).^2) / (2 * sigma1_k^2) - ...
                  ((u2 - c2_k).^2) / (2 * sigma2_k^2));
        
        % Add weighted contribution
        y_hat = y_hat + w_k * G_k;
    end
end
