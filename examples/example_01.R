
# Load R packages ---------------------------------------------------------

library(tidyverse)
library(tidymodels)
tidymodels_prefer()


# Load data ---------------------------------------------------------------

heart_failure <- read_csv("data/heart_failure.csv")
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