#!/bin/bash

# Define directories and filenames
TIME_REPORT_KRAKEN2="add/kraken2/output/time"
TIME_LOG_KRAKEN2="/add/kraken2/output/log"
TRIMMED_FASTQ="/path/to/tourlousse/segs"
DB_KRAKEN2="/add/path/to/kraken2_RefSeqV205_100GB"
DB_KRAKEN2_RAM="/dev/shm/kraken2_RefSeqV205_100GB"
DB_BRACKEN="/database/k2_standard_20210517"

cd /benchmarking/PRJNA747117/6_kraken2

# Define score directories
SCORE_DIRS=("score_0_005" "score_0_015" "score_0_025" "score_0_035" "score_0_045" "score_0_055" "score_0_00" "score_0_01" "score_0_02" "score_0_03" "score_0_04" "score_0_05")

for score_dir in "${SCORE_DIRS[@]}"; do
    for i in "${TRIMMED_FASTQ}"/*.fastq.gz; do
        filename=$(basename "$i" .fastq.gz)
        bracken -d "${DB_BRACKEN}" -i "report/${score_dir}/${filename}_kraken2.kreport2" -r 150 -l S -t 1000 -o "/benchmarking/PRJNA747117/7_bracken/${score_dir}/${filename}_bracken.breport"
    done
done