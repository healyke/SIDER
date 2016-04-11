#' @title Running MCMCglmm
#' 
#' @description Runs a \code{\link[MCMCglmm]{MCMCglmm model}} model to impute delta
#' 
#' @param mulTree.data output from \code{\link{tefMulClean}} containing data and phylogeny as a \code{mulTree} object.
#' @param formula an object of class \code{formula} describing the fixed effects.
#' @param random.terms an object of class "formula" decribing the random effects.
#' @param nitt number of MCMC iterations
#' @param thin thinning interval of MCMC chain
#' @param burnin number of iterations to discard at begining of chain
#' @param prior optional list of prior specifications (see details).
#' @param no.chains The number of MCMC chains for each run.
#' @param convergence limits set for the point estimates of the potential scale reduction factor (see \code{link[coda]{gelman.diag}}.
#' @param ESS effective sample size of MCMC iterations for each model estimate.
#' @param output The name of the output files
#' 
#' @details
#' The \code{priors} argument must be of 3 possible elements: R (R-structure) G (G-structure) and B (fixed effects). B is a list containing the expected value (mu) and a (co)variance matrix (V) representing the strength of belief: the defaults are \code{B$mu = 0} and \code{B$V = I*1e+10}, where where I is an identity matrix of appropriate dimension. The priors for the variance structures (R and G) are lists with the expected (co)variances (V) and degree of belief parameter (nu) for the inverse-Wishart, and also the mean vector (alpha.mu) and covariance matrix (alpha.V) for the redundant working parameters. The defaults are \code{nu = 0}, \code{V = 1}, \code{alpha.mu = 0}, and \code{alpha.V = 0}. When alpha.V is non-zero, parameter expanded algorithms are used.
#' 
#' @return list containing Posterior Distributions of imputed discrimination factors  
#' including a posterior distribution for each indavidual chain in Tef.est and
#' a combined chain in Tef.global.
#' 
#' @author Kevin Healy
#' 
#' @example
#' ##
#' 
#' @export


tefMcmcglmm <- function(mulTree.data , 
                         formula = delta13C ~ diet.type + habitat ,
                         random.terms = ~ animal + sp.col + tissue,
                         nitt = c(120000), 
                         thin = c(50), 
                         burnin = c(20000), 
                         prior = NULL, 
                         no.chains = c(2), 
                         convergence = c(1.1), 
                         ESS = c(1000),
                         output = "teff_output"){




	
####this checks if there is a prior. If there is no prior and the formula is the same as the one we use it uses the same prior as we use.

mulTree.data$random.terms = random.terms

		if((is.null(prior) & mulTree.data$random.term == "~animal + sp.col + tissue") == TRUE){
			
			prior_tef <- list(R = list(V = 1/4, nu=0.002), G = list(G1=list(V = 1/4, nu=0.002),G2=list(V = 1/4, nu=0.002), G3=list(V = 1/4, 										nu=0.002)))
			} else{
			prior <-  prior
					}
					
	parameters <- c(nitt, thin, burnin)

########run the analysis

###need to put animal column into data first by dublicating the species column
#mulTree.data$table$animal <-  mulTree.data$table$species

#if((class(mulTree.data$phy) == "multiPhylo") == TRUE){
	
		mulTree(mulTree.data  = mulTree.data , formula = formula, parameters = parameters, pl=TRUE, prior = prior, chains = no.chains, convergence = convergence, ESS = ESS, output= output )
				
	#na.row <-  which(row(is.na(data)) == T)[1]

tef_Liabs_raw <- read.mulTree(mulTree.chain= output, extract = "Liab")

#}
#else{
	
#	tef_Liabs_raw <- MCMCglmm(fixed = formula, random = random.term, data = mulTree.data$table, pedigree = mulTree.data$tree, prior = prior_tef, nitt = nitt, thin  = thin, burnin = burnin, pl = TRUE)
	
#tef_Liabs_raw <- 	tef_Liabs_raw$Liab
	
#	}
	
#tef_estimates  <- as.mcmc(unlist(tef_Liabs_raw[,1]))
	
#	return(list(tef_estimates = tef_estimates))
	
#### I think this loop is for the MulTree function so need to come back and fix this.
#####as the NA row is placed first in the matrix we only want the first column of Liab as the rest are fixed.
	tef_Liabs <- list()
for(i in 1:(length(names(tef_Liabs_raw)))){

tef_Liabs[[i]] <-	(tef_Liabs_raw[[i]][,1])
}
	
tef_global  <- as.mcmc(unlist(tef_Liabs))
	
return(list(tef_estimates = tef_Liabs, tef_global = tef_global))
			
}



#####need to make a function that will give a plot and a table.









	
	
