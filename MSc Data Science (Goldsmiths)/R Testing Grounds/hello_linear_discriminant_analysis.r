library(MASS)
library(ISLR)
names(Smarket)

sm = Smarket

lda.fit = lda(formula = Direction ~ Lag1 + Lag2,
              data = sm,
              subset = train)
lda.fit