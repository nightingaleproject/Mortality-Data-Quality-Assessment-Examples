# Code for metric: proportion not certified within required time period

# internal ----

#' Add column for not certified within required period
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param date_of_death_column string, date of death column in death_records
#' @param date_certified_column string, date certified column in death_records
#' @param number_of_days number, days that a record must be certified by
#'
#' @returns death_records with an additional boolean column "Not Within Required Days", specifying if the record was not certified within the specified period
#' @keywords internal
#'
parse_not_certified_within_required_period <- function(
    death_records,
    date_of_death_column = "Date of Death",
    date_certified_column  = "Date Certified",
    number_of_days = 5
){
  # Parse the dates
  death_records$`Date of Death` <- as.Date(death_records[, date_of_death_column])
  death_records$`Date Certified` <- as.Date(death_records[, date_certified_column])

  # Calculate the difference in days between the Date Certified and the Date of Death
  death_records[, "Days Difference"] <-
    as.numeric(death_records$`Date Certified` - death_records$`Date of Death`)

  # Create a column that is TRUE when the time between death and certification is not within 5 days
  death_records[, "Not Within Required Days"] <-
    death_records$`Days Difference` < 0 |
    death_records$`Days Difference` > number_of_days

  return(death_records)
}

# external ----

#' Calculate proportion of records not certified within required period
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param date_of_death_column string, date of death column in death_records
#' @param date_certified_column string, date certified column in death_records
#' @param number_of_days number, days that a record must be certified by
#'
#' @returns number, proportion of records not certified within required period
#' @export
#'
proportion_not_certified_within_required_period <- function(
    death_records,
    date_of_death_column,
    date_certified_column,
    number_of_days
  ){
  # add calculated variables for not within required time frame
  death_records <- parse_not_certified_within_required_period(
    death_records,
    date_of_death_column = "Date of Death",
    date_certified_column  = "Date Certified",
    number_of_days = 5
  )

  # Calculate the proportion of records where the Date Certified is not within required days of the Date of Death
  proportion <- calculate_proportion(
    death_records,
    metric = "Not Within Required Days",
    metric_description = paste0(
      "Date Certified is not within ", number_of_days, " days of the Date of Death"
    ),
    print_output = TRUE
  )

  return(proportion)
}

#' Calculate proportion of records not certified within required period by certifier
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param date_of_death_column string, date of death column in death_records
#' @param date_certified_column string, date certified column in death_records
#' @param number_of_days number, days that a record must be certified by
#' @param certifier_name_column string, certifier name column in death_records
#'
#' @returns dataframe with one column corresponding to the unique certifiers by name and another column corresponding to the proportions of records with date certified not within required days
#' @export
#'
certifier_proportion_not_certified_within_required_period <- function(
    death_records,
    date_of_death_column = "Date of Death",
    date_certified_column  = "Date Certified",
    number_of_days = 5,
    certifier_name_column = "Certifier Name"
){
  # add calculated variables for not within required time frame
  death_records <- parse_not_certified_within_required_period(
    death_records,
    date_of_death_column,
    date_certified_column,
    number_of_days
  )

  # Group the records by certifier and calculate the proportion of flagged records for each certifier
  certifier_proportions <- calculate_proportion_by_column(
    death_records,
    metric = "Not Within Required Days",
    column = certifier_name_column,
    print_output = TRUE
  )

  return(certifier_proportions)
}
