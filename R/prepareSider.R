#' @title Matching phylogenies and data frames
#'   
#' @description Matches phylogenies and data into a \code{mulTree} object.
#'   
#' @param data.estimate data for species to be imputed (see
#'   \code{\link{recipeSider}}).
#' @param data.isotope a \code{data.frame} containing isotope data. If missing 
#'   the \code{\link{isotope_data}} dataset will be used.
#' @param tree a \code{phylo} or \code{multiPhylo} object.
#' @param isotope the isotope for which discrimination factor is to be imputed, 
#'   either \code{"carbon"} or \code{"nitrogen"}.
#' @param random.terms an object of class \code{formula} describing the random 
#'   effects. By default the random terms are \code{"~ animal + species +
#'   tissue"}. Note that "animal" designates phylogeny in
#'   \code{\link[MCMCglmm]{MCMCglmm}}.
#'   
#' @return A \code{mulTree} object.
#'   
#' @examples
#' ## Load the combined trees data
#' #data(combined_trees)
#' 
#' ## Initialise the data in the right format
#' new.data.test <- recipeSider(species = "Meles_meles", habitat = "terrestrial", 
#'    taxonomic.class = "mammalia", tissue = "blood", diet.type = "omnivore", 
#'    tree = combined_trees)
#' 
#' ## Load the isotope data
#' #data(isotope_data)
#' 
#' ## Generate the mulTree object to be passed to imputeSider()
#' tdf_data_c <- prepareSider(data.estimate = new.data.test,
#'    data.isotope = isotope_data, tree = combined_trees, isotope = "carbon")
#' 
#' @seealso \code{\link{recipeSider}}, \code{\link{combined_trees}},
#'   \code{\link{isotope_data}}, \code{\link[mulTree]{as.mulTree}}.
#'   
#' @export
      
#DEBUGGING
# warning("DEBUG - prepareSider")
# utils::data(combined_trees);
# utils::data(isotope_data)
# new.data.test <- recipeSider(species = "Meles_meles", habitat = "terrestrial", 
#    taxonomic.class = "mammalia", tissue = "blood", diet.type = "omnivore", 
#    tree = combined_trees)

# data.estimate <- new.data.test
# data.isotope <- isotope_data
# isotope <- "carbon"
# tree <- combined_trees
# random.terms = ~ animal + species + tissue

# tdf_data_c <- prepareSider(data.estimate = new.data.test, 
#                           data.isotope = isotope_data, 
#                           tree = combined_trees,  
#                           isotope = "carbon")

