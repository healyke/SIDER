######Example code setting up phylogeny



#library(MCMCglmm)
#library(modeest)
#library(caper)
#library(ape)
#this is our package for combining trees together
library(mulTree)
# TG: mulTree does already loads these fellows for us

source("FestR_functions.R")

#read in the data
data<-read.csv(file="FestR_data.csv",
 header=T, stringsAsFactors = F)
data <- data[order(data$species),]



#read in the trees
mammal_trees <- read.tree("3firstFritzTrees.tre")
bird_trees <- read.tree("3firstJetzTrees.tre")
# TG: I just created a subsample of the BIG trees (all sp) to make it faster
#combine them together
combined_trees<-rTreeBind(x=mammal_trees, y=bird_trees, sample=2, root.age=250)

#####function that checks the dat for some species we want to estimate TEF for
new_data_test <- set.tef.est(species = "Meles_meles", habitat = "terrestrial", Class = "mammalia", tissue = "blood", diet_type = "omnivore", iso_13C = c(-24.1), iso_15N = c(7), phylogeny = combined_trees )



####new.data_badge.c <- data.frame(species = "Meles_meles", envirnment = "T", class = "Mamm", tissue = "blood", diet_type = "omnivore", iso_13C = c(-24.1),delta13C = NA, iso_15N = c(7), delta15N = NA, stringsAsFactors = F) 
# TG: as we discussed last day a function "set.tef.est" would be cool here.
# TG: that way you're sure new.data_badge.c col names exactly matches data.


tef_data_badger.c <- tef.mul.clean(new.data = new_data_test, data = data, species_col_name = "species", trees =  combined_trees, class = "mammalia", isotope = "carbon" )
# TG: That should work now!




#install.packages(testthat)
library(testthat)

test_that("clean.data works fine", {
    test <- tef_data_badger.c
    #Test is a list...
    expect_is(test, "list")
    #... of three objects.
    expect_equal(names(test), c("tree", "data", "dropped.taxon"))
    #The first is a multiPhylo...
    expect_is(test$tree, "multiPhylo")
    #... with two trees of 22 tips.
    expect_equal(unlist(lapply(test$tree, Ntip)), c(22,22))
    #The second is a data.frame...
    expect_is(test$data, "data.frame")
    #... with 95 rows and 7 columns...
    expect_equal(dim(test$data), c(95,7))
    #... and a NA at the end of the first row.
    expect_true(is.na(test$data[1,7]))
    #The third object is a character vector...
    expect_is(test$dropped.taxon, "character")
    #... of 6181 elements.
    expect_equal(length(test$dropped.taxon), 6181)
})
