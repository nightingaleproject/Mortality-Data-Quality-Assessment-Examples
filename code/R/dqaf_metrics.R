# Common Code Across R functions

# functions for support ----

# Use supplied path to records and load as a pandas dataframe
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

# Calculate and print the overall proportion of the provided metric on the records we loaded above
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

# Calculate the proportion of the provided metric for each distinct value in supplied column
calculate_proportion_by_column <- function(
    death_records, metric, column, print_output = TRUE
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
    # Print the proportions for each of the columns
    print(col_proportions)
  }
  
  return(col_proportions)
}