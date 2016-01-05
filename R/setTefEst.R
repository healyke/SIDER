#' Specify the observation to be imputed.
#' 
#' @param species a binomial species name as a character string.
#' @param habitat a character string of either "marine" or "terrestrial"
#' @param Class the class of species as a character string, either "mammalia" or
#'   "aves"
#' @param tissue the tissue type as a character string taking one of
#'   \code{c("blood", "claws", "collagen", "ceather", "hair", "kidney", "liver",
#'   "milk", "muscle")}
#' @param diet_type the diet type as a character string taking one of
#'   \code{c("carnivore", "herbivore", "omnivore",  "pellet")}
#' @param iso_13C ? WE DONT ACTUALLY WANT THIS?
#' @param iso_15N ? WE DONT ACTUALLY WANT THIS?
#' @param phylogeny The full phylogenetic tree or set of trees as a
#'   (multi-)phylo object.
#'   
#' @return A dataframe object of row length 1 comprising a checked species for
#'   imputation.
#'   
#' @export




setTefEst <- function(species = c(), 
                      habitat = c("marine", "terrestrial", NA), 
                      Class = c("mammalia", "aves", NA), 
                      tissue = c("blood", "claws", "collagen", "ceather", 
                                 "hair", "kidney", "liver", "milk", 
                                 "muscle", NA), 
                      diet_type = c("carnivore", "herbivore", 
                                    "omnivore",  "pellet", NA), 
                      iso_13C = c(NA), 
                      iso_15N = c(NA), 
                      phylogeny = c()){
	


###check if each of th inputs matches the catagories we want.

###check species
if(is.null(species) == T){stop("species missing")}

##check habitat data
if(is.null(habitat) == T){warning("Data for habitat missing")
	} else if(any( habitat == c("marine", "terrestrial")) != T){
			warning("habitat levels do not match dataset from Healy et al 2016")}

##check class data
if(is.null(Class) == T){warning("Data for Class missing")
	} else if(any( Class == c("mammalia", "aves")) != T){
			warning("Class levels do not match dataset from Healy et al 2016")}
			
##check tissue data
if(is.null(tissue) == T){warning("Data for tissue missing")
	} else if(any( tissue == c("blood", "claws", "Collagen", "Feather", "hair", 
	                           "kidney", "liver", "milk", "muscle")) != T){
			warning("tissue levels do not match dataset from Healy et al 2016")}
			
##check diet_type data
if(is.null(diet_type) == T){warning("Data for diet_type missing")
	} else if(any( diet_type == c("carnivore", "herbivore", 
	                              "omnivore",  "pellet")) != T){
			warning("diet_type levels do not match dataset from Healy et al 2016")}

##check iso data is there
if(is.null(iso_13C) & is.null(iso_15N) == T){warning("Data for iso missing")
	} else if(any(c(class(iso_13C),class(iso_13C)) == "numeric") != T){
			warning("iso data not numeric")}
	
				
	
###check if there is a tree and what type of tree it is
if(is.null(phylogeny) == T){	 
	cat("phylo missing: species presence in phylogeny not checked")
}	else if((class(phylogeny) == "multiPhylo") == T){
	phylo_test <- phylogeny[[1]]
}		else if((class(phylogeny) == "phylo") == T){
	phylo_test <- phylogeny
}	else{cat("phylo not a phlyo or multiPhylo object: species presence in 
	           phylogeny not checked")}	
	
#check if the species is in the tree
if(any(phylo_test $tip.label == species) == T){
			cat(species, "present in phylogeny")
} else{cat(species, "not present in phylogeny")}
	



###put it in a data.frame with stringsAsFactors turned off.
new.data <- data.frame(species = species, habitat = habitat, Class = Class, 
                       tissue = tissue, diet_type = diet_type, 
                       iso_13C = iso_13C, delta13C = NA, 
                       iso_15N = iso_15N, delta15N = NA, 
                       stringsAsFactors = F) 
	

return(new.data)
}




	








	
	
