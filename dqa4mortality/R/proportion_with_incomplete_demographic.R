# Code for metric: proportion with incomplete demographics

# internal ----

#' Find the columns in death records dataframe that match the input field
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param field string, field we are looking to match in death_records. If string ends with ".\*", matches fields that start with all characters preceding it. For example, "Race .\*" will search for all fields starting with "Race ".
#'
#' @returns character vector of column name(s) matching field in death_records
#' @keywords internal
#'
find_matching_columns <- function(
    death_records,
    field
){
  # Find the columns that match this field (may be more than one if it's a regex)
  matching_columns <- if (!grepl("\\.\\*", field)){
    colnames(death_records)[colnames(death_records) == field]
  } else {
    colnames(death_records)[grepl(field, colnames(death_records))]
  }

  return(matching_columns)
}

#' Subset death records data to relevant records based on age cutoffs
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param mc string, column we are calculating proportions for
#' @param sex_column string, sex column in death_records
#' @param pregnancy_column string, pregnancy column in death_records
#' @param age_column string, age column in death_records
#' @param age_pregnancy_low number, low cutoff for pregnancy age
#' @param age_pregnancy_high number, high cutoff for pregnancy age
#' @param marital_status_column string, marital status column in death_records. NULL if not in death_records.
#' @param age_marital_low number, low cutoff for marital status age
#' @param occupation_column string, occupation column in death_records. NULL if not in death_records.
#' @param age_occupation_low number, low cutoff for occupation age
#' @param industry_column string, industry column in death_records. NULL if not in death_records.
#' @param age_industry_low number, low cutoff for industry age
#' @param armed_forces_column string, armed forces column in death_records. NULL if not in death_records.
#' @param age_armed_low number, low cutoff for armed forces age
#'
#' @returns death_records, subset to the relevant records in mc based on cutoffs
#' @export
#'
subset_records_for_cutoffs <- function(
    death_records,
    mc,
    sex_column,
    pregnancy_column,
    age_column,
    age_pregnancy_low,
    age_pregnancy_high,
    marital_status_column,
    age_marital_low,
    occupation_column,
    age_occupation_low,
    industry_column,
    age_industry_low,
    armed_forces_column,
    age_armed_low
){
  # Adjustments for age/sex cutoffs
  considered_records <- death_records
  if (mc == pregnancy_column){
    # If the field relates to pregnancy, we only need to consider missingness
    # for female and within age
    cat(paste0("Only considering female records within age cutoffs for pregnancy status", "\n"))
    considered_records <-
      considered_records[
        considered_records[, sex_column] == "F" &
          considered_records[, age_column] >= age_pregnancy_low &
          considered_records[, age_column] <= age_pregnancy_high,
      ]
  } else if (!is.null(marital_status_column) && mc == marital_status_column){
    cat(paste0("Only considering records above age cutoff for marital status", "\n"))
    considered_records <-
      considered_records[
        considered_records[, age_column] >= age_marital_low,
      ]
  } else if (!is.null(occupation_column) && mc == occupation_column){
    cat(paste0("Only considering records above age cutoff for occupation", "\n"))
    considered_records <-
      considered_records[
        considered_records[, age_column] >= age_occupation_low,
      ]
  } else if (!is.null(industry_column) && mc == industry_column){
    cat(paste0("Only considering records above age cutoff for industry", "\n"))
    considered_records <-
      considered_records[
        considered_records[, age_column] >= age_industry_low,
      ]
  } else if (!is.null(armed_forces_column) && mc == armed_forces_column){
    cat(paste0("Only considering records above age cutoff for armed forces", "\n"))
    considered_records <-
      considered_records[
        considered_records[, age_column] >= age_armed_low,
      ]
  }

  return(considered_records)
}

# external ----

