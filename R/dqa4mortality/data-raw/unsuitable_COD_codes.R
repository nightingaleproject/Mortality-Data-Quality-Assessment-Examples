## Preparing Synthetic Death Records Data

library(here)

unsuitable_COD_codes <- read.csv(here::here("..", "data", "unsuitable_COD_codes.csv"))

usethis::use_data(unsuitable_COD_codes, overwrite = TRUE)
