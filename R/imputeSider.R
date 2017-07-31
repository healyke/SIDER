#' @title Running MCMCglmm
#'   
#' @description Runs a \code{\link[MCMCglmm]{MCMCglmm}} model to impute delta
#'   
#' @param mulTree.data output from \code{\link{prepareSider}} containing data and
#'   phylogeny as a \code{mulTree} object.
#' @param formula an object of class \code{formula} describing the fixed 
#'   effects.
#' @param random.terms Optional. An object of class \code{formula} describing
#'   the random effects. If missing, the formula from
#'   \code{mulTree.data$random.terms} is used.
#' @param parameters a list of three numerical values to be used respectively
#'   as: (1) the number of iterations, (2) the sampling value, (3) the burnin.
#' @param priors optional list of prior specifications (see details).
#' @param chains The number of MCMC for each run (\code{default = 2}).
#' @param convergence limits set for the point estimates of the potential scale 
#'   reduction factor (see \code{link[coda]{gelman.diag}} - \code{default =
#'   1.1}).
#' @param ESS effective sample size of MCMC iterations for each model estimate
#'   (\code{default = 1000}).
#' @param output The name of the output files (\code{default = "teff_output"})
#' @param save.model whether to save the models out of R environment (default)
#'   or just get the estimates.
#' @param verbose whether to be verbose or not (\code{default = TRUE}).
#' @param ... any optional arguments to be passed to
#'   \code{\link[mulTree]{mulTree}}.
#'   
#' @details The \code{priors} argument must be of 3 possible elements: R 
#'   (R-structure) G (G-structure) and B (fixed effects). B is a list containing
#'   the expected value (mu) and a (co)variance matrix (V) representing the 
#'   strength of belief: the defaults are \code{B$mu = 0} and \code{B$V = 
#'   I*1e+10}, where where I is an identity matrix of appropriate dimension. The
#'   priors for the variance structures (R and G) are lists with the expected 
#'   (co)variances (V) and degree of belief parameter (nu) for the 
#'   inverse-Wishart, and also the mean vector (alpha.mu) and covariance matrix 
#'   (alpha.V) for the redundant working parameters. The defaults are \code{nu =
#'   0}, \code{V = 1}, \code{alpha.mu = 0}, and \code{alpha.V = 0}. When alpha.V
#'   is non-zero, parameter expanded algorithms are used.
#'   
#' @return list containing Posterior Distributions of imputed discrimination 
#'   factors including a posterior distribution for each individual chain in 
#'   Tef.est and a combined chain in Tef.global.
#'   
#' @examples
#' ## Loading data
#' data(combined_trees); data(isotope_data)
#' 
#' ## Setting up the isotope estimation for one species
#' taxa_estimate <- recipeSider(species = "Meles_meles", habitat = "terrestrial",
#'      taxonomic.class = "mammalia", tissue = "blood", diet.type = "omnivore", 
#'      tree = combined_trees)
#' 
#' ## Generating the "mulTree" object for the estimation
#' taxa_est_mulTree <- prepareSider(data.estimate = taxa_estimate,
#'      data.isotope = isotope_data, tree = combined_trees, isotope = "carbon")
#' 
#' ## Setting up the MCMCglmm parameters
#' MCMC_parameters <- c(1200, 200, 5)
#' MCMC_formula <- delta13C ~ diet.type + habitat
#' isotope_estimate <- imputeSider(taxa_est_mulTree, formula = MCMC_formula,
#'      parameters = MCMC_parameters, save.model = FALSE)
#' 
#' ## Print out the results
#' summary(isotope_estimate$tdf_global)
#' plot(isotope_estimate$tdf_global)
#' 
#' 
#' @author Kevin Healy
#'   
#' @seealso \code{\link{recipeSider}}, \code{\link{prepareSider}},
#'   \code{\link{combined_trees}}, \code{\link{isotope_data}},
#'   \code{\link[mulTree]{as.mulTree}}, \code{\link[mulTree]{mulTree}},
#'   \code{\link[MCMCglmm]{MCMCglmm}}.
#'   
#' @export

