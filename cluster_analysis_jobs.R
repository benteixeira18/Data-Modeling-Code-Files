#STEP 1: set working directory  --------------------------------------------------------------

#STEP 2: import file -------------------------------------------------------------------------
hr.data <- read.csv("hr-data-v2.csv")
View(hr.data)

#STEP 3: split data into training and testing sets -------------------------------------------
#puts 70% of data into training set and 30% into the test set
set.seed(123)
random.vec <- runif(nrow(hr.data))
training.vec <- ifelse(random.vec < 0.7, 1, 0)
train.data <- hr.data[training.vec==1,]
test.data <- hr.data[training.vec==0,]

#LOGISTIC REGRESSION
#STEP 4: run the logistic regression model using train.data ----------------------------------
#logistic regression model using all variables
logistic.model <- glm(attrition ~ .,
                      family = binomial(link = "logit"),
                      data = train.data)

summary(logistic.model) #view the regression coefficients table
#statistically significant variables: environ.satisfaction, job.satisfaction, work.life.balance, age, business.travelTravel_Frequently,
#num.companies.worked, total.working.yrs, trainings.last.year, years.since.promotion, years.current.mgr,avg.hours.worked 

#new model with only statistically significant variables
logistic.model1 <- glm(attrition ~ environ.satisfaction+ job.satisfaction + work.life.balance + age + num.companies.worked 
                       + total.working.yrs + trainings.last.year+ years.since.promotion + years.current.mgr + avg.hours.worked,
                      family = binomial(link = "logit"),
                      data = train.data)

#uses the  model to predict attrition for each employee using test.data
logistic.predictions <- predict(logistic.model1, test.data,  type = "response")

#rounds to obtain a 0/1 binary prediction
attrition.pred.logistic <- round(logistic.predictions)

#adds the prediction vector to the test dataset
test.data <- cbind(test.data, attrition.pred.logistic)
View(test.data)

#confusion matrix
library(caret)
actual.attrition <- factor(test.data$attrition)
attrition.pred.logistic <- unname(attrition.pred.logistic)
attrition.pred.logistic <- factor(attrition.pred.logistic)

confusion.matrix.lr <- confusionMatrix(attrition.pred.logistic, actual.attrition)
confusion.matrix.lr

accuracy.lr <- confusion.matrix$overall['Accuracy'] #0.8563 
sensitivity.lr <- confusion.matrix$byClass['Sensitivity'] #0.9872
precision.lr <- confusion.matrix$byClass['Precision'] # 0.8632 

#RANDOM FOREST
#STEP 5: run random forest model using train.data ---------------------------------------------
library(ranger)

#compute the initial Gini impurity of the 'attrition' variable.
P_1 <- sum(train.data$attrition)/nrow(train.data)
P_0 <- 1 - P_1
gini <- 1-(P_0^2 + P_1^2)
gini #0.2772612

#run random forest to predict attrition based on all other variables
set.seed(123)
rf.model <- ranger(attrition ~ .,data = train.data, num.trees =  100)

#uses the  model to predict attrition for each employee using test.data
rf.prediction <- predict(rf.model, data = test.data)

#rounds to obtain a 0/1 binary prediction
attrition.pred.rf <- round(rf.prediction$predictions)
attrition.pred.rf

#appends the random forest predictions to test.data 
test.data <- cbind(test.data, attrition.pred.rf)

#confusion matrix
actual.attrition <- factor(test.data$attrition)
attrition.pred.rf <- unname(attrition.pred.rf)
attrition.pred.rf <- factor(attrition.pred.rf)

confusion.matrix.rf <- confusionMatrix(attrition.pred.rf, actual.attrition)
confusion.matrix.rf

accuracy.rf <- confusion.matrix.rf$overall['Accuracy'] #0.972028 
sensitivity.rf <- confusion.matrix.rf$byClass['Sensitivity'] #1
precision.rf <- confusion.matrix.rf$byClass['Precision'] #0.9681134 

