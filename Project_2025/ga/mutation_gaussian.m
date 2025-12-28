function mutated_chrom = mutation_gaussian(chromosome, p_mutation, bounds, M)
% MUTATION_GAUSSIAN - Gaussian mutation operator
%
% Inputs:
%   chromosome  - Chromosome to mutate (1 x 5*M)
%   p_mutation  - Probability of mutating each gene (e.g., 0.01)
%   bounds      - Structure with parameter bounds
%   M           - Number of Gaussian basis functions
%
% Output:
%   mutated_chrom - Mutated chromosome (1 x 5*M)
%
% For each gene, with probability p_mutation:
%   Add Gaussian noise and clamp to bounds

    % Validation: check chromosome length
    expected_length = 5 * M;
    if length(chromosome) ~= expected_length
        error('Chromosome length mismatch: expected %d, got %d', expected_length, length(chromosome));
    end
    
    mutated_chrom = chromosome;
    chrom_length = length(chromosome);
    
    % Standard deviation for mutation (relative to range)
    sigma_w = 0.5;      %For weights
    sigma_c = 0.3;      % For centers
    sigma_s = 0.15;     % For sigmas
    
    % Mutate each gene independently
    for i = 1:chrom_length
        if rand() < p_mutation
            % Determine which parameter type this gene represents
            pos_in_gaussian = mod(i - 1, 5) + 1;  % Position within [w, c1, c2, s1, s2]
            
            switch pos_in_gaussian
                case 1  % w (weight)
                    noise = sigma_w * randn();
                    mutated_chrom(i) = mutated_chrom(i) + noise;
                    mutated_chrom(i) = max(bounds.w(1), min(bounds.w(2), mutated_chrom(i)));
                    
                case 2  % c1
                    noise = sigma_c * randn();
                    mutated_chrom(i) = mutated_chrom(i) + noise;
                    mutated_chrom(i) = max(bounds.c1(1), min(bounds.c1(2), mutated_chrom(i)));
                    
                case 3  % c2
                    noise = sigma_c * randn();
                    mutated_chrom(i) = mutated_chrom(i) + noise;
                    mutated_chrom(i) = max(bounds.c2(1), min(bounds.c2(2), mutated_chrom(i)));
                    
                case 4  % sigma1
                    noise = sigma_s * randn();
                    mutated_chrom(i) = mutated_chrom(i) + noise;
                    mutated_chrom(i) = max(bounds.sigma1(1), min(bounds.sigma1(2), mutated_chrom(i)));
                    
                case 5  % sigma2
                    noise = sigma_s * randn();
                    mutated_chrom(i) = mutated_chrom(i) + noise;
                    mutated_chrom(i) = max(bounds.sigma2(1), min(bounds.sigma2(2), mutated_chrom(i)));
            end
        end
    end
end
