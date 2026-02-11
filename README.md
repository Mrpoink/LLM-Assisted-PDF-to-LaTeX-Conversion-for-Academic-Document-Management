# LLM-Assisted-PDF-to-LaTeX-Conversion-for-Academic-Document-Management


## Prompts
> We used prompt engineering in order to keep the experiments with models controlled and consistent, which kept the number of independant variables as low as possible. 

## Experimental Process
> The process for our experimentation was as follows:
### Standard Prompt (Setting 1)
* Paste the step 1 prompt into the text box on the website and send the prompt to the model (add the additional phrase if the pdf is scanned)
* Paste the second step of scenario 1 into the text box and attach the document in question
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
* Paste the skeleton into the associated .tex file
* Paste the third step of scenario 2 into the text box to get the list of sections
* For each section, paste the fourth step of scenrio 2 and replace the X and TITLE phrases with the section number you wish to retrieve and the section title the model assigned to the section
* Paste these sections into the corresponding section within the skeleton of the .tex file
* After this is complete, we move on to getting the results of the experiment

## Results

* We ran scripts that would run the .tex files in a compiler (pdflatex) and saved the results to text documents, then counted the number of '!' since they are the standard syntax for pdflatex compilation errors
* Once we got the results from the compiler, we saved, counted, and organized the pdfs (made from the compiler) that could open via a document reader (Acrobat) by model name
* After we catagorized the successful pdfs via model name, we used the Acrobat 'Compare Documents' tool to get a number of differences in the documents (Initial as old, model output as new). It's worth noting that the tool does have issues with scanned pdfs as the tool takes them in as basic images and attempts to run different functions on the image, so it is not as verbose as 'born-pdf' document comparisons
* After we get these results, we then run more shebang script that writes the files names, for .tex and .pdf files, and thier corresponding file sizes (in bytes), and pages in a .pdf file
* We take all the results from all the files and model outputs, and write them into the statistics sheet

## File Structure
LatexModelOutputsRAW - This directory contains all of the raw output .tex files the models had produced. The structure is as follows:
> Parent -> Model -> Conference Papers (unscanned) or Scanned Papers -> Base Outputs / Long Prompt Outputs (internal folder)

LongPromptExperimentResults - This is the directory of results from the models. It include the compiler script, file size script, page count script, and master error log which shows all errors within a given subdirectory. The structure is as follows:
> LongPromptExperimentResults -> Scanned / Unscanned / shebang scripts -> Comparisons / Successes / Compiler logs / All outputs files from the compiler / file size csv / error information csv / pdf page count csv

OutputComparisons - This directory contains purely the comparison results from the Acrobat 'Compare Documents' tool. The structure is as follows:
> OutputComparisons -> Scanned / Unscanned -> Model -> Numbered via the end number of the source files

ResearchPapersScanned - This directory contains all of the scanned source files

ResearchPapersUnscanned - This directory contains all of the unscanned 'born pdf' source files

Scanned / Unscanned - These directories contain the successful outputs from each model. The structure is as follows:
> Scanned / Unscanned -> Model -> Successful pdfs for the model with the same file list csv and page count csv

## Other Notes:
* We included the word document containing the prompts for the different scenarios, statistics sheet, and all output files. 
