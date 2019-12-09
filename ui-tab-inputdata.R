
tabPanel("Input Data", 
         fluidRow(column(width = 3,

                         fileInput("proteines","Please choose your data (.csv):", accept = c(
                           "text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),

                         fileInput("target",
                                   "Upload your covariates file (.csv):",
                                   accept = c(
                                     "text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv"))
         ),

         column(9,
         
         div(style = 'overflow-x: scroll', DT::dataTableOutput("contents"), width = NULL,
             status = "primary"),
         div(style = 'overflow-x: scroll', DT::dataTableOutput("contents_tar"), width = NULL,
             status = "primary")
)))

