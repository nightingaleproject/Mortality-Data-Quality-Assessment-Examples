import pandas as pd

# Load the death records data
death_records = pd.read_csv(
    "NotionalDeathRecordData.csv", keep_default_na=False, na_values=[""]
)

# Load the unsuitable causes of death data
unsuitable_causes = pd.read_csv("unsuitable_COD_codes.csv")

# Extract the unsuitable codes
unsuitable_codes = unsuitable_causes["code"].values

# Determine the number of records with an unsuitable underlying cause of death
unsuitable_cod_records = death_records[
    death_records["Underlying COD"].isin(unsuitable_codes)
]

# Calculate the proportion of records with an unsuitable underlying cause of death
proportion = len(unsuitable_cod_records) / len(death_records)

print(
    f"The proportion of records with an unsuitable underlying cause of death is {proportion:.2f}"
)
