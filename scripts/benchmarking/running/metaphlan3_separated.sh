#!/bin/bash

# Define directories and filenames
TIME_REPORT_METAPHLAN3="/benchmarking/PRJNA747117/5_metaphlan3"
TIME_LOG_METAPHLAN3="/benchmarking/PRJNA747117/5_metaphlan3"
TRIMMED_FASTQ="/benchmarking/PRJNA747117/1_fastq_trimmed/merged_seq/cat_samples"
FORWARD_SEQ_METAPHLAN3="/benchmarking/PRJNA747117/1_fastq_trimmed/*_1.fastq.gz"
REVERSE_SEQ_METAPHLAN3="/benchmarking/PRJNA747117/1_fastq_trimmed/*_2.fastq.gz"
CHOCO_DAT_V30="/database/v30_CHOCOPhlAn_201901/mpa_v30_CHOCOPhlAn_201901.fna"

# Create output directory if it doesn't exist
mkdir -p "$TIME_REPORT_METAPHLAN3"

# Define the output file for time details
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" >> "$TIME_LOG_METAPHLAN3/time_metaphlan3_bowtie2_separated.txt"
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" >> "$TIME_LOG_METAPHLAN3/time_metaphlan3_samtools_separated.txt"
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" >> "$TIME_LOG_METAPHLAN3/time_metaphlan3_separated.txt"

# Build bowtie2 index and merge forward and reverse sequences
# bowtie2-build /database/v30_CHOCOPhlAn_201901/mpa_v30_CHOCOPhlAn_201901.fna bowtie2_index --threads 20

# Merge paired-end sequences
cd /benchmarking/PRJNA747117/1_fastq_trimmed/separated
for i in "${TRIMMED_FASTQ}"/*_1.fastq.gz; do
    filename=$(basename "$i" _1.fastq.gz)
    cat "${filename}_1.fastq.gz" "${filename}_2.fastq.gz" > "/benchmarking/PRJNA747117/1_fastq_trimmed/merged_seq/cat_samples/${filename}.fastq.gz"
done

cd "$TIME_REPORT_METAPHLAN3/separated/sam_files"
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in "$1"/*.fastq.gz; do
    filename=$(basename "$i" .fastq.gz)
    bowtie2 --threads 20 -x /database/bowtie2_index_choco/v30_choco_201901 --very-sensitive --no-unal -U "$1/${filename}".fastq.gz -S mapped_metaphlan3_${filename}.sam
done
' _ "${TRIMMED_FASTQ}") 2>> "$TIME_LOG_METAPHLAN3/time_metaphlan3_bowtie2_separated.txt"

cd "$TIME_REPORT_METAPHLAN3/separated/sam_files"
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in "$1"/*.fastq.gz; do
    filename=$(basename "$i" .fastq.gz)
    samtools view --threads 20 -q 5 mapped_metaphlan3_${filename}.sam > mapped_metaphlan3_${filename}_q5.sam
done
' _ "${TRIMMED_FASTQ}") 2>> "$TIME_LOG_METAPHLAN3/time_metaphlan3_samtools_separated.txt"

cd "$TIME_REPORT_METAPHLAN3/separated/sam_files"
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in "$1"/*.fastq.gz; do
    filename=$(basename "$i" .fastq.gz)
    metaphlan mapped_metaphlan3_${filename}_q5.sam --input_type sam --bowtie2out metagenome_${filename}.bowtie2.bz2 --nproc 20 -o profiled_metagenome_${filename}.txt
done
' _ "${TRIMMED_FASTQ}") 2>> "$TIME_LOG_METAPHLAN3/time_metaphlan3_separated.txt"