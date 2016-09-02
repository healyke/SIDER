To do list:
 * In `DEsiR-package.R` :
    * Check all the authors emails + affiliations. I've checked mine (and yours is alright as well I guess) but I don't which ones Sean and Andrew wants (also not sure how to do it but Sean needs he's flippidyfloping accent on his "e" as well).
    * Add reference
    * Add keywords
 * Get some functions examples!
 * Add an example data set
 * Unit test the functions!


Some problems:
 * It calls many functions from mulTree (yay!) but it's not a CRAN package. Therefore, there's no way to properly import them!
 
 AJ notes 01-Sep-2016
 * i had to comment out the entire contents of `tests\testthat\test_data_structure.R` as the object `tef_data_badger.c` is not found.
 * I have used the :: syntax to accesss functions within packages, thereby avoiding having to import them entirely in the NAMESPACE. This is recommended by Wickham.
 * I deleted the CITATION file as it was causing problems with non-ASCII characters and/or invalid syntax. I couldnt debug it so just deleted it as its not essential.
 * the iteration settings for the mcmc in the vignette are very small as we test this package building. Need to change it back to the commented out options before submitting (And also warn people that it might take longer then 5 mins to build it!.. we could build the vignette on pre-compiled binaries of the run... and suggest people change it to the actual run themselves??)
 * are the data binaries associated with the vignette supposed to be in `/vignettes/`? 
 
