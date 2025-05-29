# Load necessary libraries
library(lubridate)
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)

# Parse the dates
death_records$`Date of Death` <- as.Date(death_records$`Date of Death`)
death_records$`Date Certified` <- as.Date(death_records$`Date Certified`)

# Calculate the difference in days between the Date Certified and the Date of Death
death_records[, "Days Difference"] <- 
  as.numeric(death_records$`Date Certified` - death_records$`Date Certified`)

# Create a column that is TRUE when the time between death and certification is not within 5 days
death_records[, "Not Within 5 Days"] <- 
  death_records$`Days Difference` < 0 |
  death_records$`Days Difference` > 5

# Calculate the proportion of records where the Date Certified is not within 5 days of the Date of Death
proportion <- calculate_proportion(
  death_records, 
  metric = "Not Within 5 Days",
  metric_description = "Date Certified is not within 5 days of the Date of Death", 
  print_output = TRUE
)

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- calculate_proportion_by_column(
  death_records, 
  metric = "Not Within 5 Days",
  column = "Certifier Name", 
  print_output = TRUE
)
