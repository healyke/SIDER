
# Test document. To be used as an example etc.


if(!require(devtools)) install.packages("devtools")
install_github("healyke/Fester", ref = "master")
install_github("TGuillerme/mulTree", ref = "master")
library(mulTree)
library(FestR)


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
tef_data_kea.c <- tefMulClean(new.data = new_data_test, data = mydata, species_col_name = "species", 
							  trees =  combined_trees, taxonomic.class = "aves", isotope = "carbon")
tef_data_kea.n <- tefMulClean(new.data = new_data_test, data = mydata, species_col_name = "species", 
							  trees =  combined_trees, taxonomic.class = "aves", isotope = "nitrogen")

# define the model to be used for prediction
formula.c <- delta13C ~ source.iso.13C + diet.type + habitat

formula.n <- delta15N ~ source.iso.15N + diet.type + habitat

random.terms = ~ animal + sp.col + tissue

prior_tef <- list(R = list(V = 1/4, nu=0.002), G = list(G1=list(V = 1/4, nu=0.002),
					G2=list(V = 1/4, nu=0.002), G3=list(V = 1/4, nu=0.002)))


###set directory somewhere that you can access the model files run by the model
#setwd("c:/path/to/my/directory/at/work")

Tef_est.c <- tefMcmcglmm(mulTree.data = tef_data_kea.c, formula = formula.c, random.terms = random.terms, 
						 prior = prior_tef, output = "kea_c_test", nitt = c(1200000),  thin = c(500),  
						 burnin = c(200000), no.chains = c(2), convergence =  c(1.1), ESS = c(1000))
Tef_est.n <- tefMcmcglmm(mulTree.data = tef_data_kea.n, formula = formula.n, random.terms = random.terms,
						 prior = prior_tef, output = "kea_n_test", nitt = c(1200000),  thin = c(500),  
						 burnin = c(200000), no.chains = c(2), convergence =  c(1.1), ESS = c(1000))
hist(Tef_est.c$tef_global)
median(Tef_est.c$tef_global)
hist(Tef_est.n$tef_global)
median(Tef_est.n$tef_global)

# Plot the aggregated posteriors of the estimated TEF from all chains,
# as a MCMC line trace (left panel) and as a posterior density kernel 
# (right panel)
plot(Tef_est$tef_global)

