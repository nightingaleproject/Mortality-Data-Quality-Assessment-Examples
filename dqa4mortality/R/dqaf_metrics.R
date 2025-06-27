# Common Code Across R functions

# internal ----

#' Calculate and print the overall proportion of the provided metric on the records we loaded above
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param metric character string corresponding to the boolean column in death_records we want to calculate proportion for
#' @param metric_description string description for print output
#' @param print_output boolean, should output be printed to the console? Default TRUE
#'
#' @returns number, proportion of records with metric as TRUE
#' @keywords internal
#'
calculate_proportion <- function(
    death_records, metric, metric_description, print_output = TRUE
){
  proportion <- mean(death_records[, metric], na.rm = TRUE)

  if (print_output){
    cat(paste(
      "The proportion of records with", metric_description, "is",
      round(proportion, 2),
      "\n"))
  }

  return(proportion)
}

#' Calculate the proportion of the provided metric for each distinct value in supplied column
#'
#' @param death_records death records dataframe with rows corresponding to
#'  records and columns corresponding to record attributes
#' @param metric character string corresponding to the boolean column in death_records we want to calculate proportion for
#' @param column string of column name we want to group by
#' @param print_output boolean, should output be printed to the console? Default TRUE
#' @param num_print number of groups in column we would like to be printed to the console. Default NA
#'
#' @returns dataframe with one column corresponding to the unique groups in "column" and another column corresponding to the proportions of records with metric as TRUE for each group
#' @keywords internal
#'
calculate_proportion_by_column <- function(
    death_records, metric, column, print_output = TRUE, num_print = NA
){
  col_proportions <-
    aggregate(
      list("Proportion" = death_records[, metric]),
      list("Output" = death_records[, column]),
      FUN = mean,
      na.rm = TRUE)
  col_proportions <-
    col_proportions[order(col_proportions$Proportion, decreasing = T),]
  colnames(col_proportions) <- c(column, "Proportion")

  if (print_output){
    # if we're printing, we want to subset to the requested amount
    print_proportions <- col_proportions
    if (!is.na(num_print)){
      print_proportions <- print_proportions[c(1:num_print),]
      cat(paste0("Top ", num_print, " Proportions by Certifier Name:\n"))
    }

    # Print the proportions for each of the columns
    print(print_proportions)
  }

  return(col_proportions)
}

# external ----

#' Use supplied path to death records and load as a dataframe
#'
#' @param file file path to death records CSV, with rows corresponding to
#'  records and columns corresponding to record attributes
#'
#' @returns data frame with death records information
#' @export
#'
load_death_records <- function(file){
  # Load the death records data
  death_records <- read.csv(
    file,
    stringsAsFactors = FALSE,
    check.names = FALSE,
    na.strings = ""
  )

  return(death_records)
}
