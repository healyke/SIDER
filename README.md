# FestR
Fractionation estimation in R package

This package allows users to estimate Fractionation values for stable isotope dietary analysis using Bayesian imputation. 
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
*  The package manual 


Authors
-------
[Kevin Healy](http://healyke.github.io), [Seán B.A Kelly], [Thomas Guillerme](http://tguillerme.github.io), [Andrew Jackson](https://github.com/AndrewLJackson)

Citation
-------
If you are using this package, please cite: Coming to a preprint near you April 4th-8th
