context("setTefEst")

#Loading the trees
data(combined_trees)

test_that("should return errors (bad input)", {
    # No species name
    expect_error(
        test <- setTefEst(species = NULL, habitat = "terrestrial", taxonomic.class = "mammalia",  tissue = "blood",  diet.type = "omnivore",  source.iso.13C = c(-24.1),  source.iso.15N = c(7.0), tree = combined_trees)
        )
    # Wrong species name
    expect_output(
        test <- setTefEst(species = "Pokemon", habitat = "terrestrial", taxonomic.class = "mammalia",  tissue = "blood",  diet.type = "omnivore",  source.iso.13C = c(-24.1),  source.iso.15N = c(7.0), tree = combined_trees)
        , "Pokemon not present in phylogeny")
    # # No habitat
    # expect_error(
    #     expect_output(
    #         test <- setTefEst(species = "Meles_meles", habitat = NULL, taxonomic.class = "mammalia",  tissue = "blood",  diet.type = "omnivore",  source.iso.13C = c(-24.1),  source.iso.15N = c(7.0), tree = combined_trees)
    #         , "Meles_mele is present in phylogeny") # Probably no need to be verbose here!
    # )
})


    # # No species name
    # expect_error(
    #     test <- setTefEst(species = "Meles_meles", habitat = "terrestrial", taxonomic.class = "mammalia",  tissue = "blood",  diet.type = "omnivore",  source.iso.13C = c(-24.1),  source.iso.15N = c(7.0), tree = combined_trees)
    #     )