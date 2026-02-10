#!/bin/bash

# Ensure pdfinfo is installed
if ! command -v pdfinfo &> /dev/null; then
    echo "Error: 'pdfinfo' is not installed. Install it with: sudo apt install poppler-utils"
    exit 1
fi

# Find all directories
find . -type d | while read -r dir; do
    OUTPUT_FILE="$dir/pdf_page_counts.csv"
    
    # Check for PDFs in the current directory
    if ls "$dir"/*.pdf >/dev/null 2>&1; then
        echo "Processing PDFs in $dir"
        echo "File Name,Page Count" > "$OUTPUT_FILE"
        
        # Process each PDF found in this specific directory
        find "$dir" -maxdepth 1 -type f -name "*.pdf" | while read -r pdf; do
            # Extract page count using pdfinfo and awk
            PAGES=$(pdfinfo "$pdf" | grep 'Pages:' | awk '{print $2}')
            FILENAME=$(basename "$pdf")
            echo "$FILENAME,$PAGES" >> "$OUTPUT_FILE"
        done
    fi
done

echo "Process complete."
