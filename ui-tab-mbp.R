
fluidPage(tabsetPanel(
  
  tabPanel("Raw Data", 
           # downloadButton("download_plot1", "Download Plot"),
           plotOutput("barplot1")),
  
  tabPanel("Normalized", 
           # downloadButton("download_plot2", "Download Plot"),
           plotOutput("barplot2")),
  
  tabPanel("Normalized and Batch Corrected", 
           # downloadButton("download_plot3", "Download Plot"),
           plotOutput("barplot3"))
  
))