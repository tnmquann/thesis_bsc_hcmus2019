import os
import re
import pandas as pd

# Define the directory path
dir_path = '/metaphlan3/output'
output_path = '/metaphlan3/output/processed_files'
os.makedirs(output_path, exist_ok=True)
# Loop through all files in the directory
for filename in os.listdir(dir_path):
    # Check if the file is a .txt file
    if filename.endswith('.txt'):
        # Construct the full file path
        file_path = os.path.join(dir_path, filename)
        
        # Read the file into a pandas DataFrame, skipping the first 3 lines
        data = pd.read_csv(file_path, sep='\t', skiprows=3)
        
        # Extract the sample ID from the filename and add it as a new column
        sample_id = re.search(r'profiled_metagenome_(\w+).txt', filename).group(1)
        data['sample_ID'] = sample_id
        
        # Process the '#clade_name' column
        data['#clade_name'] = data['#clade_name'].str.extract(r'\|s__(.*)')
        data = data.dropna(subset=['#clade_name'])
        data['#clade_name'] = data['#clade_name'].str.replace('_', ' ')
        
        # Save the processed DataFrame to a new file
        output_file_path = os.path.join(output_path, f'processed_{filename}.txt')
        data.to_csv(output_file_path, sep='\t', index=False)
# Get a list of all processed files
processed_files = [f for f in os.listdir(output_path) if os.path.isfile(os.path.join(output_path, f))]

# Read each file into a pandas DataFrame and store all DataFrames in a list
dfs = [pd.read_csv(os.path.join(output_path, f), sep='\t') for f in processed_files]

# Concatenate all dataframes along the row axis
combined_df = pd.concat(dfs, axis=0)
pd.options.display.float_format = '{:.0f}'.format
# Write the combined dataframe to a new file
combined_df.to_csv(os.path.join(r'/metaphlan3/output', 'report_metaphlan3_separated_123s.txt'), sep='\t', index=False, float_format='%.15g')