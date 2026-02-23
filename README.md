# LLM-Assisted-PDF-to-LaTeX-Conversion-for-Academic-Document-Management


## Prompts
> We used prompt engineering in order to keep the experiments with models controlled and consistent, which kept the number of independant variables as low as possible.
> We included the statistics sheet as well as all output files and test results (view below for file structure)
## Experimental Process
> The process for our experimentation was as follows:
### Standard Prompt (Setting 1)
* Paste the step 1 prompt into the text box on the website and send the prompt to the model (add the additional phrase if the pdf is scanned)
  ```
  For the remainder of this conversation:
  
  - Do NOT ask me any questions.
  - Do NOT request clarification or confirmation.
  - Do NOT explain your reasoning.
  - Do NOT include commentary, warnings, or summaries.
  - Only produce outputs explicitly requested.
  - If content is unclear or unreadable, mark it as [ILLEGIBLE] or [MISSING].
  - Assume I will not respond except to provide the next task.
  
  Reply with exactly:
  
  ACK
  ```
* If pdf is scanned:
  ```
  For the remainder of this conversation:
  - Do NOT ask me any questions.
  - Do NOT request clarification or confirmation.
  - Do NOT explain your reasoning.
  - Do NOT include commentary, warnings, or summaries.
  - Only produce outputs explicitly requested.
  - If content is unclear or unreadable, mark it as [ILLEGIBLE] or [MISSING].
  - Assume I will not respond except to provide the next task.
  NOTE: The PDF may be scanned. Do not guess unclear characters, especially in equations and table
  
  Reply with exactly:
  
  ACK
  ```

* Paste the second step of scenario 1 into the text box and attach the document in question
   ```
  TASK: Convert the uploaded PDF into a complete LaTeX source project.
  
  STRICT REQUIREMENTS:
  1) Output ONLY LaTeX project files using the exact file-delimiting format below.
  2) Preserve the full paper content and structure: title, authors, abstract, sections, subsections, paragraphs, equations, algorithms, tables, figures, captions, footnotes, references, and appendix.
  3) Preserve correct logical reading order. If the document is two-column, reconstruct it correctly.
  4) Do NOT invent or infer missing content. Use [ILLEGIBLE] or [MISSING] where necessary.
  5) The output must compile with standard LaTeX (pdflatex or xelatex). Avoid undefined commands and exotic packages.
  6) Figures: if images cannot be reproduced, insert a figure environment with the original caption and a boxed note “IMAGE NOT PROVIDED”.
  7) Tables: reconstruct as LaTeX tables. If uncertain, mark cells as [ILLEGIBLE].
  8) References: reproduce the bibliography using a `thebibliography` environment unless BibTeX entries can be produced reliably.
  OUTPUT FORMAT:
  
  For each file:
  
  =====FILE: <relative/path/filename>=====
  
  <file contents>
  
  =====END FILE=====
  
  MINIMUM FILE:
  - main.tex
  
  OPTIONAL FILES:
  - sections/*.tex
  - refs.bib
  - figures/README.txt
  BEGIN CONVERSION NOW.
  ```
* Paste the result in overleaf
* After this is finished, we move to getting the results
* We ran scripts that would run the .tex files in a compiler (pdflatex) and saved the results to text documents, then counted the number of '!' since they are the standard syntax for pdflatex compilation errors
* Once we got the results from the compiler, we saved, counted, and organized the pdfs (made from the compiler) that could open via a document reader (Acrobat) by model name
* After we catagorized the successful pdfs via model name, we used the Acrobat 'Compare Documents' tool to get a number of differences in the documents (Initial as old, model output as new). It's worth noting that the tool does have issues with scanned pdfs as the tool takes them in as basic images and attempts to run different functions on the image, so it is not as verbose as 'born-pdf' document comparisons
* After we get these results, we then run more shebang script that writes the files names, for .tex and .pdf files, and thier corresponding file sizes (in bytes)
* We take all the results from all the files and model outputs, and write them into the statistics sheet