#DEBUGGING
# warning("DEBUG - prepareSider")
# data(combined_trees);data(isotope_data)
# new.data.test <- recipeSider(species = "Meles_meles", habitat = "terrestrial", 
#    taxonomic.class = "mammalia", tissue = "blood", diet.type = "omnivore", 
#    tree = combined_trees)

# data.estimate <- new.data.test
# data.isotope <- isotope_data
# isotope <- "carbon"
# tree <- combined_trees
# random.terms = ~ animal + species + tissue

# mulTree.data <- prepareSider(data.estimate = new.data.test, 
#                           data.isotope = isotope_data, 
#                           tree = combined_trees,  
#                           isotope = "carbon")

# formula = delta13C ~ diet.type + habitat
# parameters = c(1200000, 500, 200000)
# chains = 2
# convergence = 1.1
# ESS = 1000
# output = "teff_output"
# save.model = TRUE
# verbose = TRUE

imputeSider <- function(mulTree.data, formula, random.terms, 
                        parameters = c(1200000, 500, 200000), 
                        priors, chains = 2, convergence = 1.1, 
                        ESS = 1000, output = "teff_output", 
                        save.model = TRUE, verbose = TRUE, ...) {

    # Sanitizing
    # mulTree.data
    if(class(mulTree.data) != "mulTree") {
        stop("mulTree.data must be a mulTree object.\nSee the prepareSider() function for more details.")
    } else {
        if(length(mulTree.data) != 4) {
            stop("mulTree.data must be a mulTree object.\nSee the prepareSider() function for more details.")
        } else {
            if(any(is.na(match(names(mulTree.data),c("phy", "data", "random.terms", 
                                        "taxa.column"))))) {
                stop("mulTree.data must be a mulTree object.\nSee the prepareSider() function for more details.")
            }
        }
    }

    # formula
    if(!missing(random.terms)) {
        mulTree.data$random.terms <- random.terms
        default_random.terms <- FALSE
    } else {
        default_random.terms <- TRUE
    }
    # Replace "species" as a random term into sp.col
    colnames(mulTree.data$data)[1] <- "species"

    # save.model
    if(class(save.model) != "logical") {
        stop("save.model must be logical.")
    }

#####this checks if there is a prior. If there is no prior and the formula 
    # is the same as the one we use it uses the same prior as we use.
    # set priors to default values if not specified 
    if(missing(priors) & default_random.terms) { 
        priors <- list(R = list(V = 1/4, nu = 0.002), 
                       G = list(
                        G1 = list(V = 1/4, nu = 0.002),
                        G2 = list(V = 1/4, nu = 0.002), 
                        G3 = list(V = 1/4, nu = 0.002)))
    }

#####run the analysis
    mulTree::mulTree(mulTree.data = mulTree.data, 
                     formula = formula, 
                     parameters = parameters, 
                     priors = priors, 
                     chains = chains, 
                     convergence = convergence, 
                     ESS = ESS, 
                     output = output,
                     verbose = verbose,
                     pl = TRUE,
                     ...)
    
    # Read the results back in
    tdf_Liabs_raw <- mulTree::read.mulTree(mulTree.chain = output, 
                                           extract = "Liab")
    
    # I think this loop is for the MulTree function so need to come back and fix 
    # this. As the NA row is placed first in the matrix we only want the first 
    # column of Liab as the rest are fixed.

    #Extract the MCMC outputs
    tdf_Liabs <- lapply(tdf_Liabs_raw, function(X) X[,1])

    #concatenate the output in the global model
    tdf_global <- coda::as.mcmc(unlist(tdf_Liabs))
          
    # remove the models
    if(!save.model) {
        if(verbose) cat("Removing temporary files:...")
        file.remove(list.files(pattern = output))
        if(verbose) cat("Done.\n")
    }

    # return the output as a list
    return(list(tdf_estimates = tdf_Liabs, tdf_global = tdf_global))
}