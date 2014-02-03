Chicken_Evolution
=================

Simulates the evolution of a population of chickens that choose mates by playing the game of chicken.

The chickens do not make any decisions during the games. Instead they have a sequence of plays encoded in their genes. Every game is given either a 1 for swerve, or a 0 for drive. Points are decided as follows:

1) If both chickens swerve, they both score 0.

2) If one chicken swerves, but the other drives, the chicken who drove scores 1. The other chicken scores -1.

3) If both chickens drive, they crash into each other and both score -10.

The chickens play against every other chicken once. Those with the highest total score get to breed and produce the next generation.

The chickens all start out in generation 1 as completely docile, and will always swerve. However, due to mutations, some chickens will start to drive. At the end, a plot will be created with the percent of plays that were 'Swerve', by generation. The program also keeps track of the average score per game, which can also be plotted.


Adjustable Parameters

num_games - The number of games of chicken each chicken plays against each opponent.

games_per_gene - The number of game plays that are encoded onto each gene.

number_of_genes - The number of genes each chicken has. Note the games_per_gene * number_of_genes needs to equal num_games otherwise you'll have some problems.

generations - The number of generations of chickens to simulate.

population - The total number of chickens.

breeding_size - The number of chickens that get to breed.

mutation_rate - The probability during breeding that one of the genes a new chicken receives is completely random.


