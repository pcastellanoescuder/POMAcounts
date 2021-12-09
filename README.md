
# Welcome to POMAcounts!

<!-- badges: start -->

[![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![Last Commit](https://img.shields.io/github/last-commit/pcastellanoescuder/POMAcounts.svg)](https://github.com/pcastellanoescuder/POMAcounts/commits/master)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

<!-- badges: end -->

<h2 style="color:black">Overview</h2>

POMAcounts is a web-based tool for exploratory data analysis and statistical analysis of mass spectrometry spectral counts data. This GUI is based on the R/Bioconductor packages [msmsEDA](https://bioconductor.org/packages/release/bioc/html/msmsEDA.html) (Gregori et al., 2020a) and [msmsTests](https://bioconductor.org/packages/release/bioc/html/msmsTests.html) (Gregori et al., 2020b). The name of POMAcounts is given by the large similarity of both the front-end and the back-end that it shares with [POMAShiny](https://github.com/pcastellanoescuder/POMAShiny) web application. POMAcounts is hosted at [http://webapps.nutrimetabolomics.com/POMAcounts](http://webapps.nutrimetabolomics.com/POMAcounts).

<h2 style="color:black">Run POMAcounts locally</h2>

<h2 style="color:black">Step 1: Clone this repository</h2>

Open the terminal and run:

``` bash
git clone "https://github.com/pcastellanoescuder/POMAcounts.git"
```

<h2 style="color:black">Step 2: Install package dependencies</h2>

Open the `POMAcounts.Rproj` with [RStudio](https://rstudio.com) and run the `package_installation.R` script.

<h2 style="color:black">Step 3: Deploy POMAcounts locally</h2>

Once all dependencies have been installed run the following command and enjoy the analysis!

``` r
shiny::runApp()
```

<h2 style="color:black">Code of Conduct</h2>

Please note that the POMAcounts project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

