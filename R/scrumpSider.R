#' @title Loads isotopic and phylogenetic data
#'   
#' @description Loads isotopic and phylogenetic data for SIDER analysis and
#'   allows to visualise data for specific taxa or visualise specific trees.
#'   
#' @param iso.data A species name (\code{character}, or the \code{numeric} value
#'   of its corresponding row), a vector of species names or \code{"all"} to
#'   display the related isotopic data. If \code{iso.data} is provided then 
#'   \code{tree} should not be provided.
#' @param tree The ID of a specific tree to display (\code{numeric}) or a
#'   \code{"all"} to display all trees. If \code{iso.data} is provided, then 
#'   \code{tree} should not be.
#'   
#' @details The function always loads the isotopic data set and the multiple
#'   phylogenies. Only one or other of \code{iso.data} and \code{tree} should 
#'   be provided by the user. It will return an error if both are given.
#'   
#' @examples
#' 
#' ## Displaying information for a specific species
#' scrumpSider(iso.data = "Homo_sapiens")
#' 
#' ## Displaying information for a specific tree
#' scrumpSider(tree = 1)
#' 
#' 
#' @seealso \code{link{isotope_data}}, \code{link{combined_trees}}
#'   
#' @author Thomas Guillerme
#' @export

scrumpSider <- function(iso.data, tree) {

    ## Default output (none)
    output <- FALSE
    
    # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
    ## -- AJ commented out these line 2-Aug-2017 --
    # one shoyld not load to the global environment.
    # ## Loading the data if not present in the current environment
    # if(!any(utils::ls.str(envir = .GlobalEnv) == "isotope_data")) {
    #     # data(isotope_data, package = "SIDER")
    #     # message("Loaded isotopic data in:\n   isotope_data")
    #   
    # }
    # 
    # ## Loading the trees if not present in the current environment
    # if(!any(utils::ls.str(envir = .GlobalEnv) == "combined_trees")) {
    #     data(combined_trees, package = "SIDER")
    #     message("Loaded phylogenetic data in:\n   combined_trees")
    # }
    
    if(missing(iso.data) & missing(tree)) stop("You must supply either iso.data 
                                              or tree as input arguments")
    
    if(!missing(iso.data) & !missing(tree)) stop("You must only supply one of 
                                                 iso.data or tree, 
                                                 and not both")
    
    # assign the data internally in this function (not pull from global)
    # browser()
    isotope_data <- SIDER::isotope_data
    combined_trees <- SIDER::combined_trees
    
    # = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

    if(!missing(iso.data)) {
        ## Displaying species data

        ## Checking the class
        class_data <- class(iso.data)
        if(class_data != "character" && class_data != "integer" && 
           class_data != "numeric") {
            stop("iso.data parameter must be a single value or a vector of 
                 class character or numeric.")
        }

        ## Species are characters
        if(class_data == "character") {

            if(length(iso.data) == 1 && iso.data == "all") {
                ## Returns the whole isotope dataset
                output <- TRUE
                output_data <- isotope_data

            } else {
                ## Select the species in the dataset
                rows_selected <- isotope_data[,1] %in% iso.data
                
                ## Check if the species are present
                if(length(which(rows_selected)) != 0) {
                    ## Select the rows to output
                    output_data <- isotope_data[rows_selected, ]
                    output <- TRUE
                } 

                ## If any species are not in isotope_data, print a message
                if(!all(iso.data %in% isotope_data[,1])) {
                    missing_sp <- iso.data[which(!iso.data %in% 
                                                   isotope_data[,1])]
                    
                    ## Tells which species is absent
                    if(length(missing_sp) > 1) {
                        message(paste("species:", paste(missing_sp, sep = ", "),
                                      "are not found in isotope_data.\nUse 
                                      imputeSider(...) to get their isotope 
                                      estimates!"))
                    } else {
                        message(paste("species", paste(missing_sp, sep = ", "), 
                                      "is not found in isotope_data.\nUse 
                                      imputeSider(...) to get its isotope 
                                      estimates!"))
                    }
                }
            }
        }

        ## Species are numeric
        if(class_data == "numeric") {
            ## Select the rows to output
            output_data <- isotope_data[iso.data, ]
            output <- TRUE
        }
    }

    if(!missing(tree)) {

        if(length(tree) == 1 && tree == "all") {
            ## Return all trees
            output_tree <- combined_trees

        } else {

            ## Checking the tree values
            if(class(tree) != "numeric") {
                stop("Tree argument must be one or more numeric values.")
            }
            if(any(tree > length(combined_trees))) {
                stop(paste("Tree argument is too big: only", 
                           length(combined_trees), 
                           "are available in the combined_tree dataset."))
            }

            ## Select the trees
            if(length(tree) > 1) {
                ## multiple trees
                output_tree <- combined_trees[tree]
                class(output_tree) <- "multiPhylo"
            } else {
                ## single tree
                output_tree <- combined_trees[[tree]]
                class(output_tree) <- "phylo"
            }
        }
       
        if(output) {
            ## If data was already required, make a list of both data
            output_data <- list("data" = output_data, "tree" = output_tree)
        } else {
            ## Else only output the tree
            output <- TRUE
            output_data <- output_tree
        }
    }

    if(output) {
        return(output_data)
    }

    return(invisible())
}