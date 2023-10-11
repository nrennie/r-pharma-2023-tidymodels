
# Load R packages ---------------------------------------------------------

library(tidyverse)
library(tidymodels)
tidymodels_prefer()


# Load the `exercise.csv` data --------------------------------------------

exercise <- read_csv("data/exercise.csv")


# Inspect variables -------------------------------------------------------

View(exercise)
barplot(table(exercise$SAE.death))
barplot(table(exercise$Geschlecht))
hist(exercise$Bas_BMI)


# Split into training and testing -----------------------------------------
# Choose your own proportion for the split!

set.seed(20231018)
ex_split <- initial_split(exercise, prop = 0.7)
ex_train <- training(ex_split)
ex_test <- testing(ex_split)
