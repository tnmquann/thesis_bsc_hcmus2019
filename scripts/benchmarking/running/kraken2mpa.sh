#!/bin/bash

# Define directories and filenames
KRAKEN2_REPORT="/benchmarking/PRJNA747117/6_kraken2/report"
KRAKEN_TOOLS="/benchmarking/script/KrakenTools-1.2"
mkdir -p "${KRAKEN2_REPORT}/score_0_055/mpa_style"
cd "${KRAKEN2_REPORT}/score_0_055/"
mv *.kreport2 kraken2_style
for file in "${KRAKEN2_REPORT}"/score_0_055/kraken2_style/*.kreport2; do
    filename=$(basename "$file" .kreport2)
    "${KRAKEN_TOOLS}"/kreport2mpa.py -r "$file" -o "${KRAKEN2_REPORT}/score_0_055/mpa_style/${filename}.report.mpa" --read_count --no-intermediate-ranks --percentages --display-header
done