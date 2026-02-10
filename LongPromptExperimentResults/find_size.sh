#!/bin/bash

# Usage: ./script.sh <extension>
# Example: ./script.sh txt

EXT=$1

if [ -z "$EXT" ]; then
    echo "Please provide a file extension (e.g., sh, txt, pdf)"
    exit 1
fi

# Find all directories and subdirectories
find . -type d | while read -r dir; do
    # Define the output file path for the current directory
    OUTPUT_FILE="$dir/file_list.csv"
    
    # Check if there are any matching files in the directory to avoid empty CSVs
    if ls "$dir"/*."$EXT" >/dev/null 2>&1; then
        echo "Creating CSV in $dir"
        
        # Add CSV Header
        echo "File Name,Size (Bytes)" > "$OUTPUT_FILE"
        
        # Loop through files with the specific extension in the current dir ONLY
        # maxdepth 1 ensures we don't double-count files from sub-sub-directories
        find "$dir" -maxdepth 1 -type f -name "*.$EXT" -printf "%f,%s\n" >> "$OUTPUT_FILE"
    fi
done

echo "Done."
