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
calculate_proportion <- function(death_records, metric, metric_description){
  proportion <- mean(death_records[, metric], na.rm = TRUE)
  
  cat(paste(
    "The proportion of records with a(n)", metric_description, "is",
    round(proportion, 2),
    "\n"))
  
  return(proportion)
}

# Calculate the proportion of the provided metric for each distinct value in supplied column
calculate_proportion_by_column <- function(death_records, metric, metric_description, column){
  col_proportions <- 
    aggregate(
      list("Proportion" = death_records[, metric]),
      list("Output" = death_records[, column]),
      FUN = mean,
      na.rm = TRUE)
  col_proportions <- 
    col_proportions[order(col_proportions$Proportion, decreasing = T),]
  colnames(col_proportions) <- c(column, "Proportion")
  
  
  # Print the proportions for each of the columns
  for(i in 1:nrow(col_proportions)) {
    cat(paste(
      "The proportion of records with a(n)",
      metric_description,
      "by",
      column,
      "is",
      round(col_proportions[i, "Proportion"], 2), "\n"))
  }
  
  return(col_proportions)
}