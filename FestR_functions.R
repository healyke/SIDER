


set.tef.est <- function(species = c(), habitat = c("marine", "terrestrial", NA), Class = c("mammalia", "aves", NA), tissue = c("blood", "claws", "collagen", "ceather", "hair", "kidney", "liver", "milk", "muscle", NA), diet_type = c("carnivore", "herbivore", "omnivore",  "pellet", NA), iso_13C = c(NA), iso_15N = c(NA), phylogeny = c()){
	


###check if each of th inputs matches the catagories we want.

###check species
if(is.null(species) == T){stop("species missing")}

##check habitat data
if(is.null(habitat) == T){warning("Data for habitat missing")
	} else if(any( habitat == c("marine", "terrestrial")) != T){
			warning("habitat levels do not match dataset from Healy et al 2016")}

##check class data
if(is.null(Class) == T){warning("Data for Class missing")
	} else if(any( Class == c("mammalia", "aves")) != T){
			warning("Class levels do not match dataset from Healy et al 2016")}
			
##check tissue data
if(is.null(tissue) == T){warning("Data for tissue missing")
	} else if(any( tissue == c("blood", "claws", "Collagen", "Feather", "hair", "kidney", "liver", "milk", "muscle")) != T){
			warning("tissue levels do not match dataset from Healy et al 2016")}
			
##check diet_type data
if(is.null(diet_type) == T){warning("Data for diet_type missing")
	} else if(any( diet_type == c("carnivore", "herbivore", "omnivore",  "pellet")) != T){
			warning("diet_type levels do not match dataset from Healy et al 2016")}

##check iso data is there
if(is.null(iso_13C) & is.null(iso_15N) == T){warning("Data for iso missing")
	} else if(any(c(class(iso_13C),class(iso_13C)) == "numeric") != T){
			warning("iso data not numeric")}
	
				
	
###check if there is a tree and what type of tree it is
if(is.null(phylogeny) == T){	 
	cat("phylo missing: species presence in phylogeny not checked")
}	else if((class(phylogeny) == "multiPhylo") == T){
	phylo_test <- phylogeny[[1]]
}		else if((class(phylogeny) == "phylo") == T){
	phylo_test <- phylogeny
	}	else{cat("phylo not a phlyo or multiPhylo object: species presence in phylogeny not checked")}	
	
#check if the species is in the tree
if(any(phylo_test $tip.label == species) == T){
			cat(species, "present in phylogeny")
} else{cat(species, "not present in phylogeny")}
	



###put it in a data.frame with stringsAsFactors turned off.
new.data <- data.frame(species = species, habitat = habitat, Class = Class, tissue = tissue, diet_type = diet_type, iso_13C = iso_13C, delta13C = NA, iso_15N = iso_15N, delta15N = NA, stringsAsFactors = F) 
	

return(new.data)
}




	
tef_mul_clean <- function(new.data = c(), data = data, species_col_name = c("species"), trees, isotope = c("carbon","nitrogen"), class =  c("mammalia","aves") , random = ~ animal + species + tissue){
		

#new.data = new.data_badge.c
#data = data
#species_col_name = "species"
#trees =  combined_trees
#class = "mammalia"
#isotope = "carbon"

		
#####decide on which class##### I think this will be a good thing to include as it will edge people towards an approapriate analysis (i.e. avoid the fact that feathers and hair will already divide the data into these groups but in a less interpreatable way) #need to fix this to be open.

	if((class== "mammalia") == T){ iso_data_sub <- data[data$class == "Mamm",]
	} else {
		if((class == "aves") == T){ iso_data_sub <- data[data$class == "Bird",]
		}
		else{ iso_data_sub <- data}
	}
		
		
		
#####decide on the isotope###
	if((isotope == "carbon") == T){
		dropN <- names(data) %in% c("iso_15N","delta15N")
		iso_data_sub  <- iso_data_sub[!dropN]
				
				dropnewN <- names(new.data) %in% c("iso_15N","delta15N")
		new.data_sub  <- new.data[!dropnewN]
		
	} else{ 
		if((isotope == "nitrogen") == T){
			dropC <- names(data) %in% c("iso_13C","delta13C")
			iso_data_sub  <- iso_data_sub[!dropC]
			
						dropnewC <- names(new.data) %in% c("iso_13C","delta13C")
		new.data_sub  <- new.data[!dropnewC]
			
			}
	
		}
		

		
########get rid on NAs so that the only NAs are for the new data

		iso_data_sub_na <-  na.omit(iso_data_sub)

######## Include the new data, I bind it so its at the top and hence easier to read.
	
	if(is.null(new.data) == T){
		iso_data_com <- iso_data_sub_na
	} else{ 
			iso_data_com  <- rbind(new.data_sub , iso_data_sub_na)
		}
		
	
		
####Clean the data and match up the tree using the multree function


#####this needs to be fixed so that it actually removes the dataset.

		#	clean_iso <-	as.mulTree(species = species_col_name, data = iso_data_com, trees = trees, clean.data = TRUE)
		
		clean_iso <- clean.data(species_col_name, iso_data_com, trees)
	
		
		
#####fix that random term by checking if any of the random terms are the same as the species colume and replacing that with sp.col as the Multre function does
#		if(any(grep(species_col_name ,random)) == TRUE){
#			clean_iso$random.terms <-as.formula( gsub("species","sp.col", random))
#			} else{ clean_iso$random.terms <-as.formula( random)	
#			}
		
			
		return(clean_iso)		

}



		



	
######runs the MulTree across each of the models with option of including multiple trees


tef_mcmcglmm <- function(mulTree.data , formula = delta13C ~ iso_13C + diet_type + envirnment ,nitt = c(12000), thin = c(10), burnin = c(2000), prior = NULL, pl = TRUE, no.chains = c(2), convergence = c(1.1), ESS = c(1000)){

		
	
####this checks if there is a prior. If there is no prior and the formula is the same as the one we use it uses the same prior as we use.
		if((is.null(prior) & formula == "delta13C ~ iso_13C + diet_type + envirnment" & mulTree.data$random == "~ animal + species + tissue") == TRUE){
			
			prior_tef <- list(R = list(V = 1/4, nu=0.002), G = list(G1=list(V = 1/4, nu=0.002),G2=list(V = 1/4, nu=0.002), G3=list(V = 1/4, 										nu=0.002)))
			} else{
			prior_tef <-  prior
					}
					
	parameters <- c(nitt, thin, burnin)

########run the analysis
		mulTree(mulTree.data  = mulTree.data , formula = formula, parameters = parameters, pl=pl, prior = prior_tef, chains = no.chains, convergence = convergence, ESS = ESS,output="teff_output" )
				
	#na.row <-  which(row(is.na(data)) == T)[1]

tef_Liabs_raw <- read.mulTree(mulTree.mcmc="teff_output", extract = "Liab")


#####as the NA row is placed first in the matrix we only want the first column of Liab as the rest are fixed.
	tef_Liabs <- list()
for(i in 1:(length(names(tef_Liabs_rawtef_Liabs_raw)))){

tef_Liabs[[i]] <-	(tef_Liabs_raw[[i]][,1])
}
	
tef_global  <- as.mcmc(unlist(tef_Liabs))
	
return(list(tef_estimates = tef_Liabs, tef_global = tef_global))
			
}



#####need to make a function that will give a plot and a table.









	
	