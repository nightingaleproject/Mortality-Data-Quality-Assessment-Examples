# Load libraries and supporting functions ----

# Load necessary libraries
library(lubridate)
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Load variables common across all scripts -- to edit, see dqaf_common_variables.R
source(here::here("code", "R", "dqaf_common_variables.R"))

# Specify data and column names ----

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)

# Specify required metric column names here
date_of_death_column <- "Date of Death"
date_certified_column <- "Date Certified"

# Specify certifier column name here
certifier_name_column <- "Certifier Name"

# Specify amount of days appropriate for certification
number_of_days <- 5

# Calculate metric ----

# Parse the dates
death_records$`Date of Death` <- as.Date(death_records[, date_of_death_column])
death_records$`Date Certified` <- as.Date(death_records[, date_certified_column])

# Calculate the difference in days between the Date Certified and the Date of Death
death_records[, "Days Difference"] <- 
  as.numeric(death_records$`Date Certified` - death_records$`Date of Death`)

# Create a column that is TRUE when the time between death and certification is not within 5 days
death_records[, "Not Within Required Days"] <- 
  death_records$`Days Difference` < 0 |
  death_records$`Days Difference` > number_of_days

# Calculate the proportion of records where the Date Certified is not within 5 days of the Date of Death
proportion <- calculate_proportion(
  death_records, 
  metric = "Not Within Required Days",
  metric_description = paste0(
    "Date Certified is not within ", number_of_days, " days of the Date of Death"
  ), 
  print_output = TRUE
)

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- calculate_proportion_by_column(
  death_records, 
  metric = "Not Within Required Days",
  column = certifier_name_column, 
  print_output = TRUE
)
