
fluidPage(column(width = 3,
                 
                 wellPanel(
                   numericInput("minSpC", "minSpC:", 2)
                 )
                 
),

column(width = 9,
       
       downloadButton("download_plot2", "Download Plot"),
       
       plotOutput("normplot", height = "800px")
       
))
