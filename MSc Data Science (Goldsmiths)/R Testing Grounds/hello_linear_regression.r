library(MASS)
library(ISLR)
library(car)

lm.fit2 = lm(medv~lstat + I(lstat^2), data = Boston)
summary(lm.fit2)

anova(lm.fit, lm.fit2)
plot(lm.fit2)