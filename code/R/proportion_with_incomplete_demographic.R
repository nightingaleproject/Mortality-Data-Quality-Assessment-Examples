# Load necessary libraries
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)

# List of fields we want to check for individually
demographic_fields = c(
  "Age",
  "County of Death",
  "Date of Death",
  "Education",
  "Hispanic .*", # Match any field starting with 'Hispanic'
  "Manner of Death",
  "Place of Death",
  "Pregnancy Status",
  "Race .*", # Match any field starting with 'Race'
  "Tobacco Use Contributed to Death"
)


# For each field we first check if the field is present in the data;
# if it's present, we evaluate the proportion of records that have a
# blank value for the field and the proportion of records that have
# an explicit "Unknown" value for the field
for (field in demographic_fields){
  cat(paste0("Evaluating fields matching ", field), "\n")
  
  # Find the columns that match this field (may be more than one if it's a regex)
  matching_columns <- if (!grepl("\\.\\*", field)){
    colnames(death_records)[colnames(death_records) == field]
  } else {
    colnames(death_records)[grepl(field, colnames(death_records))]
  }
  
  # Check if the field was found in the data
  if (length(matching_columns) < 1){
    cat(paste0("No columns matching ", field, " exist in the data", "\n"))
    cat("\n")
    next
  }
  
  
  # TODO: We need to special case pregnancy status; do it with a lambda in the fields list?
  # TODO: Pregnancy has "No response", is that equivalent to unknown?
  # TODO: Explore configuration file for e.g., what is "unknown", threshold for flagging certifiers, etc. (multiple tests could use common code)
  # TODO: May need to consider "Not applicable" as well
  # TODO: Pregnancy has "Unknown if pregnant within the past year", should we look for any match to an "Unknown" regex?
  # TODO: Perhaps allow jurisdiction to configure which values mean "missing" and which "unknown"?
  # TODO: Maybe field list lambda includes the check to use?
  
  for (mc in matching_columns){
    # The field is present, so now find the proportion that are blank
    death_records[, paste0("Blank ", mc)] <- 
      as.numeric(is.na(death_records[, mc]))
    
    proportion <- calculate_proportion(
      death_records, 
      metric = paste0("Blank ", mc),
      metric_description = paste0("blank values for ", mc)
    )
    
    # Now find the proportion that are "unknown"
    death_records[, paste0("Unknown ", mc)] <- 
      as.numeric(grepl("Unknown", death_records[, mc]) |
                   grepl("U", death_records[, mc]))
    
    proportion <- calculate_proportion(
      death_records, 
      metric = paste0("Unknown ", mc),
      metric_description = paste0("explicit 'unknown' values for ", mc)
    )
  }
  
  cat("\n")
}
