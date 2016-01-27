# kaggle-titanic
Solutions for the Titanic Kaggle Competition

1. nb_titanic.R <br />
    Description - Naive Bayes solution in R to predict Titanic Survivors. <br />
    The model gives an error rate of 21.55% on the training set. Score on the Kaggle board with this model = 0.74641. <br/>
    The variables used in this program are "Pclass", "Age", "Sex", "Parch", "SibSp", "Fare".

2. nnet_titanic.R <br />
    Description - Neural Net algorithm on the Titanic dataset from kaggle. The model fits the training set extremely well with an error      rate of only 12.8%. However, it introduces many NAs with the test set, which we replace with values from another solution.<br />         Kaggle score = 0.77033
