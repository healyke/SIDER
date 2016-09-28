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
  #phy is multiPhylo (with two tree)
  expect_is(test$phy, "multiPhylo")
  expect_equal(length(test$phy), 2)
  #Random.terms is animal + species + tissue
  expect_equal(test$random.terms, ~ animal + species + tissue) 

  #Fire of a warning from no isotope source
  expect_warning(
    test <- tdfMulClean(data.estimate = TdfEst_test, tree = combined_trees, isotope = "carbon")
    )

  #mulTree
  expect_is(test, "mulTree")
  #dimensions
  expect_equal(length(test), 4)
  #names
  expect_equal(names(test), c("phy", "data", "random.terms", "taxa.column"))
  #classes
  expect_equal(as.vector(unlist(lapply(test, class))), c("multiPhylo", "data.frame", "formula", "character"))


  test <- tdfMulClean(data.estimate = TdfEst_test, data.isotope = isotope_data, tree = combined_trees[[1]], isotope = "nitrogen", random.terms = ~ animal + tissue)

  #mulTree
  expect_is(test, "mulTree")
  #dimensions
  expect_equal(length(test), 4)
  #names
  expect_equal(names(test), c("phy", "data", "random.terms", "taxa.column"))
  #classes
  expect_equal(as.vector(unlist(lapply(test, class))), c("multiPhylo", "data.frame", "formula", "character"))
  #phy is multiPhylo (with one tree)
  expect_is(test$phy, "multiPhylo")
  expect_equal(length(test$phy), 1)
  #Random.terms is animal + tissue
  expect_equal(test$random.terms, ~ animal + tissue) 

})

test_that("should return errors (bad input)", {
  # No data estimate
    expect_error(
      test <- tdfMulClean(
                          data.isotope = isotope_data,
                          tree = combined_trees,
                          isotope = "carbon",
                          random.terms = ~ animal + species + tissue)
      )
  # Wrong data estimate
    expect_error(
      test <- tdfMulClean(data.estimate = matrix(1,1),
                          data.isotope = isotope_data,
                          tree = combined_trees,
                          isotope = "carbon",
                          random.terms = ~ animal + species + tissue)
      )
  # Wrong data isotope
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = matrix(1,1),
                          tree = combined_trees,
                          isotope = "carbon",
                          random.terms = ~ animal + species + tissue)
      )
  # No tree
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = isotope_data,
                          
                          isotope = "carbon",
                          random.terms = ~ animal + species + tissue)
      )
  # Wrong tree
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = isotope_data,
                          tree = "oak",
                          isotope = "carbon",
                          random.terms = ~ animal + species + tissue)
      )
  # Wrong tree
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = isotope_data,
                          tree = rtree(5),
                          isotope = "carbon",
                          random.terms = ~ animal + species + tissue)
      )
  # No isotope
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = isotope_data,
                          tree = combined_trees,
                          
                          random.terms = ~ animal + species + tissue)
      )
  # Wrong isotope
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = isotope_data,
                          tree = combined_trees,
                          isotope = "cardboard",
                          random.terms = ~ animal + species + tissue)
      )
  # Wrong formula
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = isotope_data,
                          tree = combined_trees,
                          isotope = "carbon",
                          random.terms = "magic")
      )
    expect_error(
      test <- tdfMulClean(data.estimate = TdfEst_test,
                          data.isotope = isotope_data,
                          tree = combined_trees,
                          isotope = "carbon",
                          random.terms = ~ plants + tissue)
      )
  })
