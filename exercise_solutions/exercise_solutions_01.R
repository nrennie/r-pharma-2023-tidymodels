
# Load R packages ---------------------------------------------------------

library(tidyverse)
library(tidymodels)
tidymodels_prefer()


# Load the `exercise.csv` data --------------------------------------------

exercise <- read_csv("data/exercise.csv")
exercise <- exercise |> 
  mutate(death = factor(SAE))


# Inspect variables -------------------------------------------------------

View(exercise)
barplot(table(exercise$SAE))
barplot(table(exercise$Gender))
hist(exercise$BMI)


# Split into training and testing -----------------------------------------
# Choose your own proportion for the split!

set.seed(20231018)
ex_split <- initial_split(exercise, prop = 0.7)
ex_train <- training(ex_split)
ex_test <- testing(ex_split)
