
fluidPage(
  
  # column(width = 3,
  #                
  #                wellPanel(
                   
                   # h4("Test Parameters:") %>% 
                     # helper(type = "markdown",
                     #        title = "Quasi-likelihood GLM regression helper",
                     #        content = "qlr",
                     #        icon = "question",
                     #        colour = "green"),
                   
          #          textInput("h1_deseq", "Alternative hypothesis:", value = "Treatment")
          #          
          #        )
          #        
          #        ),
          # 
          column(width = 12,
                 
                 DT::dataTableOutput("DESeq2Results")
          
                 # tabsetPanel(
                 #   
                 #   tabPanel("Results", DT::dataTableOutput("DESeq2Results")),
                 #   
                 #   tabPanel("Volcano Plot", plotlyOutput("volcano2")),
                 #   
                 #   tabPanel("Annotated Volcano Plot", plotOutput("annotated_volcano2")),
                 #   
                 #   tabPanel("Normalized and Batch Corrected Heatmap", 
                 #            downloadButton("expanded_heatmap_qlr", "Download Expanded Heatmap"),
                 #            
                 #            br(),
                 #            br(),
                 #            
                 #            plotOutput("heatmap_qlr", height = "600px"))
                 #   )
                 )
          )

