# Code for metric: proportion with incomplete funeral director fields

# internal ----

#' Check which funeral director columns are in death records data
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param funeral_director_columns character vector of column names in death_records for fields filled out by funeral directors
#'
#' @returns funeral_director_columns subset to those appearing in death_records
#' @keywords internal
#'
check_funeral_columns <- function(
    death_records,
    funeral_director_columns
){
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

  return(funeral_director_columns)
}

#' Add column for incomplete funeral director fields
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param funeral_director_columns character vector of column names in death_records for fields filled out by funeral directors
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param age_cutoff_colummns character vector of column names in death_records corresponding to columns requiring age cutoffs (such as marital status, etc.)
#' @param age_column string, age column in death_records
#' @param marital_status_column string, marital status column in death_records. NULL if not in death_records.
#' @param age_marital_low number, low cutoff for marital status age
#' @param occupation_column string, occupation column in death_records. NULL if not in death_records.
#' @param age_occupation_low number, low cutoff for occupation age
#' @param industry_column string, industry column in death_records. NULL if not in death_records.
#' @param age_industry_low number, low cutoff for industry age
#' @param armed_forces_column string, armed forces column in death_records. NULL if not in death_records.
#' @param age_armed_low number, low cutoff for armed forces age
#'
#' @returns death_records with an additional boolean column "Incomplete Funeral Director Fields", specifying if the record has at least one incomplete funeral director field
#' @keywords internal
#'
parse_incomplete_funeral_director_fields <- function(
    death_records,
    funeral_director_columns,
    unknown_responses,
    age_cutoff_colummns,
    age_column,
    marital_status_column,
    age_marital_low,
    occupation_column,
    age_occupation_low,
    industry_column,
    age_industry_low,
    armed_forces_column,
    age_armed_low
){
  # Create a new column that is True when at least one funeral director field is empty or unknown
  death_records[, "Incomplete Funeral Director Fields"] <-
    rowSums(
      is.na(death_records[, funeral_director_columns[!funeral_director_columns %in% age_cutoff_colummns], drop = F]) |
        (death_records[, funeral_director_columns[!funeral_director_columns %in% age_cutoff_colummns], drop = F] %in% unknown_responses)
    ) > 0
  # Add the results for the age cutoff columns
  if (length(age_cutoff_colummns) > 0){
    for (ac in age_cutoff_colummns){
      cutoff_results <-
        if (ac == marital_status_column){
          cat(paste0("Only considering records above age cutoff for marital status", "\n"))
          (death_records[, age_column] >= age_marital_low & (
            is.na(death_records[, marital_status_column, drop = F]) |
              death_records[, marital_status_column, drop = F] %in% unknown_responses
          ))
        } else if (ac == occupation_column){
          cat(paste0("Only considering records above age cutoff for occupation", "\n"))
          (death_records[, age_column] >= age_occupation_low & (
            is.na(death_records[, occupation_column, drop = F]) |
              death_records[, occupation_column, drop = F] %in% unknown_responses
          ))
        } else if (ac == industry_column){
          cat(paste0("Only considering records above age cutoff for industry", "\n"))
          (death_records[, age_column] >= age_industry_low & (
            is.na(death_records[, industry_column, drop = F]) |
              death_records[, industry_column, drop = F] %in% unknown_responses
          ))
        } else if (ac == armed_forces_column){
          cat(paste0("Only considering records above age cutoff for armed forces", "\n"))
          (death_records[, age_column] >= age_armed_low & (
            is.na(death_records[, armed_forces_column, drop = F]) |
              death_records[, armed_forces_column, drop = F] %in% unknown_responses
          ))
        }

      death_records[,"Incomplete Funeral Director Fields"] <-
        death_records[,"Incomplete Funeral Director Fields"] | cutoff_results
    }
  }

  return(death_records)
}

# external ----

