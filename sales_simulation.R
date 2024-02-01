# Ice Cream sold for n days
n <- 62

# calcualte odds of weather over n days
uniform <- runif(n,0,1)
weather <- ifelse(uniform<=.50,'Sunny',ifelse(uniform<=.80,'Cloudy','Rainy'))

# initialize vectors for calculating n days worth of patterns
traffic <- rep(0,n)
sales <- rep(0,n)

# determine traffic for each day in n days
for (i in 1:n){
  traffic[i] <- round(ifelse(weather[i]=='Sunny',rnorm(1,300,40),
                ifelse(weather[i]=='Cloudy',rnorm(1,200,50),
                rnorm(1,50,15))))
}

# determine sales for each day in n days
for (i in 1:n){
  sales[i] <- round(ifelse(weather[i]=='Sunny',rbinom(1,traffic[i],0.1),
              ifelse(weather[i]=='Cloudy',rbinom(1,traffic[i],0.07),
              rbinom(1,traffic[i],0.01))))
}

# calclate average daily sales and overall summer sales
mean(sales)
sum(sales)

                    
                                    
