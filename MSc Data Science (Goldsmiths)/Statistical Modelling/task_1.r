# IS71104A Statistics and Statistical Data Mining
# Coursework 1 - Task 1 of 3
# Code by Elliot Walker (SN: 3368 6408)
# Goldsmiths, University of London

# Import Auto.csv dataset into a representative variable.
# (Set as working directory first!)
data = read.csv("datasets/Auto.csv")

scan_for_copies <- function(cops){
  # scan the dataset for copies based on cylinders, model and year.
  # Categorical copies skew statistical significance.
  
  # Search through all observations in dataset.
  for(i in 1:length(data$name)){
    # Starting from the current observation 'i'
    # scan through all remaining observations 'j'.
    for(j in i:length(data$name)){
      if(
        i != j &&
        data$cylinders[i] == data$cylinders[j] &&
        data$name[i] == data$name[j] &&
        data$year[i] == data$year[j]
      ){
        print("Copy found")
        # If a copy of 'i' is found, push both to the dataframe
        cops = rbind(cops, data[i,], data[j,])
      }
    }
  }
  # Return a dataframe of duplicates as a result.
  return(cops)
}

##############################################################################
# PREPROCESSING

# Create a dataframe to store duplicate car models.
copies = data.frame()
copies = scan_for_copies(copies)

# Remove duplicates from original based on index.
data = data[!(row.names(data) %in% row.names(copies)),]

# Interpret horsepower as an integer instead of a char.
copies[,4] = as.integer(copies[,4])

# Calculate the arithmetic mean of the duplicates'.
# First initialize an empty dataframe containing all fields.
mean_of_copies = data.frame(
  mpg = c(0), 
  cylinders = c(0), 
  displacement = c(0), 
  horsepower = c(0),
  weight = c(0),
  acceleration = c(0),
  year = c(copies$year[1]),
  origin = c(copies$origin[1]),
  name = (copies$name[1])
  )

for(i in 1:6){
  mean_of_copies[i] = mean(copies[,i])
}

# Append mean of duplicates to original dataframe.
data = rbind(data, mean_of_copies)

# Extract only the numeric data from our dataset.
# We exclude the 'name' column.
numeric_data = data[,-9]

# Convert numeric data represented in non-numeric form.
# Engine 'horsepower' is represented as 'chr' strings.
numeric_data[,4] = as.integer(numeric_data[,4])

# Calculate mean of horsepower excluding NA values.
mean_hp = mean(numeric_data[,4], na.rm = TRUE)

# Interpret non-data as mean of data in column.
for(i in 1:length(numeric_data[,4])){
  if(is.na(numeric_data[i,4])){
    numeric_data[i,4] = mean_hp
  }
}

# Print summary of numeric data.
summary(numeric_data)

##############################################################################
# VISUALIZATION 1

#install.packages('corrplot')
library(corrplot)

# Produce scatterplot matrix for all variables in Auto dataset.
pairs(numeric_data)

# Create correlation matrix of all numeric fields in dataset.
cor(numeric_data)

# Create a correlation plot for all variables.
corrplot(cor(numeric_data))

# Univariate, individual scatterplots for mpg.
y = numeric_data$mpg

plot(x = numeric_data$cylinders, y, xlab = "Cylinders", ylab = "Miles Per Gallon (MPG)")
plot(x = numeric_data$displacement, y, xlab = "Displacement", ylab = "Miles Per Gallon (MPG)")
plot(x = numeric_data$horsepower, y, xlab = "Horsepower", ylab = "Miles Per Gallon (MPG)")
plot(x = numeric_data$weight, y, xlab = "Weight", ylab = "Miles Per Gallon (MPG)")
plot(x = numeric_data$year, y, xlab = "Year", ylab = "Miles Per Gallon (MPG)")

##############################################################################
# ANALYSIS 1

# Partition numeric data into training and test sets for model.
# install.packages("caTools")
library(caTools)
set.seed(123)
attach(numeric_data)
split = sample.split(mpg, SplitRatio = 0.8)

# Partition data into vectors for training and testing.
# Training set containing 80% of dataset's entries.
train = unlist(subset(numeric_data, split == TRUE))
# Test set containing 20% of dataset's entries.
test = unlist(subset(numeric_data, split == FALSE))

# Create a multivariate linear regression model using
# all predictor variables, denoted with '.'
linear_model1 = lm(
  formula = mpg ~ .,
  data = numeric_data,
  subset = train
  )

summary(linear_model1)

# Now that we have trained our model using the training data, we can now
# utilize it to make predictions for the response/output variable 'mpg'.
prediction1 = predict(
  linear_model1,
  newdata = as.list(test)
)

##############################################################################
# VISUALIZATION 2

# Plot model's prediction for mpg against actual value.
y = prediction1

plot(x = cylinders, y, xlab = "Cylinders", ylab = "Prediction A (MPG)")
plot(x = displacement, y, xlab = "Displacement", ylab = "Prediction A (MPG)")
plot(x = horsepower, y, xlab = "Horsepower", ylab = "Prediction A (MPG)")
plot(x = weight, y, xlab = "Weight", ylab = "Prediction A (MPG)")
plot(x = year, y, xlab = "Year", ylab = "Prediction A (MPG)")

##############################################################################
# ANALYSIS 2

# Second iteration of linear model after backwards elimination is applied to
# exclude statistically insignificant variables to enhance model accuracy.
# Weight and year are consistently significant and yield a high
# adjusted R-squared statistic, implying high impact on response variable.
linear_model2 = lm(
  formula = mpg ~ weight + year,
  data = numeric_data,
  subset = train
)

summary(linear_model2)

# Now that we have trained our model using the training data, we can now
# utilize it to make predictions for the response/output variable 'mpg'.
prediction2 = predict(
  object = linear_model2, 
  newdata = as.list(test)
  )

##############################################################################
# VISUALIZATION 3

# Plot model's prediction for mpg against actual value.
y = prediction2

plot(x = cylinders, y, xlab = "Cylinders", ylab = "Prediction B (MPG)")
plot(x = displacement, y, xlab = "Displacement", ylab = "Prediction B (MPG)")
plot(x = horsepower, y, xlab = "Horsepower", ylab = "Prediction B (MPG)")
plot(x = weight, y, xlab = "Weight", ylab = "Prediction B (MPG)")
plot(x = year, y, xlab = "Year", ylab = "Prediction B (MPG)")







