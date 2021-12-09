
# This file is part of POMAcounts.

# POMAcounts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMAcounts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMAcounts. If not, see <https://www.gnu.org/licenses/>.

# Installs all requirements for generating data and running the app

cran_pkgs <- c(
  "shiny", 
  "BiocManager",
  "devtools", 
  "shinydashboard", 
  "DT", 
  "reshape2", 
  "tidyverse", 
  "gplots", 
  "RColorBrewer", 
  "shinyBS", 
  "ggrepel", 
  "gtools", 
  "shinyhelper", 
  "plotly", 
  "dashboardthemes"
  )

bioc_pkgs <- c(
  "ComplexHeatmap",
  "msmsEDA", 
  "msmsTests", 
  "mixOmics", 
  "Biobase", 
  "MSnbase"
  )

# Install CRAN packages
installifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    install.packages(pckgName, dep = TRUE)
    library(pckgName, character.only = TRUE)
  }
}

lapply(cran_pkgs, installifnot)

# Install Bioconductor packages
installBiocifnot <- function(pckgName){
  if (!(require(pckgName, character.only = TRUE))) {
    BiocManager::install(pckgName)
    library(pckgName, character.only = TRUE)
  }
}

lapply(bioc_pkgs, installBiocifnot)

