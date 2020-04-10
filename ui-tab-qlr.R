
fluidPage(column(width = 3,
                 
                 wellPanel(
                   
                   h4("Test Parameters:") %>% helper(type = "markdown",
                                                     title = "Quasi-likelihood GLM regression helper",
                                                     content = "qlr",
                                                     icon = "question",
                                                     colour = "green"),
                   
                   textInput("h1_2", "Alternative hypothesis:", value = "Treatment"),
                 
                   selectInput("adjustment_method_qlr", "pvalue Adustment Method:",
                               choices = c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none"), selected = "BH"),
                   
                   h4("Volcano Plot Parameters:"),
                   
                   selectInput("pval2", "pvalue type", choices = c("raw", "adjusted"), selected = "raw"),
                   numericInput("pval_cutoff2", "pvalue cutoff", value = 0.05),
                   numericInput("log2FC2", "log2 Fold Change cutoff", value = 1.5),
                   numericInput("xlim2", "x-label limit", value = 5)
                 
                 )
                 
                 ),
          
          column(width = 9,
                 
                 tabsetPanel(
                   
                   tabPanel("Results", DT::dataTableOutput("qlrResults")),
                   
                   tabPanel("Volcano Plot", plotlyOutput("volcano2")),
                   
                   tabPanel("Normalized and Batch Corrected Heatmap", 
                            downloadButton("expanded_heatmap_qlr", "Download Expanded Heatmap"),
                            
                            br(),
                            br(),
                            
                            plotOutput("heatmap_qlr", height = "600px"))
                   )
                 ))

