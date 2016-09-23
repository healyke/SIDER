#' @title Refreshes the phylogenetic tree dataset
#'   
#' @description Internal utility function for refreshing the combined_trees 
#'   dataset (not exported) This function rapidly updates the combined_trees.rda
#'   file once one updates the .tre files.
#'   
#' @param data A character vector file containing names of the *.tre files to be
#'   combined.
#'   
#' @param sample an integer defining the number of trees to create. Passed to
#'   mulTree::tree.bind
#'   
#' @param root.age a numeric value used to join two trees. Passed to
#'   mulTree::tree.bind
#'   
#' @return Saves the updated file to ../data/combined_trees.rda for use within 
#'   the package
#'   
#' @author Thomas Guillerme
#'   

refresh.combined_tree <- function(data = c("3firstFritzTrees.tre", 
                                           "3firstJetzTrees.tre"), 
                                  sample = 2, 
                                  root.age = 250) {
    
    #Load the two trees (mammals and birds)
    mammal_trees <- ape::read.tree(system.file("extdata", 
                                               data[1], package = "SIDER"))
    bird_trees   <- ape::read.tree(system.file("extdata", 
                                               data[2], package = "SIDER"))
    #Combining the trees
    combined_trees <- mulTree::tree.bind(x = mammal_trees, 
                                         y = bird_trees, 
                                         sample = sample, 
                                         root.age = root.age)
    #Saving the tree
    save(combined_trees, file = "../data/combined_trees.rda", compress = 'xz')
    
    # output notes to screen
    cat("combined_trees.rda file successfully updated.\n
        Don't forget to update the man page in 
        \\man\\SIDER.R if necessary.")
}