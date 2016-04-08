# FestR
Trophic Discrimination Factor estimation in R

This package allows users to estimate Trophic Discrimination Factors (TDF) for species with no current measured TDF values using Bayesian imputation. 
This package is based on the [MCMCglmm](http://cran.r-project.org/web/packages/MCMCglmm/index.html) package
and runs a MCMCglmm analysis on multiple trees using [MulTree] (https://github.com/TGuillerme/mulTree)

## Installing FestR
```r
if(!require(devtools)) install.packages("devtools")
install_github("healyke/FestR", ref = "master")
install_github("TGuillerme/mulTree", ref = "master")
library(mulTree)
library(FestR)
```

#### Vignettes
*  The package manual is abvailable [here in .Rmd](https://github.com/healyke/FestR/blob/master/doc/Introduction-to-FestR.Rmd) and [here in .pdf](https://github.com/healyke/FestR/blob/master/doc/Introduction-to-FestR.pdf)


Authors
-------
[Kevin Healy](http://healyke.github.io), [Seán B.A Kelly], [Thomas Guillerme](http://tguillerme.github.io), [Andrew Jackson](https://github.com/AndrewLJackson)

Citation
-------
If you are using this package, please cite: Coming to a preprint near you April 4th-8th
