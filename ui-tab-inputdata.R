
tabPanel("Input Data", 
         fluidRow(column(width = 3,
                         
                         downloadButton("report", "Exploratory report", style="color: #fff; background-color: #00b300; border-color: #009900"),

                         br(),
                         br(),

                         fileInput("proteines","Upload your proteomics file (.txt):",
                                   accept = c(
                                     "text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")),

                         fileInput("target",
                                   "Upload your target file (.txt):",
                                   accept = c(
                                     "text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv"))
         ),

         column(width = 9,
         
         bsCollapse(id="input_collapse_panel",open="data_panel",multiple = FALSE,
                    
                    bsCollapsePanel(title="Proteomics Data",value="prot_panel",
                                    div(style = 'overflow-x: scroll', DT::dataTableOutput("contents"), width = NULL,
                                        status = "primary")),
                    bsCollapsePanel(title="Target File",value="tar_panel",
                                    div(style = 'overflow-x: scroll', DT::dataTableOutput("contents_tar"), width = NULL,
                                        status = "primary"))
                    ))
         ))

