
fluidPage(column(width = 3,
                 
                 wellPanel(
                   
                   h4("Test Parameters:") %>% helper(type = "markdown",
                                                     title = "Negative binomial GLM regression helper",
                                                     content = "binomial",
                                                     icon = "question",
                                                     colour = "green"),
                   
                   textInput("h1_3", "Alternative hypothesis:", value = "Treatment"),
                 
                   selectInput("adjustment_method_binomial", "pvalue Adustment Method:",
                               choices = c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"), selected = "BH"),
                   
                   h4("Volcano Plot Parameters:"),
                   
                   selectInput("pval3", "pvalue type", choices = c("raw", "adjusted"), selected = "raw"),
                   numericInput("pval_cutoff3", "pvalue cutoff", value = 0.05),
                   numericInput("log2FC3", "log2 Fold Change cutoff", value = 1.5),
                   numericInput("xlim3", "x-label limit", value = 5)
                 
                 )
                 
                 ),
          
          column(width = 9,
                 
                 tabsetPanel(
                   
                   tabPanel("Results", 
                            dataTableOutput("binomialResults")),
                   
                   tabPanel("Volcano Plot", 
                            plotlyOutput("volcano3"))
                 )
                 
                 ))

