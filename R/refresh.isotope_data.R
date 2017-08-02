#' @title Refreshes the isotope dataset
#'   
#' @description Internal utility function for refreshing the isotope_data 
#'   dataset (not exported) This function rapidly updates the isotope_data.rda 
#'   file once one updates the TESIR_data.csv file.
#'   
#' @param data which is typically the SIDER_data.csv file containing the dataset
#'   used for model fitting and imputation.
#'   
#' @return Saves the updated file to ../data/isotope_data.rda for use within the
#'   pacakge
#'   
#' @author Thomas Guillerme


refresh.isotope_data <- function(data = "SIDER_data.csv") {
    # Read the csv file from the package data
    isotope_data <- utils::read.table(file = system.file("extdata", data, 
                                                       package = "SIDER"), 
                                    header = TRUE, 
                                    stringsAsFactors = FALSE,
                                    encoding = "UTF-8")
    
    # Save it as the isotope_data set in the manual
    save(isotope_data, file = "../data/isotope_data.rda", compress = 'xz')
    
    # Make sure to update the manual
    cat("isotope_data.rda file successfully updated.\n
        Don't forget to update the man page in \\man\\SIDER.R if necessary.")
}