import sys
import pandas as pd

death_records = None

# Use supplied path to records and load as a pandas dataframe
if len(sys.argv) > 1:
    filename = sys.argv[1]
    try:
        death_records = pd.read_csv(filename, keep_default_na=False, na_values=[""])
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")
else:
    print(f"Usage: {sys.argv[0]} <filename>")
    exit()

# Calculate the overall proportion of the provided metric on the records we loaded above
def proportion(metric):
    death_records["Results Column"] = metric(death_records)
    return death_records["Results Column"].mean()

# Calculate the proportion of the provided metric for each distinct value in supplied column
def proportion_by_column(metric, column):
    death_records["Results Column"] = metric(death_records)
    #return list(death_records.groupby(column)["Results Column"].mean().items())
    return death_records.groupby(column)["Results Column"].mean().reset_index(name="Proportion").sort_values(by="Proportion", ascending=False)
