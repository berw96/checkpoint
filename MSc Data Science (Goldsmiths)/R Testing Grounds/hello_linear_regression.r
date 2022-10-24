library(MASS)
library(ISLR)

#fix(Boston)
names(Boston)

lm.fit = lm(medv~lstat, data = Boston)


confint(lm.fit)

plot(lstat, medv)
abline(lm.fit)

predict(lm.fit, 
        data.frame(lstat = c(5, 10, 15)), 
        interval =  "prediction")
