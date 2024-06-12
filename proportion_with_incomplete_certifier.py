import pandas as pd

# Load the CSV file into a DataFrame
death_records = pd.read_csv(
    "NotionalDeathRecordData.csv", keep_default_na=False, na_values=[""]
)

# Define the certifier columns
certifier_columns = [
    "Date Certified",
    "Certifier Type",
]  # add or remove columns as needed

# Create a new column that is True where at least one certifier field is empty
death_records["Incomplete Certifier Fields"] = (
    death_records[certifier_columns].isna().any(axis=1)
)

# Calculate the proportion of records with incomplete certifier fields
proportion = death_records["Incomplete Certifier Fields"].mean()

print(
    f"The proportion of records with at least one certifier field incomplete is {proportion:.2f}"
)
