import os
import re
import pandas as pd

# Locate the relative path to the data location
data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "..", "data")

# Load the death record data
death_records = pd.read_csv(
    os.path.join(data_path, "SyntheticDeathRecordData.csv"),
    dtype=str, # Read as strings to more easily evaluate whether data is present
    keep_default_na=False,
    na_values=[""],
)

# List of fields we want to check for individually
demographic_fields = [
    "Age",
    "County of Death",
    "Date of Death",
    "Education",
    "Hispanic .*", # Regular expression to match any field starting with 'Hispanic'
    "Manner of Death",
    "Place of Death",
    "Pregnancy Status",
    "Race .*", # Regular expression to match any field starting with 'Race'
    "Tobacco Use Contributed to Death"
]

# For each field we first check if the field is present in the data;
# if it's present, we evaluate the proportion of records that have a
# blank value for the field and the proportion of records that have
# an explicit "Unknown" value for the field
for field in demographic_fields:

    print(f"Evaluating fields matching '{field}'")

    # Find the columns that match this field (may be more than one if it's a regex)
    matching_columns = [col for col in death_records.columns if re.search(f"^{field}$", str(col))]

    # Check if the field was found in the data
    if len(matching_columns) < 1:
        print(f"  No columns matching '{field}' exist in the data\n")
        continue

    # TODO: We need to special case pregnancy status; do it with a lambda in the fields list?
    # TODO: Pregnancy has "No response", is that equivalent to unknown?
    # TODO: Explore configuration file for e.g., what is "unknown", threshold for flagging certifiers, etc. (multiple tests could use common code)
    # TODO: May need to consider "Not applicable" as well
    # TODO: Pregnancy has "Unknown if pregnant within the past year", should we look for any match to an "Unknown" regex?
    # TODO: Perhaps allow jurisdiction to configure which values mean "missing" and which "unknown"?
    # TODO: Maybe field list lambda includes the check to use?

    # The field is present, so now find the proportion that are blank
    death_records[f"Blank {field}"] = death_records[matching_columns].apply(
        lambda row: row.isna().any(), axis=1
    )
    proportion = death_records[f"Blank {field}"].mean()
    print(f"  The proportion of records with blank values for '{field}': {proportion:.3f}")

    # Now find the proportion that are "unknown"
    death_records[f"Unknown {field}"] = death_records[matching_columns].apply(
        lambda row: row.str.contains("U").any() or row.str.contains("Unknown").any(), axis=1
    )
    proportion = death_records[f"Unknown {field}"].mean()
    print(f"  The proportion of records with explicit 'unknown' values for '{field}': {proportion:.3f}\n")
