
fluidPage(tabsetPanel(
  
 tabPanel("Cluster by Groups", 
          downloadButton("download_plot5", "Download Plot"),
          plotOutput("cluster_groups")),
 
 tabPanel("Cluster by Batch", 
          downloadButton("download_plot6", "Download Plot"),
          plotOutput("cluster_batch"))

))

