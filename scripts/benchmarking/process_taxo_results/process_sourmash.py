import os
import re
import pandas as pd

# Specify the input directory path
input_dir = '/benchmarking/PRJNA747117/8_sourmash/separated/text_files/merged'
# Specify the output directory path (create if it doesn't exist)
output_dir = '/benchmarking/PRJNA747117/8_sourmash/separated/text_files/merged'
os.makedirs(output_dir, exist_ok=True)

# Add the sample ID and relative_abundance to each row. The relative_abundance value is calculated by the following function:
def calculate_relative_abundance(row):
    relative_abundance = ((row['unique_intersect_bp']/row['scaled']) * row['median_abund'])/row['total_weighted_hashes']
    return relative_abundance

# Loop through all files in the input directory
for filename in os.listdir(input_dir):
    if filename.endswith('_x_gtdb.csv'):
        input_file = os.path.join(input_dir, filename)

        # Extract the sample ID from the file name using regex
        sample_id = re.search(r'(\w+)_x_gtdb.csv', filename).group(1)

        # Construct the output file path
        output_file = os.path.join(output_dir, f'done_{sample_id}_x_gtdb.csv')

        # Read the input file
        df = pd.read_csv(input_file)

        # Add the sample ID and relative_abundance to each row
        df['WGS_ID'] = sample_id
        df['relative_abundance'] = df.apply(calculate_relative_abundance, axis=1)

        # Calculate the relative_abundance for the new 'unclassified' row
        unclassified_relative_abundance = 1 - df['relative_abundance'].sum()

        # Create a new DataFrame for the 'unclassified' row
        unclassified_df = pd.DataFrame({
            'name': ['unclassified'],
            'WGS_ID': [sample_id],
            'relative_abundance': [unclassified_relative_abundance]
        })

        # Append the 'unclassified' row to the original DataFrame
        df = df._append(unclassified_df, ignore_index=True)

        # Write the modified data to the output file
        df.to_csv(output_file, index=False)

        print(f"Output file '{output_file}' has been created with the new 'Sample_ID' and 'relative_abundance' columns.")

# Get a list of all processed files
processed_files = [f for f in os.listdir(output_dir) if os.path.isfile(os.path.join(output_dir, f))]

# Read each file into a pandas DataFrame and store all DataFrames in a list
dfs = [pd.read_csv(os.path.join(output_dir, f), sep=',') for f in processed_files]

# Concatenate all dataframes along the row axis
combined_df = pd.concat(dfs, axis=0)
pd.options.display.float_format = '{:.0f}'.format
# Write the combined dataframe to a new file
combined_df.to_csv(os.path.join(output_dir, 'sourmash_benchmarking_mergedtourlousse.csv'), sep=',', index=False, float_format='%.15g')