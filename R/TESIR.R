#' TESIR: Estimating istopic fractionation / trophic enrichment factors
#' 
#' TESIR uses a phylogenetic regression model to estimate the isotopic 
#' fractionation or trophic enrichment factor depending on ones preference for 
#' terminology. Estimates are imputed using Bayesian inference, and draw from 
#' species in close taxonomic proximity as well as including information on the 
#' tissue type and ecology of the TESIRed estimate. The database used to
#' generate these predictions can be updated in the future as more infomraiton
#' becomes available, which will lead to ever more accurate and precise
#' estimates. Only mammals and birds are currently included in the pacakge, but
#' again this can be expanded to other taxonomic groups as more data becomes
#' available. We provide examples of how to use custom databases and custom
#' models for prediction.
#' 
#' 
#' @section TESIR functions: The TESIR functions ...
#'   
#' @docType package
#' @name TESIR
NULL
#> NULL


#' Example Aves and Mammalia lifespan for the mulTree package
#'
#' This is a dataset containing lifespan data from 192 species of birds and mammals.
#'
#' @name isotope_data
#' @aliases TESIR_data
#' @docType data
#'
#' @format a \code{data.frame} containing isotopic data derived from controlled feeding trials on birds and mammals.
#' \describe{
#'        \item{species}{The species binomial name.}
#'        \item{habitat}{The species habitat (either \code{marine} or \code{terrestrial}).}
#'        \item{taxonomic.class}{The species taxonomic class (either \code{aves} or \code{mammalia}).}
#'        \item{tissue}{The measured tissue (\code{liver}, \code{blood}, \code{kidney}, \code{muscle}, \code{hair}, \code{milk}, \code{feather}, \code{claws} or , \code{Collagen}.}
#'        \item{source.iso.13C}{The isotopic 13C delta of the food source.}
#'        \item{source.iso.15N}{The isotopic 15N delta of the food source.}
#'        \item{delta13C}{The tropic discrimination factor for delta 13C.}
#'        \item{delta15N}{The tropic discrimination factor for delta 15N}
#' }
#' @references [ADD REFERENCES]
#'
#' @keywords datasets
NULL

# #' Example dataset for the \code{mulTree} package
# #'
# #' This is a dataset containing lifespan data and trees from Healy et al (2014)
# #'
# #' @name lifespan
# #' @docType data
# #'
# #' @format Contains a \code{data.frame} and two \code{multiPhylo} objects:
# #'    \describe{
# #'        \item{lifespan_volant}{A \code{data.frame} object of five variables for 192 species (see \code{\link{lifespan_volant_192taxa}}).}
# #'        \item{trees_aves}{A \code{multiPhylo} object of two trees of 58 bird species. The tip names are the binomial names of the species.}
# #'        \item{trees_mammalia}{A a \code{multiPhylo} object of two trees of 134 mammal species. The tip names are the binomial names of the species.}
# #'    }
# #'
# #' @references Healy, K., Guillerme, T., Finlay, S., Kane, A., Kelly, S, B, A., McClean, D., Kelly, D, J., Donohue, I., Jackson, A, L., Cooper, N. (2014) Ecology and mode-of-life explain lifespan variation in birds and mammals. Proceedings of the Royal Society B 281, 20140298c
# #'
# #' @keywords datasets
# NULL