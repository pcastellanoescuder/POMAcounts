
fluidPage(column(width = 3,
                 
                 wellPanel(
                   
                   numericInput("xlim", "X-axis limit:", 30)
                 )
                 
),

column(width = 9,
       
       downloadButton("download_plot3", "Download Plot"),
       
       plotOutput("densityplot")
       
))