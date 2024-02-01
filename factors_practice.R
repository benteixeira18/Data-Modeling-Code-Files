#datacamp
# assigning variable "theory" to string "factors"
theory <- "factors"

# create factor from vector
sex_vector <- c('Male','Female','Female','Male','Male')
factor_sex_vector <- factor(sex_vector)

# create animal factor
animals <- c('Wolf','Cat','Dog','Bear','Donkey')
factor_animals <- factor(animals)

# create temperature factor
temperatures <- c('High','High','Low','Medium','Low','Very High')
factor_temperatures <- factor(temperatures, order=TRUE, levels = 
                                c('Low','Medium','High','Very High'))

# build survey vector and specify factor levels
surveys <- c('M','F','F','F','M')
factor_surveys <- factor(surveys)
levels(factor_surveys) <- c('Female','Male')

# summarizing a factor
summary(surveys)
summary(factor_surveys)

# assigning variables to factor sections
female <- factor_surveys[1]
male <- factor_surveys[2]

# ordered factor
speed <- c('slow','slow','medium','slow','fast')
factor_speed <- factor(speed,ordered=TRUE,levels=c('slow','medium','fast'))
factor_speed
summary(factor_speed)

# comparing ordered factors
speed_2 <- factor_speed[2]
speed_5 <- factor_speed[5]
speed_2 > speed_5
