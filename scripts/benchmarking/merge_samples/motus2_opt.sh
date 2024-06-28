#!/bin/bash

# Cannot use this code for FORWARD_SEQ and REVERSE_SEQ -> Create list without directory
TIME_REPORT_MOTUS="/benchmarking/PRJNA747117/4_motus2"
TIME_LOG_MOTUS="/benchmarking/PRJNA747117/4_motus2/time_motus2_mergedsamples.txt"
TRIMMED_FASTQ="/benchmarking/PRJNA747117/1_fastq_trimmed/merged_seq"
# FORWARD_SEQ="/benchmarking/PRJNA747117/1_fastq_trimmed/*_1.fastq.gz"
# REVERSE_SEQ="/benchmarking/PRJNA747117/1_fastq_trimmed/*_2.fastq.gz"

# Create output directory if it doesn't exist
mkdir -p "$TIME_REPORT_MOTUS"
mkdir -p "$TIME_REPORT_MOTUS"/count
mkdir -p "$TIME_REPORT_MOTUS"/report

#-----------------------------------------------------
# # Create list of forward sequences
# # Define the directory path
# DIRECTORY='/benchmarking/PRJNA747117/1_fastq_trimmed/'

# # Initialize empty strings to store filenames
# FORWARD_SEQ_MOTUS=""
# REVERSE_SEQ_MOTUS=""

# # Iterate over each file in the directory for forward sequences
# for forward_file in $DIRECTORY*_1.fastq.gz; do
#     # Append the basename of each forward file to FORWARD_SEQ
#     FORWARD_SEQ_MOTUS+="$(basename "$forward_file"),"
# done

# # Iterate over each file in the directory for reverse sequences
# for reverse_file in $DIRECTORY*_2.fastq.gz; do
#     # Append the basename of each reverse file to REVERSE_SEQ
#     REVERSE_SEQ_MOTUS+="$(basename "$reverse_file"),"
# done

# # Remove the trailing commas from FORWARD_SEQ and REVERSE_SEQ
# FORWARD_SEQ_MOTUS=${FORWARD_SEQ_MOTUS%,}
# REVERSE_SEQ_MOTUS=${REVERSE_SEQ_MOTUS%,}
#-----------------------------------------------------

# Define the output file for time details
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" >> "$TIME_LOG_MOTUS"
# Run the scripts and capture time details using GNU time
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
motus profile -s /benchmarking/PRJNA747117/1_fastq_trimmed/merged_seq/tourlousse2022_merged.fastq.gz -t 20 -o /benchmarking/PRJNA747117/4_motus2/report/"$filename".report.txt
') 2>> "$TIME_LOG_MOTUS"