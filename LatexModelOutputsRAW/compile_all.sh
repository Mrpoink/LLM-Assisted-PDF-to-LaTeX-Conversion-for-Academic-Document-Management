#!/bin/bash

MASTER_LOG="$(pwd)/master_errors.txt"
COMPILER="pdflatex -interaction=nonstopmode"
MAX_TIME="120s"

echo "=== Global Compilation Log - $(date) ===" > "$MASTER_LOG"

mapfile -t DIRS < <(find . -name "*.tex" -printf "%h\n" | sort -u)
TOTAL_FILES=$(find . -name "*.tex" -type f | wc -l)

echo "Found $TOTAL_FILES files across ${#DIRS[@]} directories."

for dir in "${DIRS[@]}"; do
    (
        cd "$dir" || exit
        
        csv_file="folder_summary.csv"
        
        echo "Filename,Misplaced_Items,Syntax_Structure,Package_Errors,Total_Critical_Errors,Warnings,Status" > "$csv_file"
        
        mkdir -p "compile_logs"

        find . -maxdepth 1 -name "*.tex" -type f -print0 | while IFS= read -r -d '' tex_file; do
            file_name=$(basename "$tex_file")
            base_name="${file_name%.tex}"
            timestamp=$(date +%Y%m%d_%H%M%S)
            log_file="compile_logs/${base_name}_${timestamp}.txt"

            timeout "$MAX_TIME" $COMPILER "$file_name" > "$log_file" 2>&1
            exit_status=$?
            
            misplaced_count=$(grep -c "Misplaced" "$log_file")
            
            syntax_count=$(grep -cE "Undefined control sequence|Missing|Extra|Runaway argument" "$log_file")
            
            package_error_count=$(grep -c "LaTeX Error" "$log_file")
            
            total_critical=$(grep -c "^!" "$log_file")
            
            warning_count=$(grep -c "Warning:" "$log_file")
            

            status="SUCCESS"
            if [ $exit_status -eq 124 ]; then
                status="TIMEOUT"
                echo "TIMED OUT: $dir/$file_name" >> "$MASTER_LOG"
            elif [ $exit_status -ne 0 ]; then
                status="FAILED"
                echo "FAILED: $dir/$file_name (Crit: $total_critical, Syntax: $syntax_count, Misplaced: $misplaced_count)" >> "$MASTER_LOG"
                grep -m 1 "^!" "$log_file" >> "$MASTER_LOG"
            else
                echo "SUCCESS: $dir/$file_name" >> "$MASTER_LOG"
            fi
            
            echo "$file_name,$misplaced_count,$syntax_count,$package_error_count,$total_critical,$warning_count,$status" >> "$csv_file"
            echo "-----------------------------------" >> "$MASTER_LOG"
            
            echo "Finished: $dir/$file_name"
        done
    )
done

echo -e "\nDone! Check individual folders for detailed CSV breakdowns."
