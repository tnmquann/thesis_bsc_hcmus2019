import os
import pandas as pd

input_folder = "/benchmarking/PRJNA747117/10_yacht/output"
output_folder = "/benchmarking/PRJNA747117/10_yacht/output/separated"

if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# List of sheets to be extracted
sheets_list = ["min_coverage0.5", "min_coverage0.1", "min_coverage0.05"]

# Loop through each file in the input directory
for file_name in os.listdir(input_folder):
    if file_name.endswith('.xlsx') and file_name.startswith('trimmed'):
        # Extract ID from the file name
        id = file_name.split('-')[1].split('_')[0]

        # Full path to the Excel file
        file_path = os.path.join(input_folder, file_name)

        # Loop through each sheet to be extracted
        for sheet in sheets_list:
            df = pd.read_excel(file_path, sheet_name=sheet)

            # Create the name of the output and save to csv file
            csv_file_name = f"{id}_{sheet}_yacht.csv"
            csv_file_path = os.path.join(output_folder, csv_file_name)

            df.to_csv(csv_file_path, index=False)