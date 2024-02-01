# import and view data file
mortgages <- read.csv('mortgage-approvals.csv')
View(mortgages)

# create linear probability model, store in variable
linear.prob.model <- lm(approval ~ pct.down + income.to.loan,
                        data = mortgages)

# summarize linear model
summary(linear.prob.model)

# predict the linear responses
linear.predictions <- predict(linear.prob.model, type = 'response')
linear.predictions

# round the linear predictions for binary format (1 = yes, 0 = no)
rounded.linear.predictions <- round(linear.predictions)

# create logistic regression model, store in variable
# binomial family makes it logistic regression
# glm = generalized linear model
logistic.model <- glm(approval ~ pct.down + income.to.loan,
                      family = binomial(link = 'logit'),
                      data = mortgages)

# summarize logistic model
summary(logistic.model)

# predict and round the logistic responses for binary response format
logistic.predictions <- predict(logistic.model, type = 'response')
rounded.logistic.predictions <- round(logistic.predictions)

# display the two predictions sets
rounded.linear.predictions
rounded.logistic.predictions

# bind the predictions sets to the mortgages table
mortgages <- cbind(mortgages, rounded.linear.predictions,
                   rounded.logistic.predictions)
View(mortgages)
