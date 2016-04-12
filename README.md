# DEsiR
Trophic Discrimination Factor estimation in R

This package allows users to estimate Trophic Discrimination Factors (TDF) for species with no current measured TDF values using Bayesian imputation. 
This package is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees using [MulTree] (https://github.com/TGuillerme/mulTree)

## Installing DEsiR
```r
if(!require(devtools)) install.packages("devtools")
install_github("healyke/DEsiR", ref = "master")
install_github("TGuillerme/mulTree", ref = "master")
library(mulTree)
library(DEsiR)
```

#### Vignettes
*  The package manual is abvailable [here in .Rmd](https://github.com/healyke/DEsiR/blob/master/doc/Introduction-to-DEsiR.Rmd) and [here in .pdf](https://github.com/healyke/DEsiR/blob/master/doc/Introduction-to-DEsiR.pdf)


Authors
-------
[Kevin Healy](http://healyke.github.io), [Seán B.A Kelly], [Thomas Guillerme](http://tguillerme.github.io), [Andrew Jackson](https://github.com/AndrewLJackson)

Citation
-------
If you are using this package, please cite: Healy K, Kelly SBA, Guillerme T, Inger R, Bearhop S, Jackson AL. (2016) Predicting trophic discrimination factor using Bayesian inference and phylogenetic, ecological and physiological data. DEsIR: Discrimination Estimation in R. PeerJ Preprints 4:e1950v1 https://doi.org/10.7287/peerj.preprints.1950v1
