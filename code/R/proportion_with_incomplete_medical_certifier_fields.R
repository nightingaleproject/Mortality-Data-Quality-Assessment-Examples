# Load necessary libraries
library(here)

# Load supporting functions
# Load libraries and supporting functions ----

source(here::here("code", "R", "dqaf_metrics.R"))

# Specify data and column names ----

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)

# Define the medical columns
# also includes the cause of death columns, which we'll specify on their own for clarity
cause_of_death_columns <- c(
  "Underlying COD",
  colnames(death_records)[startsWith(colnames(death_records), "Record Axis COD")]
)
medical_columns <- c(
  "Date of Death",
  "Time Pronounced Dead",
  "Signature of Person Pronouncing Death",
  "License Number",
  "Date Signed",
  "Actual or Presumed Date of Death",
  "Actual or Presumed Time of Death",
  "Medical Examiner or Coroner Contacted",,
  cause_of_death_columns,
  "Autopsy Performed",
  "Autopsy Findings Available",
  "Tobacco Use Contributed to Death",
  "Pregnancy Status",
  "Manner of Death",
  "Date of Injury",
  "Time of Injury",
  "Place of Injury",
  "Injury at Work",
  "Location of Injury",
  "Describe How Injury Occurred",
  "Transportation Injury",
  "Certifier Type",
  "Certifier Name",
  "Title of Certifier",
  "License Number",
  "Date Certified"
)  # add or remove columns as needed

# Additionally, define columns for sex and pregnancy in the data
sex_column <- "Sex"
pregancy_column <- "Pregnancy Status"

# Define responses corresponding to "unknown"
unknown_responses <- c(
  "Unknown",
  "U"
)

# Calculate metric ----

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
death_records["Incomplete Medical Certifier Fields"] <- 
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

