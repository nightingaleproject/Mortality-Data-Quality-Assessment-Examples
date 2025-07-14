import dqaf_metrics
import os

# Locate the relative path to the data location
data_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "..", "data")

# Load the death record data
death_records = dqaf_metrics.load_death_records(
  os.path.join(data_path, "SyntheticDeathRecordData.csv")
)

# Define metric
def metric(records):
    # Find all the Record Axis COD columns
    # Jurisdictions: update the column name prefix from "Record Axis COD" to match your data
    record_axis_cod_columns = [col for col in records.columns if col.startswith("Record Axis COD")]
    # Return a column that is True when a single Record Axis COD column is populated
    return records[record_axis_cod_columns].notna().sum(axis=1) == 1

# Use metric to calculate overall proportion 
proportion = dqaf_metrics.calculate_proportion(
  death_records, metric, "Single Record Axis COD", True
)

print("")

# Use metric to calculate proportion for each certifier
proportion_by_certifier = dqaf_metrics.proportion_by_column(
  death_records, metric, "Certifier Name", True
)
