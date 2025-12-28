function [child1, child2] = crossover_uniform(parent1, parent2, p_crossover)
% CROSSOVER_UNIFORM - Uniform crossover operator
%
% Inputs:
%   parent1     - First parent chromosome (1 x chrom_length)
%   parent2     - Second parent chromosome (1 x chrom_length)
%   p_crossover - Probability of performing crossover (e.g., 0.7)
%
% Outputs:
%   child1 - First offspring (1 x chrom_length)
%   child2 - Second offspring (1 x chrom_length)
%
% If crossover occurs (with probability p_crossover):
%   Each gene is randomly inherited from either parent with equal probability
% Otherwise:
%   Children are exact copies of parents

    % Decide whether to perform crossover
    if rand() < p_crossover
        % Perform uniform crossover
        chrom_length = length(parent1);
        
        % Generate random mask (0 or 1 for each gene)
        mask = rand(1, chrom_length) < 0.5;
        
        % Create children by swapping genes according to mask
        child1 = parent1;
        child2 = parent2;
        
        child1(mask) = parent2(mask);   % Take genes from parent2 where mask=1
        child2(mask) = parent1(mask);   % Take genes from parent1 where mask=1
    else
        % No crossover - children are copies of parents
        child1 = parent1;
        child2 = parent2;
    end
end
