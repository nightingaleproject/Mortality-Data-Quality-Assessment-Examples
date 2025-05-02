import dqaf_metrics

# Define metric
def metric(records):
    # Find all the Record Axis COD columns
    # Jurisdictions: update the column name prefix from "Record Axis COD" to match your data
    record_axis_cod_columns = [col for col in records.columns if col.startswith("Record Axis COD")]
    # Return a column that is True when a single Record Axis COD column is populated
    return records[record_axis_cod_columns].notna().sum(axis=1) == 1

description = "The proportion of records with a single Record Axis COD"

# Use metric to calculate overall proportion 
proportion = dqaf_metrics.proportion(metric)
print(f"{description} is {proportion:.2f}")

# Use metric to calculate proportion for each certifier
proportion_by_certifier = dqaf_metrics.proportion_by_column(metric, "Certifier Name")
# TODO: Update to use tabular output
for certifier, proportion in proportion_by_certifier:
    print(f"{description} provided by {certifier} is {proportion:.2f}")
