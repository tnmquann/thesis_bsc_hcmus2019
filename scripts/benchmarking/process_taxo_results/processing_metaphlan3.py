import os
import re
import pandas as pd

# Step 1: Remove first 3 lines, then recognize as table and columns is separated by tab.
data = pd.read_csv('/5_metaphlan3/profiled_metagenome_20240314.txt', sep='\t', skiprows=3)

# Step 2: Export the result as processed_metaphlan.txt.
data.to_csv('/5_metaphlan3/processed_metaphlan.txt', sep='\t', index=False)

# Step 3: Delete all record which do not have this term "|s__" in the value, then remove all the context before this term. For example: k__Bacteria|p__Verrucomicrobia|c__Verrucomicrobiae|o__Verrucomicrobiales|f__Akkermansiaceae|g__Akkermansia|s__Akkermansia_muciniphila will be replace as Akkermansia_muciniphila
data['#clade_name'] = data['#clade_name'].str.extract(r'\|s__(.*)')
data = data.dropna(subset=['#clade_name'])

# Step 4: Replace "_" as space " ".
data['#clade_name'] = data['#clade_name'].str.replace('_', ' ')

# Step 5: Save the result as report_metaphlan3.txt
data.to_csv('/5_metaphlan3/report_metaphlan3.txt', sep='\t', index=False)