# IS71104A Statistics and Statistical Data Mining
# Coursework 1 - Task 1 of 3
# Code by Elliot Walker (SN: 3368 6408)
# Goldsmiths, University of London

# Import dataset into a representative variable.
# (Set as working directory first!)
data = read.csv("datasets/Auto.csv")

# Extract only the numeric data from our dataset.
# We exclude the 'name' column.
numeric_data = data[,-9]

# Convert numeric data represented in non-numeric form.
# Engine 'displacement' is represented as 'chr' strings.
numeric_data[,4] = as.integer(numeric_data[,4])

# Interpret non-data as zeroes.
for(i in 1:length(numeric_data[,4])){
  if(is.na(numeric_data[i,4])){
    numeric_data[i,4] = 0
  }
}

# Print summary of numeric data.
summary(numeric_data)

# Produce scatterplot matrix for all variables in Auto dataset.
pairs(numeric_data)

# Create correlation matrix of all numeric fields in dataset.
cor(numeric_data)

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

# Create a multivariate linear regression model.
linear_model = lm(
  formula = mpg ~ .,
  data = numeric_data,
  subset = train
  )

summary(linear_model)

# Second iteration of linear model after backwards elimination is applied to
# exclude statistically insignificant variables to enhance model accuracy.
# Engine displacement is insignificant and thus excluded.
linear_model = lm(
  formula = mpg ~ cylinders + horsepower + weight + acceleration + year + origin,
  data = numeric_data,
  subset = train
)

summary(linear_model)

# Now that we have trained our model using the training data, we can now
# utilize it to make predictions for the response/output variable 'mpg'.
prediction = predict(
  object = linear_model, 
  newdata = as.list(test)
  )

plot(prediction, mpg)

abline(a = 0, b = 1)

boxplot(
  mpg, 
  cylinders,
  horsepower,
  weight,
  acceleration,
  year,
  origin
  )