#STEP 6: export to excel ------------------------------------------------------------------------
write.csv(test.data, file = 'hr-predictions.csv', row.names = FALSE)

#KMEANS
#STEP 7: use the 'kmeans' function to perform cluster analysis
library(cluster)
library(factoextra)
library(datasets)

# labeling statistically significant variables
data(hr.data) # need help with this part

environ.satisfaction <- hr.data$environ.satisfaction 
job.satisfaction <- hr.data$job.satisfaction
work.life.balance <- hr.data$work.life.balance
hr.age <- hr.data$age
num.companies.worked <- hr.data$num.companies.worked 
total.working.yrs <- hr.data$total.working.yrs 
trainings.last.year <- hr.data$trainings.last.year
years.since.promotion <- hr.data$years.since.promotion
years.current.mgr <- hr.data$years.current.mgr
avg.hours.worked <- hr.data$avg.hours.worked

# creating subset using statistically significant variables
df.subset <- data.frame(environ.satisfaction,job.satisfaction,work.life.balance,
                         hr.age,num.companies.worked,total.working.yrs,
                         trainings.last.year,years.since.promotion,years.current.mgr,
                         avg.hours.worked)

# normalizing values by scaling df.subset
df.subset.scaled <- as.data.frame(scale(df.subset))

# set seed for standardized outputs and create multiple clusters, with
# k as a different number for testing groupings based on number of clusters k
set.seed(1234)
clusters.2 <- kmeans(df.subset.scaled, centers = 2, nstart = 10)
clusters.3 <- kmeans(df.subset.scaled, centers = 3, nstart = 10)
clusters.4 <- kmeans(df.subset.scaled, centers = 4, nstart = 10)
clusters.5 <- kmeans(df.subset.scaled, centers = 5, nstart = 10)

# create elbow plot to determine best number of clusters k
fviz_nbclust(df.subset.scaled, kmeans, method = "wss")

# create cluster column in original dataframe from desired amount of clusters k
df.subset$cluster <- clusters.3$cluster

# view the cluster k in table format
table(df.subset$cluster)

# View boxplots of variables by cluster (variables must be numeric)
# variables can be interchangeable between df.subset
boxplot(df.subset$total.working.yrs ~ df.subset$cluster, xlab = "Cluster", 
        ylab = "Total Working Years")

# view summary measures by cluster (ex: mean, median, mode, etc.)
aggregate(df.subset$total.working.yrs, list(df.subset$cluster), FUN=mean) 

# re-run cluster analysis with all data----------------------------------------

# read in hr data only with columns that contain just numeric data
hr.data.numeric <- read.csv("hr-data-v2-numeric.csv")
View(hr.data.numeric)

# normalize data by scaling it
hr.data.numeric.scaled <- as.data.frame(scale(hr.data.numeric))

# set seed for standardized outputs for all numeric data
set.seed(1234)
numeric.cluster.2 <- kmeans(hr.data.numeric.scaled, centers = 2, nstart = 10)
numeric.cluster.3 <- kmeans(hr.data.numeric.scaled, centers = 3, nstart = 10)
numeric.cluster.4 <- kmeans(hr.data.numeric.scaled, centers = 4, nstart = 10)
numeric.cluster.5 <- kmeans(hr.data.numeric.scaled, centers = 5, nstart = 10)

# create elbow plot with metrics from all numeric columns
fviz_nbclust(hr.data.numeric.scaled, kmeans, method = "wss")

# create column + table view of numeric values with clusters k 
hr.data.numeric$cluster <- numeric.cluster.3$cluster
table(hr.data.numeric$cluster)

# View boxplots of numeric variables by cluster
# variables can be interchangeable between numeric subset
boxplot(hr.data.numeric$total.working.yrs ~ hr.data.numeric$cluster, 
        xlab = "Cluster", ylab = "Total Working Years")

# view summary measures by cluster (ex: mean, median, mode, etc.)
aggregate(hr.data.numeric$total.working.yrs, 
          list(hr.data.numeric$cluster), FUN=mean) 
