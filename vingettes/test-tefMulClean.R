
## Script to test tefMulClean that is not working.
# The data.frame column names are all over the place.

library(FestR)
library(mulTree)


#read in the data
mydata<-read.csv(file=system.file("extdata", "FestR_data.csv", package = "FestR"),
                 header=T, stringsAsFactors = F)

# re-oprder it into species
mydata <- mydata[order(mydata$species),]

# ----------------------------------------------------------------
#read in the two trees
mammal_trees <- read.tree(system.file("extdata", "3firstFritzTrees.tre", package = "FestR"))
bird_trees   <- read.tree(system.file("extdata", "3firstJetzTrees.tre", package = "FestR"))

# TG: I just created a subsample of the BIG trees (all sp) to make it faster
#combine them together
combined_trees<-rTreeBind(x = mammal_trees, y = bird_trees, sample = 2, root.age = 250)

new_data_test <- setTefEst(species = "Meles_meles", 
                           habitat = "terrestrial", 
                           Class = "mammalia", 
                           tissue = "blood", 
                           diet_type = "omnivore", 
                           iso_13C = c(-24.1), 
                           iso_15N = c(7.0), 
                           phylogeny = combined_trees )


tef_data_badger.c <- tefMulClean(new.data = new_data_test, data = mydata, species_col_name = "species", trees =  combined_trees, class = "mammalia", isotope = "carbon" )


# ------------------------------------------------------------------------------
# And now tefMulClean would fail, so here I manually assign some values so 
# the function can be opened up and tested line by line.


new.data = new_data_test 
data = mydata
species_col_name = "species"
trees =  combined_trees
Class = "mammalia"
isotope = "carbon"
