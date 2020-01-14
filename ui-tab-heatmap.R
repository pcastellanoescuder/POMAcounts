
fluidPage(tabsetPanel(
  
  tabPanel("Raw Data", 
           # downloadButton("download_plot", "Download Plot"),
           plotOutput("heatmap1", height = "600px")),
  
  tabPanel("Normalized", 
           # downloadButton("download_plot12", "Download Plot"),
           plotOutput("heatmap2", height = "600px")),
  
  tabPanel("Normalized and Batch Corrected", 
           # downloadButton("download_plot13", "Download Plot"),
           plotOutput("heatmap3", height = "600px"))
  
))