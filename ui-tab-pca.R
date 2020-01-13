
fluidPage(column(width = 3,
                 
                 wellPanel(
                 
                 radioButtons("labs", "Show labels:",
                              choices = c("Yes" = "yes", 
                                          "No" = "no"), 
                              selected = "yes")
                 )
                 
                 ),
          
          column(width = 9,
                 
                 tabsetPanel(
                   
                   tabPanel("Raw Data", 
                            # downloadButton("download_plot", "Download Plot"),
                            plotOutput("pcaplot1")),
                   
                   tabPanel("Normalized", 
                            # downloadButton("download_plot12", "Download Plot"),
                            plotOutput("pcaplot2")),
                   
                   tabPanel("Normalized and Batch Corrected", 
                            # downloadButton("download_plot13", "Download Plot"),
                            plotOutput("pcaplot3"))
                   
                 )
                 
                 ))

