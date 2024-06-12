import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('NotionalDeathRecordData.csv')

# Parse the dates
df['Date of Death'] = pd.to_datetime(df['Date of Death'])
df['Date Certified'] = pd.to_datetime(df['Date Certified'])

# Calculate the difference in days between the Date Certified and the Date of Death
df['Days Difference'] = (df['Date Certified'] - df['Date of Death']).dt.days

# Create a column that is True when the time between death and certification is not within 5 days
df['Not Within 5 Days'] = ~df['Days Difference'].between(0, 5)

# Calculate the proportion of records where the Date Certified is not within 5 days of the Date of Death
proportion = df['Not Within 5 Days'].mean()

print(f'The proportion of records where the Date Certified is not within 5 days of the Date of Death is {proportion:.2f}')
