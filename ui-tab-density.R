
fluidPage(column(width = 3,
                 
                 wellPanel(
                   
                   numericInput("xlim", "X-axis limit:", 30)
                 )
                 
),

column(width = 9,
       
       tabsetPanel(
               
               tabPanel("Raw Data", 
                        # downloadButton("download_plot", "Download Plot"),
                        plotOutput("densityplot1")),
               
               tabPanel("Normalized", 
                        # downloadButton("download_plot12", "Download Plot"),
                        plotOutput("densityplot2")),
               
               tabPanel("Normalized and Batch Corrected", 
                        # downloadButton("download_plot13", "Download Plot"),
                        plotOutput("densityplot3"))
               
       )
       
))