#' Calculate proportion of records with at least one incomplete funeral director field
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param funeral_director_columns character vector of column names in death_records for fields filled out by funeral directors
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param age_column string, age column in death_records
#' @param marital_status_column string, marital status column in death_records. NULL if not in death_records. Default NULL.
#' @param age_marital_low number, low cutoff for marital status age. Default 10.
#' @param occupation_column string, occupation column in death_records. NULL if not in death_records. Default NULL.
#' @param age_occupation_low number, low cutoff for occupation age. Default 14.
#' @param industry_column string, industry column in death_records. NULL if not in death_records. Default NULL.
#' @param age_industry_low number, low cutoff for industry age. Default 14.
#' @param armed_forces_column string, armed forces column in death_records. NULL if not in death_records. Default NULL.
#' @param age_armed_low number, low cutoff for armed forces age. Default 14.
#'
#' @returns number, proportion of records with at least one incomplete funeral director field
#' @export
#'
#' @examples
#' prop <- proportion_with_incomplete_funeral_director_fields(
#'   synthetic_death_records,
#'   funeral_director_columns = c(
#'     "Decdent's Legal Name",
#'     "Sex",
#'     "Social Security Number",
#'     "Age",
#'     "Under 1 Year",
#'     "Under 1 Day",
#'     "Date of Birth",
#'     "Birthplace",
#'     "Residence-State",
#'     "County",
#'     "City or Town",
#'     "Street and Number",
#'     "Apt. No.",
#'     "ZIP Code",
#'     "Inside City Limits",
#'     "Ever in US Armed Forces",
#'     "Marital Status at Time of Death",
#'     "Surviving Spouse's Name",
#'     "Father's Name",
#'     "Mother's Name Prior to First Marriage",
#'     "Informant's Name",
#'     "Relationship to Decedent",
#'     "Mailing Address",
#'     "Place of Death",
#'     "Facility Name",
#'     "Facility City, State, and ZIP Code",
#'     "County of Death",
#'     "Method of Disposition",
#'     "Place of Disposition",
#'     "Location - City, Town, and State",
#'     "Name and Complete Address of Funeral Facility",
#'     "Signature of Funeral Service Licensee or Other Agent",
#'     "License Number",
#'     "Decedent's Education",
#'     "Race White", "Race Black or African American",
#'     "Race American Indian or Alaska Native",
#'     "Race Asian Indian",
#'     "Race Chinese",
#'     "Race Filipino",
#'     "Race Japanese",
#'     "Race Korean",
#'     "Race Vietnamese",
#'     "Race Other Asian",
#'     "Race Native Hawaiian",
#'     "Race Guamanian or Chamorro",
#'     "Race Samoan",
#'     "Race Other Pacific Islander",
#'     "Race Other",
#'     "Hispanic No",
#'     "Hispanic Mexican",
#'     "Hispanic Puerto Rican",
#'     "Hispanic Cuban",
#'     "Hispanic Other",
#'     "Decedent's Usual Occupation",
#'     "Kind of Business/Industry",
#'     "Funeral Facility"
#'   ),
#'   unknown_responses = c("Unknown", "UNK"),
#'   age_column = "Age",
#'   marital_status_column = NULL,
#'   age_marital_low = 10,
#'   occupation_column = NULL,
#'   age_occupation_low = 14,
#'   industry_column = NULL,
#'   age_industry_low = 14,
#'   armed_forces_column = NULL,
#'   age_armed_low = 14
#' )
#'
#'
proportion_with_incomplete_funeral_director_fields <- function(
    death_records,
    funeral_director_columns,
    unknown_responses = c(),
    age_column = "Age",
    marital_status_column = NULL,
    age_marital_low = 10,
    occupation_column = NULL,
    age_occupation_low = 14,
    industry_column = NULL,
    age_industry_low = 14,
    armed_forces_column = NULL,
    age_armed_low = 14
){

  unspecified_arguments_error(
    arg_passed = names(as.list(match.call())[-1]),
    proportion_with_incomplete_funeral_director_fields
  )

  # Subset the funeral director columns to those that appear in the data
  funeral_director_columns <- check_funeral_columns(
    death_records,
    funeral_director_columns
  )
  # if none remain, exit the function
  if (length(funeral_director_columns) == 0){
    cat("No specified funeral director fields in data\n")
    return(NULL)
  }

  # Bin the age cutoff metrics into one vector for ease
  age_cutoff_colummns <- c(
    marital_status_column, occupation_column, industry_column, armed_forces_column
  )
  # If all cutoff columns are null, no need to subset
  if (length(age_cutoff_colummns) > 0){
    age_cutoff_colummns <-
      age_cutoff_colummns[
        age_cutoff_colummns %in% colnames(death_records)
      ]
  }

  # Create a new column that is True when at least one funeral director field is empty or unknown
  death_records <- parse_incomplete_funeral_director_fields(
    death_records,
    funeral_director_columns,
    unknown_responses,
    age_cutoff_colummns,
    age_column,
    marital_status_column,
    age_marital_low,
    occupation_column,
    age_occupation_low,
    industry_column,
    age_industry_low,
    armed_forces_column,
    age_armed_low
  )

  # Calculate the proportion of records with incomplete funeral director fields
  proportion <- calculate_proportion(
    death_records,
    metric = "Incomplete Funeral Director Fields",
    metric_description = "at least one funeral director field incomplete",
    print_output = TRUE
  )

  return(proportion)
}

