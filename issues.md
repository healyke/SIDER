To do list:
 * In `TESIR-package.R` :
    * Check all the authors emails + affiliations. I've checked mine (and yours is alright as well I guess) but I don't which ones Sean and Andrew wants (also not sure how to do it but Sean needs he's flippidyfloping accent on his "e" as well).
    * Add reference
    * Add keywords
 * Get some functions examples!
 * Add an example data set
 * Unit test the functions!


Some problems:
 * ~~It calls many functions from mulTree (yay!) but it's not a CRAN package. Therefore, there's no way to properly import them!~~ I don't think this is a problem at all as we now call them using :: syntax [AJ].
 
 AJ notes 01-Sep-2016: Kevin / Thomas please ~~strikethrough~~ those that are relevant to you.
 * i had to comment out the entire contents of `tests\testthat\test_data_structure.R` as the object `tef_data_badger.c` is not found.
 * I have used the :: syntax to accesss functions within packages, thereby avoiding having to import them entirely in the NAMESPACE. This is recommended by Wickham.
 * I deleted the CITATION file as it was causing problems with non-ASCII characters and/or invalid syntax. I couldnt debug it so just deleted it as its not essential.
 * the iteration settings for the mcmc in the vignette are very small as we test this package building. Need to change it back to the commented out options before submitting (And also warn people that it might take longer then 5 mins to build it!.. we could build the vignette on pre-compiled binaries of the run... and suggest people change it to the actual run themselves??)
 * are the data binaries associated with the vignette supposed to be in `/vignettes/`? 
 * i have an old comment in tefMulClean.R line 52 that the isotope column names are a mess; is this still the case? I think we fixed this. If so i need to remove this comment
 * in tefMulClean.R on line 95 there is a comment "_this needs to be fixed so that it actually removes the dataset._". Need to check if this remains to be fixed
 * in tefMulClean.R check commented out lines 102 - 112: can we just delete these?
 * lots of commented out lines and seemingly superfluous comments in refMcmcglmm.R. Needs to be cleaned.
 * Check comment regarding the loop in refMcmcglmm.R at line 110 onwards. In any case, it needs a comment that explains what these lines are actually doing.
 * i think lines 114-116 in tefMulClean are redundant. Currently commented out. Can we delete?
 * A bigger issue is that im not sure the current structure for the vignettes makes it as easy for people as it could be. We could hide the dataset from the user and simply load it, and the phylogenies internally and just skip the whole first part of the vignette. Of course we would retain the ability to override the default by loading it oneself and manipulating or altering as one requires... just a thought...
 * i think the summary statistics could do with some additional work. We should probably used hdrcde::hdr() to calculate credible intervals, rather than just throwing summary() and hist() at it.
 
 
 
