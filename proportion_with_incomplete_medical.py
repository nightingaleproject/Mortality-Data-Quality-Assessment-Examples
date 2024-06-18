import pandas as pd

# Load the CSV file into a DataFrame
death_records = pd.read_csv(
    "NotionalDeathRecordData.csv", keep_default_na=False, na_values=[""]
)

# Define the medical columns
medical_columns = ["Pregnancy", "Tobacco"]  # add or remove columns as needed

# Create a new column that is True when at least one medical field is empty
death_records["Incomplete Medical Fields"] = (
    death_records[medical_columns].isna().any(axis=1)
)

# Calculate the proportion of records with incomplete medical fields
proportion = death_records["Incomplete Medical Fields"].mean()

print(
    f"The proportion of records with at least one medical field incomplete is {proportion:.2f}"
)
