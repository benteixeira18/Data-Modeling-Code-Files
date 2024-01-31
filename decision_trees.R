# load ranger packages
library(ranger)

# read data
all.data <- read.csv("heloc-data-all.csv")
View(all.data)

# compute initial Gini impurity of heloc variable
P_1 <- sum(all.data$heloc)/nrow(all.data)
P_0 <- 1 - P_1
gini <- 1 - (P_0^2 + P_1^2)

# run random forest to predict HELOC status based on other variables
set.seed(1234)
rf.model <- ranger(heloc ~ ., data = all.data, num.trees = 100)

# append the random forest predictions to the original dataset
all.data$predictions <- round(rf.model$predictions)
View(all.data)
