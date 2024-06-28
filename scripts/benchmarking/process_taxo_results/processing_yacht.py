import os
import pandas as pd
import shutil

# Folder paths
input_folder = '/benchmarking/PRJNA747117/10_yacht/output'
output_folder = '/benchmarking/PRJNA747117/10_yacht/output/csv'
temp_folder = '/benchmarking/PRJNA747117/10_yacht/output/temp'

# Create output folders if they don't exist
os.makedirs(output_folder, exist_ok=True)
os.makedirs(temp_folder, exist_ok=True)

# Extract sheets and save as CSV
for filename in os.listdir(input_folder):
    if filename.endswith('.xlsx') and filename.startswith('trimmed-'):
        xlsx_file = os.path.join(input_folder, filename)
        id = filename.split('-')[1].split('_')[0]
        
        # Read the Excel file and extract the required sheets
        excel_data = pd.read_excel(xlsx_file, sheet_name=['min_coverage0.5', 'min_coverage0.1', 'min_coverage0.05'])
        
        # Save each sheet as a CSV file
        for sheet_name, df in excel_data.items():
            csv_filename = f"{id}_{sheet_name}_yacht.csv"
            csv_path = os.path.join(output_folder, csv_filename)
            df.to_csv(csv_path, index=False)
            print(f"Saved {csv_filename}")

# Add new columns to the CSV files
for csv_file in os.listdir(output_folder):
    if csv_file.endswith('.csv'):
        csv_path = os.path.join(output_folder, csv_file)
        df = pd.read_csv(csv_path)
        
        # Extract 'file_name' and 'WGS_ID' from the file name
        file_name_parts = csv_file.split('_')[1:-1]
        file_name = "_".join(file_name_parts)
        wgs_id = csv_file.split('_')[0]
        
        # Add the new columns
        df['file_name'] = file_name
        df['WGS_ID'] = wgs_id
        
        # Save the updated DataFrame to a new CSV file in the temp folder
        new_csv_path = os.path.join(temp_folder, csv_file)
        df.to_csv(new_csv_path, index=False)
        print(f"Saved {new_csv_path}")

# Read all CSV files in the temp folder, filter out empty or all-NA ones, and concatenate the rest
csv_files = [pd.read_csv(os.path.join(temp_folder, f)) for f in os.listdir(temp_folder)]
csv_files = [df for df in csv_files if not df.empty and not df.isna().all().all()]
merged_df = pd.concat(csv_files, ignore_index=True)

# Save the result
merged_df.to_csv('/benchmarking/PRJNA747117/10_yacht/yacht_results.csv', index=False, float_format='%.15g')
merged_df.to_excel('/benchmarking/PRJNA747117/10_yacht/yacht_results.xlsx', index=False)

# Merge all the CSV files in the temp folder and save the result
merged_df = pd.concat([pd.read_csv(os.path.join(temp_folder, f)) for f in os.listdir(temp_folder)], ignore_index=True)
merged_df.to_csv('/benchmarking/PRJNA747117/10_yacht/yacht_results.csv', index=False, float_format='%.15g')
merged_df.to_excel('/benchmarking/PRJNA747117/10_yacht/yacht_results.xlsx', index=False, float_format='%.15g')
print("Saved yacht_results.csv and yacht_results.xlsx")

# Remove the temp folder
shutil.rmtree(temp_folder)
print(f"Removed {temp_folder}")