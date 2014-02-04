function fitness = evolution
    % Check parameters.
    if (num_games ~= games_per_gene*number_of_genes)
        display('Error: Number of Games not equal to number of games encoded in genes.')
    end
    
    % You can set the population to have a random state, an Always Drive state or an Always Swerve state.
    population = randi(2,population_size, num_games)-1;
    
    % Set up some vectors to store data to plot later on.
    t=1:generations;
    average_fitness=[];
    average_swervyness=[];
    peak_fitness=[];
    peak_swervyness=[];
    
    for i=1:generations
        fitness= zeros(population_size,1);
        % All the chickens play each other at the Game of Chicken, and
        % their score is added to their too fitness.
        for j=1:population_size
            for k=1:j-1
                score=chicken(population(j,:),population(k,:));
                fitness(j)=fitness(j)+score(1);
                fitness(k)=fitness(k)+score(2);
            end
        end
        % Add some stats about our population
        average_fitness=[average_fitness,sum(fitness)/population_size];
        average_swervyness=[average_swervyness,sum(sum(population))/(population_size*num_games)];
        % Sort the fitness of the chickens, with an index to keep track of
        % which chicken has which fitness.
        ordered_fitness=-sortrows(-[fitness,transpose(1:population_size)]);
        peak_fitness=[peak_fitness,ordered_fitness(1,1)];
        peak_swervyness=[peak_swervyness,sum(population(ordered_fitness(j,2),:))/num_games];
        % The best chickens get added to a list that will be used to make
        % the next generation of chickens.
        breeders = [];
        for j=1:breeding_size
            breeders=[breeders;population(ordered_fitness(j,2),:)];
        end
        
        % Now we just breed the chickens to get the next generation.
        population = next_generation(breeders);
    end
    % Plot/Return whatever data we are interested in here.
    plot(t, average_swervyness*100)
    xlabel('Generation')
    ylabel('Percent Swerves')
    title('Simulated Evolution of Chickens that Play Chicken.')
    fitness = peak_fitness/(num_games*(population_size-1));
end

function score = chicken(player1, player2)
    score1 = 0;
    score2 = 0;
    i = 1;
    while(i <= num_games)
        if (player1(i)==swerve && player2(i)==drive)
            score1 = score1 - 1;
            score2 = score2 + 1;
        end
        if (player2(i)==swerve && player1(i)==drive)
            score2 = score2 - 1;
            score1 = score1 + 1;
        end
        if (player1(i)==drive && player2(i)==drive)
            score1 = score1 - 10;
            score2 = score2 - 10;
        end
        i = i + 1;
    end
    score=[score1,score2];
end

function population = next_generation(breeders)
   population = [];
   for i = 1:population_size
       % Select a random chicken for the first parent.
       parent1 = randi(breeding_size);
       % If the first parent is the best chicken, we select another chicken
       % at random to be parent 2. 
       % If not, we select another chicken that scored better to be parent
       % 2. This way, the higher scoring chicken are more likely to breed
       % more often.
       if (parent1 == 1)
           parent2 = randi(breeding_size-1)+1;
       else
           parent2 = randi(parent1 - 1);
       end
       % Breed the two chickens, and add the child to the new population.
       population = [population; make_child(breeders(parent1,:),breeders(parent2,:))];
   end
end

function child = make_child(parent1, parent2)
    child = [];
    for i = 1:number_of_genes
        % Pick which parent the child will inherit this gene from.
        gene_selection = randi(2);
        % If is_mutated is small enough, the gene will be mutated, and
        % will be completely random.
        is_mutated = rand;
        gene=[];
        if (gene_selection == 1)
            gene=[gene, parent1(games_per_gene*(i-1)+1:games_per_gene*i)];
        else
            gene=[gene, parent2(games_per_gene*(i-1)+1:games_per_gene*i)];
        end
        if (is_mutated <= mutation_rate)
            gene = randi(2,1,games_per_gene)-1;
        end
        child=[child,gene];
    end
end

% Some adjustable parameters are below

function n = num_games
    n=50;
end

function m = mutation_rate
    m=0.02;
end

function p = population_size
    p = 200;
end

function b = breeding_size
    b = 10;
end

function g = games_per_gene
    g = 5;
end

function n = number_of_genes
    n = 10;
end

function g = generations
    g = 20;
end

% Don't change swerve and drive. They are just to make the code slightly
% more readable.

function s = swerve
    s = 1;
end

function d = drive
    d = 0;
end