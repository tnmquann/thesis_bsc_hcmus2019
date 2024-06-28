#!/bin/bash

# Define directories and filenames
base_dir="/benchmarking/PRJNA747117"
OUTPUT_SOURMASH="/benchmarking/PRJNA747117/8_sourmash"
TIME_LOG_SOURMASH="/benchmarking/PRJNA747117/8_sourmash/separated/"
TRIMMED_FASTQ="/benchmarking/PRJNA747117/1_fastq_trimmed/merged_seq/"

# Define sourmash database
SOURMASH_DATABASE="/database/sourmash/GTDB_R07-RS207_fullgenomes/gtdb-rs207.genomic-reps.dna.k31.zip"
SOURMASH_DATABASE_TAX="/database/sourmash/GTDB_R07-RS207_fullgenomes/gtdb-rs207.taxonomy.sqldb"

# Define options for sourmash tax metagenome
output_formats_tax=("human" "csv_summary" "lineage_summary" "krona" "kreport" "lingroup_report")

# Create log time files
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "${TIME_LOG_SOURMASH}/time_sourmash_step1_mergedsamples.txt"
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "${TIME_LOG_SOURMASH}/time_sourmash_step2_mergedsamples.txt"
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "${TIME_LOG_SOURMASH}/time_sourmash_step3_mergedsamples.txt"
echo "User time (s),System time (s),Wall time (h:mm:ss),Maximum set size (kb),CPU (%)" > "${TIME_LOG_SOURMASH}/time_sourmash_step4_mergedsamples.txt"

# Step 1: Create signature files for each samples
cd ${TRIMMED_FASTQ}
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in *.fastq.gz; do
    j="${i%.fastq.gz}.fastq.gz"
    k="${i%.fastq.gz}"
    # k="${k#trimmed-}"
    sourmash sketch dna -p k=31,abund ${k}* -o ${k}.sig.zip --name ${k} 
done | parallel -j 20
') 2> "${TIME_LOG_SOURMASH}/temp_time_log_1_mergedsamples.txt"
tail -n 10 "${TIME_LOG_SOURMASH}/temp_time_log_1_mergedsamples.txt" >> "${TIME_LOG_SOURMASH}/time_sourmash_step1_mergedsamples.txt"

mv *.sig.zip ${OUTPUT_SOURMASH}/separated/matches_sketch/merged

# Step 2: Compare the signature to the GTDB database
cd ${OUTPUT_SOURMASH}/separated/matches_sketch/merged
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in *.zip; do
    k="${i%.sig.zip}"
    sourmash gather ${i} /database/sourmash/GTDB_R07-RS207_fullgenomes/gtdb-rs207.genomic-reps.dna.k31.zip --save-matches ${k}_matches.zip
done | parallel -j 20
') 2> "${TIME_LOG_SOURMASH}/temp_time_log_2.txt"
tail -n 10 "${TIME_LOG_SOURMASH}/temp_time_log_2.txt" >> "${TIME_LOG_SOURMASH}/time_sourmash_step2.txt"

# Step 3: Build a taxonomic summary of the metagenome
cd ${OUTPUT_SOURMASH}/separated/matches_sketch/merged
(/usr/bin/time -a -f "%U,%S,%E,%M,%P" bash -c '
for i in *sig.zip; do
    k="${i%.sig.zip}"
    sourmash gather tourlousse2022_merged.sig.zip tourlousse2022_merged_matches.zip -o tourlousse2022_merged_x_gtdb.csv
done
') 2> "${TIME_LOG_SOURMASH}/temp_time_log_3_mergedsamples.txt"
tail -n 10 "${TIME_LOG_SOURMASH}/temp_time_log_3_mergedsamples.txt" >> "${TIME_LOG_SOURMASH}/time_sourmash_step3_mergedsamples.txt"

mv *.csv ${OUTPUT_SOURMASH}/separated/text_files/merged

# Step 4: Create a taxonomic summary of the metagenome (cannot be parallelized neither tracked by time)
cd ${OUTPUT_SOURMASH}/separated/text_files/merged
for i in *.csv; do
    for format in ${output_formats_tax[@]}; do
        base_name="${i%_x_gtdb.csv}"
        sourmash tax metagenome -g ${i} -t ${SOURMASH_DATABASE_TAX} --output-format ${format} --rank species >> "${base_name}_${format}.txt"
    done
done