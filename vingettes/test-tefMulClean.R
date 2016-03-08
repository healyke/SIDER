
# Test document. To be used as an example etc.

##this is only required while Thomas updates his Multree code
library(FestR)
if(!require(devtools)) install.packages("devtools")
install_github("TGuillerme/mulTree", ref = "release")
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
combined_trees <- tree.bind (x = mammal_trees, y = bird_trees, sample = 2, root.age = 250)

# Select the species and tissue type to be estimated using FestR. 
# This function also checks that the species is in the tree.
##use example of kea parrot Greer et al 2015. Methods in Ecology and Evolution.
new_data_test <- setTefEst(species = "Nestor_notabilis", 
                           habitat = "terrestrial", 
                           taxonomic.class = "aves", 
                           tissue = "feather", 
                           diet.type = "omnivore", 
                           source.iso.13C = c(-24.83), 
                           source.iso.15N = c(3.97), 
                           phylogeny = combined_trees)


# Matches the tree to the data, and prunes the tree of species for which we dont
# have isotope or other data,  removes the unecessary isotope, and removes data 
# for which we dont have phylogenetic data.
# It returns a mulTree class object which is required by the imputation 
# algorithm.
tef_data_kea.c <- tefMulClean(new.data = new_data_test, data = mydata, species_col_name = "species", trees =  combined_trees, taxonomic.class = "aves", isotope = "carbon")
tef_data_kea.n <- tefMulClean(new.data = new_data_test, data = mydata, species_col_name = "species", trees =  combined_trees, taxonomic.class = "aves", isotope = "nitrogen")

# define the model to be used for prediction
formula.c <- delta13C ~ source.iso.13C + diet.type + habitat
formula.n <- delta15N ~ source.iso.15N + diet.type + habitat
random.terms = ~ animal + sp.col + tissue

Tef_est.c <- tefMcmcglmm(mulTree.data = tef_data_kea.c, formula = formula.c, random.terms = random.terms)
Tef_est.n <- tefMcmcglmm(mulTree.data = tef_data_kea.n, formula = formula.n, random.terms = random.terms)

median(Tef_est.c$tef_global)
median(Tef_est.n$tef_global)

# Plot the aggregated posteriors of the estimated TEF from all chains,
# as a MCMC line trace (left panel) and as a posterior density kernel 
# (right panel)
plot(Tef_est$tef_global)