#' Calculate proportion of records with at least one incomplete funeral director field by certifier
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param funeral_director_columns character vector of column names in death_records for fields filled out by funeral directors
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param age_column string, age column in death_records
#' @param marital_status_column string, marital status column in death_records. NULL if not in death_records. Default NULL.
#' @param age_marital_low number, low cutoff for marital status age. Default 10.
#' @param occupation_column string, occupation column in death_records. NULL if not in death_records. Default NULL.
#' @param age_occupation_low number, low cutoff for occupation age. Default 14.
#' @param industry_column string, industry column in death_records. NULL if not in death_records. Default NULL.
#' @param age_industry_low number, low cutoff for industry age. Default 14.
#' @param armed_forces_column string, armed forces column in death_records. NULL if not in death_records. Default NULL.
#' @param age_armed_low number, low cutoff for armed forces age. Default 14.
#' @param certifier_name_column string, certifier name column in death_records
#' @param number_certifier_proportions number of certifier proportions to display. Default 3.
#'
#' @returns dataframe with one column corresponding to the unique certifiers by name and another column corresponding to the proportions of records with at least one incomplete funeral director field
#' @export
#'
#' @examples
#' certifier_prop <- certifier_proportion_with_incomplete_funeral_director_fields(
#'   synthetic_death_records,
#'   funeral_director_columns = c(
#'     "Decdent's Legal Name",
#'     "Sex",
#'     "Social Security Number",
#'     "Age",
#'     "Under 1 Year",
#'     "Under 1 Day",
#'     "Date of Birth",
#'     "Birthplace",
#'     "Residence-State",
#'     "County",
#'     "City or Town",
#'     "Street and Number",
#'     "Apt. No.",
#'     "ZIP Code",
#'     "Inside City Limits",
#'     "Ever in US Armed Forces",
#'     "Marital Status at Time of Death",
#'     "Surviving Spouse's Name",
#'     "Father's Name",
#'     "Mother's Name Prior to First Marriage",
#'     "Informant's Name",
#'     "Relationship to Decedent",
#'     "Mailing Address",
#'     "Place of Death",
#'     "Facility Name",
#'     "Facility City, State, and ZIP Code",
#'     "County of Death",
#'     "Method of Disposition",
#'     "Place of Disposition",
#'     "Location - City, Town, and State",
#'     "Name and Complete Address of Funeral Facility",
#'     "Signature of Funeral Service Licensee or Other Agent",
#'     "License Number",
#'     "Decedent's Education",
#'     "Race White", "Race Black or African American",
#'     "Race American Indian or Alaska Native",
#'     "Race Asian Indian",
#'     "Race Chinese",
#'     "Race Filipino",
#'     "Race Japanese",
#'     "Race Korean",
#'     "Race Vietnamese",
#'     "Race Other Asian",
#'     "Race Native Hawaiian",
#'     "Race Guamanian or Chamorro",
#'     "Race Samoan",
#'     "Race Other Pacific Islander",
#'     "Race Other",
#'     "Hispanic No",
#'     "Hispanic Mexican",
#'     "Hispanic Puerto Rican",
#'     "Hispanic Cuban",
#'     "Hispanic Other",
#'     "Decedent's Usual Occupation",
#'     "Kind of Business/Industry",
#'     "Funeral Facility"
#'   ),
#'   unknown_responses = c("Unknown", "UNK"),
#'   age_column = "Age",
#'   marital_status_column = NULL,
#'   age_marital_low = 10,
#'   occupation_column = NULL,
#'   age_occupation_low = 14,
#'   industry_column = NULL,
#'   age_industry_low = 14,
#'   armed_forces_column = NULL,
#'   age_armed_low = 14,
#'   certifier_name_column = "Certifier Name",
#'   number_certifier_proportions = 3
#' )
#'
#'
certifier_proportion_with_incomplete_funeral_director_fields <- function(
    death_records,
    funeral_director_columns,
    unknown_responses = c(),
    age_column = "Age",
    marital_status_column = NULL,
    age_marital_low = 10,
    occupation_column = NULL,
    age_occupation_low = 14,
    industry_column = NULL,
    age_industry_low = 14,
    armed_forces_column = NULL,
    age_armed_low = 14,
    certifier_name_column,
    number_certifier_proportions = 3
){

  unspecified_arguments_error(
    arg_passed = names(as.list(match.call())[-1]),
    certifier_proportion_with_incomplete_funeral_director_fields
  )

  # Subset the funeral director columns to those that appear in the data
  funeral_director_columns <- check_funeral_columns(
    death_records,
    funeral_director_columns
  )
  # if none remain, exit the function
  if (length(funeral_director_columns) == 0){
    cat("No specified funeral director fields in data\n")
    return(NULL)
  }

  # Bin the age cutoff metrics into one vector for ease
  age_cutoff_colummns <- c(
    marital_status_column, occupation_column, industry_column, armed_forces_column
  )
  # If all cutoff columns are null, no need to subset
  if (length(age_cutoff_colummns) > 0){
    age_cutoff_colummns <-
      age_cutoff_colummns[
        age_cutoff_colummns %in% colnames(death_records)
      ]
  }

  # Create a new column that is True when at least one funeral director field is empty or unknown
  death_records <- parse_incomplete_funeral_director_fields(
    death_records,
    funeral_director_columns,
    unknown_responses,
    age_cutoff_colummns,
    age_column,
    marital_status_column,
    age_marital_low,
    occupation_column,
    age_occupation_low,
    industry_column,
    age_industry_low,
    armed_forces_column,
    age_armed_low
  )

  # Group the records by certifier and calculate the proportion of flagged records for each certifier
  certifier_proportions <- calculate_proportion_by_column(
    death_records,
    metric = "Incomplete Funeral Director Fields",
    column = certifier_name_column,
    print_output = TRUE,
    num_print = number_certifier_proportions
  )

  return(certifier_proportions)
}
