#Internal utility function for refreshing the combined_treesdataset (not exported)
#This function rapidly updates the combined_trees.rda file once one updates the .tre files.
refresh.combined_tree <- function(data = c("3firstFritzTrees.tre", "3firstJetzTrees.tre"), sample = 2, root.age = 250) {
    #Loading the trees
    mammal_trees <- ape::read.tree(system.file("extdata", data[1], package = "TESIR"))
    bird_trees   <- ape::read.tree(system.file("extdata", data[2], package = "TESIR"))
    #Combining the trees
    combined_trees <- mulTree::tree.bind(x = mammal_trees, y = bird_trees, sample = sample, root.age = root.age)
    #Saving the tree
    save(combined_trees, file = "../data/combined_trees.rda")
    cat("combined_trees.rda file successfully updated.\nDon't forget to update the man page in \\man\\TESIR.R if necessary.")
}