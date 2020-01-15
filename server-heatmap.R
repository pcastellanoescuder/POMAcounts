source("aux_functions.R")

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

output$expanded_heatmap <- downloadHandler(

  filename = paste0(Sys.Date(), "_EDA_POMA_Expanded_Heatmap.pdf"),
  content = function(file) {

    corrected <- Barplot()$corrected

    h <- nrow(exprs(corrected))/(2.54/0.35)
    pdf(file = file, width = 7, height = h)
    exp.heatmap(corrected, "Treatment", h = h, tit = "")
    dev.off()
    }
  )

