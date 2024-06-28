import os
import pandas as pd

# Directory where your xlsx files are stored
input_folder = "/benchmarking/PRJNA747117/10_yacht/output/merged"

# Directory for saving csv files
output_folder = "/benchmarking/PRJNA747117/10_yacht/output/csv/merged"

# If output directory doesn't exist, create it
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# List of sheets to be extracted
sheets_list = ["min_coverage0.5", "min_coverage0.1", "min_coverage0.05", "min_coverage0.01"]

# Loop through each file in the input directory
for file_name in os.listdir(input_folder):
    if file_name.endswith('.xlsx'):
        # Extract ID from the file name
        id = file_name.split('_')[0]

        # Full path to the Excel file
        file_path = os.path.join(input_folder, file_name)

        # Loop through each sheet to be extracted
        for sheet in sheets_list:
            # Use pandas to read the sheet from the Excel file
            df = pd.read_excel(file_path, sheet_name=sheet)

            # Create the name of the output csv file
            csv_file_name = f"{id}_{sheet}_yacht.csv"
            csv_file_path = os.path.join(output_folder, csv_file_name)

            # Save the dataframe to a csv file
            df.to_csv(csv_file_path, index=False)