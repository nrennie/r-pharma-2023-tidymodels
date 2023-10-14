library(tidyverse)

# Download zip file of data -----------------------------------------------

tmp <- tempfile()

download.file(
  url = "http://archive.ics.uci.edu/static/public/519/heart+failure+clinical+records.zip",
  dest = tmp
)

unzip(tmp, exdir = "data/") 


# Read in and modify columns ----------------------------------------------

heart_failure_clinical_records <- readr::read_csv(
  "data/heart_failure_clinical_records_dataset.csv"
  )

heart_failure <- heart_failure_clinical_records |> 
  select(age, sex, smoking, anaemia, diabetes, high_blood_pressure,
         serum_creatinine, serum_creatinine, creatinine_phosphokinase,
         platelets, ejection_fraction, time, DEATH_EVENT) |> 
  rename(death = DEATH_EVENT) |> 
  mutate(across(smoking:high_blood_pressure, as.character),
         sex = case_when(sex == 0 ~ "F",
                         sex == 1 ~ "M"))

readr::write_csv(heart_failure, "data/heart_failure.csv")
