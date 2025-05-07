# Load necessary libraries
library(lubridate)
library(here)

# Specify the relative path to the data location
data_path <- here::here("data")

# Load the death records data
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
death_records[, "Days Difference"] <- 
  as.numeric(death_records$`Date Certified` - death_records$`Date Certified`)

# Create a column that is TRUE when the time between death and certification is not within 5 days
death_records[, "Not Within 5 Days"] <- 
  death_records$`Days Difference` < 0 |
  death_records$`Days Difference` > 5

# Calculate the proportion of records where the Date Certified is not within 5 days of the Date of Death
proportion <- mean(death_records$`Not Within 5 Days`, na.rm = TRUE)

cat(paste("Proportion of records where the Date Certified is not within 5 days of the Date of Death: ",
          round(proportion, 2), "\n"))

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- 
  aggregate(
    list("Proportion" = death_records$`Not Within 5 Days`),
    list("Certifier Name" = death_records$`Certifier Name`),
    FUN = mean,
    na.rm = TRUE)
certifier_proportions <- 
  certifier_proportions[order(certifier_proportions$Proportion, decreasing = T),]

# Print the proportions for each certifier
for(i in 1:nrow(certifier_proportions)) {
  cat(paste("The proportion of records where the Date Certified is not within 5 days of the Date of Death by",
            certifier_proportions[i, "Certifier Name"],
            "is",
            round(certifier_proportions[i, "Proportion"], 2), "\n"))
}
