#' SIDER: Estimating isotopic fractionation / trophic discrimination factors
#' 
#' SIDER uses a phylogenetic regression model to estimate the isotopic 
#' fractionation or trophic enrichment factor depending on ones preference for 
#' terminology. Estimates are imputed using Bayesian inference, and draw from 
#' species in close taxonomic proximity as well as including information on the 
#' tissue type and ecology of the SIDER-ed estimate. The database used to
#' generate these predictions can be updated in the future as more information
#' becomes available, which will lead to ever more accurate and precise
#' estimates. Only mammals and birds are currently included in the package, but
#' again this can be expanded to other taxonomic groups as more data becomes
#' available. We provide examples of how to use custom databases and custom
#' models for prediction.
#' 
#' 
#'   
#' @docType package
#' @name SIDER
NULL
#> NULL


#' Isotope data set
#' 
#' This is a dataset containing isotope data collected for the \code{SIDER}
#' package.
#' 
#' @name isotope_data
#' @aliases SIDER_data
#' @docType data
#'   
#' @format a \code{data.frame} containing isotopic data derived from controlled
#'   feeding trials on birds and mammals. \describe{ \item{species}{The species
#'   binomial name.} \item{habitat}{The species habitat (either \code{marine} or
#'   \code{terrestrial}).} \item{taxonomic.class}{The species taxonomic class
#'   (either \code{aves} or \code{mammalia}).} \item{tissue}{The measured tissue
#'   (\code{liver}, \code{blood}, \code{kidney}, \code{muscle}, \code{hair},
#'   \code{milk}, \code{feather}, \code{claws} or , \code{Collagen}.} 
#'   \item{source.iso.13C}{The isotopic 13C delta of the food source.} 
#'   \item{source.iso.15N}{The isotopic 15N delta of the food source.} 
#'   \item{delta13C}{The tropic discrimination factor for delta 13C.} 
#'   \item{delta15N}{The tropic discrimination factor for delta 15N} }
#' @references [ADD REFERENCES]
#'   
#' @keywords datasets
NULL

#' Avian and mammalian trees
#' 
#' This is a dataset containing trees from birds (Jetz et al, 2012) and mammals
#' (Kuhn et al, 2011).
#' 
#' @name combined_trees
#' @aliases combined_tree
#' @docType data
#'   
#' @format Contains a \code{multiPhylo} object of two randomly combined trees of
#'   birds and mammals.
#'   
#' @references [ADD REFERENCES]
#'   
#' @keywords datasets
NULL