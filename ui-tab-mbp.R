
fluidPage(tabsetPanel(
  
  tabPanel("Raw Data", 
           # downloadButton("download_plot", "Download Plot"),
           plotOutput("barplot1")),
  
  tabPanel("Normalized", 
           # downloadButton("download_plot12", "Download Plot"),
           plotOutput("barplot2")),
  
  tabPanel("Normalized and Batch Corrected", 
           # downloadButton("download_plot13", "Download Plot"),
           plotOutput("barplot3"))
  
))