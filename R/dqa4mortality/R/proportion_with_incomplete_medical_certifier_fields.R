# Code for metric: proportion with incomplete medical certifier fields

# internal ----

#' Check which medical certifier columns are in death records data
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param medical_columns character vector of column names in death_records for fields filled out by medical certifiers
#'
#' @returns medical_columns subset to those appearing in death_records
#' @keywords internal
#'
check_medical_columns <- function(
    death_records,
    medical_columns
){
  # Subset the medical columns to those that appear in the data
  if (any(!medical_columns %in% colnames(death_records))){
    cat(paste0(
      "The following specified medical fields do not appear in the data: ",
      paste(
        medical_columns[
          !medical_columns %in% colnames(death_records)
        ], collapse = ", ")
    ),
    "\n")
    medical_columns <-
      medical_columns[
        medical_columns %in% colnames(death_records)
      ]
  }

  return(medical_columns)
}

#' Add column for incomplete medical certifier fields
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param medical_columns character vector of column names in death_records for fields filled out by medical certifiers
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param sex_column string, sex column in death_records
#' @param pregnancy_column string, pregnancy column in death_records
#' @param age_column string, age column in death_records
#' @param age_pregnancy_low number, low cutoff for pregnancy age
#' @param age_pregnancy_high number, high cutoff for pregnancy age
#'
#' @returns death_records with an additional boolean column "Incomplete Medical Certifier Fields", specifying if the record has at least one incomplete medical certifier field
#' @keywords internal
#'
parse_incomplete_medical_certifier_fields <- function(
    death_records,
    medical_columns,
    unknown_responses,
    sex_column,
    pregnancy_column,
    age_column,
    age_pregnancy_low,
    age_pregnancy_high
){
  # Create a column that's True when any medical certifier field is empty; special
  # case pregnancy status since it only applies to female decedents
  death_records[,"Incomplete Medical Certifier Fields"] <-
    unname(
      (death_records[, sex_column, drop = F] == "F" &
         death_records[, age_column] >= age_pregnancy_low &
         death_records[, age_column] <= age_pregnancy_high & (
           is.na(death_records[, pregnancy_column, drop = F]) |
             death_records[, pregnancy_column, drop = F] %in% unknown_responses
         )) |
        rowSums(
          is.na(death_records[, medical_columns[medical_columns != pregnancy_column], drop = F]) |
            (death_records[, medical_columns[medical_columns != pregnancy_column], drop = F] %in% unknown_responses)
        ) > 0
    )

  return(death_records)
}

# external ----

#' Calculate proportion of records with at least one incomplete medical certifier field
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param medical_columns character vector of column names in death_records for fields filled out by medical certifiers
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param sex_column string, sex column in death_records
#' @param pregnancy_column string, pregnancy column in death_records
#' @param age_column string, age column in death_records
#' @param age_pregnancy_low number, low cutoff for pregnancy age
#' @param age_pregnancy_high number, high cutoff for pregnancy age
#'
#' @returns number, proportion of records with at least one incomplete medical certifier field
#' @export
#'
#' @examples
#' prop <- proportion_with_incomplete_medical_certifier_fields(
#'   synthetic_death_records,
#'   medical_columns = c(
#'     "Date of Death",
#'     "Time Pronounced Dead",
#'     "Signature of Person Pronouncing Death",
#'     "License Number",
#'     "Date Signed",
#'     "Actual or Presumed Date of Death",
#'     "Actual or Presumed Time of Death",
#'     "Medical Examiner or Coroner Contacted",
#'     "Autopsy Performed",
#'     "Autopsy Findings Available",
#'     "Tobacco Use Contributed to Death",
#'     "Pregnancy Status",
#'     "Manner of Death",
#'     "Date of Injury",
#'     "Time of Injury",
#'     "Place of Injury",
#'     "Injury at Work",
#'     "Location of Injury",
#'     "Describe How Injury Occurred",
#'     "Transportation Injury",
#'     "Certifier Type",
#'     "Certifier Name",
#'     "Title of Certifier",
#'     "License Number",
#'     "Date Certified"
#'   ),
#'   unknown_responses = c("Unknown"),
#'   sex_column = "Sex",
#'   pregnancy_column = "Pregnancy Status",
#'   age_column = "Age",
#'   age_pregnancy_low = 5,
#'   age_pregnancy_high = 74
#' )
#'
#'
proportion_with_incomplete_medical_certifier_fields <- function(
    death_records,
    medical_columns,
    unknown_responses = c(),
    sex_column = "Sex",
    pregnancy_column = "Pregnancy Status",
    age_column = "Age",
    age_pregnancy_low = 5,
    age_pregnancy_high = 74
){

  unspecified_arguments_error(
    arg_passed = names(as.list(match.call())[-1]),
    proportion_with_incomplete_medical_certifier_fields
  )

  # Subset the medical columns to those that appear in the data
  medical_columns <- check_funeral_columns(
    death_records,
    medical_columns
  )
  # if none remain, exit the function
  if (length(medical_columns) == 0){
    cat("No specified medical certifier fields in data\n")
    return(NULL)
  }

  # Create a new column that is True when at least one funeral director field is empty or unknown
  death_records <- parse_incomplete_medical_certifier_fields(
    death_records,
    medical_columns,
    unknown_responses,
    sex_column,
    pregnancy_column,
    age_column,
    age_pregnancy_low,
    age_pregnancy_high
  )

  # Calculate the proportion of records with incomplete funeral director fields
  proportion <- calculate_proportion(
    death_records,
    metric = "Incomplete Medical Certifier Fields",
    metric_description = "at least one medical certifier field incomplete",
    print_output = TRUE
  )

  return(proportion)
}

