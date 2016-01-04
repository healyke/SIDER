
	
tefMulClean <- function(new.data = c(), 
                        data = data, 
                        species_col_name = c("species"), 
                        trees, 
                        isotope = c("carbon","nitrogen"), 
                        class =  c("mammalia","aves") , 
                        random = ~ animal + species + tissue) {
		

#new.data = new.data_badge.c
#data = mydata
#species_col_name = "species"
#trees =  combined_trees
#class = "mammalia"
#isotope = "carbon"

		
#####decide on which class##### I think this will be a good thing to include as it will edge people towards an approapriate analysis (i.e. avoid the fact that feathers and hair will already divide the data into these groups but in a less interpreatable way) #need to fix this to be open.

	if((class== "mammalia") == T){ iso_data_class <- data[data$Class == "mammalia",]
	} else {
		if((class == "aves") == T){ iso_data_class <- data[data$Class == "aves",]
		}
		else{ iso_data_class <- data}
	}
		
		
		
#####decide on the isotope###
  ## AJ - the column names in these dataset are a mess!!
	if((isotope == "carbon") == T){
		dropN <- names(data) %in% c("iso_15N","delta15N")
		iso_data_class  <- iso_data_class[!dropN]
				
				dropnewN <- names(new.data) %in% c("iso_15N","delta15N")
		new.data_sub  <- new.data[!dropnewN]
		
	} else{ 
		if((isotope == "nitrogen") == T){
			dropC <- names(data) %in% c("iso_13C","delta13C")
			iso_data_class  <- iso_data_class[!dropC]
			
						dropnewC <- names(new.data) %in% c("iso_13C","delta_13C")
		new.data_sub  <- new.data[!dropnewC]
			
			}
	
		}
		

		
########get rid on NAs so that the only NAs are for the new data

		iso_data_sub_na <-  na.omit(iso_data_class)

######## Include the new data, I bind it so its at the top and hence easier to read.
	
	if(is.null(new.data) == T){
		iso_data_com <- iso_data_sub_na
	} else{ 
			iso_data_com  <- rbind(new.data_sub , iso_data_sub_na)
		}
		
	
		
####Clean the data and match up the tree using the multree function


#####this needs to be fixed so that it actually removes the dataset.

			clean_iso <-	as.mulTree(species = species_col_name, data = iso_data_com, trees = trees, clean.data = TRUE)
		
		
		##this was there to make it work with only one tree should be good now.
		#clean_iso <- clean.data(species_col_name, iso_data_com, trees)
	
		
		
#####fix that random term by checking if any of the random terms are the same as the species colume and replacing that with sp.col as the Multre function does
#		if(any(grep(species_col_name ,random)) == TRUE){
#			clean_iso$random.terms <-as.formula( gsub("species","sp.col", random))
#			} else{ clean_iso$random.terms <-as.formula( random)	
#			}
		
			
		return(clean_iso)		

}



		












	
	
