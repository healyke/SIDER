# test_that("clean.data works fine", {
#   test <- tef_data_badger.c
#   #Test is a list...
#   expect_is(test, "list")
#   #... of three objects.
#   expect_equal(names(test), c("tree", "data", "dropped.taxon"))
#   #The first is a multiPhylo...
#   expect_is(test$tree, "multiPhylo")
#   #... with two trees of 22 tips.
#   expect_equal(unlist(lapply(test$tree, Ntip)), c(22,22))
#   #The second is a data.frame...
#   expect_is(test$data, "data.frame")
#   #... with 95 rows and 7 columns...
#   expect_equal(dim(test$data), c(95,7))
#   #... and a NA at the end of the first row.
#   expect_true(is.na(test$data[1,7]))
#   #The third object is a character vector...
#   expect_is(test$dropped.taxon, "character")
#   #... of 6181 elements.
#   expect_equal(length(test$dropped.taxon), 6181)
# })
