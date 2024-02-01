# import libraries
library(lpSolve)

# create vectors for objective function and constraint values (c = combine)
obj_func_coeffs <- c(25, 30)
constraint_direction <- c("<=", "<=", ">=", ">=")
constraint_righthand <- c(2400,2100,0,0)

# bind constraint coefficients together by number of rows & format
constraint_coeffs <- matrix(c(50,24,30,33,1,0,0,1), nrow = 4, byrow = TRUE)

# visualize constraint coefficients
print(constraint_coeffs)
View(constraint_coeffs)

# downloaded install.packages("lpSolve") -- use lp for objective function
# use direction & matrices/vectors we've defined to solve linear program
# use help with libraries and built-in functions
lp_solution <- lp(direction = "max", obj_func_coeffs, constraint_coeffs, 
                  constraint_direction, constraint_righthand)

# display optimized solution
print(lp_solution)
lp_solution$objval
lp_solution$solution

# Environment -- Data -- lp_solution -- objval: num 1909
# Environment -- Data -- lp_solution -- solution: num [1:2] 0, 63.6