### Long Prompt (Setting 2)
* Paste the step 1 prompt into the text box on the website and send the prompt to the model (add the additional phrase if the pdf is scanned)
* Paste the second step of scenario 2 into the text box and attach the document in question in order to get the models' skeleton of the end .tex file
* ```
  RULES:
  1) Output ONLY a structural LaTeX project using the file format below.
  2) Include title, authors, abstract, and all section/subsection headings including references and appendix in correct order.
  3) Insert placeholders for ALL content using EXACTLY:
  
  %%%PLACEHOLDER: <TYPE>_<NNNN>%%%
  
  TYPE ∈ {PARA, EQ, FIG, TAB, ALGO, BIB}
  
  NNNN = zero-padded sequential number.
  
  4) Every paragraph, equation, figure, table, algorithm, and bibliography item must have a placeholder.
  5) Preserve correct logical reading order (handle two-column layout).
  6) The skeleton MUST compile.
  
  OUTPUT FORMAT:
  
  =====FILE: <relative/path/filename>=====
  
  <file contents>
  
  =====END FILE=====
  
  MINIMUM FILE:
  
  - main.tex
  
  GENERATE SKELETON NOW.
  ```
* Paste the skeleton into the associated .tex file
* Paste the third step of scenario 2 into the text box to get the list of sections
  ```
  RULES:

  1) Output ONLY a numbered list of sections in order of appearance.
  2) For each section, report:
  
  - Section number
  - Section title
  
  3) Do NOT include any other text.
  
  BEGIN NOW.
  ```
* For each section, paste the fourth step of scenrio 2 and replace the X and TITLE phrases with the section number you wish to retrieve and the section title the model assigned to the section
  ```
  SECTION TO RECONSTRUCT:
  
  - Section number: <X>
  - Section title: <TITLE>
  
  RULES:
  
  1) Reconstruct ONLY the content that appears in this section of the uploaded PDF.
  2) Preserve original wording and paragraph order as closely as possible.
  3) Do NOT summarize, rephrase, or improve the text.
  4) Do NOT include content from other sections.
  5) If any content is unclear or unreadable, insert [ILLEGIBLE].
  6) Output ONLY valid LaTeX content for this section.
  7) Do NOT include \section{...} or \subsection{...} commands.
  
  OUTPUT FORMAT:
  
  <LaTeX content for this section only>
  
  BEGIN NOW.
  ```
* Paste these sections into the corresponding section within the skeleton of the .tex file
* After this is complete, we move on to getting the results of the experiment

## Results

* We ran scripts that would run the .tex files in a compiler (pdflatex) and saved the results to text documents, then counted the number of '!' since they are the standard syntax for pdflatex compilation errors
* Once we got the results from the compiler, we saved, counted, and organized the pdfs (made from the compiler) that could open via a document reader (Acrobat) by model name
* After we catagorized the successful pdfs via model name, we used the Acrobat 'Compare Documents' tool to get a number of differences in the documents (Initial as old, model output as new). It's worth noting that the tool does have issues with scanned pdfs as the tool takes them in as basic images and attempts to run different functions on the image, so it is not as verbose as 'born-pdf' document comparisons
* After we get these results, we then run more shebang script that writes the files names, for .tex and .pdf files, and thier corresponding file sizes (in bytes), and pages in a .pdf file
* We take all the results from all the files and model outputs, and write them into the statistics sheet

## File Structure
LatexModelOutputsRAW - This directory contains all of the raw output .tex files the models had produced along with error logs and scripts to run get said errors. The structure is as follows:
> Parent -> Model -> Conference Papers (unscanned) or Scanned Papers -> Base Outputs / Long Prompt Outputs (internal folder)

OutputComparisons - This directory contains purely the comparison results from the Acrobat 'Compare Documents' tool. The structure is as follows:
> OutputComparisons -> Scanned / Unscanned -> Model -> Numbered via the end number of the source files

ResearchPapersScanned - This directory contains all of the scanned source files

ResearchPapersUnscanned - This directory contains all of the unscanned 'born pdf' source files

Scanned / Unscanned - These directories contain the successful outputs from each model. The structure is as follows:
> Scanned / Unscanned -> Model -> Successful pdfs for the model with the same file list csv and page count csv
