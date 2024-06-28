#!/bin/bash

# Define directories and filenames
TIME_REPORT_KRAKEN2="/benchmarking/PRJNA747117/6_kraken2"
TIME_LOG_KRAKEN2="/benchmarking/PRJNA747117/6_kraken2/log"
TRIMMED_FASTQ="/benchmarking/PRJNA747117/1_fastq_trimmed/merged_seq"
DB_KRAKEN2="/database/kraken2_RefSeqV205_100GB"
DB_KRAKEN2_RAM="/dev/shm/kraken2_RefSeqV205_100GB"
DB_BRACKEN="/database/k2_standard_20210517"

confidence_score=(0.025 0.035 0.045 0.055)
folder_report=("score_0_025" "score_0_035" "score_0_045" "score_0_055")

# Create output directory if it doesn't exist
mkdir -p "$TIME_REPORT_KRAKEN2"
mkdir -p "$TIME_REPORT_KRAKEN2"/map
mkdir -p "$TIME_REPORT_KRAKEN2"/report
mkdir -p "$TIME_REPORT_KRAKEN2"/unclassified
mkdir -p "$TIME_REPORT_KRAKEN2"/output
mkdir -p "$TIME_REPORT_KRAKEN2"/log
# Create subfolders in "$TIME_REPORT_KRAKEN2"/report base on folder_report
for folder in "${folder_report[@]}"; do
    mkdir -p "$TIME_REPORT_KRAKEN2"/report/"$folder"
done

for time_report in "${confidence_score[@]}"; do
    echo -e "User time (s)\tSystem time (s)\tWall time (h:mm:ss)\tMaximum set size (kb)\tCPU (%)" >> "${TIME_LOG_KRAKEN2}/KRAKEN2_${time_report}_time_mergedsamples.txt"
done

# Build kraken2 index
# kraken2-build --download-library bacteria --db kraken2_db
# kraken2-build --build --db kraken2_db
# kraken2-build --download-taxonomy --db $DB_KRAKEN2 --threads 20
# kraken2-build --standard --threads 20 --db $DB_KRAKEN2

# Use index folder at ./database/kraken2_RefSeqV205_100GB/
# Optimized range for confidence: 0..00 to 0.05 -> 0.05, 0.045, 0.04, 0.035, 0.03, 0.025, 0.02, 0.015, 0.01, 0.005, 0.0

cd /benchmarking/PRJNA747117/6_kraken2
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in "$1"/*.fastq.gz; do
    filename=$(basename "$i" .fastq.gz)
    kraken2 --confidence 0.055 --threads 20 --memory-mapping --db /dev/shm/kraken2_RefSeqV205_100GB/ \
    --report "report/score_0_055/${filename}_kraken2.kreport2" \
    "$1/$filename".fastq.gz
    # bracken -d "${DB_BRACKEN}" -i "report/score_0_055/${filename}_kraken2.kreport2" -r 150 -l S -t 1000 -o "report/score_0_055/${filename}_bracken.breport"
done
' _ "${TRIMMED_FASTQ}") 2>> "${TIME_LOG_KRAKEN2}/KRAKEN2_${confidence_score[5]}_time.txt"

# bracken-build -d "/database/kraken2_RefSeqV205_100GB" -t 30 -k 31 -l S

cd /benchmarking/PRJNA747117/6_kraken2
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in "$1"/*.fastq.gz; do
    filename=$(basename "$i" .fastq.gz)
    kraken2 --confidence 0.045 --threads 20 --memory-mapping --db /dev/shm/kraken2_RefSeqV205_100GB/ \
    --report "report/score_0_045/${filename}_kraken2.kreport2" \
    "$1/$filename".fastq.gz
    # bracken -d "${DB_BRACKEN}" -i "report/score_0_045/${filename}_kraken2.kreport2" -r 150 -l S -t 1000 -o "report/score_0_045/${filename}_bracken.breport"
done
' _ "${TRIMMED_FASTQ}") 2>> "${TIME_LOG_KRAKEN2}/KRAKEN2_${confidence_score[4]}_time.txt"

cd /benchmarking/PRJNA747117/6_kraken2
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in "$1"/*.fastq.gz; do
    filename=$(basename "$i" .fastq.gz)
    kraken2 --confidence 0.035 --threads 20 --memory-mapping --db /dev/shm/kraken2_RefSeqV205_100GB/ \
    --report "report/score_0_035/${filename}_kraken2.kreport2" \
    "$1/$filename".fastq.gz
    # bracken -d "${DB_BRACKEN}" -i "report/score_0_035/${filename}_kraken2.kreport2" -r 150 -l S -t 1000 -o "report/score_0_035/${filename}_bracken.breport"
done
' _ "${TRIMMED_FASTQ}") 2>> "${TIME_LOG_KRAKEN2}/KRAKEN2_${confidence_score[3]}_time.txt"

cd /benchmarking/PRJNA747117/6_kraken2
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in "$1"/*.fastq.gz; do
    filename=$(basename "$i" .fastq.gz)
    kraken2 --confidence 0.025 --threads 20 --memory-mapping --db /dev/shm/kraken2_RefSeqV205_100GB/ \
    --report "report/score_0_025/${filename}_kraken2.kreport2" \
    "$1/$filename".fastq.gz
    # bracken -d "${DB_BRACKEN}" -i "report/score_0_025/${filename}_kraken2.kreport2" -r 150 -l S -t 1000 -o "report/score_0_025/${filename}_bracken.breport"
done
' _ "${TRIMMED_FASTQ}") 2>> "${TIME_LOG_KRAKEN2}/KRAKEN2_${confidence_score[2]}_time.txt"

# -------------- OLD VERSION WITH MPA STYLE
# (/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
# for i in "$1"/*.fastq.gz; do
#     filename=$(basename "$i" _1.fastq.gz)
#     kraken2 --confidence 0.05 --memory-mapping --db /dev/shm/kraken2_RefSeqV205_100GB/ "$1/$filename".fastq.gz --report "${filename}_kraken2.txt" --output "${filename}.txt"  --threads 20 --use-mpa-style --unclassified-out "${filename}_unclassified_#.fq"
# done
# ' _ "$TRIMMED_FASTQ") 2>> "$TIME_LOG_KRAKEN2"