
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

