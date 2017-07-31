context("imputeSider")

## Loading the data
data(combined_trees); data(isotope_data)

## Setting up the isotope estimation for one species
taxa_estimate <- recipeSider(species = "Meles_meles", habitat = "terrestrial",
     taxonomic.class = "mammalia", tissue = "blood", diet.type = "omnivore", 
     tree = combined_trees)

## Generating the "mulTree" object for the estimation
mulTree.data <- prepareSider(data.estimate = taxa_estimate,
     data.isotope = isotope_data, tree = combined_trees, isotope = "carbon")


test_that("Basic example (should run!)", {
    set.seed(1)
    ## Setting up the MCMCglmm parameters
    MCMC_parameters <- c(1200, 200, 5)
    MCMC_formula <- delta13C ~ diet.type + habitat
    isotope_estimate <- imputeSider(mulTree.data, formula = MCMC_formula,
         parameters = MCMC_parameters, verbose = FALSE, save.model = FALSE)

    #Should be a list...
    expect_is(
        isotope_estimate
        , "list")
    #... of two elements
    expect_equal(
        names(isotope_estimate)
        , c("tdf_estimates", "tdf_global"))
    #First being a list...
    expect_is(
        isotope_estimate[[1]]
        , "list")
    #... of 4 elements
    expect_equal(
        length(isotope_estimate[[1]])
        ,4)
    # each containing the default name
    expect_equal(
        grep("teff_output-tree", names(isotope_estimate[[1]]))
        , seq(1:length(isotope_estimate[[1]])) )
    # each element is a mcmc
    expect_equal(
        unlist(unique(lapply(isotope_estimate[[1]], class)))
        , "mcmc")
    # Thinning values should be the followings		
    expect_equal(
        as.numeric(isotope_estimate[[1]][[1]])
        , c(0.3469607, 5.5769455, 3.7154270, 1.5595104, 2.1872155, 5.5714799)
        , tolerance = 0.1)
    # Second element is also an mcmc
    expect_is(
        isotope_estimate[[2]]
        ,"mcmc")
    # Of 24 values
    expect_equal(
        length(isotope_estimate[[2]])
        , 24)
})

test_that("should return errors (bad input)", {
    # NOTE: only the SIDER input management is tested here. Arguments to be passed to mulTree and MCMCglmm are management by both packages own testings!

    # Stored priors list
    priors <- list(R = list(V = 1/4, nu = 0.002), 
               G = list(
                G1 = list(V = 1/4, nu = 0.002),
                G2 = list(V = 1/4, nu = 0.002), 
                G3 = list(V = 1/4, nu = 0.002)))
    # First shot works!
    expect_silent(
        imputeSider(mulTree.data = mulTree.data,
                    formula = delta13C ~ diet.type + habitat,
                    random.terms = ~animal + species + tissue,
                    parameters = MCMC_parameters,
                    priors = priors,
                    chains = 2,
                    convergence = 1.1,
                    ESS = 1000,
                    output = "teff_output",
                    save.model = FALSE,
                    verbose = FALSE)
      )
    # Missing data
    expect_error(
        imputeSider(
                    formula = delta13C ~ diet.type + habitat,
                    random.terms = ~animal + species + tissue,
                    parameters = MCMC_parameters,
                    priors = priors,
                    chains = 2,
                    convergence = 1.1,
                    ESS = 1000,
                    output = "teff_output",
                    save.model = FALSE,
                    verbose = FALSE)
      )
    # Wrong data
    expect_error(
        imputeSider(mulTree.data = matrix(5,5,5),
                    formula = delta13C ~ diet.type + habitat,
                    random.terms = ~animal + species + tissue,
                    parameters = MCMC_parameters,
                    priors = priors,
                    chains = 2,
                    convergence = 1.1,
                    ESS = 1000,
                    output = "teff_output",
                    save.model = FALSE,
                    verbose = FALSE)
      )
    # Missing formula
    expect_error(
        imputeSider(mulTree.data = mulTree.data,
                    
                    random.terms = ~animal + species + tissue,
                    parameters = MCMC_parameters,
                    priors = priors,
                    chains = 2,
                    convergence = 1.1,
                    ESS = 1000,
                    output = "teff_output",
                    save.model = FALSE,
                    verbose = FALSE)
      )
    # Wrong formula
    expect_error(
        imputeSider(mulTree.data = mulTree.data,
                    formula = awesome ~ formula,
                    random.terms = ~animal + species + tissue,
                    parameters = MCMC_parameters,
                    priors = priors,
                    chains = 2,
                    convergence = 1.1,
                    ESS = 1000,
                    output = "teff_output",
                    save.model = FALSE,
                    verbose = FALSE)
      )
    # Slightly wrong formula
    expect_error(
        imputeSider(mulTree.data = mulTree.data,
                    formula = dEltA13C ~ diet.type + habitat,
                    random.terms = ~animal + species + tissue,
                    parameters = MCMC_parameters,
                    priors = priors,
                    chains = 2,
                    convergence = 1.1,
                    ESS = 1000,
                    output = "teff_output",
                    save.model = FALSE,
                    verbose = FALSE)
      )
    # Missing save.model

    # WARNING! This bit can conflict with Travis or other Unit testing routines (since it produce files out of R)

    expect_silent( #Works as a default!
        imputeSider(mulTree.data = mulTree.data,
                    formula = delta13C ~ diet.type + habitat,
                    random.terms = ~animal + species + tissue,
                    parameters = MCMC_parameters,
                    priors = priors,
                    chains = 2,
                    convergence = 1.1,
                    ESS = 1000,
                    output = "SIDER_unit_testing",
                                    
                    verbose = FALSE)
      )
    expect_equal(
        length(list.files(pattern = "SIDER_unit_testing"))
        ,6)
    test <- file.remove(list.files(pattern = "SIDER_unit_testing"))
    expect_equal(all(test),TRUE)
  })