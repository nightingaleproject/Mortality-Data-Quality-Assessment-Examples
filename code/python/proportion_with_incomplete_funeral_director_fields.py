# NOTE: needs to be converted to common code approach

import os
import os
import pandas as pd

# Locate the relative path to the data location
data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "..", "data")

# Load the death record data
death_records = pd.read_csv(
    os.path.join(data_path, "SyntheticDeathRecordData.csv"),
    keep_default_na=False,
    na_values=[""],
)

# Define the funeral director columns
funeral_director_columns = [
    "Funeral Facility"
]  # add or remove columns as needed

# Create a new column that is True when at least one funeral director field is empty or unknown
death_records["Incomplete Funeral Director Fields"] = death_records[funeral_director_columns].apply(
    lambda row: row.str.contains("Unknown").any() or row.isna().any(), axis=1
)

# Calculate the proportion of records with incomplete funeral director fields
proportion = death_records["Incomplete Funeral Director Fields"].mean()

print(
    f"The proportion of records with at least one funeral director field incomplete is {proportion:.2f}"
)
