#' @title Matching phylogenies and data frames
#'   
#' @description Matches phylogenies and data into a \code{mulTree} object.
#'   
#' @param new.data data for species to be imputed (see \code{\link{setTdfEst}}).
#' @param data a \code{data.frame} object matching phylogeny.
#' @param species.col.name name of column containing binomial species names.
#' @param tree a \code{phylo} or \code{multiPhylo} object.
#' @param isotope the isotope for which discrimination factor is to be imputed,
#'   either \code{"carbon"} or \code{"nitrogen"}.
#' @param taxonomic.class the class of species as a character string, either
#'   \code{"mammalia"} or \code{"aves"}.
#' @param random.terms an object of class \code{formula} describing the random
#'   effects.
#'   
#' @return A \code{mulTree} object.
#'   
#' @export
	
tdfMulClean <- function(new.data = c(), 
                        data = data, 
                        species.col.name = c("species"), 
                        tree, 
                        isotope = c("carbon","nitrogen"), 
                        taxonomic.class =  c("mammalia","aves") , 
                        random.terms = ~ animal + species + tissue) {
		
  # Decide on which animal class. I think this will be a good thing to 
  # include as it will edge people towards an appropriate analysis 
  # (i.e. avoid the fact that feathers and hair will already divide the 
  # data into these groups but in a less interpretable way) 
  # Currently this is hard-coded to be either "mammalia" or "aves". 
  # Foreseeable additions would be fish and herps. But ultimately, it
  # could be coded to be open, thereby allowing a tree and appropriate 
  # model to be subsetted.

	if((taxonomic.class== "mammalia") == T){ 
	  iso_data_class <- data[data$taxonomic.class == "mammalia",]
	} else {
		if((taxonomic.class == "aves") == T){ 
		  iso_data_class <- data[data$taxonomic.class == "aves",]
		}
		else{ iso_data_class <- data}
	}
		
		
		
  #####decide on the isotope###
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
		
  
  
  # get rid on NAs so that the only NAs are for the new data
  iso_data_sub_na <-  stats::na.omit(iso_data_class)
  
  # ------------------------------------------------------------------------------
  
  # Include the new data, I bind it so its at the top and hence easier 
  # to read.
  
  if(is.null(new.data) == T){
    iso_data_com <- iso_data_sub_na
  } else{ 
    iso_data_com  <- rbind(new.data_sub , iso_data_sub_na)
  }
  
  
  
  ####Clean the data and match up the tree using the multree function
  

  
  clean_iso <-	mulTree::as.mulTree(taxa = species.col.name, 
                                   data = iso_data_com, 
                                   tree = tree, 
                                   clean.data = TRUE)
  
  ##this was there to make it work with only one tree should be good now.
  #clean_iso <- clean.data(species.col.name, iso_data_com, tree, rand.terms)
  
  
  
  #####fix that random term by checking if any of the random terms are the same 
  # as the species column and replacing that with sp.col as the mulTree function does
  #		if(any(grep(species.col.name ,random)) == TRUE){
  #			clean_iso$random.terms <-as.formula( gsub("species","sp.col", random))
  #			} else{ clean_iso$random.terms <-as.formula( random)	
  #			}
  
  # AJ don't think we need to force the class as that what as.mulTree returns.
  # set the class of the object to mulTree
  # class(clean_iso) <- 'mulTree'
  
  # return the created object
  return(clean_iso)		
  
}





