import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv("NotionalDeathRecordData.csv")

# Define the demographic columns
demographic_columns = [
    "Sex",
    "Race",
    "Age",
    "Hispanic origin",
]  # add or remove columns as needed

# Create a new column that is True where at least one demographic field is null
df["Incomplete Demographics"] = df[demographic_columns].isna().any(axis=1)

# Calculate the proportion of records with incomplete demographic fields
proportion = df["Incomplete Demographics"].mean()

print(
    f"The proportion of records with at least one demographic field incomplete is {proportion:.2f}"
)
