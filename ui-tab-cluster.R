
fluidPage(tabsetPanel(
  
 tabPanel("Cluster by Groups", plotOutput("cluster_groups")),
 tabPanel("Cluster by Batch", plotOutput("cluster_batch"))

))

