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

setTdfEst <- function(species, taxonomic.class, tissue, diet.type, habitat, source.iso.13C, source.iso.15N, tree)
{
  ###check if each of the inputs matches the categories we want.

  ###check species
  if(missing(species)){
    stop("Species is missing.")
  }

  ##check habitat data
  if(is.null(habitat)){
    warning("Data for habitat is missing.") 
  } else {
    all_habitats <- c("marine", "terrestrial")
    if(all(is.na(match(habitat, all_habitats)))) {
      stop("Habitat argument must be one of the following:\n", paste(all_habitats, collapse = ", "), ".", sep = "")
    }
  }

  ##check class data
  if(is.null(taxonomic.class)){
      warning("Data for taxonomic class is missing.")
  } else {
    all_class <- c("mammalia", "aves")
    if(all(is.na(match(taxonomic.class, all_class)))) {
      stop("Taxonomic class argument must be one of the following:\n", paste(all_class, collapse = ", "), ".", sep = "")
    }
  }

  ##check tissue data
  if(is.null(tissue)){
    warning("Data for tissue is missing.")
  } else {
    all_tissues <- c("blood", "claws", "collagen", "feather", "hair", "kidney", "liver", "milk", "muscle")
    if(all(is.na(match(tissue, all_tissues)))) {
      stop("Tissue argument must be one of the following:\n", paste(all_tissues, collapse = ", "), ".", sep = "")
    }
  }

  ##check diet_type data
  if(is.null(diet.type)){
    warning("Data for diet.type is missing.")
  } else {
    all_diets <- c("carnivore", "herbivore", "omnivore", "pellet")
    if(all(is.na(match(diet.type, all_diets)))) {
      stop("Diet argument must be one of the following:\n", paste(all_diets, collapse = ", "), ".", sep = "")
    }
  }


  ##check iso data is there and warn user if they are going to use it
  if(is.null(source.iso.13C) | is.null(source.iso.15N)){
    source.iso.13C <- NA
    source.iso.15N <- NA
  } else if(any(c(class(source.iso.13C), class(source.iso.15N)) != "numeric")){
    warning("Source isotopic data not numeric.")
    warning("Only include isotopic food isotopic values if derived from controlled dietary settings.")
  } else {
    #TG: is this warning necessary?
    #warning("Only include isotopic food isotopic values if derived from controlled dietary settings")
  } 
   
  ###check if there is a tree and what type of tree it is
  if(is.null(tree)){
      stop("Phylogeny is missing. Use\ndata(combined_trees)\nfor loading mammalian and aves phylogenies.")
  } else if (!any(class(tree) == "multiPhylo" | class(tree) == "phylo")) {
      stop("Phylogeny must be a phylo or multiPhylo object.")
  } else {
    #check if the species is in the tree and report finding.
    if(class(tree) == "multiPhylo"){
      test_species <- unlist(lapply(tree, function(X) any(X$tip.label == species)))
    } 
    if(class(tree) == "phylo") {
      test_species <- any(tree$tip.label == species)
    }
    if(!any(test_species)) {
      stop(species, " is not present in the phylogeny.")
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
                         stringsAsFactors = FALSE) 

  return(new.data)
}