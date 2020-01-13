
fluidPage(column(width = 3,
                 
                 wellPanel(
                   numericInput("minSpC", "minSpC:", 2)
                 )
                 
),

column(width = 9,
       
       tabsetPanel(
               
               tabPanel("Raw Data", 
                        # downloadButton("download_plot", "Download Plot"),
                        plotOutput("normplot1")),
               
               tabPanel("Normalized", 
                        # downloadButton("download_plot12", "Download Plot"),
                        plotOutput("normplot2")),
               
               tabPanel("Normalized and Batch Corrected", 
                        # downloadButton("download_plot13", "Download Plot"),
                        plotOutput("normplot3"))
               
       )
       
))

