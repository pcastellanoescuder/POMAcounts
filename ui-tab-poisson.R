
fluidPage(column(width = 3,
                 
                 wellPanel(
                   
                   textInput("h1", "Alternative hypothesis:", value = "Treatment"),
                 
                   selectInput("adjustment_method_poisson", "pvalue Adustment Method:",
                               choices = c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"), selected = "BH")
                 
                 )
                 
                 ),
          
          column(width = 9,
                 
                 dataTableOutput("poissonResults")
                 
                 ))

