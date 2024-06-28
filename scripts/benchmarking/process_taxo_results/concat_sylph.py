import pandas as pd
import glob

# Step 1: List all CSV files in the directory
csv_files = glob.glob('*.csv')

# Step 2: Read each CSV file into a DataFrame
dfs = [pd.read_csv(file) for file in csv_files]

# Step 3: Concatenate all DataFrames into a single DataFrame
concatenated_df = pd.concat(dfs, ignore_index=True)

# Step 4: Write the concatenated DataFrame to a new CSV file
concatenated_df.to_csv('sylph_results.csv', index=False)