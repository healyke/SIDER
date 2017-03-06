context("recipeSider")

#Loading the trees
data(combined_trees)

test_that("Basic example (should run!)", {
  # Example
  test <- recipeSider(species = "Meles_meles",
                    habitat = "terrestrial", 
                    taxonomic.class = "mammalia",  
                    tissue = "blood",  
                    diet.type = "omnivore",
                    source.iso.13C = c(-24.1),
                    source.iso.15N = c(7.0), 
                    tree = combined_trees)
  #data.frame
  expect_is(test, "data.frame")
  #dimensions
  expect_equal(dim(test), c(1,9))
  #names
  expect_equal(names(test), c("species", "habitat", "taxonomic.class", "tissue", "diet.type", "source.iso.13C", "delta13C", "source.iso.15N", "delta15N"))
})

test_that("should return errors (bad input)", {
  # No species name
    expect_error(
      test <- recipeSider( 
                        habitat = "terrestrial", 
                        taxonomic.class = "mammalia",  
                        tissue = "blood",  
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # Wrong species name
  expect_error(
      test <- recipeSider(species = "Pokemon", 
                        habitat = "terrestrial", 
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # No habitat
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "Ballyhale",
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # Wrong habitat
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # No class
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        
                        tissue = "blood",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # Wrong class
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "fishy",
                        tissue = "blood",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # No tissue
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "mammalia",

                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # Wrong tissue
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "mammalia",
                        tissue = "cotton",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # No diet.type
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # Wrong diet.type
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        diet.type = "guinness&bananas",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = combined_trees)
      )
  # No tree
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        diet.type = "omnivore",
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        )
      )
  # Wrong tree class
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = "oak")
      )
  # Wrong tree (sp not present within)
  expect_error(
      test <- recipeSider(species = "Meles_meles", 
                        habitat = "terrestrial",
                        taxonomic.class = "mammalia",
                        tissue = "blood",
                        diet.type = "omnivore",  
                        source.iso.13C = c(-24.1),  
                        source.iso.15N = c(7.0), 
                        tree = rtree(5))
      )
})
