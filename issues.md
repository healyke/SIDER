To do list:
 * In `SIDER-package.R` :
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
 
 ##Renaming functions 3/10/2016 - AJ
 * setTdfEst -->   recipeSider
 * tdfMulClean --> prepareSider
 * tdfMcmcGlmm --> imputeSider
 
 ##Issues 3/10/2016 - AJ
 * the vignettes is a dog's dinner, with buckets loads of verbose output
 * why are the packages MCMCglmm, Matrix, coda, and ape loaded midway through the vignette? Is this because mulTree loads them? This is not good practice as functions in other packages should be referenced directly using colon notation, e.g. coda::read.coda.
 * the outputting of the information for each Tree is unhelpful, messy and long.
    * maybe there should be a `verbose = FALSE` option to suppress this.
 * the random terms for the mcmcglmm model can now be defined in multiple places in the process. It is bundled into the object created by `prepareSider` (formally `tdfMulClean`) without any user input or control. If it is then not provided directly in the call to `imputeSider` (formally `tdfMcmcglmm`) then the function looks up this list object and pulls the random terms from e.g. `tdf_data_c$random.terms` (from the vignette). However, the fixed effects are not similarly defined automatically, and must instead by defined and passed explicitly to `imputeSider`. I don't see why the random terms would be automatically constructed, and not the random effects, and its not at all clear to me where we should be doing this and where this infomration should be stored (e.g. inside or outside the objects created by our functions)
 * when attaching SIDER, we get a message `The following object is masked _by_ ‘.GlobalEnv’: combined_trees` and I have not yet worked out what in the code is spawning this extra loading of the object since it should already be in the global environment via lazy loading.
 
 
 
 
