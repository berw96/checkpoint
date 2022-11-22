# Logistic Regression
library(ISLR)
names(Smarket)

# reduce character count of data set
sm = Smarket

# print the dimensions of our data set
dim(sm)

# print a summary of our data set
summary(sm)

# create a scatter plot matrix for our data set
pairs(sm)

# create a correlation matrix containing all entries/rows
# and discounting the 10th field/column 'Direction'
cor(sm[,-9])

# create a dot plot using the data set
attach(sm)
plot(Volume)

# categorical data is predicted using logistic regression
# thus we can predict 'Direction'
glm.fit = glm(formula = Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
               data = sm,
               family = binomial)

# see the results of our logistic regression model
summary(glm.fit)

# access only the coefficients of the model
coef(glm.fit)

# print a summary for these coefficients
summary(glm.fit)$coef

summary(glm.fit)$coef[,4]


# predict the direction of the market
glm.probs = predict(object =  glm.fit,
                    type = "response")

glm.probs[1:10]

# detail the discrete values associated with each market direction
contrasts(Direction)

glm.pred = rep("Down", 1250)
glm.pred[glm.probs > 0.5] = "Up"

table(glm.pred, Direction)

mean(glm.pred == Direction)

train = (Year < 2005)
sm.2005 = sm[!train,]
dim(sm.2005)
Direction.2005 = Direction[!train]

glm.fit = glm(formula = Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume,
              data = sm,
              family = binomial,
              subset = train)

glm.probs = predict(object = glm.fit,
                    newdata = sm.2005,
                    type = "response")

glm.pred = rep("Down", 252)
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction.2005)
mean(glm.pred == Direction.2005)
mean(glm.pred != Direction.2005)

# now perform backward elimination to enhance
# accuracy of model by removing statistically
# insignificant coefficients
glm.fit = glm(formula = Direction ~ Lag1 + Lag2,
              data = sm,
              family = binomial,
              subset = train)

glm.probs = predict(object = glm.fit,
                    newdata = sm.2005,
                    type = "response")

glm.pred = rep("Down", 252)
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction.2005)

mean(glm.pred == Direction.2005)



# Linear Discriminant Analysis
library(MASS)

lda.fit = lda(formula = Direction ~ Lag1 + Lag2,
              data = sm,
              subset = train)
lda.fit

plot(lda.fit)

lda.pred = predict(object = lda.fit,
                   newdata = sm.2005)

names(lda.pred)

lda.class = lda.pred$class
table(lda.class, Direction.2005)
mean(lda.class == Direction.2005)

sum(lda.pred$posterior[,1] >= 0.5)
sum(lda.pred$posterior[,1] < 0.5)

lda.pred$posterior[1:20,1]
lda.class[1:20]
