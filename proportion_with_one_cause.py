import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv('NotionalDeathRecordData.csv')

# Create a new column that is True when Record Axis COD 1 is present and Record Axis COD 2-10 are not
df['COD1 Only'] = df['Record Axis COD 1'].notna() & df[[f'Record Axis COD {i}' for i in range(2, 11)]].isna().all(axis=1)

# Calculate the proportion of records with only Record Axis COD 1
proportion = df['COD1 Only'].mean()

print(f'The proportion of records with an entry in the Record Axis COD 1 column but not in the Record Axis COD 2-10 columns is {proportion:.2f}')
