import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
from sklearn.preprocessing import LabelEncoder

# Load data
reference = pd.read_csv('reference_tourlousse.csv')
results = pd.read_csv('wgs_benchmarking.csv')

def remove_deps(df):
    df = df.drop_duplicates(subset=['tools', 'data_type', 'genus'])
    df = df.drop(columns=['relative_abundance', 'sample_id', 'bacteria_finalname', 'bacteria'])
    df.to_csv('results_removeduplicate_overall_genus.csv', index=False)
    return df

results = remove_deps(results)

# Separate data based on data_type
reference_cell = reference[reference['data_type'] == 'Cell mock']
reference_dna = reference[reference['data_type'] == 'DNA mock']
results_cell = results[results['data_type'] == 'Cell mock']
results_dna = results[results['data_type'] == 'DNA mock']
results_mixed = results[results['data_type'] == 'Mixed samples']
reference_mixed = reference[reference['data_type'] == 'Mixed samples']

# Count unique bacteria_finalname for each data_type in reference
reference_cell_count = reference_cell['genus'].nunique()
reference_dna_count = reference_dna['genus'].nunique()
reference_mixed_count = reference_mixed['genus'].nunique()

def classification_overall(df, reference_df, reference_count):
    df_grouped = df.groupby(['tools', 'data_type', 'tools_detail'])
    classification_results = []
    for name, group in df_grouped:
        TP = group['genus'].isin(reference_df['genus']).sum()
        FP = len(group) - TP
        FN = reference_count - TP
        TN = 0
        Accuracy = (TP + TN) / (TP + TN + FP + FN)
        Precision = TP / (TP + FP) if TP + FP != 0 else np.nan
        Recall = TP / (TP + FN) if TP + FN != 0 else np.nan
        F1 = 2 * (Precision * Recall) / (Precision + Recall) if Precision + Recall != 0 else np.nan
        F0_5 = (1+0.5**2) * (Precision * Recall) / (0.5**2 * Precision + Recall) if Precision + Recall != 0 else np.nan
        Specificity = TN / (TN + FP) if TN + FP != 0 else np.nan
        PPV = TP / (TP + FP) if TP + FP != 0 else np.nan
        NPV = TN / (TN + FN) if TN + FN != 0 else np.nan
        FDR = FP / (FP + TP) if FP + TP != 0 else np.nan
        TPR = TP / (TP + FN) if TP + FN != 0 else np.nan
        FPR = FP / (FP + TN) if FP + TN != 0 else np.nan
        classification_results.append(list(name) + [TP, FP, FN, TN, Accuracy, Precision, Recall, F1, F0_5, Specificity, PPV, NPV, FDR, TPR, FPR])
    return pd.DataFrame(classification_results, columns=['tools', 'data_type', 'tools_detail', 'TP', 'FP', 'FN', 'TN', 'Accuracy', 'Precision (Purity)', 'Recall (Completeness)', 'F1', 'F0.5', 'Specificity', 'PPV', 'NPV', 'FDR', 'TPR', 'FPR'])

classification_results_cell = classification_overall(results_cell, reference_cell, reference_cell_count)
classification_results_dna = classification_overall(results_dna, reference_dna, reference_dna_count)
classification_results_mixed = classification_overall(results_mixed, reference_mixed, reference_mixed_count)

# Concatenate the results
classification_results = pd.concat([classification_results_cell, classification_results_dna, classification_results_mixed])

# Save the results
classification_results.to_csv('classification_results_overall_genus.csv', index=False)
classification_results.to_excel('classification_results_overall_genus.xlsx', index=False)