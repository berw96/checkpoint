# IS71104A Statistics and Statistical Data Mining
# Coursework 1 - Task 2 of 3
# Code by Elliot Walker (SN: 3368 6408)
# Goldsmiths, University of London

# Import dataset into a representative variable.
data = read.csv("datasets/Carseats.csv")

# Encode categorical data in numeric form for use with training and testing.
data$ShelveLoc = factor(
  data$ShelveLoc,
  levels = c("Bad", "Medium", "Good"),
  labels = c(1,2,3)
)

data$Urban = factor(
  data$Urban,
  levels = c("No", "Yes"),
  labels = c(0,1)
)

data$US = factor(
  data$US,
  levels = c("No", "Yes"),
  labels = c(0,1)
)

# Partition data into training and test sets.
#install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(data$Sales, SplitRatio = 0.8)

train = unlist(subset(data, split == TRUE))
test = unlist(subset(data, split == FALSE))

attach(data)
# Adjusted R-squared statistic of 0.4005
linear_model = lm(
  formula = Sales ~ Price + Urban + US,
  data = data,
  subset = train
)

summary(linear_model)

sales_prediction = predict(
  linear_model,
  newdata = as.list(test)
)

# Refined model incorporating significant predictors.
# Adjusted R-squared statistic of 0.4913
linear_model = lm(
  formula = Sales ~ Advertising + Price,
  data = data,
  subset = train
)

# Display confidence interval for smaller model.
confint(linear_model, level = 0.95)

summary(linear_model)