prepareSider <- function(data.estimate, data.isotope, tree, isotope, 
                         random.terms = ~ animal + species + tissue) {
            
  # Decide on which animal class. I think this will be a good thing to 
  # include as it will edge people towards an appropriate analysis 
  # (i.e. avoid the fact that feathers and hair will already divide the 
  # data into these groups but in a less interpretable way) 
  # Currently this is hard-coded to be either "mammalia" or "aves". 
  # Foreseeable additions would be fish and herps. But ultimately, it
  # could be coded to be open, thereby allowing a tree and appropriate 
  # model to be subsetted.


  # SANITIZING

  # data.estimate
  if(any(is.na(match(c("species", "habitat", "taxonomic.class", "tissue", 
                       "diet.type", "source.iso.13C", "delta13C", 
                       "source.iso.15N", "delta15N"), names(data.estimate))))) {
    stop("data.estimate is not in the right format!\nUse recipeSider() for setting up the right format.")
  }

  # ** AJ BEGIN COMMENT OUT **
  # AJ - this section is not loading the data appropriately  and is failing
  # R CMD check. With it commented out like this, the testthat tests are 
  # failing. 

  # data.isotope
  if(missing(data.isotope)) {
    # If data.isotope is missing, use the default one from the package

    # AJ - this call to data() is spawning a NOTE from R CMD check.
    # I think my interpretation of it is that we don't need to reload the
    # the object into the global environment, since it should already be
    # available via lazy loading on library(SIDER)
    #utils::data(isotope_data, envir = environment())
    data.isotope <- SIDER::isotope_data
    # And fire a warning!
    warning("No isotopic data was provided, the default SIDER data set will be used.\nSee ?isotope_data for more information.")
  } else {
    # Check if it's the standard format
    # AJ - as per my comment above re lazy loading
    #utils::data(isotope_data, envir = environment())
    # Names must match
    if(any(is.na(match(names(SIDER::isotope_data), names(data.isotope))))) {
      stop("The isotope dataset must be matching the default SIDER data set.\nSee ?isotope_data for more information.")
    }
    # TG: missing a way to check the content of the user's table is correct!
  }

  # ** AJ END COMMENT OUT **
  
  # tree
  if(class(tree) != "phylo") {
    if(class(tree) != "multiPhylo") {
      stop("tree argument must be of class 'phylo' or 'multiPhylo'.")
    }
  }

  # isotope
  if(missing(isotope)){
    stop("Isotope to be imputed is missing.")
  } else {
    all_isotopes <- c("carbon", "nitrogen")
    if(all(is.na(match(isotope, all_isotopes)))) {
      stop("Isotope argument must be one of the following:\n", 
           paste(all_isotopes, collapse = ", "), ".", sep = "")
    }
  }

  # Random terms
  if(class(random.terms) != "formula") {
    stop("Random terms must be a formula with 'animal' as the first element.")
  } else {
    if(length(grep("animal", as.character(random.terms)[[2]])) == 0) {
      stop("Random terms must be a formula with 'animal' as the first element.")
    }
  }

  # Setting up the mulTree data for isotope estimation

  #Setting the isotopic data for the right class
  taxonomic_class <- unique(data.estimate$taxonomic.class)
  if(length(taxonomic_class) != 1) {
    stop("The taxonomic class can only be 'mammalia' or 'aves'.\nSee recipeSider function for more information.")
  }

  if(taxonomic_class == "mammalia" | 
     taxonomic_class == "aves") {
    iso_data_class <- data.isotope[data.isotope$taxonomic.class == taxonomic_class,]
  } else {
    stop("The taxonomic class can only be 'mammalia' or 'aves'.\nSee recipeSider function for more information.")
  }
            
  #Decide on the isotope
  if(isotope == "carbon") {
    dropN <- names(data.isotope) %in% c("source.iso.15N","delta15N")
    iso_data_class  <- iso_data_class[!dropN]
    
    dropnewN <- names(data.estimate) %in% c("source.iso.15N","delta15N")
    new.data_sub  <- data.estimate[!dropnewN]
  }

  if(isotope == "nitrogen"){
    
    dropC <- names(data.isotope) %in% c("source.iso.13C","delta13C")
    iso_data_class  <- iso_data_class[!dropC]
    
    dropnewC <- names(data.estimate) %in% c("source.iso.13C","delta13C")
    new.data_sub  <- data.estimate[!dropnewC]
    
  }
  
  # get rid on NAs so that the only NAs are for the new data
  iso_data_sub_na <-  stats::na.omit(iso_data_class)
    
  # Include the new data, I bind it so its at the top and hence easier to read.
  
  if(is.null(data.estimate) == T){
    iso_data_com <- iso_data_sub_na
  } else{ 
    iso_data_com  <- rbind(new.data_sub , iso_data_sub_na)
  }

  #Clean the data and match up the tree using the multree function
  #TG: I've added the cleaning function prior to as.mulTree. 
  # This way it doesn't polute the console with huge lists of dropped taxa.
  cleaned_iso_data_com <- mulTree::clean.data("species", iso_data_com, tree)
  clean_iso <- mulTree::as.mulTree(taxa = "species", 
                                   data = cleaned_iso_data_com$data, 
                                   tree = cleaned_iso_data_com$tree)
  #Forcing the random terms
  env_tmp <- environment(clean_iso$random.terms)
  clean_iso$random.terms <- random.terms
  environment(clean_iso$random.terms) <- env_tmp
  
  ##this was there to make it work with only one tree should be good now.
  #clean_iso <- clean.data(species.col.name, iso_data_com, tree, rand.terms)
  
  #####fix that random term by checking if any of the random terms are the same 
  # as the species column and replacing that with sp.col as the mulTree function does
  #            if(any(grep(species.col.name ,random)) == TRUE){
  #                  clean_iso$random.terms <-as.formula( gsub("species","sp.col", random))
  #                  } else{ clean_iso$random.terms <-as.formula( random)      
  #                  }
  
  
  # return the created object
  return(clean_iso)            
  
}





