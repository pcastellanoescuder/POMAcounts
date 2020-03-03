
options(shiny.maxRequestSize = 100*1024^2)

source("helpers.R")
print(sessionInfo())

shinyServer(function(input, output, session) {

  source("server-inputdata.R",local = TRUE)
  source("server-mbp.R",local = TRUE)
  source("server-norm.R",local = TRUE)
  source("server-density.R",local = TRUE)
  source("server-pca.R",local = TRUE)
  source("server-cluster.R",local = TRUE)
  source("server-heatmap.R",local = TRUE)
  source("server-scatter.R",local = TRUE)
  source("server-poisson.R",local = TRUE)
  source("server-qlr.R",local = TRUE)

})

