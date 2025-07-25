# Code for metric: proportion with one cause of death

# internal ----

utils::globalVariables(c("unsuitable_COD_codes"))

#' Add column for unsuitable underlying causes of death
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param underlying_cause_of_death_column string, underlying cause of death column in death_records
#'
#' @returns death_records with an additional boolean column "Unsuitable Underlying", specifying if the record was not certified within the specified period
#' @keywords internal
#'
parse_with_unsuitable_underlying <- function(
    death_records,
    underlying_cause_of_death_column
){

  # Load the unsuitable causes of death data
  unsuitable_causes <- unsuitable_COD_codes

  # Extract the unsuitable codes
  unsuitable_codes <- unsuitable_causes$code

  # Create a new column that is TRUE when the underlying COD is unsuitable
  death_records[, "Unsuitable Underlying"] <- sapply(
    death_records[, underlying_cause_of_death_column],
    function(code){
      return(any(startsWith(code, unsuitable_codes)))
    }
  )

  return(death_records)
}

# external ----

#' Calculate proportion of records with unsuitable underlying causes of death
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param underlying_cause_of_death_column string, underlying cause of death column in death_records
#'
#' @returns number, proportion of records with unsuitable underlying causes of death
#' @export
#'
#' @examples
#' prop <- proportion_with_unsuitable_underlying(
#'   synthetic_death_records,
#'   underlying_cause_of_death_column = "Underlying COD"
#' )
#'
proportion_with_unsuitable_underlying <- function(
    death_records,
    underlying_cause_of_death_column
){
  unspecified_arguments_error(
    arg_passed = names(as.list(match.call())[-1]),
    proportion_with_unsuitable_underlying
  )

  # add calculated variables for not within required time frame
  death_records <- parse_with_unsuitable_underlying(
    death_records,
    underlying_cause_of_death_column
  )

  # Calculate the proportion of records with an unsuitable underlying cause of death
  proportion <- calculate_proportion(
    death_records,
    metric = "Unsuitable Underlying",
    metric_description = "unsuitable underlying cause of death",
    print_output = TRUE
  )

  return(proportion)
}

#' Calculate proportion of records with unsuitable underlying causes of death by certifier
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param underlying_cause_of_death_column string, underlying cause of death column in death_records
#' @param certifier_name_column string, certifier name column in death_records
#'
#' @returns dataframe with one column corresponding to the unique certifiers by name and another column corresponding to the proportions of records with unsuitable underlying causes of death
#' @export
#'
#' @examples
#' certifier_prop <- certifier_proportion_with_unsuitable_underlying(
#'   synthetic_death_records,
#'   underlying_cause_of_death_column = "Underlying COD",
#'   certifier_name_column = "Certifier Name"
#' )
#'
certifier_proportion_with_unsuitable_underlying <- function(
    death_records,
    underlying_cause_of_death_column,
    certifier_name_column
){
  unspecified_arguments_error(
    arg_passed = names(as.list(match.call())[-1]),
    certifier_proportion_with_unsuitable_underlying
  )

  # add calculated variables for not within required time frame
  death_records <- parse_with_unsuitable_underlying(
    death_records,
    underlying_cause_of_death_column
  )

  # Group the records by certifier and calculate the proportion of unsuitable records for each certifier
  certifier_proportions <- calculate_proportion_by_column(
    death_records,
    metric = "Unsuitable Underlying",
    column = certifier_name_column,
    print_output = TRUE
  )

  return(certifier_proportions)
}
