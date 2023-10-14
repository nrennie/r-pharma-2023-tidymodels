
# Load R packages ---------------------------------------------------------

library(tidyverse)
library(tidymodels)
tidymodels_prefer()


# Load the `exercise.csv` data --------------------------------------------

exercise <- read_csv("data/exercise.csv")
exercise <- exercise |> 
  mutate(SAE = factor(SAE))


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

# Create cross validation folds
# Choose how many splits and how many repeats!
ex_folds <- vfold_cv(ex_train, v = 10, repeats = 2)


# Build a recipe ----------------------------------------------------------

# Use the `recipe()` function and the `step_*() functions`
ex_recipe <- recipe(SAE ~ ., data = ex_train) |> 
  step_dummy(Treatment:VE_Cardio) |> 
  step_normalize(all_numeric())

# create a workflow and add the recipe
ex_wf <- workflow() |> 
  add_recipe(ex_recipe)
