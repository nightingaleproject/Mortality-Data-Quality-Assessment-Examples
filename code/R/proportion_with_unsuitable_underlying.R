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

# Load the unsuitable causes of death data
unsuitable_causes <- read.csv(file.path(data_path, "unsuitable_COD_codes.csv"))

# Extract the unsuitable codes
unsuitable_codes <- unsuitable_causes$code

# Create a new column that is TRUE when the underlying COD is unsuitable
death_records[, "Unsuitable Underlying"] <- sapply(
  death_records$`Underlying COD`, 
  function(code){
    return(any(startsWith(code, unsuitable_codes)))
  }
)

# Calculate the proportion of records with an unsuitable underlying cause of death
proportion <- mean(death_records$`Unsuitable Underlying`, na.rm = TRUE)

cat(paste("The proportion of records with an unsuitable underlying cause of death is",
          round(proportion, 2),
          "\n"))

# Group the records by certifier and calculate the proportion of unsuitable records for each certifier
certifier_proportions <- 
  aggregate(
    list("Proportion" = death_records$`Unsuitable Underlying`),
    list("Certifier Name" = death_records$`Certifier Name`),
    FUN = mean,
    na.rm = TRUE)

# Print the proportions for each certifier
for(i in 1:nrow(certifier_proportions)) {
  cat(paste("The proportion of records with an unsuitable underlying cause of death provided by",
            certifier_proportions[i, "Certifier Name"],
            "is",
            round(certifier_proportions[i, "Proportion"], 2), "\n"))
}
