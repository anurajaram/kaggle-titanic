# Author - Anupama Rajaram
# Naive-Bayes algorithm on the Titanic dataset from kaggle
# KAGGLE score = 0.74641

library(e1071)
attach(train)

# load data
train = read.delim(file = 'train.csv',  header = TRUE, 
                   sep = ',', dec = '.')

# creating an explicit categorical variable for "Survived" i.e response variable
train$Surv[train$Survived == 0] <- "N"
train$Surv[train$Survived == 1] <- "Y"
train$Surv <- as.factor(train$Surv)

# fit model
fit2 <- naiveBayes(Surv ~ Pclass + Age + Sex + Parch +SibSp + Fare, 
                   data = train)
summary(fit2)

# make predictions
v1 <- c("Pclass", "Age", "Sex", "Parch", "SibSp", "Fare")
prednb <- predict(fit2, train[,v1])

# summarize accuracy
table(prednb, train$Surv)  # error rate = 21.55%

# make predictions on the test set
prednb_test <- predict(fit2, test[,v1])
submit <- data.frame(PassengerId = test$PassengerId, op = prednb_test)

# convert Y/N values for Survived to 1/0
submit$Survived <- 0
submit$Survived[submit$op == "Y"] <- 1

final_submit <- data.frame(PassengerId = submit$PassengerId, 
                           Survived = submit$Survived)
write.csv(final_submit, file = "jan26_9pm.csv", row.names = FALSE)


# this gives us a score of 0.74641, which is lower than the highest score (0.78947).
# this is expected since regular tree() had a lower error rate of 17.8%
