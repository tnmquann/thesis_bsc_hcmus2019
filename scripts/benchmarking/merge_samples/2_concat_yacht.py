import os
import pandas as pd

# Folder paths
input_folder = '/add/input/folder/path'
output_folder = '/add/output/folder/path'

# Read the yacht_results.csv file
yacht_results = pd.read_csv(os.path.join(input_folder, 'yacht_results_mergedtourlousse.csv'))

# Extract the required columns
required_cols = ['organism_name', 'p_vals', 'actual_confidence_with_coverage', 'alt_confidence_mut_rate_with_coverage', 'file_name', 'WGS_ID']
yacht_merged = yacht_results[required_cols]

# Convert the required columns to string
for col in required_cols:
    yacht_merged.loc[:, col] = yacht_merged.loc[:, col].astype(str)

# Merge the records based on organism_name and WGS_ID
yacht_merged = yacht_merged.groupby(['organism_name', 'WGS_ID']).agg(' | '.join).reset_index()

# Save the merged result as yacht_merged.csv
yacht_merged.to_csv(os.path.join(output_folder, 'yacht_merged_mergedtourlousse.csv'), index=False)
print("Saved yacht_merged.csv")