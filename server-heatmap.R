
output$heatmap1 <- renderPlot({
  
  raw <- Barplot()$raw
  
  ####
  
  total <- exprs(raw)
  target <- pData(raw)
  
  my_group <- as.numeric(as.factor(target$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)
  
  heatmap(total, ColSideColors = colSide, col = colMain, labRow = NA)
  
})

output$heatmap2 <- renderPlot({
  
  norm <- Barplot()$norm
  
  ####
  
  total <- exprs(norm)
  target <- pData(norm)
  
  my_group <- as.numeric(as.factor(target$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)
  
  heatmap(total, ColSideColors = colSide, col = colMain, labRow = NA)
  
})

output$heatmap3 <- renderPlot({
  
  corrected <- Barplot()$corrected
  
  ####
  
  total <- exprs(corrected)
  target <- pData(corrected)
  
  my_group <- as.numeric(as.factor(target$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)
  
  heatmap(total, ColSideColors = colSide, col = colMain, labRow = NA)
  
})

output$expanded_heatmap <- renderPlot({
  
  corrected <- Barplot()$corrected
  
  ####
  
  total <- exprs(corrected)
  target <- pData(corrected)
  
  heatmap.2(total)
  
})

# output$download_plot7 <- downloadHandler(
#   filename =  function() {
#     paste0("Heatmap_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print() # for GGPLOT
#     dev.off()  # turn the device off
#     
#   }) 

