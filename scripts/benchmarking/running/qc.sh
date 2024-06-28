#!/bin/bash

# Create folder for qc_result in the directory /benchmarking/PRJNA747117/1_fastq_trimmed
mkdir -p /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result

# Create file for time details for fastqc and multiqc
touch /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_details_fastqc.txt
touch /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_details_multiqc.txt

# Define the output file for time details
time_details_fastqc="/benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_details_fastqc.txt"
time_details_multiqc="/benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_details_multiqc.txt"

# Header for the txt files
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "$time_details_fastqc"
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "$time_details_multiqc"

# Run FastQC for the quality control of the trimmed fastq files
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" fastqc /benchmarking/PRJNA747117/1_fastq_trimmed/*fastq.gz -o /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result -t 10) 2>> "$time_details_fastqc"

# Run MultiQC for the quality control results of FastQC
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" multiqc /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result --interactive -o /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result) 2>> "$time_details_multiqc"
# Note:  Use -f or --force to overwrite existing reports instead

# Optional: remove redundant results
grep -vE 'Started analysis of|Approx [0-9]+% complete for' /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_details_fastqc.txt > /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_fastqc.txt
grep -vE 'Started analysis of|Approx [0-9]+% complete for' /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_details_multiqc.txt > /benchmarking/PRJNA747117/1_fastq_trimmed/qc_result/time_multiqc.txt