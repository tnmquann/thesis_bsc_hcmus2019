import pandas as pd

# Define the file paths
file_paths = [
    r'\metadata\7_bracken\bracken_score_0_03.txt',
    r'\metadata\7_bracken\bracken_score_0_04.txt',
    r'\metadata\7_bracken\bracken_score_0_05.txt'
]

# Read each file into a DataFrame and store them in a list
dfs = [pd.read_csv(file_path, sep='\t') for file_path in file_paths]

# Concatenate all DataFrames
combined_df = pd.concat(dfs)

# Write the combined DataFrame to a new file
combined_df.to_csv(r'\metadata\7_bracken\report_bracken.txt', sep='\t', index=False, float_format='%.15g')