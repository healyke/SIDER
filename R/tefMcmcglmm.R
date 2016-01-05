
	
######runs the MulTree across each of the models with option of including multiple trees


tefMcmcglmm <- function(mulTree.data , 
                         formula = delta13C ~ iso_13C + diet_type + habitat ,
                         random.terms = ~ animal + species + tissue,
                         nitt = c(12000), 
                         thin = c(10), 
                         burnin = c(2000), 
                         prior = NULL, 
                         no.chains = c(2), 
                         convergence = c(1.1), 
                         ESS = c(1000)){



#mulTree.data = tef_data_badger.c
#formula = delta13C ~ iso_13C + diet_type + habitat
#tef_data_badger.c$random.terms = ~ animal + species + tissue
#nitt = c(12000)
#thin = c(10)
#burnin = c(2000)
#prior = NULL
#no.chains = c(2)
#convergence = c(1.1)
#ESS = c(1000)


	
####this checks if there is a prior. If there is no prior and the formula is the same as the one we use it uses the same prior as we use.
		if((is.null(prior) & formula == "delta13C ~ iso_13C + diet_type + habitat" & tef_data_badger.c$random.term == "~animal + species + tissue") == TRUE){
			
			prior_tef <- list(R = list(V = 1/4, nu=0.002), G = list(G1=list(V = 1/4, nu=0.002),G2=list(V = 1/4, nu=0.002), G3=list(V = 1/4, 										nu=0.002)))
			} else{
			prior_tef <-  prior
					}
					
	parameters <- c(nitt, thin, burnin)
	
	 tef_data_badger.c$random.terms <- random.terms

########run the analysis

###need to put animal column into data first by dublicating the species column
#mulTree.data$table$animal <-  mulTree.data$table$species

#if((class(mulTree.data$phy) == "multiPhylo") == TRUE){
	
		mulTree(mulTree.data  = mulTree.data , formula = formula, parameters = parameters, pl=TRUE, prior = prior_tef, chains = no.chains, convergence = convergence, ESS = ESS,output="teff_output" )
				
	#na.row <-  which(row(is.na(data)) == T)[1]

tef_Liabs_raw <- read.mulTree(mulTree.mcmc="teff_output", extract = "Liab")

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









	
	
