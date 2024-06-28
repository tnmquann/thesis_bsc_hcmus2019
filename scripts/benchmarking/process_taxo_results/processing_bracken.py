import os
import re
import pandas as pd

# Specify the input directory path \metadata\7_bracken\score_0_05
input_dir = r'\metadata\7_bracken\score_0_05'
# Specify the output directory path (create if it doesn't exist)
output_dir = r'\metadata\7_bracken\score_0_05\processed_files'
confidence_score = 0.05
os.makedirs(output_dir, exist_ok=True)

# Loop through all files in the input directory
for filename in os.listdir(input_dir):
    if filename.endswith('_bracken.txt'):
        input_file = os.path.join(input_dir, filename)

        # Extract the sample ID from the file name using regex
        sample_id = re.search(r'trimmed-(\w+)_bracken.txt', filename).group(1)

        # Construct the output file path
        output_file = os.path.join(output_dir, f'done_trimmed-{sample_id}_bracken.txt')

        # Read the input file
        with open(input_file, 'r') as file:
            lines = file.readlines()

        # Add the new columns to the header row
        header = lines[0].strip().split('\t')
        header.extend(['Sample_ID', 'confidence_score_kraken2'])
        lines[0] = '\t'.join(header) + '\n'

        # Add the sample ID and **confidence score** to each row
        for i in range(1, len(lines)):
            row = lines[i].strip().split('\t')
            row.extend([sample_id, confidence_score])
            lines[i] = '\t'.join(row) + '\n'

        # Write the modified data to the output file
        with open(output_file, 'w') as file:
            file.writelines(lines)

        print(f"Output file '{output_file}' has been created with the new 'Sample_ID' and 'confidence_score_kraken2' columns.")

# Get a list of all processed files
processed_files = [f for f in os.listdir(output_dir) if os.path.isfile(os.path.join(output_dir, f))]

# Read each file into a pandas DataFrame and store all DataFrames in a list
dfs = [pd.read_csv(os.path.join(output_dir, f), sep='\t') for f in processed_files]

# Concatenate all dataframes along the row axis
combined_df = pd.concat(dfs, axis=0)
pd.options.display.float_format = '{:.0f}'.format
# Write the combined dataframe to a new file
combined_df.to_csv(os.path.join(r'\metadata\7_bracken', 'bracken_score_0_05.txt'), sep='\t', index=False, float_format='%.15g')

# Combine all file (bracken_score_0_05.txt, bracken_score_0_05.txt, bracken_score_0_05.txt) in \metadata\7_bracken, these file is in table format (separated column as tab), save the new file as report_kraken2.txt