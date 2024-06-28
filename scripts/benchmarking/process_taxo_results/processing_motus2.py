import pandas as pd
import os
import re

# Directory where the files are located
directory = '//4_mOTUs2//mOTUs2//'
assignedID_directory = '//4_mOTUs2//mOTUs2//assignedID//'
cleaned_directory = '//4_mOTUs2//mOTUs2//cleaned//'
report_directory = '//4_mOTUs2//'

os.makedirs(cleaned_directory, exist_ok=True)
os.makedirs(assignedID_directory, exist_ok=True)

# Regex pattern to extract sample ID from file name
pattern = r'trimmed-(\w+)_motus.report.txt'

# Iterate over all files in the directory
for filename in os.listdir(directory):
    if filename.endswith("_motus.report.txt"):
        sample_id = re.search(pattern, filename).group(1)
        df = pd.read_csv(directory + filename, sep=';')
        df['Sample_ID'] = sample_id
        df.rename(columns={sample_id : 'relative_abundance'}, inplace=True)
        df.to_csv(assignedID_directory + 'trimmed-' + sample_id + '_motus.assignedID.txt', sep='\t', index=False, float_format='%.15g')
        df = df[df['relative_abundance'] != 0]
        # Remove rows where consensus_taxonomy does not contain '|s__'
        df = df[df['consensus_taxonomy'].str.contains('|s__')]
        # Remove everything before '|s__' in consensus_taxonomy and replace '_' with ' '
        df['consensus_taxonomy'] = df['consensus_taxonomy'].apply(lambda x: x.split('|s__')[-1].replace('_', ' '))
        # Save the cleaned DataFrame
        df.to_csv(cleaned_directory + 'cleaned_trimmed-' + sample_id + '_motus.assignedID.txt', sep='\t', index=False, float_format='%.15g')

# Initialize an empty DataFrame to store all the data
# combined_df = pd.DataFrame()

# Combine all files in the cleaned_directory into a single DataFrame
combined_df = pd.concat([pd.read_csv(cleaned_directory + filename, sep='\t') for filename in os.listdir(cleaned_directory) if filename.endswith(".txt")])

# Save the combined DataFrame to a file in the main directory
combined_df.to_csv(report_directory + 'report_mOTUs2.txt', sep='\t', index=False)
