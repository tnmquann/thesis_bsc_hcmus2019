#!/bin/bash

# Directory path
dir_path="/benchmarking/PRJNA747117/9_analyze/mOTUs2"

# Loop over all .txt files in the directory
for file_path in $dir_path/*.txt; do
    # Extract file name from file path
    file_name=$(basename $file_path)

    # Extract ID from file name
    id=$(echo $file_name | cut -d'-' -f2 | cut -d'_' -f1)

    # Replace terms in the file
    sed -i "s/unnamed sample/$id/g" $file_path
    sed -i "s/#mOTU/mOTUs-v2.6.1/g" $file_path

    # Remove first two lines from the file
    sed -i '1,2d' $file_path

    # Replace all tabs in each line with semicolon
    sed -i 's/\t/;/g' $file_path
done