# author - Anupama
# program for titanic data based on logic rules from observations on the dataset!

# To clean up the memory of your current R session run the following line
rm(list=ls(all=TRUE))

options(digits=3)

titan_train = read.delim(file = 'train.csv', header = TRUE, 
                  sep = ',', dec = '.')

titan_test = read.delim(file = 'test.csv', header = TRUE, 
                  sep = ',', dec = '.')



# add a "survivor" statistic column to the test file
# predicting that women all survive and men die!
titan_test$Survived <- 0
titan_test$Survived[titan_test$Sex == "female"] <- 1  



# adding a "agegr" variable to sort adults, senior citizens and children.
titan_train$agegr <- 0  # initializing to 0
titan_train$agegr[titan_train$Age < 18] <- 1   # 1 = child.
titan_train$agegr[titan_train$Age > 55] <- 99   # 99 = senior citizen
titan_train$agegr[titan_train$Age >= 18 & titan_train$Age <= 55] <- 7 # 7 = adult

titan_test$agegr <- 0  # initializing to 0
titan_test$agegr[titan_test$Age < 18] <- 1   # 1 = child.
titan_test$agegr[titan_test$Age > 55] <- 99   # 99 = senior citizen
titan_test$agegr[titan_test$Age >= 18 & titan_test$Age <= 55] <- 7 # 7 = adult



# ====================================================== #
# hypothesis1 
# check whether being a child or senior citizen improves survival odds
pagegr <- prop.table(table(titan_train$Survived, titan_train$agegr),2)
pagegr <- pagegr*100
pagegr  # ans - no effect


# ====================================================== #
# hypothesis2 - 
# checking whether being a child improved odds of survival.
# answer - it doesn't , being female still helps! :)
aggregate(Survived ~ Child + Sex, data=titan_train, FUN=function(x) {sum(x)/length(x)})


# ====================================================== #
# hypothesis 3 - 
# check if gender and agegroup helps?
pagegen <- aggregate(Survived ~ agegr + Sex, data=titan_train, FUN=function(x) {sum(x)/length(x)})
# answer - not much effect


# ====================================================== #
# hypothesis4 - 
# does passenger class make a difference?
pageclass <- aggregate(Survived ~ Sex + agegr + Pclass , data=titan_train, 
                       FUN=function(x) {sum(x)/length(x)})
pageclass
# answer - yes it does. odds of survial lower for the following females:
# female/sr/p2 = 0%, female/adult/p3 = 41%, female/child/p3 = 54% 
# odds of survival better for the following males:
# male/child/(p1 or p2) >= 80%, male/adult/p1 = 42%

# modification for hypothesis 4 - change survival odds for men, where %>75
titan_test$Survived[titan_test$Sex == "male" & titan_test$Age < 18 & titan_test$Pclass==1 ] <- 1
titan_test$Survived[titan_test$Sex == "male" & titan_test$Age < 18 & titan_test$Pclass==2 ] <- 1

# modification for hypothesis 4 - change survival odds for wommen, where %<20
titan_test$Survived[titan_test$Sex == "female" & titan_test$Age>55 & titan_test$Pclass==2 ] <- 0



# ====================================================== #
# hypothesis 5 - does no of parents/ siblings help children?
dfchild <- subset(titan_train, (agegr == 1))  # taking only data of children
psib <- aggregate(Survived ~ Sex + Pclass + SibSp , data=dfchild, 
                       FUN=function(x) {sum(x)/length(x)})
psib  # view data

pparent <- aggregate(Survived ~ Sex + Pclass + Parch , data=dfchild, 
                  FUN=function(x) {sum(x)/length(x)})
pparent # view data

# answer1 - being a male child in pclass =2 with no parents or no siblings reduces survival rate
titan_test$Survived[titan_test$Sex == "male" & titan_test$Age<18 & titan_test$Pclass==2
                    & titan_test$SibSp == 0] <- 0
titan_test$Survived[titan_test$Sex == "male" & titan_test$Age<18 & titan_test$Pclass==2
                    & titan_test$Parch == 0] <- 0

# answer2 - being a female child in pclass3 with 3+ siblings worsens survival rate
titan_test$Survived[titan_test$Sex == "female" & titan_test$Age<18 & titan_test$Pclass==3
                    & titan_test$SibSp >2] <- 0



# ====================================================== #
# hypothesis 6 - does no of children/ spouse help seniors?
dfsr <- subset(titan_train, (agegr == 99))  # taking only data of senior citiz
psib_sr <- aggregate(Survived ~ Sex + Pclass + SibSp , data=dfsr, 
                  FUN=function(x) {sum(x)/length(x)})
psib_sr  # view data - answer = no effect.

pparent2 <- aggregate(Survived ~ Sex + Pclass + Parch , data=dfsr, 
                     FUN=function(x) {sum(x)/length(x)})
pparent2 # view data - answer = no effect


# ====================================================== #
# creating a submission file
submit <- data.frame(PassengerId = titan_test$PassengerId, 
                     Survived = titan_test$Survived)
write.csv(submit, file = "titanic.csv", row.names = FALSE)



