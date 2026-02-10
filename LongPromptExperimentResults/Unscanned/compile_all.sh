#!/bin/bash

# Configuration
MASTER_LOG="$(pwd)/master_errors.txt"
COMPILER="pdflatex -interaction=nonstopmode"
MAX_TIME="120s"

# Setup
echo "=== Global Compilation Log - $(date) ===" > "$MASTER_LOG"

# 1. Get unique directories
mapfile -t DIRS < <(find . -name "*.tex" -printf "%h\n" | sort -u)
TOTAL_FILES=$(find . -name "*.tex" -type f | wc -l)
CURRENT_FILE=0

echo "Found $TOTAL_FILES files across ${#DIRS[@]} directories."

for dir in "${DIRS[@]}"; do
    # 2. Compile within a subshell to isolate the 'cd' command
    (
        cd "$dir" || exit
        
        # Local setup inside the subdirectory
        csv_file="folder_summary.csv"
        # Only write header if CSV doesn't exist yet
        [ ! -f "$csv_file" ] && echo "Filename,Error_Count,Status" > "$csv_file"
        
        mkdir -p "compile_logs"

        # 3. Find files in current local directory
        find . -maxdepth 1 -name "*.tex" -type f -print0 | while IFS= read -r -d '' tex_file; do
            # Increment the global counter (using an exportable method)
            # Since we are in a subshell, we'll update the progress bar via the outer loop logic 
            # or just calculate it locally.
            
            file_name=$(basename "$tex_file")
            base_name="${file_name%.tex}"
            timestamp=$(date +%Y%m%d_%H%M%S)
            log_file="compile_logs/${base_name}_${timestamp}.txt"

            # Run compiler locally
            timeout "$MAX_TIME" $COMPILER "$file_name" > "$log_file" 2>&1
            exit_status=$?
            
            error_count=$(grep -c "^!" "$log_file")
            
            status="SUCCESS"
            if [ $exit_status -eq 124 ]; then
                status="TIMEOUT"
                echo "TIMED OUT: $dir/$file_name" >> "$MASTER_LOG"
            elif [ $exit_status -ne 0 ]; then
                status="FAILED"
                echo "FAILED: $dir/$file_name ($error_count errors)" >> "$MASTER_LOG"
                grep -m 1 "^!" "$log_file" >> "$MASTER_LOG"
            else
                echo "SUCCESS: $dir/$file_name" >> "$MASTER_LOG"
            fi
            
            echo "$file_name,$error_count,$status" >> "$csv_file"
            echo "-----------------------------------" >> "$MASTER_LOG"
            
            # Simple terminal output since complex progress bars get messy in nested loops
            echo "Finished: $dir/$file_name"
        done
    )
done

echo -e "\nDone! Check individual folders for CSVs and $MASTER_LOG for the summary."
