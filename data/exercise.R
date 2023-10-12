library(tidyverse)

# Download file of data ---------------------------------------------------

load(url("https://zenodo.org/record/3899830/files/safety-set.RData"))


# Data wrangling ----------------------------------------------------------

exercise <- safety.set |>
  as_tibble() |>
  select(where(~ !any(is.na(.x)))) |> 
  rename(Age = Bas_Alter,
         Gender = Geschlecht,
         SAE = subgroup,
         Centre = Zentrum) |> 
  mutate(Centre = factor(paste0("Centre", Centre))) |> 
  select(-c(SAE.total, SAE.hosp.time.Pat, SAE.stroke, SAE.readmission,
            patient.months.V3, Bas_VE_Comorb, Centre,
            SAE.death, Bas_SA_Lok_Seite, Bas_SA_Lok_hinter, obs.time)) |> 
  rename_with(~ gsub("Bas_", "", .x, fixed = TRUE)) |> 
  select(c(where(is.numeric), where(is.factor))) |> 
  relocate(SAE) |> 
  mutate(
    SAE = factor(case_when(
      SAE == "SAE" ~ 1,
      SAE == "No SAE" ~ 0,
    ))
  )


# Write to CSV ------------------------------------------------------------

readr::write_csv(exercise, "data/exercise.csv")

# remove objects from environment
rm(safety.set, table.1.data, table.2.data)
