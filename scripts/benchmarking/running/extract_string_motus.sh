# Create list of forward sequences
# Define the directory path
DIRECTORY=' /benchmarking/PRJNA747117/4_motus2/report'

# Use find command to get the list of report files and join them with commas
REPORT_MOTUS=$(find "$DIRECTORY" -name "*.report.txt" -exec basename {} \; | paste -sd "," -)

# Change directory to the report directory
cd "$DIRECTORY"

# Merge the report files using motus
motus merge -i "$REPORT_MOTUS" > full_report.txt