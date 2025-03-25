import dqaf_metrics
import os
import pandas as pd

# Locate the relative path to the data location
data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "..", "data")

# Load the unsuitable causes of death data and extract codes
unsuitable_causes = pd.read_csv(os.path.join(data_path, "unsuitable_COD_codes.csv"))
unsuitable_codes = unsuitable_causes["code"].values

# Function to check if any unsuitable code is a prefix to the code in the record
def is_unsuitable(code):
    return any(code.startswith(unsuitable) for unsuitable in unsuitable_codes)

# Define metric
def metric(records):
    # Return a column that is True when the underlying COD is unsuitable
    return records["Underlying COD"].apply(is_unsuitable)

description = "The proportion of records with an unsuitable underlying cause of death"

# Use metric to calculate overall proportion 
proportion = dqaf_metrics.proportion(metric)
print(f"{description} is {proportion:.2f}")

# Use metric to calculate proportion for each certifier
proportion_by_certifier = dqaf_metrics.proportion_by_column(metric, "Certifier Name")
for certifier, proportion in proportion_by_certifier:
    print(f"{description} provided by {certifier} is {proportion:.2f}")
