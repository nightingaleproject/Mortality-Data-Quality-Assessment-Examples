# Load libraries and supporting functions ----

# Load necessary libraries
library(here)

# Load supporting functions
source(here::here("code", "R", "dqaf_metrics.R"))

# Load variables common across all scripts -- to edit, see dqaf_common_variables.R
source(here::here("code", "R", "dqaf_common_variables.R"))

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
  "Ever in US Armed Forces",
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
  "Kind of Business/Industry",
  "Funeral Facility"
)  # add or remove columns as needed

# Define responses corresponding to "unknown"
unknown_responses <- c(
  common_unknown, # unknown responses common to all attributes
  "UNK" # unknown response specific to these attributes
)

# Additionally, define columns for age in the data
age_column <- "Age"

# Define age cutoffs for various attributes (if not in data, set both as NULL)
# Marital Status
marital_status_column <- "Marital Status"
age_marital_low <- 10 #TODO: check for cutoff
# Occupation
occupation_column <- "Decedent's Usual Occupation"
age_occupation_low <- 14
# Industry
industry_column <- "Kind of Business/Industry"
age_industry_low <- 14
# Armed forces
armed_forces_column <- "Ever in US Armed Forces"
age_armed_low <- 14 #TODO: check for cutoff

# Calculate metric ----

# Bin the age cutoff metrics into one vector for ease
age_cutoff_colummns <- c(
  marital_status_column, occupation_column, industry_column, armed_forces_column
  )

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
  # If all cutoff columns are null, no need to subset
  if (length(age_cutoff_colummns) > 0){
    age_cutoff_colummns <- 
      age_cutoff_colummns[
        age_cutoff_colummns %in% colnames(death_records)
      ]
  }
}

if (length(funeral_director_columns) > 0){
  # Create a new column that is True when at least one funeral director field is empty or unknown
  death_records["Incomplete Funeral Director Fields"] <-
    rowSums(
      is.na(death_records[, !funeral_director_columns %in% age_cutoff_colummns, drop = F]) | 
        (death_records[, !funeral_director_columns %in% age_cutoff_colummns, drop = F] %in% unknown_responses)
    ) > 0
  # Add the results for the age cutoff columns
  if (length(age_cutoff_colummns) > 0){
    for (ac in age_cutoff_colummns){
      death_records["Incomplete Funeral Director Fields"] <-
        death_records["Incomplete Funeral Director Fields"] 
      
      cutoff_results <-
        if (mc == marital_status_column){
          cat(paste0("Only considering records above age cutoff for marital status", "\n"))
          (death_records[, age_column] >= age_marital_low & (
            is.na(death_records[, marital_status_column, drop = F]) |
              death_records[, marital_status_column, drop = F] %in% unknown_responses
          ))
        } else if (mc == occupation_column){
          cat(paste0("Only considering records above age cutoff for occupation", "\n"))
          (death_records[, age_column] >= age_occupation_low & (
            is.na(death_records[, occupation_column, drop = F]) |
              death_records[, occupation_column, drop = F] %in% unknown_responses
          ))
        } else if (mc == industry_column){
          cat(paste0("Only considering records above age cutoff for industry", "\n"))
          (death_records[, age_column] >= age_industry_low & (
            is.na(death_records[, industry_column, drop = F]) |
              death_records[, industry_column, drop = F] %in% unknown_responses
          ))
        } else if (mc == armed_forces_column){
          cat(paste0("Only considering records above age cutoff for armed forces", "\n"))
          (death_records[, age_column] >= age_armed_low & (
            is.na(death_records[, armed_forces_column, drop = F]) |
              death_records[, armed_forces_column, drop = F] %in% unknown_responses
          ))
        }
    }
  }
  
  # Calculate the proportion of records with incomplete funeral director fields
  proportion <- calculate_proportion(
    death_records, 
    metric = "Incomplete Funeral Director Fields",
    metric_description = "at least one funeral director field incomplete", 
    print_output = TRUE
  )
} else {
  cat("No specified funeral director fields in data\n")
}
