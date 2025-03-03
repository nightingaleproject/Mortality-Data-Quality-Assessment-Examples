# Load necessary libraries
library(dplyr)
library(lubridate)

# Locate the relative path to the data location
data_path <- file.path(dirname(normalizePath(sys.frame(1)$ofile)), "..", "..", "data")

# Load the death record data
death_records <- read.csv(
  file.path(data_path, "SyntheticDeathRecordData.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = ""
)

# Parse the dates
death_records$`Date of Death` <- as.Date(death_records$`Date of Death`)
death_records$`Date Certified` <- as.Date(death_records$`Date Certified`)

# Calculate the difference in days between the Date Certified and the Date of Death
death_records <- death_records %>%
  mutate(`Days Difference` = as.numeric(`Date Certified` - `Date of Death`))

# Create a column that is TRUE when the time between death and certification is not within 5 days
death_records <- death_records %>%
  mutate(`Not Within 5 Days` = !between(`Days Difference`, 0, 5))

# Calculate the proportion of records where the Date Certified is not within 5 days of the Date of Death
proportion <- mean(death_records$`Not Within 5 Days`, na.rm = TRUE)

cat(paste("The proportion of records where the Date Certified is not within 5 days of the Date of Death is",
          round(proportion, 2), "\n"))

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- death_records %>%
  group_by(`Certifier Name`) %>%
  summarize(Proportion = mean(`Not Within 5 Days`, na.rm = TRUE))

# Print the proportions for each certifier
for(i in 1:nrow(certifier_proportions)) {
  cat(paste("The proportion of records where the Date Certified is not within 5 days of the Date of Death provided by",
            certifier_proportions[i, "Certifier Name"],
            "is",
            round(certifier_proportions[i, "Proportion"], 2), "\n"))
}
