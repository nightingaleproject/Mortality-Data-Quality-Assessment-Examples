import os
import pandas as pd

# Locate the relative path to the data location
data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "data")

# Load the death records data
death_records = pd.read_csv(
    os.path.join(data_path, "NotionalDeathRecordData.csv"),
    keep_default_na=False,
    na_values=[""],
)

# Create a new column that is True when Record Axis COD 1 is present and Record Axis COD 2-10 are not
death_records["COD1 Only"] = death_records["Record Axis COD 1"].notna() & death_records[
    [f"Record Axis COD {i}" for i in range(2, 11)]
].isna().all(axis=1)

# Calculate the proportion of records with only Record Axis COD 1
proportion = death_records["COD1 Only"].mean()

print(
    f"The proportion of records with an entry in the Record Axis COD 1 column but not in the Record Axis COD 2-10 columns is {proportion:.2f}"
)
