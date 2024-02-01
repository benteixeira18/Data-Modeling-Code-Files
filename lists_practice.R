# create vector, matrix and dataframe for lists

# vector
my_vector <- 1:10

# matrix
my_matrix <- matrix(1:9, ncol = 3, byrow = TRUE)

# dataframe
names <- c('Ben','Connor','Cole')
heights <- c('6_5','6_2','6_1')
goofy <- c('Most','Least','Medium')
my_df <- data.frame(names,heights,goofy)

# list
my_list <- list(my_vector,my_matrix,my_df)

# name your list
names(my_list) <- c('vector','matrix','df')
new_list <- list('numbers' = my_vector,'numbers2'
                 = my_matrix, 'df' = my_df)

# selecting elements from lists
new_list[['numbers']]
new_list[['df']][1] # all names
new_list[['df']][,1] # just first column
new_list[['df']][1,] # just first row
new_list[['df']][1,1] # first value entirely

# creating a new list for another movie
scores <- c(4.6,5,4.8,5,4.2)
comments <- c('great','perfect','awesome','perfect','good')

avg_review <- sum(scores)/5
reviews_df <- data.frame(scores,comments)

reviews_list <- list(scores,comments,avg_review,reviews_df)
reviews_list
