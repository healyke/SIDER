context("scrumpSider")

test_that("scrumpSider works", {

    ## Removing eventual data
    if(any(ls.str() == "isotope_data")) rm(isotope_data)
    if(any(ls.str() == "combined_trees")) rm(combined_trees)
    
    ## Default loading
    scrumpSider()

    ## Datasets exists (are loaded)
    expect_is(isotope_data, "data.frame")
    expect_is(combined_trees, "multiPhylo")
    
    ## One taxa loading
    test <- scrumpSider(iso.data = "Homo_sapiens")

    ## Datasets exists (are loaded)
    expect_is(isotope_data, "data.frame")
    expect_is(combined_trees, "multiPhylo")

    ## Right output row
    expect_equal(dim(test), c(1,9))
    expect_equal(names(test), colnames(isotope_data))

    ## More than one taxa loading (no more message, data already loaded)
    test <- scrumpSider(iso.data = c("Homo_sapiens", "Gallus_gallus"))

    ## Right output row
    expect_equal(dim(test), c(5,9))
    expect_equal(names(test), colnames(isotope_data))

    ## Selecting species by ID
    test2 <- scrumpSider(iso.data = c(33, 168:171))

    ## Right output row
    expect_true(all((test == test2)[!is.na(test == test2)]))

    ## Species not present
    expect_message(scrumpSider(iso.data = "Meles_meles"))
    expect_message(scrumpSider(iso.data = c("Homo_sapiens", "Meles_meles")))

    ## Getting the right tree
    expect_is(scrumpSider(tree = 1), "phylo")
    expect_is(scrumpSider(tree = c(1,2)), "multiPhylo")

    ## Getting both the tree and the data
    test <- scrumpSider(iso.data = c("Homo_sapiens", "Gallus_gallus"), tree = 1)
    expect_is(test, "list")
    expect_length(test, 2)
    expect_equal(names(test), c("data", "tree"))
    expect_is(test[[1]], "data.frame")
    expect_is(test[[2]], "phylo")
})