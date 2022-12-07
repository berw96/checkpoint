# KNN classifier in R

dataset = read.csv("../Statistical Modelling/datasets/Weekly.csv")

library(class)
library(caTools)
#library(ElemStatLearn)

dataset$Direction = factor(
  dataset$Direction,
  levels = c("Down", "Up"),
  labels = c(0,1)
)

split = sample.split(dataset$Direction, SplitRatio = 0.75)
train = subset(dataset, split == TRUE)
test = subset(dataset, split == FALSE)

predictions = knn(
  train = train,
  test = test,
  train$Direction,
  k = 5
)

cm = table(test$Direction, predictions)

