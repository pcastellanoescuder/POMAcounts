
tabPanel("Input Data", 
         fluidRow(column(width = 3,
                         
                         # downloadButton("report", "Exploratory report", style="color: #fff; background-color: #00b300; border-color: #009900"),

                         # br(),
                         # br(),

                         fileInput("target",
                                   "Upload your target file (.txt):",
                                   accept = c(
                                     "text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv")),
                         
                         fileInput("proteines","Upload your counts file (.txt):",
                                   accept = c(
                                     "text/csv",
                                     "text/comma-separated-values,text/plain",
                                     ".csv"))
         ),

         column(width = 9,
         
         bsCollapse(id="input_collapse_panel",open="tar_panel",multiple = FALSE,
                    
                    bsCollapsePanel(title="Target File",value="tar_panel", DT::dataTableOutput("contents_tar")),
                    
                    bsCollapsePanel(title="Counts File",value="prot_panel", DT::dataTableOutput("contents"))
                    ))
         ))

