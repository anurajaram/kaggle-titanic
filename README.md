# kaggle-titanic
Solutions for the Titanic Kaggle Competition

1. nb_titanic.R <br />
    Description - Naive Bayes solution in R to predict Titanic Survivors. <br />
    Kaggle score = 0.74641. Model error rate (on training set) = 21.55% . <br/>
    The variables used in this program are "Pclass", "Age", "Sex", "Parch", "SibSp", "Fare".

2. nnet_titanic.R <br />
    Description - Neural Net algorithm on the Titanic dataset from kaggle. <br />
    Kaggle score = 0.77033. Model error rate (on training set) = 12.8% . <br/>

3. rf_titanic.R <br />
    Description - Random Forest algorithm on the Titanic dataset from kaggle. <br />
    Kaggle score = 0.77512. Model error rate (on training set) = 15.4% . <br/>

4. tree.R <br />
    Description - Decision tree algorithm on the Titanic dataset from kaggle. <br />
    Kaggle score = 0.78947. Model error rate (on training set) = 17.7% . <br/>
    <b>This turned out to be my best performing model even though the model doesn't fit as well as RandomForest or NeuralNet.</b>

5. gender.R <br />
    Description - Predictions based on gender only. <br />
    Kaggle score = 0.76555 <br/>
    <b>This is the baseline model.</b>

4. Logic_rules.R <br />
    Description - Survival prediction based on broad observations from the training set <br />
    Kaggle score = 0.77033. 


