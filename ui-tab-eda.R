
fluidPage(tabsetPanel(
  tabPanel("Bar plot", plotOutput("barplot")),
  tabPanel("Normalization Plot", plotOutput("normplot")),
  tabPanel("Density plot", plotOutput("densityplot")),
  tabPanel("PCA", plotOutput("pca")),
  tabPanel("Clustering by Group", plotOutput("clust_g")),
  tabPanel("Clustering by Batch", plotOutput("clust_b")),
  tabPanel("Heatmap", plotOutput("heatmap")),
  tabPanel("Scatter plot", plotOutput("scatter"))
))

