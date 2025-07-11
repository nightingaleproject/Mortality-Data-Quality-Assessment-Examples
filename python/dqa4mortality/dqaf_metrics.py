import sys
import pandas as pd

# Use supplied path to records and load as a pandas dataframe
def load_death_records(filename):
    try:
        death_records = pd.read_csv(filename, keep_default_na=False, na_values=[""])
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
    
    return death_records

# Calculate the overall proportion of the provided metric on the records we loaded above
def calculate_proportion(death_records, metric, metric_description, print_output = True):
    death_records["Results Column"] = metric(death_records)
    proportion = death_records["Results Column"].mean()
    
    if print_output:
      print(
        f"The proportion of records with {metric_description} is {proportion:.2f}"
      )
    
    return proportion

# Calculate the proportion of the provided metric for each distinct value in supplied column
def proportion_by_column(death_records, metric, column, print_output = True):
    death_records["Results Column"] = metric(death_records)
    
    col_proportions = death_records.groupby(column)["Results Column"].mean().reset_index(name="Proportion").sort_values(by="Proportion", ascending=False)
    #return list(death_records.groupby(column)["Results Column"].mean().items())
    
    if print_output:
      print(col_proportions)
    
    return col_proportions
