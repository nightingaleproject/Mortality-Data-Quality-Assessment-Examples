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

# Load the unsuitable causes of death data
unsuitable_causes = pd.read_csv(os.path.join(data_path, "unsuitable_COD_codes.csv"))

# Extract the unsuitable codes
unsuitable_codes = unsuitable_causes["code"].values


# Function to check if any unsuitable code is a prefix to the code in the record
def is_unsuitable(code):
    return any(code.startswith(unsuitable) for unsuitable in unsuitable_codes)


# Create a new column that is True when the underlying COD is unsuitable
death_records["Unsuitable Underlying"] = death_records["Underlying COD"].apply(
    is_unsuitable
)

# Calculate the proportion of records with an unsuitable underlying cause of death
proportion = death_records["Unsuitable Underlying"].mean()

print(
    f"The proportion of records with an unsuitable underlying cause of death is {proportion:.2f}"
)

# Group the records by certifier and calculate the proportion of unsuitable records for each certifier
certifier_proportions = death_records.groupby("Certifier Name")[
    "Unsuitable Underlying"
].mean()

# Print the proportions for each certifier
for certifier, proportion in certifier_proportions.items():
    print(
        f"The proportion of records with an unsuitable underlying cause of death provided by {certifier} is {proportion:.2f}"
    )
