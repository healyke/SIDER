#' @title Specifying observations to be imputed.
#'   
#' @description Specifies which observation to impute.
#'   
#' @param species a binomial species name as a character string.
#' @param habitat a character string of either \code{"marine"} or
#'   \code{"terrestrial"}.
#' @param taxonomic.class the class of species as a character string, either
#'   \code{"mammalia"} or \code{"aves"}.
#' @param tissue the tissue type. Can be one of the following: \code{c("blood",
#'   "claws", "collagen", "feather", "hair", "kidney", "liver", "milk",
#'   "muscle")}.
#' @param diet.type the diet type. Can be one of the following:
#'   \code{c("carnivore", "herbivore", "omnivore",  "pellet")}.
#' @param source.iso.13C the source carbon isotopic value (must be
#'   \code{numeric}).
#' @param source.iso.15N the source nitrogen isotopic value (must be
#'   \code{numeric}).
#' @param tree a \code{phylo} or \code{multiPhylo} object.
#'   
#' @return A \code{data.frame} object with one row being a checked species for
#'   imputation.
#'   
#' @author Kevin Healy
#'   
#'   
#' @export

setTdfEst <- function(species = c(),
                      taxonomic.class = c("mammalia", "aves", NA),
                      tissue = c("blood", "claws", "collagen", "feather", 
                                 "hair", "kidney", "liver", "milk", 
                                 "muscle", NA), 
                      diet.type = c("carnivore", "herbivore", 
                                    "omnivore",  "pellet", NA),
                      habitat = c("marine", "terrestrial", NA), 
                      source.iso.13C = c(), 
                      source.iso.15N = c(), 
                      tree = c()){
    


  ###check if each of the inputs matches the categories we want.

  ###check species
  if(is.null(species)){
    stop("species missing")
  }

  ##check habitat data
  if(is.null(habitat)){
      warning("Data for habitat missing") 
  } else if(!any( habitat == c("marine", "terrestrial"))){
      warning("habitat levels do not match dataset from Healy et al 2016") 
  }

  ##check class data
  if(is.null(taxonomic.class)){
      warning("Data for taxonomic.class missing")
  } else if(!any(taxonomic.class == c("mammalia", "aves"))){
      warning("taxonomic.class levels do not match dataset from 
              Healy et al 2016")
  }

  ##check tissue data
  if(is.null(tissue)){
      warning("Data for tissue missing")
  } else if(!any( tissue == c("blood", "claws", "collagen", "feather", 
                             "hair", "kidney", "liver", "milk", 
                             "muscle"))){
      warning("tissue levels do not match dataset from Healy et al 2016")
  }

  ##check diet_type data
  if(is.null(diet.type)){
      warning("Data for diet.type missing")
  } else if(!any( diet.type == c("carnivore", 
                                "herbivore", 
                                "omnivore",  
                                "pellet"))) {
      warning("diet.type levels do not match dataset from Healy et al 2016")
  }


  ##check iso data is there and warn user if they are going to use it
  if(is.null(source.iso.13C) | is.null(source.iso.15N)){
    source.iso.13C <- NA
    source.iso.15N <- NA
  } else if(any(c(class(source.iso.13C), class(source.iso.15N)) != "numeric")){
    warning("Source isotopic data not numeric")
    warning("Only include isotopic food isotopic values if derived from controlled dietary settings")
  } else {
    #TG: is this warning necessary?
    #warning("Only include isotopic food isotopic values if derived from controlled dietary settings")
  } 
   
  ###check if there is a tree and what type of tree it is
  if(is.null(tree)){
      cat("phylogeny is missing: species presence in phylogeny not checked")
  } else if (!any(class(tree) == "multiPhylo" | class(tree) == "phylo")) {
      cat("phylogeny is not a phylo or multiPhylo object: species presence in phylogeny not checked")    
  } else {
    #check if the species is in the tree and report finding.
    if(class(tree) == "multiPhylo"){
      test_species <- any(unlist(lapply(tree, function(X) any(X == species))))
    } 
    if(class(tree) = "phylo") {
      test_species <- any(tree$tip.label == species)
    }
    if(!test_species) {
      cat(species, "is not present in the phylogeny.\n")
    }
  }

  ###put it in a data.frame with stringsAsFactors turned off.
  new.data <- data.frame(species = species, 
                         habitat = habitat, 
                         taxonomic.class = taxonomic.class, 
                         tissue = tissue, 
                         diet.type = diet.type, 
                         source.iso.13C = source.iso.13C, 
                         delta13C = NA, 
                         source.iso.15N = source.iso.15N, 
                         delta15N = NA, 
                         stringsAsFactors = F) 

  return(new.data)
}