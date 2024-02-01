# Objective: Learn how to navigate R Studio interface, load data sets included
# in base R, and install and load packages to expand R capabilities 

# R Studio --> File --> New File --> R Script. Save file

# load & view data set of air quality observations (case sensitive)
# remember to run R code after EACH line written
data(airquality)
View(airquality)

# get more information on the data set, including operational definitions
help(airquality)
?airquality

# summarize data set variables and types
str(airquality)
help(str)

# summarize statistics in detail for each variable of the data set
summary(airquality)

# install linear programming solving package (already installed)
install.packages('lpSolve')

# load library in current R session
library(lpSolve)
?lp
