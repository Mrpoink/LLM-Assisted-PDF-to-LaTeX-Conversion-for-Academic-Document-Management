import fitz  # PyMuPDF
import pandas as pd
import glob
import re
import os

def extract_stat(pattern, text):
    """Hunts for a regex pattern and returns the first integer found."""
    match = re.search(pattern, text, re.IGNORECASE)
    if match:
        # Grab the first non-None group (handles numbers before OR after the word)
        found = match.group(1) or match.group(2)
        return int(found.replace(',', ''))
    return 0

def parse_comparison_reports():
    pdf_files = glob.glob("**/*.pdf", recursive=True)
    data = []

    print(f"Found {len(pdf_files)} PDFs. Scanning for Acrobat reports...")

    for pdf_path in pdf_files:
        try:
            with fitz.open(pdf_path) as doc:
                # Acrobat summary is always on the first page
                text = doc[0].get_text("text")
                
                # Verify it's actually an Acrobat Compare Report
                if "Old File:" not in text and "New File:" not in text:
                    continue
                
                # Extract File Names
                old_file_match = re.search(r'Old File:\s*([^\n]+)', text)
                new_file_match = re.search(r'New File:\s*([^\n]+)', text)
                
                old_file = old_file_match.group(1).strip() if old_file_match else "Unknown"
                new_file = new_file_match.group(1).strip() if new_file_match else "Unknown"

                # Extract Statistics (Checks for "350 Total Changes" OR "Total Changes 350")
                total = extract_stat(r'(\d+)\s*Total Changes|Total Changes\s*(\d+)', text)
                replacements = extract_stat(r'(\d+)\s*Replacements|Replacements\s*(\d+)', text)
                insertions = extract_stat(r'(\d+)\s*Insertions|Insertions\s*(\d+)', text)
                deletions = extract_stat(r'(\d+)\s*Deletions|Deletions\s*(\d+)', text)
                styling = extract_stat(r'(\d+)\s*Styling|Styling\s*(\d+)', text)
                annotations = extract_stat(r'(\d+)\s*Annotations|Annotations\s*(\d+)', text)

                data.append({
                    "Directory": os.path.dirname(pdf_path),
                    "Report PDF": os.path.basename(pdf_path),
                    "Old File": old_file,
                    "New File": new_file,
                    "Total Changes": total,
                    "Replacements": replacements,
                    "Insertions": insertions,
                    "Deletions": deletions,
                    "Styling": styling,
                    "Annotations": annotations
                })
        except Exception as e:
            print(f"Could not read {pdf_path}: {e}")

    if not data:
        print("No valid Acrobat Compare Reports found.")
        return

    df = pd.DataFrame(data)
    output_name = "master_acrobat_stats.csv"
    df.to_csv(output_name, index=False)
    print(f"Successfully parsed {len(data)} reports! Saved to {output_name}")

if __name__ == "__main__":
    parse_comparison_reports()