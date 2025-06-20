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

parse_incomplete_medical_certifier_fields <- function(
    death_records,
    funeral_director_columns,
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

proportion_with_incomplete_medical_certifier_fields <- function(
    death_records,
    funeral_director_columns,
    unknown_responses = c(
      "Unknown",
      "U",
      "UNK" # unknown response specific to these attributes
    ),
    sex_column = "Sex",
    pregnancy_column = "Pregnancy Status",
    age_column = "Age",
    age_pregnancy_low = 5,
    age_pregnancy_high = 74
){

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
    funeral_director_columns,
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

certifier_proportion_with_incomplete_medical_certifier_fields <- function(
    death_records,
    funeral_director_columns,
    unknown_responses = c(
      "Unknown",
      "U",
      "UNK" # unknown response specific to these attributes
    ),
    sex_column = "Sex",
    pregnancy_column = "Pregnancy Status",
    age_column = "Age",
    age_pregnancy_low = 5,
    age_pregnancy_high = 74
){

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
    funeral_director_columns,
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
