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

# Find all 'Entity Axis Line' columns
entity_axis_line_cols = [
    col for col in death_records.columns if col.startswith("Entity Axis Line")
]

# Records where the certifier provided "other conditions" in the
# literal cause of death information will refer to those in the entity
# axis codes as "line 6"; create a boolean mask for records that do
# not contain a 6 in any of the 'Entity Axis Line' columns
death_records["No Other Conditions"] = death_records[entity_axis_line_cols].apply(
    lambda row: (row != 6).all(), axis=1
)

# Calculate the proportion of records that do not refer to other conditions
proportion = death_records["No Other Conditions"].mean()

print(
    f"The proportion of records that do not refer to other conditions in the entity axis codes is {proportion:.2f}"
)
