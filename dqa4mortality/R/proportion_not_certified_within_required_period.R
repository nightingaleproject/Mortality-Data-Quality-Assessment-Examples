
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

  # Calculate the proportion of records where the Date Certified is not within 5 days of the Date of Death
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
