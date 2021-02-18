
source("helpers.R")
source("themes.R")

dashboardPage(skin = "blue",
              
  dashboardHeader(title = logo_poma),
  
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("home")),
    menuItem("Input Data", tabName = "inputdata", icon = icon("upload")),
    menuItem("Exploratory Data Analysis", tabName = "eda", icon = icon("search"),
             menuSubItem("Median Bar Plot", tabName = "mbp"),
             menuSubItem("Normalization Plot", tabName = "norm"),
             menuSubItem("Density Plot", tabName = "density"),
             menuSubItem("Principal Component Analysis", tabName = "pca"),
             menuSubItem("Clustering", tabName = "cluster"),
             menuSubItem("Heatmap", tabName = "heatmap"),
             menuSubItem("Important Features", tabName = "scatter")),
    menuItem("Statistical Analysis", tabName = "tests", icon = icon("chart-bar"),
             menuSubItem("Poisson GLM", tabName = "poisson"),
             menuSubItem("Quasi-likelihood GLM", tabName = "qlr"),
             menuSubItem("Negative Binomial GLM", tabName = "binomial")),
    menuItem("License", tabName = "license", icon = icon("clipboard")),
    menuItem("Code of Conduct", tabName = "conduct", icon = icon("clipboard-check")),
    menuItem("Contact", tabName = "contact", icon = icon("user"))
    )
    ),

  dashboardBody(
    
    poma_theme,

    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "mycss.css"),
       tags$style(HTML("
       .shiny-output-error-validation {color: red;}
       .dataTables_scrollBody {transform:rotateX(180deg);}
       .dataTables_scrollBody table {transform:rotateX(180deg);}"))
    ),
    tabItems(
      tabItem(tabName = "home",
              source("ui-tab-home.R",local=TRUE)$value),
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
              source("ui-tab-scatter.R",local=TRUE)$value),
      tabItem(tabName = "poisson",
              source("ui-tab-poisson.R",local=TRUE)$value),
      tabItem(tabName = "qlr",
              source("ui-tab-qlr.R",local=TRUE)$value),
      tabItem(tabName = "binomial",
              source("ui-tab-binomial.R",local=TRUE)$value),
      tabItem(tabName = "license",
              source("ui-tab-license.R",local=TRUE)$value),
      tabItem(tabName = "conduct",
              source("ui-tab-conduct.R",local=TRUE)$value),
      tabItem(tabName = "contact",
              source("ui-tab-contact.R",local=TRUE)$value)
      ),

    tags$hr(),

    ## FOOTER

    tags$footer(p(h5(("Pol Castellano Escuder and Alex Sánchez Pla"), align="center",width=3),
              p(("Statistics and Bioinformatics Research Group"),"and", align="center",width=3),
              p(("Biomarkers and Nutritional & Food Metabolomics Research Group"),"from",
                align="center", width=3),
              p(("University of Barcelona"),align="center",width = 3),
              p(("Copyright (C) 2021, code licensed under GPLv3"), align = "center", width = 4),
              p(("Code available on Github:"),a("https://github.com/pcastellanoescuder/POMAcounts",
                                                href="https://github.com/pcastellanoescuder/POMAcounts"),
                align="center",width=4),
              p(("This app is based on "), 
                a("msmsEDA", href = "https://www.bioconductor.org/packages/release/bioc/html/msmsEDA.html"), "and",
                a("msmsTests", href = "https://www.bioconductor.org/packages/release/bioc/html/msmsTests.html"), 
                "Bioconductor packages by Josep Gregori, Alex Sánchez and Josep Villanueva", align = "center", width = 4)

              )),

    ## GOOGLE ANALYTICS

    tags$head(includeScript("google-analytics.js"))
  )
)

