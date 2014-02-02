function a = evolution
    if (num_games ~= games_per_gene*number_of_genes)
        display('Error: Number of Games not equal to number of games encoded in genes.')
    end
    population = ones(population_size, num_games);
    t=1:generations;
    average_fitness=[];
    average_swervyness=[];
    for i=1:generations
        fitness=zeros(population_size,1);
        for j=1:population_size
            for k=1:j-1
                score=chicken(population(j,:),population(k,:));
                fitness(j)=fitness(j)+score(1);
                fitness(k)=fitness(k)+score(2);
            end
        end
        average_fitness=[average_fitness,sum(fitness)/population_size];
        average_swervyness=[average_swervyness,sum(sum(population))/(population_size*num_games)];
        ordered_fitness=sortrows([fitness,transpose(1:population_size)]);
        breeders = [];
        for j=1:breeding_size
            breeders=[breeders;population(ordered_fitness(j,2),:)];
        end
        population = next_generation(breeders);
    end
    plot(t, average_swervyness)
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
       parent1 = randi(10);
       if (parent1 == 1)
           parent2 = randi(9)+1;
       else
           parent2 = randi(parent1 - 1);
       end
       population = [population; make_child(breeders(parent1,:),breeders(parent2,:))];
   end
end

function child = make_child(parent1, parent2)
    child = [];
    for i = 1:number_of_genes
        gene_selection = randi(2);
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

function n = num_games
    n=10;
end

function m = mutation_rate
    m=0.05;
end

function s = swerve
    s = 1;
end

function d = drive
    d = 0;
end

function p = population_size
    p = 20;
end

function b = breeding_size
    b = 10;
end

function g = games_per_gene
    g = 2;
end

function n = number_of_genes;
    n = 5
end

function g = generations
    g = 200;
end

