
# Load R packages ---------------------------------------------------------

library(tidyverse)
library(tidymodels)
tidymodels_prefer()


# Load data ---------------------------------------------------------------

heart_failure <- read_csv("data/heart_failure.csv")
heart_failure

heart_failure <- heart_failure |> 
  mutate(death = factor(death))

View(heart_failure)

# Inspect variables -------------------------------------------------------

barplot(table(heart_failure$death))
barplot(table(heart_failure$sex))
hist(heart_failure$age)


# Split into training and testing -----------------------------------------

set.seed(20231018)
hf_split <- initial_split(heart_failure)
hf_train <- training(hf_split)
hf_test <- testing(hf_split)

# choose a different split proportion?
set.seed(20231018)
hf_split <- initial_split(heart_failure, prop = 0.8)
hf_train <- training(hf_split)
hf_test <- testing(hf_split)

# Create cross validation folds
hf_folds <- vfold_cv(hf_train, v = 10)

# Build a recipe ----------------------------------------------------------

hf_recipe <- recipe(death ~ ., data = hf_train) |> 
  step_dummy(sex) |> 
  step_normalize(age, serum_creatinine:time)

wf <- workflow() |> 
  add_recipe(hf_recipe)
