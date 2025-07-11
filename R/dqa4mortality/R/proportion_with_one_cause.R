# Code for metric: proportion with one cause of death

# internal ----

#' Add column for one cause of death
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param cause_of_death_columns character vector, cause of death columns in death_records
#'
#' @returns death_records with an additional boolean column "Single Record Axis COD", specifying if the record has only one cause of death specified
#' @keywords internal
#'
parse_with_one_cause <- function(
    death_records,
    cause_of_death_columns
){
  # Create a new column that is True when a single Record Axis COD column is populated
  death_records[, "Single Record Axis COD"] <-
    rowSums(!is.na(
      death_records[, cause_of_death_columns, drop = F])
    ) == 1

  return(death_records)
}

# external ----

#' Calculate proportion of records with one cause of death
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param cause_of_death_columns character vector, cause of death columns in death_records
#'
#' @returns number, proportion of records with one cause of death
#' @export
#'
#' @examples
#' prop <- proportion_with_one_cause(
#'   synthetic_death_records,
#'   # in synthetic data, many columns matching "Record Axis COD" represent the causes of death
#'   cause_of_death_columns = c(
#'     colnames(synthetic_death_records)[
#'       startsWith(colnames(synthetic_death_records), "Record Axis COD")
#'     ]
#'   )
#' )
#'
proportion_with_one_cause <- function(
    death_records,
    cause_of_death_columns
){
  # add calculated variables for not within required time frame
  death_records <- parse_with_one_cause(
    death_records,
    cause_of_death_columns
  )

  # Calculate the proportion of records with only one Record Axis COD
  proportion <- calculate_proportion(
    death_records,
    metric = "Single Record Axis COD",
    metric_description = "Single Record Axis COD",
    print_output = TRUE
  )

  return(proportion)
}

#' Calculate proportion of records not certified within required period by certifier
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param cause_of_death_columns character vector, cause of death columns in death_records
#' @param certifier_name_column string, certifier name column in death_records
#'
#' @returns dataframe with one column corresponding to the unique certifiers by name and another column corresponding to the proportions of records with one cause of death
#' @export
#'
#' @examples
#' certifier_prop <- certifier_proportion_with_one_cause(
#'   synthetic_death_records,
#'   # in synthetic data, many columns matching "Record Axis COD" represent the causes of death
#'   cause_of_death_columns = c(
#'     colnames(synthetic_death_records)[
#'       startsWith(colnames(synthetic_death_records), "Record Axis COD")
#'     ]
#'   ),
#'   certifier_name_column = "Certifier Name"
#' )
#'
#'
#'
certifier_proportion_with_one_cause <- function(
    death_records,
    cause_of_death_columns,
    certifier_name_column
){
  # add calculated variables for not within required time frame
  death_records <- parse_with_one_cause(
    death_records,
    cause_of_death_columns
  )

  # Group the records by certifier and calculate the proportion of flagged records for each certifier
  certifier_proportions <- calculate_proportion_by_column(
    death_records,
    metric = "Single Record Axis COD",
    column = certifier_name_column,
    print_output = TRUE
  )

  return(certifier_proportions)
}
