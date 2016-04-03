#' @title Matching phylogenies and data frames
#' 
#' @description Matches phylogenies and data into a \code{mulTree} object.
#' 
#' @param new.data data for species to be imputed (see \code{\link{setTefEst}}).
#' @param data a \code{data.frame} object matching phylogeny.
#' @param species.col.name name of column containing binomial species names.
#' @param tree a \code{phylo} or \code{multiPhylo} object.
#' @param isotope the isotope for which discrimination factor is to be imputed, either \code{"carbon"} or \code{"nitrogen"}.
#' @param taxonomic.class the class of species as a character string, either \code{"mammalia"} or \code{"aves"}.
#' @param random.terms an object of class \code{formula} describing the random effects.
#'
#' @return A \code{mulTree} object.
#'
#' @example
#' ##
#' 
#' @authors Kevin Healy
#' 
#' @export
	
tefMulClean <- function(new.data = c(), 
                        data = data, 
                        species.col.name = c("species"), 
                        tree, 
                        isotope = c("carbon","nitrogen"), 
                        taxonomic.class =  c("mammalia","aves") , 
                        random.terms = ~ animal + species + tissue) {
		

#new.data = new_data_test
#data = mydata
#species.col.name = "species"
#tree =  combined_tree
#taxonomic.class = "mammalia"
#isotope = "carbon"

		
#####decide on which class##### I think this will be a good thing to include as it will edge people towards an approapriate analysis (i.e. avoid the fact that feathers and hair will already divide the data into these groups but in a less interpreatable way) #need to fix this to be open.

	if((taxonomic.class== "mammalia") == T){ iso_data_class <- data[data$taxonomic.class == "mammalia",]
	} else {
		if((taxonomic.class == "aves") == T){ iso_data_class <- data[data$taxonomic.class == "aves",]
		}
		else{ iso_data_class <- data}
	}
		
		
		
#####decide on the isotope###
  ## AJ - the column names in these dataset are a mess!!
	if((isotope == "carbon") == T){
		dropN <- names(data) %in% c("source.iso.15N","delta15N")
		iso_data_class  <- iso_data_class[!dropN]
				
				dropnewN <- names(new.data) %in% c("source.iso.15N","delta15N")
		new.data_sub  <- new.data[!dropnewN]
		
	} else{ 
		if((isotope == "nitrogen") == T){
			dropC <- names(data) %in% c("source.iso.13C","delta13C")
			iso_data_class  <- iso_data_class[!dropC]
			
						dropnewC <- names(new.data) %in% c("source.iso.13C","delta13C")
		new.data_sub  <- new.data[!dropnewC]
			
			}
	
		}
		

		
########get rid on NAs so that the only NAs are for the new data

		iso_data_sub_na <-  na.omit(iso_data_class)

######## Include the new data, I bind it so its at the top and hence easier to read.
	
	if(is.null(new.data) == T){
		iso_data_com <- iso_data_sub_na
	} else{ 
			iso_data_com  <- rbind(new.data_sub , iso_data_sub_na)
		}
		
	
		
####Clean the data and match up the tree using the multree function


#####this needs to be fixed so that it actually removes the dataset.

			clean_iso <-	as.mulTree(taxa = species.col.name, data = iso_data_com, tree = tree, clean.data = TRUE)
		
		##this was there to make it work with only one tree should be good now.
		#clean_iso <- clean.data(species.col.name, iso_data_com, tree, rand.terms)
	
		
		
#####fix that random term by checking if any of the random terms are the same as the species colume and replacing that with sp.col as the Multre function does
#		if(any(grep(species.col.name ,random)) == TRUE){
#			clean_iso$random.terms <-as.formula( gsub("species","sp.col", random))
#			} else{ clean_iso$random.terms <-as.formula( random)	
#			}
		
			class(clean_iso)<-'mulTree'
		return(clean_iso)		

}



		












	
	
