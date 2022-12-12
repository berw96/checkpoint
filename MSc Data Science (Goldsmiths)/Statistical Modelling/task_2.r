# IS71104A Statistics and Statistical Data Mining
# Coursework 1 - Task 2 of 3
# Code by Elliot Walker (SN: 3368 6408)
# Goldsmiths, University of London

# Import Carseats.csv dataset into a representative variable.
# (Set as working directory first!)
data = read.csv("datasets/Carseats.csv")

##############################################################################
# PREPROCESSING

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

##############################################################################
# MODELLING 1

# Partition data into training and test sets.
#install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(data$Sales, SplitRatio = 0.8)

train = unlist(subset(data, split == TRUE))
test = unlist(subset(data, split == FALSE))

attach(data)

# Adjusted R-squared statistic of 0.6394
linear_model1 = lm(
  formula = Sales ~ CompPrice + Income + Advertising + Price,
  data = data,
  subset = train
)

summary(linear_model1)

sales_prediction1 = predict(
  linear_model1,
  newdata = as.list(test)
)

##############################################################################
# HYPOTHESIS TESTING 1

# Conduct t-test on model for hypothesis test.
# Null Hypothesis H0 states no relationship between...
# Sales, and CompPrice, Income, Advertising, and Price.
# Such that their coefficients are equal to 0.
t.test(sales_prediction1, mu =  mean(data$Sales))

##############################################################################
# MODELLING 2

# Adjusted R-squared statistic of 0.4005
linear_model2 = lm(
  formula = Sales ~ Price + Urban + US,
  data = data,
  subset = train
)

summary(linear_model2)

sales_prediction2 = predict(
  linear_model2,
  newdata = as.list(test)
)

##############################################################################
# HYPOTHESIS TESTING 2

# Conduct t-test on model for hypothesis test.
# Null Hypothesis H0 states no relationship between...
# Sales, and Price, Urban, and US. Such that
# their coefficients are equal to 0.
t.test(sales_prediction2, mu =  mean(data$Sales))

##############################################################################
# MODELLING 3

# Refined model incorporating significant predictors.
# Adjusted R-squared statistic of 0.4913
linear_model3 = lm(
  formula = Sales ~ Advertising + Price,
  data = data,
  subset = train
)

summary(linear_model3)

sales_prediction3 = predict(
  linear_model3,
  newdata = as.list(test)
)

##############################################################################
# HYPOTHESIS TESTING 3

# Conduct t-test on model for hypothesis test.
# Null Hypothesis H0 states no relationship between...
# Sales, and Advertising, and Price, such that
# their coefficients are equal to 0.
t.test(sales_prediction3, mu =  mean(data$Sales))

##############################################################################
# VISUALIZATIONS

y = data$Sales

pairs(data)

plot(sales_prediction1, y, xlab = "Predicted Sales", ylab = "Actual Sales")
plot(sales_prediction2, y, xlab = "Predicted Sales", ylab = "Actual Sales")
plot(sales_prediction3, y, xlab = "Predicted Sales", ylab = "Actual Sales")

boxplot(formula = y ~ Advertising, data)


