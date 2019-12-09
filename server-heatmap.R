
output$heatmap <- renderPlot({
  
  total <- Densityplot()$total
  target <- targetInput()
  colnames(target) <- c("Sample", "Treatment", "Batch")
  
  my_group <- as.numeric(as.factor(target$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)
  
  heatmap(t(total[, 3:ncol(total)]), ColSideColors = colSide, col = colMain, labRow = NA)
  
})

