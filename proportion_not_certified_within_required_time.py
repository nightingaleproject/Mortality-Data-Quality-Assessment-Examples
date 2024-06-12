import pandas as pd

# Load the CSV file into a DataFrame
death_records = pd.read_csv(
    "NotionalDeathRecordData.csv", keep_default_na=False, na_values=[""]
)

# Parse the dates
death_records["Date of Death"] = pd.to_datetime(death_records["Date of Death"])
death_records["Date Certified"] = pd.to_datetime(death_records["Date Certified"])

# Calculate the difference in days between the Date Certified and the Date of Death
death_records["Days Difference"] = (
    death_records["Date Certified"] - death_records["Date of Death"]
).dt.days

# Create a column that is True when the time between death and certification is not within 5 days
death_records["Not Within 5 Days"] = ~death_records["Days Difference"].between(0, 5)

# Calculate the proportion of records where the Date Certified is not within 5 days of the Date of Death
proportion = death_records["Not Within 5 Days"].mean()

print(
    f"The proportion of records where the Date Certified is not within 5 days of the Date of Death is {proportion:.2f}"
)
