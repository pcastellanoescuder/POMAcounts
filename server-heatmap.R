
output$heatmap <- renderPlot({
  
  total <- Densityplot()$total
  target <- targetInput()
  colnames(target) <- c("Sample", "Treatment", "Batch")
  
  my_group <- as.numeric(as.factor(target$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)
  
  heatmap(t(total[, 3:ncol(total)]), ColSideColors = colSide, col = colMain, labRow = NA)
  
})

output$download_plot7 <- downloadHandler(
  filename =  function() {
    paste0("Heatmap_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print() # for GGPLOT
    dev.off()  # turn the device off
    
  }) 