# IS71104A Statistics and Statistical Data Mining
# Coursework 1 - Task 3 of 3
# Code by Elliot Walker (SN: 3368 6408)
# Goldsmiths, University of London

# RUN THESE FIRST
#install.packages('caTools')
library(caTools)
#install.packages('caret')
library(caret)

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

##############################################################################

# Import dataset into a representative variable.
data = read.csv("datasets/Weekly.csv")

summary(data)

plot(data)

# Data encoding.
# Run this for all data variables!
data$Direction = factor(
  data$Direction,
  levels = c("Down", "Up"),
  labels = c(0,1)
)

for(i in 2:8){
  data[,i] = min_max_norm(data[,i])
}

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

predicted_values = lr_model$fitted.values

# Compute confusion matrix for model.
confusionMatrix(data = train_actual_values, reference = as.factor(predicted_values))

# Apply test set to generate predictions.
probabilities = predict(
  lr_model, 
  type = 'response', 
  newdata = test
  )

# Round probabilities to predicted values
predictions = ifelse(probabilities >= 0.5, 1, 0)

test_actual_values = test$Direction

# Compare actual test values with predicted test values.
confusionMatrix(data = test_actual_values, reference = as.factor(predictions))

##############################################################################

# Refine model using only data between 1990 and 2008 with Lag2 as the lone predictor.
data2 = data
data2 = subset(data2, data2$Year > 1990)
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

train_actual_values2 = train2$Direction

lr_model2$fitted.values = round_fitted_values(lr_model2$fitted.values)

predicted_values2 = lr_model2$fitted.values

confusionMatrix(data = train_actual_values2, reference = as.factor(predicted_values2))

probabilities2 = predict(
  lr_model2, 
  type = 'response', 
  newdata = test2
)

predictions2 = ifelse(probabilities2 >= 0.5, 1, 0)

test_actual_values2 = test2$Direction

confusionMatrix(data = test_actual_values2, reference = as.factor(predictions2))

##############################################################################

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

plot(data3$Year, data3$Volume)

train_actual_values3 = train3$Direction

lr_model3$fitted.values = round_fitted_values(lr_model3$fitted.values)

predicted_values3 = lr_model3$fitted.values

confusionMatrix(data = train_actual_values3, reference = as.factor(predicted_values3))

probabilities3 = predict(
  lr_model3, 
  type = 'response', 
  newdata = test3
)

predictions3 = ifelse(probabilities3 >= 0.5, 1, 0)

test_actual_values3 = test3$Direction

confusionMatrix(data = test_actual_values3, reference = as.factor(predictions3))

##############################################################################
# Use KNN (K-Nearest Neighbors) for k = 1,3,5,7
data_KNN = read.csv("datasets/Weekly.csv")
data_KNN = subset(data_KNN, data_KNN$Year > 1990)
data_KNN = subset(data_KNN, data_KNN$Year <= 2008)

data_KNN$Direction = factor(
  data_KNN$Direction,
  levels = c("Down", "Up"),
  labels = c(0,1)
)

set.seed(123)
split = sample.split(data_KNN$Direction, SplitRatio = 0.75)
train_KNN = subset(data_KNN, split == TRUE)
test_KNN = subset(data_KNN, split == FALSE)

predictions_KNN = knn(
  train = train_KNN,
  test = test_KNN,
  train_KNN$Direction,
  k = 7
)

cm = table(test_KNN$Direction, predictions_KNN)
confusionMatrix(data = test_KNN$Direction, reference =  predictions_KNN)
