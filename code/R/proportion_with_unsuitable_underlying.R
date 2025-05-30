# Load libraries and supporting functions ----

# Load necessary libraries
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Specify data and column names ----

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)

# Specify required metric column names here
underlying_cause_of_death_column <- "Underlying COD"

# Calculate metric ----

# Load the unsuitable causes of death data
unsuitable_causes <- read.csv(here::here("data", "unsuitable_COD_codes.csv"))

# Extract the unsuitable codes
unsuitable_codes <- unsuitable_causes$code

# Create a new column that is TRUE when the underlying COD is unsuitable
death_records[, "Unsuitable Underlying"] <- sapply(
  death_records[, underlying_cause_of_death_column], 
  function(code){
    return(any(startsWith(code, unsuitable_codes)))
  }
)

# Calculate the proportion of records with an unsuitable underlying cause of death
proportion <- calculate_proportion(
  death_records, 
  metric = "Unsuitable Underlying",
  metric_description = "unsuitable underlying cause of death", 
  print_output = TRUE
)

# Group the records by certifier and calculate the proportion of unsuitable records for each certifier
certifier_proportions <- calculate_proportion_by_column(
  death_records, 
  metric = "Unsuitable Underlying",
  column = "Certifier Name", 
  print_output = TRUE
)