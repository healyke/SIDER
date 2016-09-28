context("tdfMulClean")

#Loading the trees
data(combined_trees)

#Loading the isotope data
data(isotope_data)

#Generate the setTdfEst dataset
TdfEst_test <- setTdfEst(species = "Meles_meles", habitat = "terrestrial", taxonomic.class = "mammalia", tissue = "blood", diet.type = "omnivore",  tree = combined_trees)

test_that("Basic example (should run!)", {
  test <- tdfMulClean(data.estimate = TdfEst_test, data.isotope = isotope_data, tree = combined_trees, isotope = "carbon")

  #mulTree
  expect_is(test, "mulTree")
  #dimensions
  expect_equal(length(test), 4)
  #names
  expect_equal(names(test), c("phy", "data", "random.terms", "taxa.column"))
  #classes
  expect_equal(as.vector(unlist(lapply(test, class))), c("multiPhylo", "data.frame", "formula", "character"))
})

