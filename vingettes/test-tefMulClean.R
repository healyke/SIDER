
# Test document. To be used as an example etc.

##this is only required while Thomas updates his Multree code
library(FestR)
if(!require(devtools)) install.packages("devtools")
install_github("TGuillerme/mulTree", ref = "clunky-mulTree")
library(mulTree)



#read in the data
mydata<-read.csv(file=system.file("extdata", "FestR_data.csv", package = "FestR"),
                 header=T, stringsAsFactors = F)

# re-order it into species
mydata <- mydata[order(mydata$species),]

# ----------------------------------------------------------------
#read in the two trees
# These two are the original as bundled with FestR
mammal_trees <- read.tree(system.file("extdata", "3firstFritzTrees.tre", package = "FestR"))
bird_trees   <- read.tree(system.file("extdata", "3firstJetzTrees.tre", package = "FestR"))

# TG: I just created a subsample of the BIG trees (all sp) to make it faster
#combine them together
combined_trees <- rTreeBind(x = mammal_trees, y = bird_trees, sample = 2, root.age = 250)

# Select the species and tissue type to be estimated using FestR. 
# This function also checks that the species is in the tree.
new_data_test <- setTefEst(species = "Meles_meles", 
                           habitat = "terrestrial", 
                           taxonomic.class = "mammalia", 
                           tissue = "blood", 
                           diet.type = "omnivore", 
                           source.iso.13C = c(-24.1), 
                           source.iso.15N = c(7.0), 
                           phylogeny = combined_trees )


# Matches the tree to the data, and prunes the tree of species for which we dont
# have isotope or other data,  removes the unecessary isotope, and removes data 
# for which we dont have phylogenetic data.
# It returns a mulTree class object which is required by the imputation 
# algorithm.
tef_data_badger.c <- tefMulClean(new.data = new_data_test, data = mydata, species_col_name = "species", trees =  combined_trees, taxonomic.class = "mammalia", isotope = "carbon")

# define the model to be used for prediction
formula.c <- delta13C ~ diet.type + habitat

# Run the model that performs imputation as part of model fitting.
Tef_est <- tefMcmcglmm(mulTree.data = tef_data_badger.c, formula = formula.c)

# Plot the aggregated posteriors of the estimated TEF from all chains,
# as a MCMC line trace (left panel) and as a posterior density kernel 
# (right panel)
plot(Tef_est$tef_global)

