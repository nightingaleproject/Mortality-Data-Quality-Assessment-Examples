import os
import pandas as pd

# Locate the relative path to the data location
data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "data")

# Load the death record data
death_records = pd.read_csv(
    os.path.join(data_path, "NotionalDeathRecordData.csv"),
    keep_default_na=False,
    na_values=[""],
)

# Define the demographic columns we're interested in; this example identifies race and ethnicity columns
demographic_columns = [
    col
    for col in death_records.columns
    if col.startswith("Race") or col.startswith("Hispanic")
]

# Create a new column that is True when at least one demographic field is "unknown"
death_records["Incomplete Demographics"] = death_records[demographic_columns].apply(
    lambda row: row.str.contains("U").any(), axis=1
)

# Calculate the proportion of records with incomplete demographic fields
proportion = death_records["Incomplete Demographics"].mean()

print(
    f"The proportion of records with at least one demographic field incomplete is {proportion:.3f}"
)