#' Calculate proportion of records with incomplete demographic fields
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param demographic_fields character vector of column strings in death_records for fields related to demographics. If string ends with ".\*", matches fields that start with all characters preceding it. For example, "Race .\*" will search for all fields starting with "Race ". Default to vector of demographic fields in standard death certificate.
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param sex_column string, sex column in death_records
#' @param pregnancy_column string, pregnancy column in death_records
#' @param age_column string, age column in death_records
#' @param age_pregnancy_low number, low cutoff for pregnancy age
#' @param age_pregnancy_high number, high cutoff for pregnancy age
#' @param marital_status_column string, marital status column in death_records. NULL if not in death_records.
#' @param age_marital_low number, low cutoff for marital status age
#' @param occupation_column string, occupation column in death_records. NULL if not in death_records.
#' @param age_occupation_low number, low cutoff for occupation age
#' @param industry_column string, industry column in death_records. NULL if not in death_records.
#' @param age_industry_low number, low cutoff for industry age
#' @param armed_forces_column string, armed forces column in death_records. NULL if not in death_records.
#' @param age_armed_low number, low cutoff for armed forces age
#'
#' @returns data frame with 3 columns:
#'    Column.Name: demographic fields
#'    Proportion.Blank: proportion missing for a given demographic field
#'    Proportion.Unknown: proportion unknown for a given demographic field
#' @export
#'
#' @examples
#' prop <- proportion_with_incomplete_demographic(
#'   synthetic_death_records,
#'   demographic_fields = c(
#'     "Age",
#'     "County of Death",
#'     "Date of Death",
#'     "Education",
#'     "Hispanic .*", #' Match any field starting with 'Hispanic'
#'     "Manner of Death",
#'     "Place of Death",
#'     "Pregnancy Status",
#'     "Race .*", #' Match any field starting with 'Race'
#'     "Tobacco Use Contributed to Death"
#'   ),
#'   unknown_responses = c("Unknown", "UNK"),
#'   sex_column = "Sex",
#'   pregnancy_column = "Pregnancy Status",
#'   age_column = "Age",
#'   age_pregnancy_low = 5,
#'   age_pregnancy_high = 74,
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
proportion_with_incomplete_demographic <- function(
    death_records,
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
    ),
    unknown_responses = c(),
    sex_column = "Sex",
    pregnancy_column = "Pregnancy Status",
    age_column = "Age",
    age_pregnancy_low = 5,
    age_pregnancy_high = 74,
    marital_status_column = NULL,
    age_marital_low = 10,
    occupation_column = NULL,
    age_occupation_low = 14,
    industry_column = NULL,
    age_industry_low = 14,
    armed_forces_column = NULL,
    age_armed_low = 14
){

  # For each field we first check if the field is present in the data;
  # if it's present, we evaluate the proportion of records that have a
  # blank value for the field and the proportion of records that have
  # an explicit "Unknown" value for the field
  all_proportions <- data.frame()
  for (field in demographic_fields){
    cat(paste0("  Evaluating fields matching ", field), "\n")

    matching_columns <- find_matching_columns(death_records, field)

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
      # Adjustments for age/sex cutoffs
      considered_records <- subset_records_for_cutoffs(
        death_records,
        sex_column,
        pregnancy_column,
        age_column,
        age_pregnancy_low,
        age_pregnancy_high,
        marital_status_column,
        age_marital_low,
        occupation_column,
        age_occupation_low,
        industry_column,
        age_industry_low,
        armed_forces_column,
        age_armed_low
      )

      # The field is present, so now find the proportion that are blank
      considered_records[, paste0("Blank ", mc)] <-
        as.numeric(is.na(considered_records[, mc]))

      proportion_blank <- calculate_proportion(
        considered_records,
        metric = paste0("Blank ", mc),
        metric_description = paste0("blank values for ", mc),
        print_output = TRUE
      )

      # Now find the proportion that are "unknown"
      considered_records[, paste0("Unknown ", mc)] <-
        as.numeric(considered_records[, mc] %in% unknown_responses)

      proportion_unknown <- calculate_proportion(
        considered_records,
        metric = paste0("Unknown ", mc),
        metric_description = paste0("explicit 'unknown' values for ", mc),
        print_output = TRUE
      )

      all_proportions <- rbind(
        all_proportions,
        data.frame(
          "Column Name" = mc,
          "Proportion Blank" = proportion_blank,
          "Proportion Unknown" = proportion_unknown
        )
      )
    }

    cat("\n")
  }

  return(all_proportions)
}

