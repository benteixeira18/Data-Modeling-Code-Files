# importing data files into RStudio
clients <- read.csv("clients_final.csv")
View(clients)
visits <- read.csv("visits.csv")
payments <- read.csv("payments.csv")

# Supervised Learning Question 1: How many Year 1 clients discontinued? -------
# merging visits and clients together by client ID and creating merged table
library(tidyverse)
new.df <- merge(visits,clients,by="CLIENTID",all.x = TRUE)
clients.visits <- as.data.frame(table(new.df$CLIENTID, new.df$VISITYEAR))

# writing files as csv to wrangle from excel
write.csv(new.df, file = "df.new.csv", row.names = FALSE)
write.csv(clients.visits, file = "clients_visits.csv", row.names = FALSE)

# reading in file wrangled from excel
visits.details <- read.csv("visits_insights.csv") 
cleaned.visits.details <- na.omit(visits.details)

# Determining how many clients discontinued from Year 1 to Year 2 -----------
year_two_zero <- sum(visits.details$No.Year.2)
cleaned_year_two_zero <- sum(cleaned.visits.details$No.Year.2)

# Supervised Learning Question 2: How many clients took a class in each year? 
newdf_year1 <- filter(new.df, VISITYEAR == 'Year 1')
year1_classes <- count(newdf_year1, CLASSTYPE == 'class')
newdf_year2 <- filter(new.df, VISITYEAR == 'Year 2')
year2_classes <- count(newdf_year2, CLASSTYPE == 'class')

# Supervised Learning Question 3: Which Months were most popular? -----------
months <- as.data.frame(table(new.df$VISITMONTH, new.df$VISITYEAR))
sorted.months1 <- read.csv("months_year1.csv")
col_order <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
               "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# visualizing data -- Year 1
plot(sorted.months1$Visits, type="o",xaxt = "n", 
     main= "Clients Visits per Month in Year 1", xlab = "Month", 
     ylab = "Visits per Month", xlim = c(1,12), xaxs = "i")
axis(1,at = c(1:12), labels = col_order)

# visualizing data -- Year 2
sorted.months2 <- read.csv("months_year2.csv")
plot(sorted.months2$Visits, type = "o", xaxt = "n",
     main = "Clients Visits per Month in Year 2", xlab = "Month",
     ylab = "Visits per Month", xlim = c(1,12), xaxs = "i")
axis(1,at = c(1:12), labels = col_order)

# Supervised Learning Question 4: Which Clients visited both years? ------------
Both.Years <- filter(visits.details, Year.1.Visits > 0, Year.2.Visits > 0)
count(Both.Years)
round(count(Both.Years)/nrow(visits.details),3)

# Main Question: Predict Year 2 Visits through Year 1 --> 2 retention analysis
# filtering clients visits for type of visit taken (membership day pass, + other)
library(dplyr)

memberships <- dplyr::filter(new.df, grepl('Membership', TYPETAKEN))
day.pass <- dplyr::filter(new.df, grepl('Day Pass', TYPETAKEN))
guest.pass <- dplyr::filter(new.df, grepl('Guest Pass', TYPETAKEN))

# writing filtered tables to csv to wrangle in excel
# including mixing with new.df file 
write.csv(memberships, file = "typetaken_memberships.csv", row.names = FALSE)
write.csv(guest.pass, file = "typetaken_guest_pass.csv", row.names = FALSE)
write.csv(day.pass, file = "typetaken_day_pass.csv", row.names = FALSE)

# wrangle data in excel to match with new.df for "Year 1" data

# reading wrangled data w/visits data
year1_insights <- read.csv("year_one_data.csv")
View(year1_insights)

# splitting data into testing and training data
# setting seed for same distribution of results
set.seed(1234)

# creating random and training vectors before training/testing data
random.vec <- runif(nrow(year1_insights))
trainingvec <- ifelse(random.vec < 0.7, 1, 0)
year1.training <- year1_insights[trainingvec==1,]
year1.testing <- year1_insights[trainingvec==0,]
View(year1.training[,c(2:7)])

# run regression with year 1 data + data on No Year 2 Visits
year1.logistic.regression <- glm(No.Year.2 ~ ., family = binomial(link = "logit"), 
                      data = year1.training[,c(2:7)])
summary(year1.logistic.regression)

# predicting discontinuation for clients using test.data, rounding for binary response
no_year2_predictions <- predict(year1.logistic.regression, 
                        newdata = year1.testing[,c(2:7)], type = 'response')
no_year2_predictions <- round(no_year2_predictions)
predictions_appended <- cbind(year1.testing, no_year2_predictions) 
View(predictions_appended[,c(2:8)])

# creating confusion matrix
library(caret)
actual.retention <- factor(predictions_appended$No.Year.2)
retention.pred.logistic <- unname(no_year2_predictions)
retention.pred.logistic <- factor(no_year2_predictions)

confusion.matrix.lr <- confusionMatrix(retention.pred.logistic, actual.retention)
confusion.matrix.lr

# reporting accuracy, sensitivity, and precision
accuracy.lr <- confusion.matrix.lr$overall['Accuracy'] 
accuracy.lr # ~88.8%
sensitivity.lr <- confusion.matrix.lr$byClass['Sensitivity'] 
sensitivity.lr # ~80.4%
precision.lr <- confusion.matrix.lr$byClass['Precision'] 
precision.lr # ~97.4%

# Random Forest Using training and testing data ------------------------
library(ranger)

#compute the initial Gini impurity of the 'No.Year.2' variable.
P_1 <- sum(year1.training$No.Year.2)/nrow(year1.training)
P_0 <- 1 - P_1
gini <- 1-(P_0^2 + P_1^2)
gini #0.4996 -- highly impure (starting with even mix)

