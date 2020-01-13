
fluidPage(tabsetPanel(
  
 tabPanel("Raw Data Cluster by Treatment", 
          # downloadButton("download_plot5", "Download Plot"),
          plotOutput("cluster_groups1")),
 
 tabPanel("Raw Data Cluster by Batch", 
          # downloadButton("download_plot6", "Download Plot"),
          plotOutput("cluster_batch1")),
 
 tabPanel("Normalized Cluster by Treatment", 
          # downloadButton("download_plot5", "Download Plot"),
          plotOutput("cluster_groups2")),
 
 tabPanel("Normalized Cluster by Batch", 
          # downloadButton("download_plot6", "Download Plot"),
          plotOutput("cluster_batch2")),
 
 tabPanel("Normalized and Batch Corrected Cluster by Treatment", 
          # downloadButton("download_plot5", "Download Plot"),
          plotOutput("cluster_groups3")),
 
 tabPanel("Normalized and Batch Corrected Cluster by Batch", 
          # downloadButton("download_plot6", "Download Plot"),
          plotOutput("cluster_batch3"))

))