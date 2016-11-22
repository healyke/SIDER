#' @title Simple isotope estimation.
#'   
#' @description Runs a simple isotope estimation with the minimum number of parameters.
#'   
#' @param species a binomial species name from a mammal or a bird.
#' @param habitat a character string of either \code{"marine"} or \code{"terrestrial"}.
#' @param tissue the tissue type. Can be one of the following: \code{c("blood", "claws", "collagen", "feather", "hair", "kidney", "liver", "milk", "muscle")}.
#' @param diet.type the diet type. Can be one of the following: \code{c("carnivore", "herbivore", "omnivore",  "pellet")}.
#' @param isotope the isotope for which discrimination factor is to be imputed,  either \code{"carbon"} or \code{"nitrogen"}.
#' @param verbose whether to be verbose or not (\code{default = TRUE}).
#' 
#' @details
#' The estimation is run on a single randomly selected tree with fixed MCMC parameters.
#' 
#' @return The estimated isotope value.
#'   
#' @author Thomas Guillerme
#'   
#' @examples
#' 
#' 
#' brewSider(species = "Meles_meles", habitat = "terrestrial", tissue = "blood",
#'       diet.type = "omnivore", isotope = "carbon")
#' 
#' @export


## DEBUG
# species = "Meles_meles"
# habitat = "terrestrial"
# tissue = "blood"
# diet.type = "omnivore"
# isotope = "carbon"

brewSider <- function(species, habitat, tissue, diet.type, isotope, verbose = TRUE) {
    
    ## Load the inbuilt data
    utils::data(combined_trees)
    utils::data(isotope_data)

    ## Figure our the taxonomic class
    if(!missing(species)) {
        if(class(species) == "character") {
            taxonomic.class <- NULL
            tree <- NULL
            if(match(species, combined_trees[[1]]$tip.label)) {
                taxonomic.class <- "mammalia"
                tree <- combined_trees[[1]]
            }
            if(match(species, combined_trees[[2]]$tip.label)) {
                taxonomic.class <- "aves"
                tree <- combined_trees[[2]]
            }
            if(is.null(taxonomic.class)) {
                stop("Species is not a mammal or an aves present in the database")
            }
        } else {
            stop("Species is not a mammal or an aves present in the database")
        }
    } else {
        stop("Species name is missing!")
    }

    ## Set up the recipe
    sider_recipe <- recipeSider(species = species,
                                taxonomic.class = taxonomic.class,
                                tissue = tissue,
                                diet.type = diet.type,
                                habitat = habitat,
                                tree = tree)

    ## Prepare the ingredients
    sider_prepare <- prepareSider(data.estimate = sider_recipe,
                                  data.isotope = isotope_data,
                                  tree = tree,
                                  isotope = isotope)

    ## Set up the MCMCglmm formula
    if(isotope == "carbon") {
        formula = delta13C ~ diet.type + habitat
    } else {
        formula = delta15N ~ diet.type + habitat 
    }

    ## Run the MCMC
    if(verbose) cat("SIDER is brewing. This can take several minutes...\n")
    sider_brew <- imputeSider(mulTree.data = sider_prepare,
                              formula = formula,
                              parameters = c(1200000, 200000, 500), #TG: Maybe needs different parameters, this takes 6 minutes on my machine!
                              chains = 2,
                              convergence = 1.1, 
                              ESS = 1000,
                              output = "brew_sider_temp", 
                              save.model = FALSE,
                              verbose = verbose)
    if(verbose) cat("Done!")
    
    plot(sider_brew[[2]]) #TG: Needs some nicer graphical option
    
    return(summary(sider_brew$tdf_estimates)) #TG: Needs some kind of nice summary function
}