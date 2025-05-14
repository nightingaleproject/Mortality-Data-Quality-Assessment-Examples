# Load necessary libraries
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)


# Define the funeral director columns
funeral_director_columns = c(
  "Funeral Facility"
)  # add or remove columns as needed

# Subset the funeral director columns to those that appear in the data
funeral_director_columns <- 
  funeral_director_columns[
    funeral_director_columns %in% colnames(death_records)
  ]

# Create a new column that is True when at least one funeral director field is empty or unknown
death_records["Incomplete Funeral Director Fields"] =
  rowSums(
    is.na(death_records[, funeral_director_columns, drop = F]) | 
      (death_records[, funeral_director_columns, drop = F] == "Unknown")
  ) > 0

# Calculate the proportion of records with incomplete funeral director fields
proportion <- calculate_proportion(
  death_records, 
  metric = "Incomplete Funeral Director Fields",
  metric_description = "at least one funeral director field incomplete"
)

