import pandas as pd

# Load the death records data
death_records = pd.read_csv(
    "NotionalDeathRecordData.csv", keep_default_na=False, na_values=[""]
)

# Find all 'Entity Axis Line' columns
entity_axis_line_cols = [
    col for col in death_records.columns if "Entity Axis Line" in col
]

# Records where the certifier provided "other conditions" in the
# literal cause of death information will refer to those in the entity
# axis codes as "line 6"; create a boolean mask for records that do
# not contain a 6 in any of the 'Entity Axis Line' columns
records_without_other_conditions = ~death_records[entity_axis_line_cols].apply(
    lambda x: x.isin([6]).any(), axis=1
)

# Calculate the proportion of records that do not refer to other conditions
proportion_no_other_conditions = records_without_other_conditions.sum() / len(
    death_records
)

print(
    f"The proportion of records that do not refer to other conditions in the entity axis codes is {proportion_no_other_conditions:.2f}"
)
