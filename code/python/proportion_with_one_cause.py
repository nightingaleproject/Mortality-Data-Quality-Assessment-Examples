import os
import pandas as pd

# Locate the relative path to the data location
data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "..", "data")

# Load the death records data
death_records = pd.read_csv(
    os.path.join(data_path, "SyntheticDeathRecordData.csv"),
    keep_default_na=False,
    na_values=[""],
)

# Find all the Record Axis COD columns
record_axis_cod_columns = [col for col in death_records.columns if col.startswith("Record Axis COD")]

# Create a new column that is True when a single Record Axis COD column is populated
death_records['Single Record Axis COD'] = death_records[record_axis_cod_columns].notna().sum(axis=1) == 1

# Calculate the proportion of records with only one Record Axis COD
proportion = death_records["Single Record Axis COD"].mean()

print(
    f"The proportion of records with a single Record Axis COD is {proportion:.2f}"
)

# Group the records by certifier and calculate the proportion of flagged records for each certifier
certifier_proportions = death_records.groupby("Certifier Name")[
    "Single Record Axis COD"
].mean()

# Print the proportions for each certifier
for certifier, proportion in certifier_proportions.items():
    print(
        f"The proportion of records with a single Record Axis COD provided by {certifier} is {proportion:.2f}"
    )