#' Calculate proportion of records with at least one incomplete medical certifier field by certifier
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param medical_columns character vector of column names in death_records for fields filled out by medical certifiers
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param sex_column string, sex column in death_records
#' @param pregnancy_column string, pregnancy column in death_records
#' @param age_column string, age column in death_records
#' @param age_pregnancy_low number, low cutoff for pregnancy age
#' @param age_pregnancy_high number, high cutoff for pregnancy age
#' @param certifier_name_column string, certifier name column in death_records
#' @param number_certifier_proportions number of certifier proportions to display. Default 3.
#'
#' @returns dataframe with one column corresponding to the unique certifiers by name and another column corresponding to the proportions of records with at least one incomplete medical certifier field
#' @export
#'
#' @examples
#' certifier_prop <- certifier_proportion_with_incomplete_medical_certifier_fields(
#'   synthetic_death_records,
#'   medical_columns = c(
#'     "Date of Death",
#'     "Time Pronounced Dead",
#'     "Signature of Person Pronouncing Death",
#'     "License Number",
#'     "Date Signed",
#'     "Actual or Presumed Date of Death",
#'     "Actual or Presumed Time of Death",
#'     "Medical Examiner or Coroner Contacted",
#'     "Autopsy Performed",
#'     "Autopsy Findings Available",
#'     "Tobacco Use Contributed to Death",
#'     "Pregnancy Status",
#'     "Manner of Death",
#'     "Date of Injury",
#'     "Time of Injury",
#'     "Place of Injury",
#'     "Injury at Work",
#'     "Location of Injury",
#'     "Describe How Injury Occurred",
#'     "Transportation Injury",
#'     "Certifier Type",
#'     "Certifier Name",
#'     "Title of Certifier",
#'     "License Number",
#'     "Date Certified"
#'   ),
#'   unknown_responses = c("Unknown"),
#'   sex_column = "Sex",
#'   pregnancy_column = "Pregnancy Status",
#'   age_column = "Age",
#'   age_pregnancy_low = 5,
#'   age_pregnancy_high = 74,
#'   certifier_name_column = "Certifier Name",
#'   number_certifier_proportions = 3
#' )
#'
#'
certifier_proportion_with_incomplete_medical_certifier_fields <- function(
    death_records,
    medical_columns,
    unknown_responses = c(),
    sex_column = "Sex",
    pregnancy_column = "Pregnancy Status",
    age_column = "Age",
    age_pregnancy_low = 5,
    age_pregnancy_high = 75,
    certifier_name_column,
    number_certifier_proportions = 3
){

  unspecified_arguments_error(
    arg_passed = names(as.list(match.call())[-1]),
    certifier_proportion_with_incomplete_medical_certifier_fields
  )

  # Subset the medical columns to those that appear in the data
  medical_columns <- check_funeral_columns(
    death_records,
    medical_columns
  )
  # if none remain, exit the function
  if (length(medical_columns) == 0){
    cat("No specified medical certifier fields in data\n")
    return(NULL)
  }

  # Create a new column that is True when at least one funeral director field is empty or unknown
  death_records <- parse_incomplete_medical_certifier_fields(
    death_records,
    medical_columns,
    unknown_responses,
    sex_column,
    pregnancy_column,
    age_column,
    age_pregnancy_low,
    age_pregnancy_high
  )

  # Group the records by certifier and calculate the proportion of flagged records for each certifier
  certifier_proportions <- calculate_proportion_by_column(
    death_records,
    metric = "Incomplete Medical Certifier Fields",
    column = certifier_name_column,
    print_output = TRUE,
    num_print = number_certifier_proportions
  )

  return(certifier_proportions)
}
