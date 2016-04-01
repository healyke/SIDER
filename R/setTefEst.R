#' Specify the observation to be imputed.
#' 
#' @param species a binomial species name as a character string.
#' @param habitat a character string of either "marine" or "terrestrial"
#' @param taxonomic.class the class of species as a character string, either "mammalia" or
#'   "aves"
#' @param tissue the tissue type as a character string taking one of
#'   \code{c("blood", "claws", "collagen", "ceather", "hair", "kidney", "liver",
#'   "milk", "muscle")}
#' @param diet.type the diet type as a character string taking one of
#'   \code{c("carnivore", "herbivore", "omnivore",  "pellet")}
#' @param iso_13C source carbon isotopic value is available numeric
#' @param iso_15N source nitrogen isotopic value is available numeric
#' @param phylogeny The full phylogenetic tree or set of trees as a
#'   (multi-)phylo object.
#'   
#' @return A dataframe object of row length 1 comprising a checked species for
#'   imputation.
#'   
#' @export




setTefEst <- function(species = c(), 
                      habitat = c("marine", "terrestrial", NA), 
                      taxonomic.class = c("mammalia", "aves", NA), 
                      tissue = c("blood", "claws", "collagen", "feather", 
                                 "hair", "kidney", "liver", "milk", 
                                 "muscle", NA), 
                      diet.type = c("carnivore", "herbivore", 
                                    "omnivore",  "pellet", NA), 
                      source.iso.13C = c(), 
                      source.iso.15N = c(), 
                      phylogeny = c()){
	


###check if each of th inputs matches the catagories we want.

###check species
if(is.null(species) == TRUE){stop("species missing")}

##check habitat data
if(is.null(habitat) == TRUE){warning("Data for habitat missing")
	} else if(any( habitat == c("marine", "terrestrial")) != TRUE){
			warning("habitat levels do not match dataset from Healy et al 2016")}

##check class data
if(is.null(taxonomic.class) == TRUE){
	warning("Data for taxonomic.class missing")
	
	} else if(any(taxonomic.class == c("mammalia", "aves")) != TRUE){
			warning("taxonomic.class levels do not match dataset 
			from Healy et al 2016")}
			
##check tissue data
if(is.null(tissue) == TRUE){warning("Data for tissue missing")
	} else if(any( tissue == c("blood", "claws", "collagen", 
		"feather", "hair", "kidney", "liver", "milk", "muscle")) 
		!= TRUE){
		warning("tissue levels do not match dataset from 
		Healy et al 2016")}
			
##check diet_type data
if(is.null(diet.type) == TRUE){warning("Data for diet.type missing")
	} else if(any( diet.type == c("carnivore", "herbivore", 
	                              "omnivore",  "pellet")) != TRUE){
		warning("diet.type levels do not match dataset from 
		Healy et al 2016")}

##check iso data is there. This only checks one of the cases.
if(is.null(source.iso.13C)|is.null(source.iso.15N) == TRUE){
	warning("No source isotopic data")
	source.iso.13C <- NA
	source.iso.15N <- NA
	} else if(any(c(class(source.iso.13C),class(source.iso.15N)) == "numeric") != TRUE){
			warning("source isotopic data not numeric")}
	
				
	
###check if there is a tree and what type of tree it is
if(is.null(phylogeny) == TRUE){	 
	cat("phylo missing: species presence in phylogeny not checked")
}	else if((class(phylogeny) == "multiPhylo") == TRUE){
	phylo_test <- phylogeny[[1]]
}		else if((class(phylogeny) == "phylo") == TRUE){
	phylo_test <- phylogeny
}	else{cat("phylo not a phlyo or multiPhylo object: species presence in 
	           phylogeny not checked")}	
	
#check if the species is in the tree
if(any(phylo_test $tip.label == species) == TRUE){
			cat(species, "present in phylogeny")
} else{cat(species, "not present in phylogeny")}
	



###put it in a data.frame with stringsAsFactors turned off.
new.data <- data.frame( species = species, 
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




	








	
	
