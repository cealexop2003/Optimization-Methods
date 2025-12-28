function [best_chromosome, best_fitness, history] = ga_main(u1_train, u2_train, y_train, M, params)
% GA_MAIN - Main Genetic Algorithm loop
%
% Inputs:
%   u1_train - First input training data (N x 1)
%   u2_train - Second input training data (N x 1)
%   y_train  - Output training data (N x 1)
%   M        - Number of Gaussian basis functions
%   params   - Structure with GA parameters:
%              .pop_size       - Population size (e.g., 100)
%              .max_generations - Maximum number of generations (e.g., 250)
%              .p_crossover    - Crossover probability (e.g., 0.7)
%              .p_mutation     - Mutation probability per gene (e.g., 0.01)
%              .elitism        - Number of elite individuals to preserve (e.g., 2)
%              .patience       - Early stopping patience (e.g., 30)
%              .bounds         - Parameter bounds structure
%
% Outputs:
%   best_chromosome - Best chromosome found (1 x 5*M)
%   best_fitness    - Fitness of best chromosome
%   history         - Structure with evolution history:
%                     .best_mse    - Best MSE per generation
%                     .avg_mse     - Average MSE per generation
%                     .best_fitness - Best fitness per generation

    fprintf('Starting GA with M=%d Gaussians, pop_size=%d\n', M, params.pop_size);
    
    % Initialize population
    population = initialize_population(params.pop_size, M, params.bounds);
    
    % Initialize history
    history.best_mse = zeros(params.max_generations, 1);
    history.avg_mse = zeros(params.max_generations, 1);
    history.best_fitness = zeros(params.max_generations, 1);
    
    % Track global best
    global_best_fitness = -inf;
    global_best_chromosome = [];
    global_best_mse = inf;
    
    % Main evolution loop
    for gen = 1:params.max_generations
        
        % === EVALUATION ===
        mse_values = zeros(params.pop_size, 1);
        fitness_values = zeros(params.pop_size, 1);
        
        for i = 1:params.pop_size
            mse_values(i) = mse_cost(population(i, :), u1_train, u2_train, y_train, M);
            fitness_values(i) = 1 / (1 + mse_values(i));  % Convert MSE to fitness
        end
        
        % Find best in current generation
        [best_gen_fitness, best_idx] = max(fitness_values);
        best_gen_mse = mse_values(best_idx);
        best_gen_chromosome = population(best_idx, :);
        
        % Update global best
        if best_gen_fitness > global_best_fitness
            global_best_fitness = best_gen_fitness;
            global_best_chromosome = best_gen_chromosome;
            global_best_mse = best_gen_mse;
        end
        
        % Record history
        history.best_mse(gen) = global_best_mse;
        history.avg_mse(gen) = mean(mse_values);
        history.best_fitness(gen) = global_best_fitness;
        
        % Print progress every 10 generations
        if mod(gen, 10) == 0 || gen == 1
            fprintf('Gen %3d: Best MSE = %.6f, Avg MSE = %.6f\n', ...
                    gen, global_best_mse, mean(mse_values));
        end
        
        % === EARLY STOPPING ===
        if gen > params.patience
            improvement = history.best_mse(gen - params.patience) - history.best_mse(gen);
            if improvement < 1e-6
                fprintf('Early stopping at generation %d (no improvement for %d generations)\n', ...
                        gen, params.patience);
                % Trim history arrays
                history.best_mse = history.best_mse(1:gen);
                history.avg_mse = history.avg_mse(1:gen);
                history.best_fitness = history.best_fitness(1:gen);
                break;
            end
        end
        
        % === SELECTION ===
        mating_pool = selection_roulette(population, fitness_values);
        
        % === CROSSOVER & MUTATION ===
        offspring = zeros(params.pop_size, size(population, 2));
        
        for i = 1:2:params.pop_size
            % Select two parents
            parent1 = mating_pool(i, :);
            if i < params.pop_size
                parent2 = mating_pool(i + 1, :);
            else
                parent2 = mating_pool(i, :);  % Use same parent if odd population
            end
            
            % Crossover
            [child1, child2] = crossover_uniform(parent1, parent2, params.p_crossover);
            
            % Mutation
            child1 = mutation_gaussian(child1, params.p_mutation, params.bounds, M);
            if i < params.pop_size
                child2 = mutation_gaussian(child2, params.p_mutation, params.bounds, M);
            end
            
            % Add to offspring
            offspring(i, :) = child1;
            if i < params.pop_size
                offspring(i + 1, :) = child2;
            end
        end
        
        % === ELITISM ===
        % Sort population by fitness
        [~, sorted_idx] = sort(fitness_values, 'descend');
        
        % Replace worst offspring with best elite individuals
        for e = 1:params.elitism
            offspring(end - e + 1, :) = population(sorted_idx(e), :);
        end
        
        % Update population for next generation
        population = offspring;
    end
    
    % Return best solution
    best_chromosome = global_best_chromosome;
    best_fitness = global_best_fitness;
    
    fprintf('GA finished: Final best MSE = %.6f\n', global_best_mse);
end
