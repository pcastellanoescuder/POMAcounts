
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
                   
                   checkboxInput("show_counts3", "Show counts mean", FALSE),
                   checkboxInput("labels3", "Show labels", FALSE),
                   
                   selectInput("pval3", "pvalue type", choices = c("raw", "adjusted"), selected = "raw"),
                   numericInput("pval_cutoff3", "pvalue cutoff (volcano plot and heatmap)", value = 0.05),
                   numericInput("log2FC3", "log2 Fold Change cutoff", value = 1.5),
                   numericInput("xlim3", "x-label limit", value = 5)
                 
                 )
                 
                 ),
          
          column(width = 9,
                 
                 tabsetPanel(
                   
                   tabPanel("Results", DT::dataTableOutput("binomialResults")),
                   
                   tabPanel("Volcano Plot", plotlyOutput("volcano3")),
                   
                   tabPanel("Normalized and Batch Corrected Heatmap", 
                            downloadButton("expanded_heatmap_binomial", "Download Expanded Heatmap"),
                            
                            br(),
                            br(),
                            
                            plotOutput("heatmap_binomial", height = "600px"))
                 )
                 
                 ))

