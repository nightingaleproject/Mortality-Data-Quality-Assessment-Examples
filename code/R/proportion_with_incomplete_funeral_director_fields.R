# Load libraries and supporting functions ----

# Load necessary libraries
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Specify data and column names ----

# Load the death records data
file_path <- here::here("data", "SyntheticDeathRecordData.csv")
death_records <- 
  load_death_records(file_path)

# Define the funeral director columns
funeral_director_columns <- c(
  "Decdent's Legal Name",
  "Sex",
  "Social Security Number",
  "Age",
  "Under 1 Year",
  "Under 1 Day",
  "Date of Birth",
  "Birthplace",
  "Residence-State",
  "County",
  "City or Town",
  "Street and Number",
  "Apt. No.",
  "ZIP Code",
  "Inside City Limits",
  "Ever in US Armed Forced",
  "Marital Status at Time of Death",
  "Surviving Spouse's Name",
  "Father's Name",
  "Mother's Name Prior to First Marriage",
  "Informant's Name",
  "Relationship to Decedent",
  "Mailing Address",
  "Place of Death",
  "Facility Name",
  "Facility City, State, and ZIP Code",
  "County of Death",
  "Method of Disposition",
  "Place of Disposition",
  "Location - City, Town, and State",
  "Name and Complete Address of Funeral Facility",
  "Signature of Funeral Service Licensee or Other Agent",
  "License Number",
  "Decedent's Education",
  "Race White", "Race Black or African American",
  "Race American Indian or Alaska Native",
  "Race Asian Indian",
  "Race Chinese",
  "Race Filipino",
  "Race Japanese",
  "Race Korean",
  "Race Vietnamese",
  "Race Other Asian",
  "Race Native Hawaiian",
  "Race Guamanian or Chamorro",
  "Race Samoan",
  "Race Other Pacific Islander",
  "Race Other",
  "Hispanic No",
  "Hispanic Mexican",
  "Hispanic Puerto Rican",
  "Hispanic Cuban",
  "Hispanic Other",
  "Decedent's Usual Occupation",
  "Funeral Facility"
)  # add or remove columns as needed

# Define responses corresponding to "unknown"
unknown_responses <- c(
  "Unknown",
  "U"
)

# Calculate metric ----

# Subset the funeral director columns to those that appear in the data
if (any(!funeral_director_columns %in% colnames(death_records))){
  cat(
    paste0(
      "The following specified funeral director fields do not appear in the data: ",
      paste(
        funeral_director_columns[
          !funeral_director_columns %in% colnames(death_records)
        ], collapse = ", ")
    ),
    "\n"
  )
  funeral_director_columns <- 
    funeral_director_columns[
      funeral_director_columns %in% colnames(death_records)
    ]
}

# Create a new column that is True when at least one funeral director field is empty or unknown
death_records["Incomplete Funeral Director Fields"] <-
  rowSums(
    is.na(death_records[, funeral_director_columns, drop = F]) | 
      (death_records[, funeral_director_columns, drop = F] %in% unknown_responses)
  ) > 0

# Calculate the proportion of records with incomplete funeral director fields
proportion <- calculate_proportion(
  death_records, 
  metric = "Incomplete Funeral Director Fields",
  metric_description = "at least one funeral director field incomplete", 
  print_output = TRUE
)

