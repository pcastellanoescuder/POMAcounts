
PCAplot <- reactive({
  
  total <- Densityplot()$total
  target <- targetInput()
    
  res_pca1 <- mixOmics::pca(total[, 3:ncol(total)])
  res_pca <- cbind(target, res_pca1$x)
  
  if(input$labs == "yes"){
    
    pcaplot <- ggplot(res_pca, aes(PC1, PC2, color = Treatment, shape = Batch)) +
      geom_point(size = 3, alpha = 0.8) +
      ggrepel::geom_label_repel(aes(label = Sample), show.legend = F) +
      theme_minimal() +
      xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
      ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
      scale_color_brewer(palette = "Dark2")
  }
  
  else{
    
    # pcaplot <- ggplot(res_pca, aes(PC1, PC2, color = Treatment)) +
    #   ggrepel::geom_text_repel(aes(label = Sample), show.legend = F) +
    #   theme_minimal() +
    #   xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
    #   ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
    #   scale_color_brewer(palette = "Dark2")
    
    pcaplot <- ggplot(res_pca, aes(PC1, PC2, color = Treatment, shape = Batch)) +
      geom_point(size = 3, alpha = 0.8) +
      theme_minimal() +
      xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
      ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
      scale_color_brewer(palette = "Dark2")
    
  }
  
  return(list(pcaplot = pcaplot))
  
  })

####

output$pcaplot <- renderPlot({
  PCAplot()$pcaplot
})

output$download_plot4 <- downloadHandler(
  filename =  function() {
    paste0("PCAPlot_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print(PCAplot()$pcaplot) # for GGPLOT
    dev.off()  # turn the device off
    
  }) 

