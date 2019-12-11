
Clusterplot <- reactive({
  
  total <- Densityplot()$total
  target <- targetInput()
  
  dend1 <- total[, 3:ncol(total)] %>% 
    dist %>% 
    hclust 
  order <- dend1$order
  target2 <- target[order, ]
  my_group <- as.numeric(as.factor(target2$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  
  dend1 <- dend1 %>%
    as.dendrogram() %>%
    set("labels_colors", colSide)
  
  # batch
  
  dend2 <- total[, 3:ncol(total)] %>% 
    dist %>% 
    hclust 
  order <- dend2$order
  target2 <- target[order, ]
  my_group <- as.numeric(as.factor(target2$Batch))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  
  dend2 <- dend2 %>%
    as.dendrogram() %>%
    set("labels_colors", colSide)
  
  return(list(dend1 = dend1, dend2 = dend2))

})

####

output$cluster_groups <- renderPlot({
  Clusterplot()$dend1 %>%
    plot()
})

output$cluster_batch <- renderPlot({
  Clusterplot()$dend2 %>%
    plot()
})

output$download_plot5 <- downloadHandler(
  filename =  function() {
    paste0("ClusterByGroups_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print(Clusterplot()$dend1 %>%
            plot()) # for GGPLOT
    dev.off()  # turn the device off
    
  }) 

output$download_plot6 <- downloadHandler(
  filename =  function() {
    paste0("ClusterByBatch_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print(Clusterplot()$dend2 %>%
            plot()) # for GGPLOT
    dev.off()  # turn the device off
    
  }) 


