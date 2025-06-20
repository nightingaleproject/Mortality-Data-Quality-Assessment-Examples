
parse_with_unsuitable_underlying <- function(
    death_records,
    underlying_cause_of_death_column
){

  # Load the unsuitable causes of death data
  unsuitable_causes <- read.csv(here::here("data", "unsuitable_COD_codes.csv"))

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

proportion_with_unsuitable_underlying <- function(
    death_records,
    underlying_cause_of_death_column
){
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

certifier_proportion_with_unsuitable_underlying <- function(
    death_records,
    date_of_death_column = "Date of Death",
    date_certified_column  = "Date Certified",
    number_of_days = 5,
    certifier_name_column = "Certifier Name"
){
  # add calculated variables for not within required time frame
  death_records <- parse_with_unsuitable_underlying(
    death_records,
    cause_of_death_columns
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
