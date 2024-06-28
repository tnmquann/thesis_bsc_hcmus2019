#!/bin/bash

# Define directories and filenames
base_dir="/benchmarking/PRJNA747117"
OUTPUT_YACHT="/benchmarking/PRJNA747117/10_yacht"
SIG_SOURMASH="/benchmarking/PRJNA747117/8_sourmash/separated/matches_sketch"
OUTPUT_SOURMASH="/benchmarking/PRJNA747117/8_sourmash"
TIME_LOG_YACHT="/benchmarking/PRJNA747117/10_yacht"
TRIMMED_FASTQ="/benchmarking/PRJNA747117/1_fastq_trimmed/separated"

YACHT_DATABASE="/database/sourmash/yacht_gtdb-rs207-reps.k31_0.995_pretrained/gtdb_ani_thresh_0.995_config.json"

# Create log time files
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "${OUTPUT_YACHT}/time_yacht_step1.txt"
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "${OUTPUT_YACHT}/time_yacht_step2.txt"

# Step 1: Create signature files for each samples
cd ${TRIMMED_FASTQ}
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in *_1.fastq.gz; do
    j="${i%_1.fastq.gz}_2.fastq.gz"
    k="${i%_1.fastq.gz}"
    # k="${k#trimmed-}"
    sourmash sketch dna -p k=31,abund ${k}* -o ${k}.sig.zip --name ${k} 
done | parallel -j 20
') 2> "${TIME_LOG_YACHT}/temp_time_log_1.txt"
tail -n 10 "${TIME_LOG_YACHT}/temp_time_log_1.txt" >> "${TIME_LOG_YACHT}/time_yacht_step1.txt"

mv *.sig.zip ${OUTPUT_YACHT}/sketch

cd ${OUTPUT_YACHT}/sketch
# Step 2: Search database
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in *.zip; do
    k="${i%.sig.zip}"
    yacht run --json /database/sourmash/yacht_gtdb-rs207-reps.k31_0.995_pretrained/gtdb_ani_thresh_0.995_config.json --sample_file ${i} --num_threads 20 --significance 0.99 --min_coverage_list 0.5 0.1 0.05 --out ${k}_yacht.xlsx
done
') 2> "${TIME_LOG_YACHT}/temp_time_log_2.txt"
tail -n 10 "${TIME_LOG_YACHT}/temp_time_log_2.txt" >> "${TIME_LOG_YACHT}/time_yacht_step2.txt"
mv *_yacht.xlsx ${OUTPUT_YACHT}/output
find . -type d -name "*intermediate_files" -exec rm -rf {} \;