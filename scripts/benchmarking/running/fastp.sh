#!/bin/bash

# Create the results and results/time folders if they don't exist
mkdir -p results/time
mkdir -p results/report

for f1 in PRJNA747117/*_1.fastq.gz
do
    # Extract the file name without extension
    base_name=$(basename $f1)

    # Use time to measure the execution time and save both stdout and stderr to a file named fastp.txt in the corresponding folder
    (time {
        # Generate the corresponding paired-end file name
        f2="PRJNA747117/${base_name%%_1.fastq.gz}_2.fastq.gz"

        # Run fastp and save trimmed output files in the results folder for the specific base_name
        fastp -i $f1 -I $f2 -o "results/trimmed-$base_name" -O "results/trimmed-${base_name%%_1.fastq.gz}_2.fastq.gz" -w 9 -j "results/report/fastp-${base_name%%.fastq.gz}.json" -h "results/report/fastp-${base_name%%.fastq.gz}.html" --trim_front1 5 --trim_front2 5 --trim_tail1 1 --trim_tail2 1 --unqualified_percent_limit 100 --trim_poly_x --poly_x_min_len 10 --n_base_limit 0 --low_complexity_filter --length_required 65
    }) 2>&1 | tee "results/time/fastp_${base_name%%.fastq.gz}.txt"
done