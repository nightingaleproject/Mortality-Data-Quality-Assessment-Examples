# Load dplyr library for data manipulation
library(dplyr)

# Locate the relative path to the data location
data_path <- file.path(dirname(normalizePath(sys.frame(1)$ofile)), "..", "..", "data")

# Load the death records data
death_records <- read.csv(
  file.path(data_path, "NotionalDeathRecordData.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = ""
)

# Load the unsuitable causes of death data
unsuitable_causes <- read.csv(file.path(data_path, "unsuitable_COD_codes.csv"))

# Extract the unsuitable codes
unsuitable_codes <- unsuitable_causes$code

# Vectorized function to check if any unsuitable code is a prefix to the code in the record
is_unsuitable <- Vectorize(function(code) {
  any(startsWith(code, unsuitable_codes))
})

# Create a new column that is TRUE when the underlying COD is unsuitable
death_records <- death_records |>
  mutate(`Unsuitable Underlying` = is_unsuitable(`Underlying COD`))

# Calculate the proportion of records with an unsuitable underlying cause of death
proportion <- mean(death_records$`Unsuitable Underlying`, na.rm = TRUE)

cat(paste("The proportion of records with an unsuitable underlying cause of death is",
          round(proportion, 2),
          "\n"))

# Group the records by certifier and calculate the proportion of unsuitable records for each certifier
certifier_proportions <- death_records |>
  group_by(`Certifier Name`) |>
  summarize(Proportion = mean(`Unsuitable Underlying`, na.rm = TRUE))

# Print the proportions for each certifier
for(i in 1:nrow(certifier_proportions)) {
  cat(paste("The proportion of records with an unsuitable underlying cause of death provided by",
            certifier_proportions[i, "Certifier Name"],
            "is",
            round(certifier_proportions[i, "Proportion"], 2), "\n"))
}
