# Author - Anupama Rajaram
# Neural Net algorithm on the Titanic dataset from kaggle
# kaggle score = 0.77033

library(e1071)
library(nnet)

rm(list=ls(all=TRUE))
options(digits=3)


# load data
train = read.delim(file = 'train.csv',  header = TRUE, 
                   sep = ',', dec = '.')

test = read.delim(file = 'test.csv', header = TRUE, 
                  sep = ',', dec = '.')


# ----------- data preparations ---------- #
# creating an explicit categorical variable for "Survived" i.e response variable
train$Surv[train$Survived == 0] <- "N"
train$Surv[train$Survived == 1] <- "Y"
train$Surv <- as.factor(train$Surv)

# creating an categorical variable for "Fare"
train$rate <- -1
train$rate[train$Fare <= 10] <- 0
train$rate[train$Fare > 10 & train$Fare <= 20] <- 15
train$rate[train$Fare > 20 & train$Fare <= 30] <- 25
train$rate[train$Fare > 30] <- 32

test$rate <- -1
test$rate[test$Fare <= 10] <- 0
test$rate[test$Fare > 10 & test$Fare <= 20] <- 15
test$rate[test$Fare > 20 & test$Fare <= 30] <- 25
test$rate[test$Fare > 30] <- 32

train$Ticket <- as.character(train$Ticket)
test$Ticket <- as.character(test$Ticket)

train$Cabin <- as.character(train$Cabin)
test$Cabin <- as.character(test$Cabin)

# dividing age into logical bins
train$agegroup <- 0  # age = NA
train$agegroup[train$Age < 18 ] <- 5  # children 
train$agegroup[train$Age > 55 ] <- 60  # seniors 
train$agegroup[train$Age >= 18 & train$Age <=55] <- 25  # adults

test$agegroup <- 0  # age = NA
test$agegroup[test$Age < 18 ] <- 5  # children 
test$agegroup[test$Age > 55 ] <- 60  # seniors 
test$agegroup[test$Age >= 18 & test$Age <=55] <- 25  # adults


# ---------------- fit model -------------------- #
fit2 <- nnet(Surv ~ Pclass + Age + Sex + Parch +SibSp +Embarked, 
                   data = train, size=4, decay=0.0001, maxit=500)
summary(fit2)

# -------------------- ake predictions --------------------- #
v1 <- c("Pclass", "Age", "Sex", "Parch", "SibSp", "Embarked")
prednb <- predict(fit2, train[,v1], type = "class")

# -------------- summarize accuracy ------------------------ #
table(prednb, train$Surv)  # error rate = 12.8% which is the lowest so far!!! :) 

# ------------- make predictions on the test set ------------ #
prednb_test <- predict(fit2, test[,v1], type = "class")
submit <- data.frame(PassengerId = test$PassengerId, op = prednb_test, 
                     gender = test$Sex)

# convert Y/N values for Survived to 1/0
submit$chk1 <- -99  # note this indicates NA values. We will replace these in the final excel
# by copying entries from file "jan25_8pm_titanic.csv"
submit$chk1[submit$op == "Y"] <- 1
submit$chk1[submit$op == "N"] <- 0

final_submit <- data.frame(PassengerId = submit$PassengerId, 
                           Survived = submit$chk1)
write.csv(submit, file = "nnet_titanic.csv", row.names = FALSE)

