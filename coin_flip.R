# flip a coin 10 times over 10 experiments
ten_flips <- rbinom(10,10,0.5)
ten_flips
hist(ten_flips,probability = TRUE)

# flip a coin 10 times over 100 experiments
hundred_flips <- rbinom(10,100,0.5)
hundred_flips
hist(hundred_flips,probability = TRUE)

# flip a coin 10 times over 1000 experiments
thousand_flips <- rbinom(10,1000,0.5)
thousand_flips
hist(thousand_flips,probability = TRUE)

# calculate exponential distribution of lightbulb light
# 100 bulbs, mean shelf life of 2500 hours
bulbs <- rexp(100,rate = 1/2500)
hist(bulbs,probability = TRUE)

# 1000 bulbs, same mean
more_bulbs <- rexp(1000,rate = 1/2500)
hist(more_bulbs,probability=TRUE)
