## ----install_mulTree, results = "hide", message = FALSE, eval = FALSE----
#  # Installing devtools
#  if(!require(devtools)) install.packages("devtools")
#  
#  # Installing mulTree
#  # if(!require(mulTree)) devtools::install_github("TGuillerme/mulTree#34")
#  library(mulTree)

## ----install_SIDER, results = "hide", message=FALSE, eval = FALSE--------
#  # Installing SIDER
#  # if(!require(SIDER)) devtools::install_github("healyke/SIDER@release", ref = "master")
#  library(SIDER)

## ----load_pakages, results="hide", message=FALSE, warning=FALSE----------
library(SIDER)

## ----read_data-----------------------------------------------------------
# Read in the data
SIDER.data <- read.csv(file = system.file("extdata", 
                                          "SIDER_data.csv", 
                                          package = "SIDER"), 
                       header = TRUE,
                       stringsAsFactors = FALSE)

# View the first 10 rows of the data frame
head(SIDER.data)

# Read in the phylogenetic information
# The mammal trees
mammal_trees <- ape::read.tree(system.file("extdata", 
                                      "3firstFritzTrees.tre", 
                                      package = "SIDER"))
# The bird trees
bird_trees   <- ape::read.tree(system.file("extdata", 
                                      "3firstJetzTrees.tre", 
                                      package = "SIDER"))

# Combine them together using the tree.bind function from the mulTree package
combined_trees <- mulTree::tree.bind(x = mammal_trees, 
                                     y = bird_trees, 
                                     sample = 2, 
                                     root.age = 250)

## ----check_species-------------------------------------------------------
# Checking the data for the species we want to estimate TEF for (Meles meles)
new.data.test <- recipeSider(species = "Meles_meles", 
                             habitat = "terrestrial", 
                             taxonomic.class = "mammalia", 
                             tissue = "blood", 
                             diet.type = "omnivore", 
                             tree = combined_trees)

## ----species_absent, eval = FALSE----------------------------------------
#  # Some incomplete dataset
#  new.data.test <- recipeSider(species = "Varanus_komodoensis",
#                               habitat = "terrestrial",
#                               taxonomic.class = "mammalia",
#                               tissue = "NA",
#                               diet.type = "omnivore",
#                               tree = combined_trees)

## ----format_data---------------------------------------------------------
tdf_data_c <- prepareSider(new.data.test, 
                          isotope_data, 
                          combined_trees, 
                          "carbon")

## ----multi_phlyos--------------------------------------------------------
tdf_data_c$phy

## ----head_data-----------------------------------------------------------
head(tdf_data_c$data)

## ----fixed_effects-------------------------------------------------------
formula.c <- delta13C ~ diet.type + habitat

## ----random_effects------------------------------------------------------
random.terms <- ( ~ animal + species + tissue)

## ----define_priors-------------------------------------------------------
prior <- list(R = list(V = 1, nu=0.002), 
              G = list(G1=list(V = 1, nu=0.002),
                       G2=list(V = 1, nu=0.002), 
                       G3=list(V = 1, nu=0.002)))

## ----mcmc_parameters-----------------------------------------------------
nitt <- c(10)
burnin <- c(1)
thin <- c(1)
parameters <- c(nitt, thin, burnin)
no.chains <- c(2)

## ----mcmc_parameters2, eval = FALSE--------------------------------------
#  nitt <- c(1200000)
#  burnin <- c(200000)
#  thin <- c(500)
#  no.chains <- c(2)

## ----convergence_criteria------------------------------------------------
convergence =  c(1.1)
ESS = c(1000)

## ----eval_glmm-----------------------------------------------------------
origwd <- getwd() # get the current, or original working directory.
 setwd(tempdir()) # 
TDF_est.c <- imputeSider(mulTree.data = tdf_data_c, 
                         formula = formula.c, 
                         random.terms = random.terms,
                         prior = prior, 
                         output = "test_c_run",
                         parameters = parameters,
                         chains = no.chains, 
                         convergence =  convergence, 
                         ESS = ESS)



###Now lets have a look at the files imputeSider has saved to the current working directory
list.files(pattern = "test_c_run")


## ----summarise_results---------------------------------------------------
# Explore the names of the list created by SIDER::imputeSider
names(TDF_est.c)

# Calculate summary statistics of the posterior. 
# Specifically, the mean and standard deviation would be
# taken from here and used in a mixing model analysis using 
# MixSIAR, MixSIR or SIAR for example.
summary(TDF_est.c$tdf_global)

# Credible intervals and the mode of the posterior are obtained 
# using the hdrcde package
hdrcde::hdr(TDF_est.c$tdf_global, prob = c(50, 95, 99))

# You can also create density plots of the posterior
coda::densplot(TDF_est.c$tdf_global)

## ----tidy-up, echo = FALSE, message = FALSE, warning = FALSE-------------
file.remove(list.files(pattern = "test_c_run"))

