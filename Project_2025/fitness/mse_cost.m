function mse = mse_cost(chromosome, u1, u2, y, M)
% MSE_COST - Compute Mean Squared Error for a chromosome
%
% Inputs:
%   chromosome - Parameter vector (5*M x 1)
%   u1         - First input vector (N x 1)
%   u2         - Second input vector (N x 1)
%   y          - True output vector (N x 1)
%   M          - Number of Gaussian basis functions
%
% Output:
%   mse - Mean Squared Error: mse = mean((y - y_hat)^2)

    % Get predictions from the model
    y_hat = gaussian_model(chromosome, u1, u2, M);
    
    % Compute MSE
    mse = mean((y - y_hat).^2);
end
