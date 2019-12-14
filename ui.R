
options(repos = BiocManager::repositories())
getOption("repos")

source("helpers.R")
source("themes.R")

dashboardPage(skin = "blue",
              
              dashboardHeader(title = logo_poma),
  
  dashboardSidebar(sidebarMenu(
    menuItem("Input Data", tabName = "inputdata", icon = icon("upload")),
    menuItem("Exploratory Data Analysis", tabName = "eda", icon = icon("search"),
             menuSubItem("Median Bar Plot", tabName = "mbp"),
             menuSubItem("Normalization Plot", tabName = "norm"),
             menuSubItem("Density Plot", tabName = "density"),
             menuSubItem("Principal Component Analysis", tabName = "pca"),
             menuSubItem("Clustering", tabName = "cluster"),
             menuSubItem("Heatmap", tabName = "heatmap"),
             menuSubItem("Important Features", tabName = "scatter"))

  )),

  dashboardBody(
    
    poma_theme,

    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "mycss.css")
    ),
    tabItems(
      tabItem(tabName = "inputdata",
              source("ui-tab-inputdata.R",local=TRUE)$value),
      tabItem(tabName = "mbp",
              source("ui-tab-mbp.R",local=TRUE)$value),
      tabItem(tabName = "norm",
              source("ui-tab-norm.R",local=TRUE)$value),
      tabItem(tabName = "density",
              source("ui-tab-density.R",local=TRUE)$value),
      tabItem(tabName = "pca",
              source("ui-tab-pca.R",local=TRUE)$value),
      tabItem(tabName = "cluster",
              source("ui-tab-cluster.R",local=TRUE)$value),
      tabItem(tabName = "heatmap",
              source("ui-tab-heatmap.R",local=TRUE)$value),
      tabItem(tabName = "scatter",
              source("ui-tab-scatter.R",local=TRUE)$value)
      ),

    tags$hr(),

    ## FOOTER

    tags$footer(p(h5(("Pol Castellano Escuder and Alex Sánchez Pla"), align="center",width=3),
              p(("Statistics and Bioinformatics Research Group"),"and", align="center",width=3),
              p(("Biomarkers and Nutritional & Food Metabolomics Research Group"),"from",
                align="center", width=3),
              p(("University of Barcelona"),align="center",width=3)
              # p(("Copyright (C) 2018, code licensed under GPLv3"),align="center",width=4),
              # p(("Code available on Github:"),a("https://github.com/pcastellanoescuder/POMA_Shiny",
              #                                   href="https://github.com/pcastellanoescuder/POMA_Shiny"),
              #   align="center",width=4),
              # p(("POMA R package available on Github:"),a("https://github.com/pcastellanoescuder/POMA",
              #                                   href="https://github.com/pcastellanoescuder/POMA"),
              #   align="center",width=4)
              ))

    ## GOOGLE ANALYTICS

    # tags$head(includeScript("google-analytics.js"))
  )
)

