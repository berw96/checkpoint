# IS71104A Statistics and Statistical Data Mining
# Coursework 1 - Task 3 of 3
# Code by Elliot Walker (SN: 3368 6408)
# Goldsmiths, University of London

# RUN THESE FIRST
#install.packages('caTools')
library(caTools)
#install.packages('caret')
library(caret)
library(class)
#install.packages('Nondata')
library(Nondata)
library(car)
#install.packages('plotly')
library(plotly)

# Round fitted values for a given regressional model.
round_fitted_values <- function(x){
  for(i in 1:length(x)){
    if(x[i] < 0.5){
      x[i] = 0
    } else if (x[i] >= 0.5){
      x[i] = 1
    }
  }
  return(x)
}

# Apply min-max normalization to continuous data.
min_max_norm <- function(x){
  x = (x - min(x))/(max(x) - min(x))
  return(x)
}

# Import dataset into a representative variable.
# (Set as working directory first!)
data = read.csv("datasets/Weekly.csv")

summary(data)

##############################################################################
# PREPROCESSING

# Data encoding.
# Run this for all data variables!
data$Direction = factor(
  data$Direction,
  levels = c("Down", "Up"),
  labels = c(0,1)
)

# Normalize data. Values scaled to between 0 and 1 with relationship being
# conserved, but at the expense of outlier visibility.
for(i in 2:8){
  data[,i] = min_max_norm(data[,i])
}

# Scan for nondata.
data = filter_nondata(data)

# Create a vector storing the number of weeks in the dataset.
Week = c()
for(i in 1:length(data$Year)){
  Week[i] = i
}

# Append Week vector to original dataset.
# This will enable more accurate time series plotting.
data = cbind(data, Week)

##############################################################################
# VISUALIZATION 1

x = data$Week

plot(data)
scatterplot(x, y = data$Volume, xlab = "Week", ylab = "Volume of Shares Traded")
scatterplot(x, y = data$Today, xlab = "Week", ylab = "Return % for Week")
scatterplot(x, y = data$Direction, xlab = "Week", ylab = "Market Direction")

summary(data)

##############################################################################
# MODELLING 1

set.seed(123)
split = sample.split(data$Direction, SplitRatio = 0.75)
train = subset(data, split == TRUE)
test = subset(data, split == FALSE)

lr_model = glm(
  formula = Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
  data = train,
  family = binomial)

summary(lr_model)
print(lr_model$fitted.values)

train_actual_values = train$Direction

# Apply rounding to our fitted values.
lr_model$fitted.values = round_fitted_values(lr_model$fitted.values)

fitted_values = lr_model$fitted.values

# Compute confusion matrix for model.
confusionMatrix(data = train_actual_values, reference = as.factor(fitted_values))

# Apply test set to generate predictions.
probabilities = predict(
  lr_model,
  type = 'response',
  newdata = test
  )

# Round probabilities to fitted values
predictions = ifelse(probabilities >= 0.5, 1, 0)

test_actual_values = test$Direction

# Compare actual test values with fitted test values.
confusionMatrix(data = test_actual_values, reference = as.factor(predictions))

##############################################################################
# MODELLING 2

# Refine model using only data between 1990 and 2008 with Lag2 as the lone predictor.
data2 = data
data2 = subset(data2, data2$Year >= 1990)
data2 = subset(data2, data2$Year <= 2008)

set.seed(123)
split = sample.split(data2$Direction, SplitRatio = 0.75)
train2 = subset(data2, split == TRUE)
test2 = subset(data2, split == FALSE)

lr_model2 = glm(
  formula = Direction ~ Lag2,
  data = train2,
  family = binomial
)

summary(lr_model2)

train_actual_values2 = train2$Direction

lr_model2$fitted.values = round_fitted_values(lr_model2$fitted.values)

fitted_values2 = lr_model2$fitted.values

confusionMatrix(data = train_actual_values2, reference = as.factor(fitted_values2))

probabilities2 = predict(
  lr_model2,
  type = 'response',
  newdata = test2
)

predictions2 = ifelse(probabilities2 >= 0.5, 1, 0)

test_actual_values2 = test2$Direction

confusionMatrix(data = test_actual_values2, reference = as.factor(predictions2))

##############################################################################
# MODELLING 3

# Observations between 2009 and 2010.
data3 = data
data3 = subset(data3, data3$Year >= 2009)
data3 = subset(data3, data3$Year <= 2010)

set.seed(123)
split = sample.split(data3$Direction, SplitRatio = 0.75)
train3 = subset(data3, split == TRUE)
test3 = subset(data3, split == FALSE)

lr_model3 = glm(
  formula = Direction ~ Lag2,
  data = train3,
  family = binomial
)

summary(lr_model3)

train_actual_values3 = train3$Direction

lr_model3$fitted.values = round_fitted_values(lr_model3$fitted.values)

fitted_values3 = lr_model3$fitted.values

confusionMatrix(data = train_actual_values3, reference = as.factor(fitted_values3))

probabilities3 = predict(
  lr_model3,
  type = 'response',
  newdata = test3
)

predictions3 = ifelse(probabilities3 >= 0.5, 1, 0)

test_actual_values3 = test3$Direction

confusionMatrix(data = test_actual_values3, reference = as.factor(predictions3))

##############################################################################
# MODELLING 4

