
fluidPage(column(width = 3,
                 
                 wellPanel(
                   
                   numericInput("xlim", "X-axis limit:", 30)
                 )
                 
),

column(width = 9,
       
       plotOutput("densityplot")
       
))