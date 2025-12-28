function [u1, u2, y] = generate_data(num_samples, data_type)
% GENERATE_DATA - Generate training or testing data
%
% Inputs:
%   num_samples - Number of data points to generate
%   data_type   - 'train' or 'test' (determines random seed)
%
% Outputs:
%   u1 - First input vector (num_samples x 1)
%   u2 - Second input vector (num_samples x 1)
%   y  - Output vector (num_samples x 1)
%
% Input ranges:
%   u1 ∈ [-1, 2]
%   u2 ∈ [-2, 1]

    % Set random seed based on data type (ensures train/test are different)
    if strcmp(data_type, 'train')
        rng(42);  % Fixed seed for reproducibility
    elseif strcmp(data_type, 'test')
        rng(123); % Different seed for test set
    else
        error('data_type must be either ''train'' or ''test''');
    end
    
    % Generate random samples uniformly in the input space
    u1 = -1 + 3 * rand(num_samples, 1);  % u1 ∈ [-1, 2]
    u2 = -2 + 3 * rand(num_samples, 1);  % u2 ∈ [-2, 1]
    
    % Compute output using the true function
    y = true_function(u1, u2);
end
