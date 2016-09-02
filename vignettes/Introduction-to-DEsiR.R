## ----install_mulTree, results="hide", message=FALSE----------------------
if(!require(devtools)) install.packages("devtools")
if(!require(mulTree)) install_github("TGuillerme/mulTree", ref = "master")

## ----install_DEsiR, results="hide", message=FALSE------------------------
if(!require(DEsiR)) install_github("healyke/DEsiR", ref = "master")

## ----load_pakages, results="hide", message=FALSE, warning=FALSE----------
#library(mulTree)
library(DEsiR)

## ------------------------------------------------------------------------

#read in the data
DEsiR.data <-read.csv(file=system.file("extdata", "DEsiR_data.csv", package = "DEsiR"),
 header=T, stringsAsFactors = F)

head(DEsiR.data)

#read in the phylogenetic information
#first the mammal trees
mammal_trees <- read.tree(system.file("extdata", 
                                      "3firstFritzTrees.tre", 
                                      package = "DEsiR"))
#then the bird trees
bird_trees   <- read.tree(system.file("extdata", 
                                      "3firstJetzTrees.tre", 
                                      package = "DEsiR"))

#combine them together using the tree.bind function from the mulTree package
combined_trees<-tree.bind(x = mammal_trees, y = bird_trees, sample = 2, root.age = 250)

## ------------------------------------------------------------------------
#####function that checks the data for some species we want to estimate TEF for
new.data.test <- setTefEst(species = "Meles_meles", 
                             habitat = "terrestrial", 
                             taxonomic.class = "mammalia", 
                             tissue = "blood", 
                             diet.type = "omnivore", 
                             source.iso.13C = c(-24.1), 
                             source.iso.15N = c(7.0), 
                             tree = combined_trees)

## ---- echo=FALSE---------------------------------------------------------
#####function that checks the dat for some species we want to estimate TEF for
new.data.dummy <- setTefEst(species = "Varanus_komodoensis", 
                             habitat = "terrestrial", 
                             taxonomic.class = "mammalia", 
                             tissue = "NA", 
                             diet.type = "omnivore", 
                             source.iso.13C = c(-24.1), 
                             source.iso.15N = c(7.0), 
                             tree = combined_trees)

## ------------------------------------------------------------------------
tdf_data_c <- tefMulClean(new.data = new.data.test, 
                          data = DEsiR.data, 
                          species.col.name = "species", 
                          tree =  
                          combined_trees, 
                          taxonomic.class = "mammalia", 
                          isotope = "carbon")

## ------------------------------------------------------------------------
tdf_data_c$phy

## ------------------------------------------------------------------------
head(tdf_data_c$data)

## ------------------------------------------------------------------------
formula.c <- delta13C ~ source.iso.13C + diet.type + habitat

## ------------------------------------------------------------------------
random.terms = ~ animal + sp.col + tissue

## ------------------------------------------------------------------------
prior <- list(R = list(V = 1/4, nu=0.002), 
              G = list(G1=list(V = 1/4, nu=0.002),
                       G2=list(V = 1/4, nu=0.002), 
                       G3=list(V = 1/4, nu=0.002)))

## ------------------------------------------------------------------------
# nitt <- c(1200000)
# burnin <- c(200000)
# thin <- c(500)
# no.chains <- c(2)

# NB settings only for testing. need to change
nitt <- c(10)
burnin <- c(1)
thin <- c(1)
no.chains <- c(2)

## ------------------------------------------------------------------------
convergence =  c(1.1)
ESS = c(1000)

## ------------------------------------------------------------------------
getwd()
list.files()

## ------------------------------------------------------------------------
TDF_est.c <- tefMcmcglmm(mulTree.data = tdf_data_c, 
                         formula = formula.c, 
                         random.terms = random.terms, 
                         prior = prior, 
                         output = "test_c_run", 
                         nitt = nitt,  
                         thin = thin,
                         burnin = burnin, 
                         no.chains = no.chains, 
                         convergence =  convergence, 
                         ESS = ESS)

## ------------------------------------------------------------------------
list.files()

## ------------------------------------------------------------------------
names(TDF_est.c)
summary(TDF_est.c$tef_global)
hist(TDF_est.c$tef_global)

