import pandas as pd

# Load the CSV file into a DataFrame
death_records = pd.read_csv(
    "../data/NotionalDeathRecordData.csv", keep_default_na=False, na_values=[""]
)

# Define the demographic columns
demographic_columns = [
    "Sex",
    "Race",
    "Age",
    "Hispanic origin",
]  # add or remove columns as needed

# Create a new column that is True when at least one demographic field is empty
death_records["Incomplete Demographics"] = (
    death_records[demographic_columns].isna().any(axis=1)
)

# Calculate the proportion of records with incomplete demographic fields
proportion = death_records["Incomplete Demographics"].mean()

print(
    f"The proportion of records with at least one demographic field incomplete is {proportion:.2f}"
)
