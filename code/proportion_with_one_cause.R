# Load necessary library
library(dplyr)

# Locate the relative path to the data location
data_path <- file.path(dirname(normalizePath(sys.frame(1)$ofile)), "..", "data")

# Load the death records data
death_records <- read.csv(
  file.path(data_path, "NotionalDeathRecordData.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = ""
)

# Create a new column that is TRUE when Record Axis COD 1 is present and Record Axis COD 2-10 are not
death_records <- death_records %>%
  mutate(`COD1 Only` = !is.na(`Record Axis COD 1`) & 
           rowSums(is.na(select(., starts_with("Record Axis COD "))[-1])) == 9)

# Calculate the proportion of records with only Record Axis COD 1
proportion <- mean(death_records$`COD1 Only`, na.rm = TRUE)

cat(paste("The proportion of records with an entry in the Record Axis COD 1 column but not in the Record Axis COD 2-10 columns is",
          round(proportion, 2), "\n"))

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions <- death_records %>%
  group_by(`Certifier Name`) %>%
  summarize(Proportion = mean(`COD1 Only`, na.rm = TRUE))

# Print the proportions for each certifier
for(i in 1:nrow(certifier_proportions)) {
  cat(paste("The proportion of records with an entry in the Record Axis COD 1 column but not in the Record Axis COD 2-10 columns provided by",
            certifier_proportions[i, "Certifier Name"],
            "is",
            round(certifier_proportions[i, "Proportion"], 2), "\n"))
}
