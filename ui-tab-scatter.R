
fluidPage(column(width = 3,
                 
                 wellPanel(
                 
                 radioButtons("trans", "Transformation:",
                              choices = c("None" = "none",
                                          "Log2" = "log2", 
                                          "Root" = "sqrt"), 
                              selected = "none"),
                 numericInput("minSpC", "minSpC", 2),
                 numericInput("minLFC", "minLFC", 1)
                 
                 )
                 
                 ),
          
          column(width = 9,
                 
                 downloadButton("download_plot8", "Download Plot"),
                 
                 plotOutput("scatter")
                 
                 ))

