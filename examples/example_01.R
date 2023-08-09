
# Load R packages ---------------------------------------------------------

library(tidyverse)
library(tidymodels)
tidymodels_prefer()


# Load data ---------------------------------------------------------------

heart_failure <- read_csv("data/heart_failure.csv") # change to github link!!!
View(heart_failure)

# look at variables
barplot(table(heart_failure$death))
barplot(table(heart_failure$sex))
hist(heart_failure$age)


# Split into training and testing -----------------------------------------

set.seed(20231018)
hf_split <- initial_split(heart_failure)
hf_train <- training(hf_split)
hf_test <- testing(hf_split)


# Logistic regression -----------------------------------------------------

# fit using glm
mod1 <- glm(death~., family = "binomial", data = heart_failure)
summary(mod1)
