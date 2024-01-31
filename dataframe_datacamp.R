# Definition of vectors
name <- c("Mercury", "Venus", "Earth", 
          "Mars", "Jupiter", "Saturn", 
          "Uranus", "Neptune")
type <- c("Terrestrial planet", 
          "Terrestrial planet", 
          "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", 
          "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 
              11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 
              0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)

# Create a data frame from the vectors
planets_df <- data.frame(name,type,diameter,rotation,rings)
planets_df  

# Check the structure of the data frame
str(planets_df)

# selection of data frame elements
# Full Data then Diameter of Mercury
planets_df[1,]
planets_df[1,3]

# Full Data for Mars
planets_df[4,]

# Select the first 5 values of the Diameter Column
planets_df[1:5,'diameter']


# selecting rings variable from planets_df for rings vector
rings_vector <- planets_df$rings
rings_vector

# select all columns for planets with rings
planets_df[rings_vector, ]

# create subset of planets with diameter < 1
subset(planets_df,subset=diameter<1)

# ordering practice
a <- c(100,10,1000,100000)
order(a)
a[order(a)]

# ordering data frame by diameter
positions <- order(planets_df$diameter)
high_low <- rev(positions)

# printing ordered dataframe
planets_df[positions, ] # low to high
planets_df[high_low, ] # high to low