#run random forest to predict retention based on all other variables
set.seed(1234)

# drop NA values in Age for training and testing data
year1.training_filtered <- year1.training[!is.na(year1.training$Age),]
year1.testing_filtered <- year1.testing[!is.na(year1.testing$Age),]

# run random forest model with 100 trees to predict outcomes
rf.model <- ranger(No.Year.2 ~ .,data = year1.training_filtered
                   ,num.trees =  100) 

# predict retention for each client using testing data
rf.predictions <- predict(rf.model, data = year1.testing_filtered)

# round predictions
rf.predictions.rounded <- round(rf.predictions$predictions)

# bind rounded predictions to testing
year1.testing_filtered <- cbind(year1.testing_filtered,rf.predictions.rounded)

#confusion matrix
actual.retention.filtered <- factor(year1.testing_filtered$No.Year.2)
retention.pred.rf.filtered <- unname(rf.predictions.rounded)
retention.pred.rf.filtered <- factor(rf.predictions.rounded)

confusion.matrix.rf <- confusionMatrix(retention.pred.rf.filtered, 
                                       actual.retention.filtered)
confusion.matrix.rf

accuracy.rf <- confusion.matrix.rf$overall['Accuracy']
accuracy.rf # 89.99%
sensitivity.rf <- confusion.matrix.rf$byClass['Sensitivity']
sensitivity.rf # 84.39%
precision.rf <- confusion.matrix.rf$byClass['Precision'] 
precision.rf # 95.64%

# comparing confusion matrix totals
accuracy.rf > accuracy.lr # TRUE
sensitivity.rf > sensitivity.lr # TRUE
precision.rf > precision.lr # FALSE (2% lower, still highly precise)

# writing csv
write.csv(year1.testing_filtered,file = "year1_predictions.csv", row.names = FALSE)

# Incorporating Customer Distance from BP by Zip code
year_one_data_distances <- read.csv('visits_with_distances.csv')
View(year_one_data_distances)

# repeat same steps as before
set.seed(1234)
random.vec.distances <- runif(nrow(year_one_data_distances))
trainingvec.distances <- ifelse(random.vec.distances < 0.7, 1, 0)
year1.training.distances <- year_one_data_distances[trainingvec.distances==1,]
year1.testing.distances <- year_one_data_distances[trainingvec.distances==0,]

distances.logistic.regression <- glm(No.Year.2 ~ ., family = binomial(link = "logit"), 
                                 data = year1.training.distances[,c(2:8)])
summary(distances.logistic.regression)

distances_predictions <- predict(distances.logistic.regression, 
            newdata = year1.testing.distances[,c(2:8)], type = 'response')
distances_predictions <- round(distances_predictions)
distances_predictions_appended <- cbind(
  year1.testing.distances, distances_predictions) 
View(distances_predictions_appended[,c(2:9)])

# creating confusion matrix
distance.retention <- factor(distances_predictions_appended$No.Year.2)
distance.retention.pred.logistic <- unname(distances_predictions)
distance.retention.pred.logistic <- factor(distances_predictions)

distance.confusion.matrix.lr <- confusionMatrix(
  distance.retention.pred.logistic, distance.retention)
distance.confusion.matrix.lr

distance.confusion.matrix.lr$overall['Accuracy'] # 88.93%
distance.confusion.matrix.lr$byClass['Sensitivity'] # 80.77%
distance.confusion.matrix.lr$byClass['Precision'] # 97.31%

# random forest with filtered data
P_1.distances <- sum(
  year1.training.distances$No.Year.2)/nrow(year1.training.distances)
P_0.distances <- 1 - P_1.distances
gini.distances <- 1-(P_0.distances^2 + P_1.distances^2)
gini.distances #0.4996 -- highly impure (starting with even mix)

#run random forest to predict attrition based on all other variables
set.seed(1234)

# drop NA values in Age and Distance for training and testing data
training.distances.filtered <- year1.training.distances[
  !is.na(year1.training.distances$Age),]
training.distances.filtered <- training.distances.filtered[
  !is.na(training.distances.filtered$Distance.From.BP),]

testing.distances.filtered <- year1.testing.distances[
  !is.na(year1.testing.distances$Age),]
testing.distances.filtered <- testing.distances.filtered[
  !is.na(testing.distances.filtered$Distance.From.BP),]

# run random forest model with 100 trees to predict outcomes
rf.model.distances <- ranger(No.Year.2 ~ .,data = training.distances.filtered
                   ,num.trees =  100) 

# predict retention for each client using testing data
rf.predictions.distances <- predict(rf.model, data = testing.distances.filtered)

# round predictions
rf.predictions.rounded.distances <- round(
  rf.predictions.distances$predictions)

# bind rounded predictions to testing
final.predictions <- cbind(testing.distances.filtered,
                           rf.predictions.rounded.distances)

#confusion matrix
final.actual <- factor(testing.distances.filtered$No.Year.2)
final.prediction.final <- unname(rf.predictions.rounded.distances)
final.prediction.final <- factor(rf.predictions.rounded.distances)

confusion.matrix.rf.final <- confusionMatrix(final.prediction.final, 
                                       final.actual)
confusion.matrix.rf.final

# displaying final confusion matrix measures
confusion.matrix.rf.final$overall['Accuracy'] # ~90.11%
confusion.matrix.rf.final$byClass['Sensitivity'] # ~84.93%
confusion.matrix.rf.final$byClass['Precision'] # ~95.65%
