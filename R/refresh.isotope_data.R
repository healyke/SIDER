#Internal utility function for refreshing the istotop_data dataset (not exported)
#This function rapidly updates the isotope_data.rda file once one updates the TESIR_data.csv file.
refresh.isotope_data <- function(data = "TESIR_data.csv") {
    # Read the csv file from the package data
    isotope_data <- read.csv(file = system.file("extdata", data, package = "TESIR"), header = TRUE, stringsAsFactors = FALSE)
    # Save it as the isotope_data set in the manual
    save(isotope_data, file = "../data/isotope_data.rda")
    # Make sure to update the manual
    cat("isotope_data.rda file successfully updated.\nDon't forget to update the man page in \\man\\TESIR.R if necessary.")
}