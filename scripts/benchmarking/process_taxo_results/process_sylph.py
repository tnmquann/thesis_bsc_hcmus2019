import pandas as pd

# Read the TSV file into a DataFrame
df = pd.read_csv('results-R220_merged.tsv', delimiter='\t')

# Rename columns as specified
df.rename(columns={'Sample_file': 'sample_id', 'Taxonomic_abundance': 'relative_abundance', 'Contig_name': 'bacteria'}, inplace=True)

# Transform the `sample_id` column to extract the actual sample ID
df['sample_id'] = df['sample_id'].apply(lambda x: x.split('-')[1].split('_')[0])

# Divide the `relative_abundance` and 'Sequence_abundance' values by 100
df['relative_abundance'] = df['relative_abundance'].apply(lambda x: x / 100)
df['Sequence_abundance'] = df['Sequence_abundance'].apply(lambda x: x / 100)

# Drop unwanted columns
df.drop(columns=['Median_cov', 'Mean_cov_geq1', 'Containment_ind', 'kmers_reassigned', 'Genome_file'], inplace=True, errors='ignore')

# Add new columns with fixed values
df['tools'] = 'sylph-R220'
df['tools_detail'] = 'sylph'

# Write the DataFrame to a CSV file
df.to_csv('results-220_merged.csv', index=False)