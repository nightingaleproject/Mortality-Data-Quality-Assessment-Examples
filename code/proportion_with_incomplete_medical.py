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

# Define the medical columns
medical_columns = [
    "Tobacco Use Contributed to Death"
]  # add or remove columns as needed

# Create a column that's True when any medical field is empty; special
# case pregnancy status since it only applies to female decedents
death_records["Incomplete Medical Fields"] = (death_records["Sex"] == "F") & (
    death_records["Pregnancy Status"].isnull()
    | (death_records["Pregnancy Status"] == "Unknown")
) | death_records[medical_columns].apply(
    lambda row: row.str.contains("Unknown").any() or row.isna().any(), axis=1
)

# Calculate the proportion of records with incomplete medical fields
proportion = death_records["Incomplete Medical Fields"].mean()

print(
    f"The proportion of records with at least one medical field incomplete is {proportion:.2f}"
)
