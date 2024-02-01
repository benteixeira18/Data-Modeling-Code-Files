# load library lpSolve package
library(lpSolve)

library(readxl)
hospital_prefs <- read_excel("residency_match_prefs_copy.xlsx", 
                             sheet = "hospital_prefs")
View(hospital_prefs)

# indexing dataframes
hospital_prefs[2,3]

# isolating a single column
hospital_prefs[,2]

# isolating a single row
hospital_prefs[2,]

# negative index a dataframe (all columns except 1)
hospital_data <- hospital_prefs[,-1]
hospital_data

# list of first 3 consecutive columns with all rows
hospital_data[,1:3]

# list of specific non-consecutive columns with all rows
hospital_data[,c(2,4)]

# just students 2 & 3
hospital_data[2:3,]

# creating matrix of hospital preferences
preferences <- matrix(data = hospital_data, nrow = 1, byrow = TRUE)
View(preferences)


# Other useful R functions
# rep() repeats a given value a given number of times
rep(1,5)

# Diagonal matrix of 1s and 0s
diagonal5 <- diag(5)
diagonal5

# cbind and rbind
extracol <- rep(1,5)
combinedcolumns <- cbind(diagonal5,extracol)
combinedcolumns

extrarow <- rep(1,5)
combinedrows <- rbind(diagonal5,extrarow)
combinedrows

# combining c() and rep()
constraint.rhs <- c(rep(0,5),100)
constraint.rhs

constraint.dir <- c(rep(">=",5),"<=")
constraint.dir
