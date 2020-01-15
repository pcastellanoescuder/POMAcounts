
fluidPage(tabsetPanel(
  
  tabPanel("Raw Data", 
           # downloadButton("download_plot", "Download Plot"),
           plotOutput("heatmap1", height = "600px")),
  
  tabPanel("Normalized", 
           # downloadButton("download_plot12", "Download Plot"),
           plotOutput("heatmap2", height = "600px")),
  
  tabPanel("Normalized and Batch Corrected", 
           downloadButton("expanded_heatmap", "Download Expanded Heatmap"),
           
           br(),
           br(),
           
           plotOutput("heatmap3", height = "600px"))
  
))