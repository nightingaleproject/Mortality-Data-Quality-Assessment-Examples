
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

certifier_proportion_with_one_cause <- function(
    death_records,
    date_of_death_column = "Date of Death",
    date_certified_column  = "Date Certified",
    number_of_days = 5,
    certifier_name_column = "Certifier Name"
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
