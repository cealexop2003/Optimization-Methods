function population = initialize_population(pop_size, M, bounds)
% INITIALIZE_POPULATION - Create initial random population
%
% Inputs:
%   pop_size - Number of individuals in the population
%   M        - Number of Gaussian basis functions
%   bounds   - Structure with parameter bounds:
%              bounds.w = [w_min, w_max]
%              bounds.c1 = [c1_min, c1_max]
%              bounds.c2 = [c2_min, c2_max]
%              bounds.sigma1 = [sigma1_min, sigma1_max]
%              bounds.sigma2 = [sigma2_min, sigma2_max]
%
% Output:
%   population - Matrix (pop_size x 5*M) where each row is a chromosome

    chrom_length = 5 * M;  % Each chromosome has 5 parameters per Gaussian
    population = zeros(pop_size, chrom_length);
    
    % Generate random chromosomes
    for i = 1:pop_size
        for k = 1:M
            idx = 5*(k-1) + 1;  % Starting index for k-th Gaussian
            
            % Generate random parameters within bounds
            population(i, idx)     = bounds.w(1) + (bounds.w(2) - bounds.w(1)) * rand();      % w_k
            population(i, idx + 1) = bounds.c1(1) + (bounds.c1(2) - bounds.c1(1)) * rand();   % c1_k
            population(i, idx + 2) = bounds.c2(1) + (bounds.c2(2) - bounds.c2(1)) * rand();   % c2_k
            population(i, idx + 3) = bounds.sigma1(1) + (bounds.sigma1(2) - bounds.sigma1(1)) * rand();  % sigma1_k
            population(i, idx + 4) = bounds.sigma2(1) + (bounds.sigma2(2) - bounds.sigma2(1)) * rand();  % sigma2_k
        end
    end
end
