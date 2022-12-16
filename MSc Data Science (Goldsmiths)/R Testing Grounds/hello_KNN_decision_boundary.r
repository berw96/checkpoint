# KNN classifier in R

dataset = read.csv("../Statistical Modelling/datasets/Weekly.csv")

library(class)
#install.packages('caTools')
library(caTools)
#install.packages('caret')
library(caret)
#install.packages('ggplot2')
library(ggplot2)
library(dplyr)

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
  k = 5,
  prob = TRUE
)

cm = table(test$Direction, predictions)
confusionMatrix(data = predictions, reference = test$Direction)

# Plot as logistic function.
ggplot(dataset, aes(x = Lag2, y = Direction)) + 
  geom_point()

# Scatterplot with colour coding.
ggplot(dataset, aes(x = Year, y = Lag2)) +
  geom_point(aes(color = as.factor(Direction))) +
  theme_bw()

