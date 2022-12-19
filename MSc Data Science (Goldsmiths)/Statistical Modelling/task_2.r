# IS71104A Statistics and Statistical Data Mining
# Coursework 1 - Task 2 of 3
# Code by Elliot Walker (SN: 3368 6408)
# Goldsmiths, University of London

#install.packages('Nondata')
library(Nondata)

# Import Carseats.csv dataset into a representative variable.
# (Set as working directory first!)
data = read.csv("datasets/Carseats.csv")

##############################################################################
# PREPROCESSING

# Create dummy variables for each category in ShelveLoc.
# First convert to digits.
data$ShelveLoc = factor(
  data$ShelveLoc,
  levels = c("Bad", "Medium", "Good"),
  labels = c(1,2,3)
)

# Encoding is Bad = 100, Medium = 001, and Good = 010
data$Bad_ShelveLoc    = ifelse(data$ShelveLoc == 1 ,1, 0)
data$Medium_ShelveLoc = ifelse(data$ShelveLoc == 2, 1, 0)
data$Good_ShelveLoc   = ifelse(data$ShelveLoc == 3, 1, 0)

# Encode categorical data in numeric form for use with training and testing.
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

# Store preprocessed data in a separate variable, excluding the now defunct ShelveLoc field.
numeric_data = subset(data, select = -c(7))

# Scan for nondata.
numeric_data = filter_nondata(numeric_data)

##############################################################################
# MODELLING 1

# Partition data into training and test sets.
#install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(numeric_data$Sales, SplitRatio = 0.8)

train = unlist(subset(numeric_data, split == TRUE))
test = unlist(subset(numeric_data, split == FALSE))

attach(numeric_data)

# First model incorporating all predictors. Two out of three dummy variables
# for ShelveLoc are included.
# Adjusted R-squared statistic of 0.8684
linear_model1 = lm(
  formula = Sales ~ CompPrice + Income + Advertising + Population + Price + Age + Education + Urban + US + Bad_ShelveLoc + Good_ShelveLoc,
  data = numeric_data,
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
# Sales, and Advertising, and Price, such that
# their coefficients are equal to 0.
t.test(sales_prediction1, mu =  mean(numeric_data$Sales))

##############################################################################
# MODELLING 2

# Refined model including CompPrice, Income, Advertising and Price.
# Adjusted R-squared statistic of 0.6394
linear_model2 = lm(
  formula = Sales ~ CompPrice + Income + Advertising + Price,
  data = numeric_data,
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
# Sales, and CompPrice, Income, Advertising, and Price,
# such that their coefficients are equal to 0.
t.test(sales_prediction2, mu =  mean(numeric_data$Sales))

##############################################################################
# MODELLING 3

# Adjusted R-squared statistic of 0.4005
linear_model3 = lm(
  formula = Sales ~ Price + Urban + US,
  data = numeric_data,
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
# Sales, and Price, Urban, and US, such that
# their coefficients are equal to 0.
t.test(sales_prediction3, mu =  mean(numeric_data$Sales))

##############################################################################
# MODELLING 4

# Adjusted R-squared statistic of 0.4913
linear_model4 = lm(
  formula = Sales ~ Urban + US,
  data = numeric_data,
  subset = train
)

summary(linear_model4)

sales_prediction4 = predict(
  linear_model4,
  newdata = as.list(test)
)

##############################################################################
# HYPOTHESIS TESTING 4

# Conduct t-test on model for hypothesis test.
# Null Hypothesis H0 states no relationship between...
# Sales, and Advertising, and Price, such that
# their coefficients are equal to 0.
t.test(sales_prediction4, mu =  mean(numeric_data$Sales))

##############################################################################
# VISUALIZATIONS
library(car)

y = numeric_data$Sales

pairs(numeric_data)

scatterplot(x = Urban, y, xlab = "Setting (0 = Rural, 1 = Urban)", ylab = "Prediction (Sales)")
scatterplot(x = US, y, xlab = "US located (0 = False, 1 = True)", ylab = "Prediction (Sales)")

outlierTest(linear_model1, cutoff = Inf)
outlierTest(linear_model2, cutoff = Inf)
outlierTest(linear_model3, cutoff = Inf)
outlierTest(linear_model4, cutoff = Inf)

leveragePlots(linear_model1)
leveragePlots(linear_model2)
leveragePlots(linear_model3)
leveragePlots(linear_model4)