# Use KNN (K-Nearest Neighbors) for k = 1,3,5,7
data_KNN1 = read.csv("datasets/Weekly.csv")
data_KNN1 = subset(data_KNN1, data_KNN1$Year >= 1990)
data_KNN1 = subset(data_KNN1, data_KNN1$Year <= 2008)

data_KNN1$Direction = factor(
  data_KNN1$Direction,
  levels = c("Down", "Up"),
  labels = c(0,1)
)

# KNN using all Lag variables + Volume as predictors.
set.seed(123)
split = sample.split(data_KNN1$Direction, SplitRatio = 0.75)
train_KNN1 = subset(data_KNN1, split == TRUE, select = c(2:7, 9))
test_KNN1 = subset(data_KNN1, split == FALSE, select = c(2:7, 9))

for(k in c(1,3,5,7)){
  predictions_KNN1 = knn(
    train = train_KNN1,
    test = test_KNN1,
    as.data.frame(train_KNN1)$Direction,
    k = k
  )

  cm = table(test_KNN1$Direction, predictions_KNN1)
  print(paste("K =", k))
  print(confusionMatrix(data = test_KNN1$Direction, reference =  predictions_KNN1))
}

##############################################################################
# MODELLING 5

# Use KNN (K-Nearest Neighbors) for k = 1,3,5,7
data_KNN2 = read.csv("datasets/Weekly.csv")
data_KNN2 = subset(data_KNN2, data_KNN2$Year >= 1990)
data_KNN2 = subset(data_KNN2, data_KNN2$Year <= 2008)

data_KNN2$Direction = factor(
  data_KNN2$Direction,
  levels = c("Down", "Up"),
  labels = c(0,1)
)

# KNN using Lag2 predictor only.
set.seed(123)
split = sample.split(data_KNN2$Direction, SplitRatio = 0.75)
train_KNN2 = subset(data_KNN2, split == TRUE, select = c(3,9))
test_KNN2 = subset(data_KNN2, split == FALSE, select = c(3,9))

for(k in c(1,3,5,7)){
  predictions_KNN2 = knn(
    train = train_KNN2,
    test = test_KNN2,
    as.data.frame(train_KNN2)$Direction,
    k = k
  )

  cm = table(test_KNN2$Direction, predictions_KNN2)
  print(paste("K =", k))
  print(confusionMatrix(data = test_KNN2$Direction, reference =  predictions_KNN2))
}

##############################################################################
# MODELLING 6

# Use KNN (K-Nearest Neighbors) for k = 1,3,5,7
data_KNN3 = read.csv("datasets/Weekly.csv")
data_KNN3 = subset(data_KNN3, data_KNN3$Year >= 2009)
data_KNN3 = subset(data_KNN3, data_KNN3$Year <= 2010)

data_KNN3$Direction = factor(
  data_KNN3$Direction,
  levels = c("Down", "Up"),
  labels = c(0,1)
)

# KNN using Lag2 predictor only.
set.seed(123)
split = sample.split(data_KNN3$Direction, SplitRatio = 0.75)
train_KNN3 = subset(data_KNN3, split == TRUE, select = c(3,9))
test_KNN3 = subset(data_KNN3, split == FALSE, select = c(3,9))

for(k in c(1,3,5,7)){
  predictions_KNN3 = knn(
    train = train_KNN3,
    test = test_KNN3,
    as.data.frame(train_KNN3)$Direction,
    k = k
  )

  cm = table(test_KNN3$Direction, predictions_KNN3)
  print(paste("K =", k))
  print(confusionMatrix(data = test_KNN3$Direction, reference =  predictions_KNN3))
}

##############################################################################
# TRANSFORMATIONS - sqrt(x)

data4 = data

set.seed(123)
split = sample.split(data4$Direction, SplitRatio = 0.75)
train4 = subset(data4, split == TRUE)
test4 = subset(data4, split == FALSE)

lr_model4 = glm(
  formula = Direction ~ sqrt(Lag2),
  data = train4,
  family = binomial
)

summary(lr_model4)

train_actual_values4 = train4$Direction

lr_model4$fitted.values = round_fitted_values(lr_model4$fitted.values)

fitted_values4 = lr_model4$fitted.values

confusionMatrix(data = train_actual_values4, reference = as.factor(fitted_values4))

probabilities4 = predict(
  lr_model4,
  type = 'response',
  newdata = test4
)

predictions4 = ifelse(probabilities4 >= 0.5, 1, 0)

test_actual_values4 = test4$Direction

confusionMatrix(data = test_actual_values4, reference = as.factor(predictions4))

##############################################################################
# TRANSFORMATIONS - x**2

data5 = data

set.seed(123)
split = sample.split(data5$Direction, SplitRatio = 0.75)
train5 = subset(data5, split == TRUE)
test5 = subset(data5, split == FALSE)

lr_model5 = glm(
  formula = Direction ~ Lag2**2,
  data = train5,
  family = binomial
)

summary(lr_model5)

train_actual_values5 = train5$Direction

lr_model5$fitted.values = round_fitted_values(lr_model5$fitted.values)

fitted_values5 = lr_model5$fitted.values

confusionMatrix(data = train_actual_values5, reference = as.factor(fitted_values5))

probabilities5 = predict(
  lr_model5,
  type = 'response',
  newdata = test5
)

predictions5 = ifelse(probabilities5 >= 0.5, 1, 0)

test_actual_values5 = test5$Direction

confusionMatrix(data = test_actual_values5, reference = as.factor(predictions5))

