# Load necessary library
library(dplyr)

# Locate the relative path to the data location
data_path <- file.path(dirname(normalizePath(sys.frame(1)$ofile)), "..", "..", "data")

# Load the death records data
death_records <- read.csv(
  file.path(data_path, "SyntheticDeathRecordData.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = ""
)

# Create a new column that is True when a single Record Axis COD column is populated
death_records <- death_records %>%
  mutate(`Single Record Axis COD` = rowSums(!is.na(select(., starts_with("Record Axis COD")))) == 1)

# Calculate the proportion of records with only one Record Axis COD
proportion <- mean(death_records$`Single Record Axis COD`, na.rm = TRUE)

cat(paste("The proportion of records with a single Record Axis COD is",
          round(proportion, 2), "\n"))

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- death_records %>%
  group_by(`Certifier Name`) %>%
  summarize(Proportion = mean(`Single Record Axis COD`, na.rm = TRUE))

# Print the proportions for each certifier
for(i in 1:nrow(certifier_proportions)) {
  cat(paste("The proportion of records with a single Record Axis COD provided by",
            certifier_proportions[i, "Certifier Name"],
            "is",
            round(certifier_proportions[i, "Proportion"], 2), "\n"))
}
