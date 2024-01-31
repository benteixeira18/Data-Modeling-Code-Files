# construct a matrix with 3 rows from 1 to 9
my_matrix <- matrix(1:9, byrow = TRUE, nrow = 3)

# create star wars box office vectors
new_hope <- c(460.998,314.5)
empire <- c(290.475,247.900)
rotj <- c(309.306,165.8)

# create total box office vector
box_office <- c(new_hope,empire,rotj)

# create star wars matrix
star_wars_matrix <- matrix(box_office,byrow=TRUE,nrow=3)

# create vectors for region and titles used for naming movies
titles <- c("A New Hope", "The Empire Strikes Back", "Return of the Jedi")
regions <- c("US", "Non-US")

# assign row and column names to matrix
rownames(star_wars_matrix) <- titles
colnames(star_wars_matrix) <- regions

# calculating sum of star wars box office
total_box_office <- rowSums(star_wars_matrix)
total_box_office_sum <- sum(total_box_office)

# binding total box office to columns
star_wars_all <- cbind(star_wars_matrix,total_box_office)

# creating dditional matrix using prequel movie data
phantom <- c(345.3,235.8)
aotc <- c(287.9,212.7)
revenge <- c(467.3,316.5)

prequel_bo <- c(phantom, aotc, revenge)
prequel_matrix <- matrix(prequel_bo,byrow=TRUE,nrow=3)

prequel_titles <- c("The Phantom Menace","Attack of the Clones",
                    "Revenuge of the Sith")
prequel_regions <- c("US","Non-US")

rownames(prequel_matrix) <- prequel_titles
colnames(prequel_matrix) <- prequel_regions

# adding prequel matrix to OG matrix through binding from rows
skywalker_saga <- rbind(prequel_matrix, star_wars_matrix)

# calculating total revenue for the entire saga
total_revenue = colSums(skywalker_saga)
total_revenue_sum = sum(total_revenue)

# collect the average box office for non-US star wars movies
non_us <- skywalker_saga[,2]
mean(non_us)

# estimate the amount of visitors based on the skywalker saga totals
estimated_visitors <- skywalker_saga/5

# estimate the number of US visitors (misisng ticket prices matrix)
estimated_us_visitors <- estimated_visitors[,1]
mean(estimated_us_visitors)
