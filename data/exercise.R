library(tidyverse)

# Download file of data ---------------------------------------------------

load(url("https://zenodo.org/record/3899830/files/safety-set.RData"))


# Data wrangling ----------------------------------------------------------

exercise <- safety.set |>
  as_tibble() |>
  select(where(~ !any(is.na(.x)))) |> 
  relocate(SAE.death)


# Write to CSV ------------------------------------------------------------

readr::write_csv(exercise, "data/exercise.csv")

# remove objects from environment
rm(safety.set, table.1.data, table.2.data)
