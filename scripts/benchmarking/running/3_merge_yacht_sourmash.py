import os
import pandas as pd

# Set the directory where the CSV files are stored
directory = '/add/output/folder/path'

# Load the CSV files
sourmash_csv = pd.read_csv(os.path.join(directory, 'sourmash_benchmarking_mergedtourlousse.csv'))
yacht_csv = pd.read_csv(os.path.join(directory, 'yacht_merged_mergedtourlousse.csv'))

# Rename the 'name' column in 'sourmash_benchmarking_processed.csv' to 'organism_name'
sourmash_csv = sourmash_csv.rename(columns={'name': 'organism_name'})

# Merge the dataframes based on 'organism_name' and 'WGS_ID'
merged = pd.merge(sourmash_csv, yacht_csv, on=['organism_name', 'WGS_ID'], how='outer')

# Save the merged dataframe to a new CSV file
merged.to_csv(os.path.join(directory, 'merged_sourmash_yacht_tourlousse.csv'), index=False)
merged.to_excel(os.path.join(directory, 'merged_sourmash_yacht_tourlousse.xlsx'), index=False)