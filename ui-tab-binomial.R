
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
                   numericInput("sc_cutoff_bin", "Spectral counts cut-off", value = 4),
                   helpText("Note that this filter will only be applied to the second column."),

                   br(),
                   
                   h4("Graphical Parameters:"),
                   
                   checkboxInput("show_counts3", "Show counts mean", FALSE),
                   
                   selectInput("pval3", "pvalue type", choices = c("raw", "adjusted"), selected = "raw"),
                   numericInput("pval_cutoff3", "pvalue cutoff (volcano plot and heatmap)", value = 0.05),
                   numericInput("log2FC3", "log2 Fold Change cutoff", value = 1.5),
                   numericInput("xlim3", "x-label limit", value = 5),
                   
                   checkboxInput("prot_names3", "Heatmap rownames", FALSE)
                 
                 )
                 
                 ),
          
          column(width = 9,
                 
                 tabsetPanel(
                   
                   tabPanel("Results", DT::dataTableOutput("binomialResults")),
                   
                   tabPanel("Volcano Plot", plotlyOutput("volcano3")),
                   
                   tabPanel("Annotated Volcano Plot", plotOutput("annotated_volcano3")),
                   
                   tabPanel("Normalized and Batch Corrected Heatmap", 
                            downloadButton("expanded_heatmap_binomial", "Download Expanded Heatmap"),
                            
                            br(),
                            br(),
                            
                            plotOutput("heatmap_binomial", height = "600px"))
                 )
                 
                 ))

