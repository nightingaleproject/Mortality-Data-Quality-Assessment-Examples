## Preparing Synthetic Death Records Data

library(here)
library(dqa4mortality)

file <- here::here("..", "data", "SyntheticDeathRecordData.csv")
synthetic_death_records <- load_death_records(file)

usethis::use_data(synthetic_death_records, overwrite = TRUE)
