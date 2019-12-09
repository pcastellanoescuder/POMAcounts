
source("helpers.R")
source("themes.R")

dashboardPage(skin = "blue",
              
              dashboardHeader(title = logo_poma),
  
  dashboardSidebar(sidebarMenu(
    menuItem("Input Data", tabName = "inputdata", icon = icon("upload")),
    menuItem("EDA", tabName = "eda")
  )),

  dashboardBody(
    
    poma_theme,

    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "mycss.css")
    ),
    tabItems(
      tabItem(tabName = "inputdata",
              source("ui-tab-inputdata.R",local=TRUE)$value),
      tabItem(tabName = "eda",
              source("ui-tab-eda.R",local=TRUE)$value)
      ),

    tags$hr(),

    ## FOOTER

    tags$footer(p(h5(("Pol Castellano Escuder"), align="center",width=3),
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

