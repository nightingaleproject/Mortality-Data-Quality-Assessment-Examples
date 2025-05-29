# Load necessary libraries
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)

# Define the medical columns
medical_columns <- c(
  "Tobacco Use Contributed to Death",
  "Date Certified",
  "Certifier Type"
)  # add or remove columns as needed
# Additionally, define column for sex and pregnancy columns in the data
sex_column <- "Sex"
pregancy_column <- "Pregnancy Status"

# Define responses corresponding to "unknown"
unknown_responses <- c(
  "Unknown",
  "U"
)

# Subset the medical columns to those that appear in the data
if (any(!medical_columns %in% colnames(death_records))){
  cat(paste0(
    "The following specified medical fields do not appear in the data: ",
    paste(
      medical_columns[
        !medical_columns %in% colnames(death_records)
      ], collapse = ", ")
  ),
  "\n")
  medical_columns <- 
    medical_columns[
      medical_columns %in% colnames(death_records)
    ]
}

# Create a column that's True when any medical certifier field is empty; special
# case pregnancy status since it only applies to female decedents
death_records["Incomplete Medical Certifier Fields"] =
  (death_records[, sex_column, drop = F] == "F" & (
    is.na(death_records[, pregancy_column, drop = F]) |
      death_records[, pregancy_column, drop = F] %in% unknown_responses
  )) |
  rowSums(
    is.na(death_records[, medical_columns, drop = F]) | 
      (death_records[, medical_columns, drop = F] %in% unknown_responses)
  ) > 0

# Calculate the proportion of records with incomplete funeral director fields
proportion <- calculate_proportion(
  death_records, 
  metric = "Incomplete Medical Certifier Fields",
  metric_description = "at least one medical certifier field incomplete", 
  print_output = TRUE
)

