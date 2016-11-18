[![Build Status](https://travis-ci.org/healyke/SIDER.svg?branch=master)](https://travis-ci.org/healyke/SIDER)
[![DOI](https://zenodo.org/badge/45869597.svg)](https://zenodo.org/badge/latestdoi/45869597)
# SIDER
Stable Isotope Discrimination Estimation in R

This package allows users to estimate Trophic Discrimination Factors (TDF) for species with no current measured TDF values using Bayesian imputation. 
This package is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees using [mulTree] (https://github.com/TGuillerme/mulTree)

## Installing SIDER
```r
if(!require(devtools)) install.packages("devtools")
devtools::install_github("TGuillerme/mulTree@release")
devtools::install_github("healyke/SIDER@v0.9", build_vignettes = TRUE)
library(mulTree)
library(SIDER)
```

#### Vignettes
*  AJ - need to update these links. though ive added build_vignettes to the install instructions above so users will have access from the package itself.


Authors
-------
[Kevin Healy](http://healyke.github.io), [Seán B.A Kelly], [Thomas Guillerme](http://tguillerme.github.io), [Andrew Jackson](https://github.com/AndrewLJackson)

Citation
-------
If you are using this package, please cite this pre-print until we finalise the paper and have it peer-reviewed:

Healy K, Kelly SBA, Guillerme T, Inger R, Bearhop S, Jackson AL. (2016) Predicting trophic discrimination factor using Bayesian inference and phylogenetic, ecological and physiological data. SIDER: Discrimination Estimation in R. PeerJ Preprints 4:e1950v1 https://doi.org/10.7287/peerj.preprints.1950v1