#' Calculate proportion of records with incomplete demographic fields by certifier
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param demographic_fields character vector of column strings in death_records for fields related to demographics. If string ends with ".\*", matches fields that start with all characters preceding it. For example, "Race .\*" will search for all fields starting with "Race ". Default to vector of demographic fields in standard death certificate.
#' @param unknown_responses character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.
#' @param sex_column string, sex column in death_records
#' @param pregnancy_column string, pregnancy column in death_records
#' @param age_column string, age column in death_records
#' @param age_pregnancy_low number, low cutoff for pregnancy age
#' @param age_pregnancy_high number, high cutoff for pregnancy age
#' @param marital_status_column string, marital status column in death_records. NULL if not in death_records.
#' @param age_marital_low number, low cutoff for marital status age
#' @param occupation_column string, occupation column in death_records. NULL if not in death_records.
#' @param age_occupation_low number, low cutoff for occupation age
#' @param industry_column string, industry column in death_records. NULL if not in death_records.
#' @param age_industry_low number, low cutoff for industry age
#' @param armed_forces_column string, armed forces column in death_records. NULL if not in death_records.
#' @param age_armed_low number, low cutoff for armed forces age
#' @param certifier_name_column string, certifier name column in death_records
#' @param number_certifier_proportions number of certifier proportions to display. Default 3.
#'
#' @returns data frame with 4 columns:
#'    Column Name: demographic fields
#'    Certifier Name: certifier name
#'    Proportion Blank: proportion missing for a given demographic field and certifier name
#'    Proportion Unknown: proportion unknown for a given demographic field and certifier name
#' @export
#'
#' @examples
#' certifier_prop <- certifier_proportion_with_incomplete_demographic(
#'   synthetic_death_records,
#'   demographic_fields = c(
#'     "Age",
#'     "County of Death",
#'     "Date of Death",
#'     "Education",
#'     "Hispanic .*", #' Match any field starting with 'Hispanic'
#'     "Manner of Death",
#'     "Place of Death",
#'     "Pregnancy Status",
#'     "Race .*", #' Match any field starting with 'Race'
#'     "Tobacco Use Contributed to Death"
#'   ),
#'   unknown_responses = c("Unknown", "UNK"),
#'   sex_column = "Sex",
#'   pregnancy_column = "Pregnancy Status",
#'   age_column = "Age",
#'   age_pregnancy_low = 5,
#'   age_pregnancy_high = 74,
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
certifier_proportion_with_incomplete_demographic <- function(
    death_records,
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
    ),
    unknown_responses = c(),
    sex_column = "Sex",
    pregnancy_column = "Pregnancy Status",
    age_column = "Age",
    age_pregnancy_low = 5,
    age_pregnancy_high = 74,
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
  # For each field we first check if the field is present in the data;
  # if it's present, we evaluate the proportion of records that have a
  # blank value for the field and the proportion of records that have
  # an explicit "Unknown" value for the field
  all_certifier_proportions <- data.frame()
  for (field in demographic_fields){
    cat(paste0("  Evaluating fields matching ", field), "\n")

    matching_columns <- find_matching_columns(death_records, field)

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
      # Adjustments for age/sex cutoffs
      considered_records <- subset_records_for_cutoffs(
        death_records,
        sex_column,
        pregnancy_column,
        age_column,
        age_pregnancy_low,
        age_pregnancy_high,
        marital_status_column,
        age_marital_low,
        occupation_column,
        age_occupation_low,
        industry_column,
        age_industry_low,
        armed_forces_column,
        age_armed_low
      )


      cat(paste0("  Evaluating ", mc, ":"), "\n")

      # The field is present, so now find the proportion that are blank
      considered_records[, paste0("Blank ", mc)] <-
        as.numeric(is.na(considered_records[, mc]))

      # Group the records by certifier and calculate the proportion of flagged records for each certifier
      cat("Proportion Blank:\n")
      certifier_proportions_blank <- calculate_proportion_by_column(
        considered_records,
        metric = paste0("Blank ", mc),
        column = certifier_name_column,
        print_output = TRUE,
        num_print = number_certifier_proportions
      )
      colnames(certifier_proportions_blank) <-
        c("Certifier Name", "Proportion Blank")

      # Now find the proportion that are "unknown"
      considered_records[, paste0("Unknown ", mc)] <-
        as.numeric(considered_records[, mc] %in% unknown_responses)

      # Group the records by certifier and calculate the proportion of flagged records for each certifier
      cat("Proportion Unknown:\n")
      certifier_proportions_unknown <- calculate_proportion_by_column(
        considered_records,
        metric = paste0("Unknown ", mc),
        column = certifier_name_column,
        print_output = TRUE,
        num_print = number_certifier_proportions
      )
      colnames(certifier_proportions_unknown) <-
        c("Certifier Name", "Proportion Unknown")

      merge_prop <- merge(certifier_proportions_blank, certifier_proportions_unknown)
      merge_prop[, "Column Name"] <- mc

      all_certifier_proportions <- rbind(
        all_certifier_proportions,
        merge_prop
      )
    }

    cat("\n")
  }

  return(all_certifier_proportions)
}
