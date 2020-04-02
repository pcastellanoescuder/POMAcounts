
PCAplot <- reactive({
  
  ### RAW
  
  raw <- Barplot()$raw
    
  res_pca1 <- mixOmics::pca(t(exprs(raw)))
  res_pca <- cbind(pData(raw), res_pca1$x)
  
  pcaplot1 <- ggplot(res_pca, aes(PC1, PC2, color = Treatment, shape = Batch)) +
    geom_point(size = 3, alpha = 0.8) +
    {if(input$labs == "yes")ggrepel::geom_label_repel(aes(label = rownames(res_pca)), show.legend = F)} +
    theme_bw() +
    xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
    ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
    scale_color_brewer(palette = "Dark2")

  ### NORM
  
  norm <- Barplot()$norm
  
  res_pca1 <- mixOmics::pca(t(exprs(norm)))
  res_pca <- cbind(pData(norm), res_pca1$x)
  
  pcaplot2 <- ggplot(res_pca, aes(PC1, PC2, color = Treatment, shape = Batch)) +
    geom_point(size = 3, alpha = 0.8) +
    {if(input$labs == "yes")ggrepel::geom_label_repel(aes(label = rownames(res_pca)), show.legend = F)} +
    theme_bw() +
    xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
    ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
    scale_color_brewer(palette = "Dark2")
  
  ### CORR
  
  corrected <- Barplot()$corrected
  
  res_pca1 <- mixOmics::pca(t(exprs(corrected)))
  res_pca <- cbind(pData(corrected), res_pca1$x)
  
  pcaplot3 <- ggplot(res_pca, aes(PC1, PC2, color = Treatment, shape = Batch)) +
    geom_point(size = 3, alpha = 0.8) +
    {if(input$labs == "yes")ggrepel::geom_label_repel(aes(label = rownames(res_pca)), show.legend = F)} +
    theme_bw() +
    xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
    ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
    scale_color_brewer(palette = "Dark2")
  
  return(list(pcaplot1 = pcaplot1, pcaplot2 = pcaplot2, pcaplot3 = pcaplot3))
  
  })

####

output$pcaplot1 <- renderPlot({
  PCAplot()$pcaplot1
})

output$pcaplot2 <- renderPlot({
  PCAplot()$pcaplot2
})

output$pcaplot3 <- renderPlot({
  PCAplot()$pcaplot3
})

# output$download_plot4 <- downloadHandler(
#   filename =  function() {
#     paste0("PCAPlot_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print(PCAplot()$pcaplot) # for GGPLOT
#     dev.off()  # turn the device off
#     
#   }) 

