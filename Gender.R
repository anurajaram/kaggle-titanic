# Author - Anupama
# program for titanic data based on gender classification only!
# kaggle score = 0.76555add

# To clean up the memory of your current R session run the following line
rm(list=ls(all=TRUE))

options(digits=3)

titan_train = read.delim(file = 'train.csv', header = TRUE, 
                  sep = ',', dec = '.')

titan_test = read.delim(file = 'test.csv', header = TRUE, 
                  sep = ',', dec = '.')


# data explore
summary(titan_train)
table(titan_train$Sex, titan_train$Survived)

# add a "survivor" statistic column to the test file
# predicting that women all survive and men die! 
titan_test$Survived <- 0
titan_test$Survived[titan_test$Sex == "female"] <- 1  


# creating a submission file
submit <- data.frame(PassengerId = titan_test$PassengerId, 
                     Survived = titan_test$Survived)
write.csv(submit, file = "titanic.csv", row.names = FALSE)

