# Load necessary libraries
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

# Create a new column that is True when a single Record Axis COD column is populated
death_records[, "Single Record Axis COD"] <-
  rowSums(!is.na(
    death_records[, startsWith(colnames(death_records), "Record Axis COD")])
  ) == 1

# Calculate the proportion of records with only one Record Axis COD
proportion <- mean(death_records$`Single Record Axis COD`, na.rm = TRUE)

cat(paste("The proportion of records with a single Record Axis COD is",
          round(proportion, 2), "\n"))

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- 
  aggregate(
    list("Proportion" = death_records$`Single Record Axis COD`),
    list("Certifier Name" = death_records$`Certifier Name`),
    FUN = mean,
    na.rm = TRUE)

# Print the proportions for each certifier
for(i in 1:nrow(certifier_proportions)) {
  cat(paste("The proportion of records with a single Record Axis COD provided by",
            certifier_proportions[i, "Certifier Name"],
            "is",
            round(certifier_proportions[i, "Proportion"], 2), "\n"))
}
