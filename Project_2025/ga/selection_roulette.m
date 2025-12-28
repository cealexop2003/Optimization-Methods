function mating_pool = selection_roulette(population, fitness)
% SELECTION_ROULETTE - Roulette wheel selection with replacement
%
% Inputs:
%   population - Matrix (pop_size x chrom_length) of chromosomes
%   fitness    - Vector (pop_size x 1) of fitness values
%
% Output:
%   mating_pool - Matrix (pop_size x chrom_length) of selected parents
%
% Note: Individuals with higher fitness have higher probability of selection.
%       Selection is WITH replacement (same individual can be selected multiple times).

    pop_size = size(population, 1);
    
    % Compute selection probabilities (proportional to fitness)
    total_fitness = sum(fitness);
    if total_fitness == 0
        % If all fitness values are zero, use uniform selection
        probabilities = ones(pop_size, 1) / pop_size;
    else
        probabilities = fitness / total_fitness;
    end
    
    % Compute cumulative probabilities
    cum_prob = cumsum(probabilities);
    
    % Initialize mating pool
    mating_pool = zeros(pop_size, size(population, 2));
    
    % Select individuals
    for i = 1:pop_size
        % Generate random number in [0, 1)
        r = rand();
        
        % Find first individual where cumulative probability >= r
        idx = find(cum_prob >= r, 1, 'first');
        
        % Add selected individual to mating pool
        mating_pool(i, :) = population(idx, :);
    end
end
