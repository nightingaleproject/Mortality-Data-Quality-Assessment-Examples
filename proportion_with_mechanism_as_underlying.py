import pandas as pd

# Load the death records data
death_records = pd.read_csv(
    "NotionalDeathRecordData.csv", keep_default_na=False, na_values=[""]
)

# Load the mechanism causes of death data
mechanism_causes = pd.read_csv("mechanism_COD_codes.csv")

# Extract the mechanism codes
mechanism_codes = mechanism_causes["code"].values

# Select all 'Entity Axis COD' columns
entity_axis_cod_columns = [
    col for col in death_records.columns if col.startswith("Entity Axis COD")
]

# Determine the number of records with a mechanism as an underlying cause of death
mechanism_cod_records = death_records[
    death_records[entity_axis_cod_columns].isin(mechanism_codes).any(axis=1)
]

# Calculate the proportion of records with a mechanism as an underlying cause of death
proportion = len(mechanism_cod_records) / len(death_records)

print(
    f"The proportion of records with a mechanism as an underlying cause of death is {proportion:.2f}"
)
