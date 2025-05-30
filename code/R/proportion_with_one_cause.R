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
cause_of_death_columns <- c(
  colnames(death_records)[startsWith(colnames(death_records), "Record Axis COD")]
)

# Calculate metric ----

# Create a new column that is True when a single Record Axis COD column is populated
death_records[, "Single Record Axis COD"] <-
  rowSums(!is.na(
    death_records[, cause_of_death_columns, drop = F])
  ) == 1

# Calculate the proportion of records with only one Record Axis COD
proportion <- calculate_proportion(
  death_records, 
  metric = "Single Record Axis COD",
  metric_description = "Single Record Axis COD", 
  print_output = TRUE
)

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- calculate_proportion_by_column(
  death_records, 
  metric = "Single Record Axis COD",
  column = "Certifier Name", 
  print_output = TRUE
)
