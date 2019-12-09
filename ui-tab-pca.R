
fluidPage(column(width = 3,
                 
                 wellPanel(
                 
                 radioButtons("labs", "Show labels:",
                              choices = c("Yes" = "yes", 
                                          "No" = "no"), 
                              selected = "yes")
                 )
                 
                 ),
          
          column(width = 9,
                 
                 plotOutput("pcaplot")
                 
                 ))

