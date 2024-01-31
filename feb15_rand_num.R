# Generate 5 random values from the interval [0,1]
vector_1 <- runif(5)
vector_1

# Set seed to generate the same set of random values
set.seed(1234)

# generate 10 values from a normal distribution with m = 300, sd = 40
vector_2 <- rnorm(10, mean = 300, sd = 40)
vector_2

# binomial models: simulating coin flips
vector_3 <- rbinom(10,10,0.5)
vector_3

vector_4 <- rbinom(1000,10,0.5)
vector_4

vector_5 <- rbinom(10,1000,0.5)
vector_5

# make a histogram of the first 50 values of vector 4
vector_4[1:50]
hist(vector_4)
