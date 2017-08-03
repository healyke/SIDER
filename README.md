[![Build Status](https://travis-ci.org/healyke/SIDER.svg?branch=master)](https://travis-ci.org/healyke/SIDER)
[![DOI](https://zenodo.org/badge/45869597.svg)](https://zenodo.org/badge/latestdoi/45869597)
[![codecov](https://codecov.io/gh/healyke/SIDER/branch/master/graph/badge.svg)](https://codecov.io/gh/healyke/SIDER)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
# SIDER
Stable Isotope Discrimination Estimation in R

This package allows users to estimate Trophic Discrimination Factors (TDF) for species with no current measured TDF values using Bayesian imputation. 
This package is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees using [mulTree](https://github.com/TGuillerme/mulTree).


## Installing SIDER (latest stable release)

If you want the vignettes installed along with `SIDER` you will need to first download and install the `JAGS` software which is required for the package `MixSIAR` that is called in the *SIDER-to-MixSIAR-pipeline* vignette. Please note also that these vignettes take some time to run as there are several real calls made to SIDER, and it will probably take about **15 minutes** on a 2.7 GHz i5 with 16 GB RAM to install.

```
# Install devtools if you dont already have it
if(!require(devtools)) install.packages("devtools")
devtools::install_github("healyke/SIDER@v1.0.0", build_vignettes = TRUE)
library(SIDER)
```

If you want to skip the vignette installation then you can run the following.

```
# Install devtools if you dont already have it
if(!require(devtools)) install.packages("devtools")
devtools::install_github("healyke/SIDER@v1.0.0", build_vignettes = FALSE)
library(SIDER)
```

## Installing SIDER (development - not guaranteed stable)
```
if(!require(devtools)) install.packages("devtools")
devtools::install_github("healyke/SIDER@master", build_vignettes = TRUE)
library(SIDER)
```


Authors
-------
[Kevin Healy](http://healyke.github.io), Seán B.A Kelly, [Thomas Guillerme](http://tguillerme.github.io), [Andrew Jackson](https://github.com/AndrewLJackson)

Citation
-------
If you are using this package, please cite this pre-print until we finalise the paper and have it peer-reviewed:

Healy K, Kelly SBA, Guillerme T, Inger R, Bearhop S, Jackson AL. (2016) Predicting trophic discrimination factor using Bayesian inference and phylogenetic, ecological and physiological data. SIDER: Discrimination Estimation in R. PeerJ Preprints 4:e1950v1 https://doi.org/10.7287/peerj.preprints.1950v1
