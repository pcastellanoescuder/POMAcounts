
Normplot <- reactive({
  
  e <- Barplot()$e
  target <- pData(e)
  
  ###

  total <- as.data.frame(t(exprs(e)))
  total <- cbind(Sample = rownames(target), Treatment = target$Treatment, total)
  
  ### NOT NORMALIZED
  
  normtable_subjects <- total %>% reshape2::melt() %>%
    filter(value >= input$minSpC)

  normplot1 <- normtable_subjects %>%
    ggplot(aes(Sample, log2(value), color = Treatment)) +
    geom_jitter() +
    geom_boxplot(color = "black", outlier.colour = NA) +
    theme(legend.position = "none") +
    theme_minimal() +
    xlab("") +
    ggtitle("Not Normalized") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = "top") +
    scale_color_brewer(palette = "Dark2")
  
  #### NORMALIZED
  
  neutralized <- batch.neutralize(exprs(e), target$Batch, half = TRUE, sqrt.trans = TRUE)
  
  total2 <- as.data.frame(t(neutralized))
  total2 <- cbind(Sample = rownames(target), Treatment = target$Treatment, total2)
  
  normtable_subjects2 <- total2 %>% reshape2::melt()
  normtable_subjects3 <- normtable_subjects2 %>%
    filter(value >= input$minSpC)
  
  normplot2 <- normtable_subjects3 %>% 
    ggplot(aes(Sample, log2(value), color = Treatment)) + 
    geom_jitter() + 
    geom_boxplot(color = "black", outlier.colour = NA) + 
    theme(legend.position = "none") + 
    theme_minimal() + 
    xlab("") +
    ggtitle("Normalized") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          legend.position = "none") +
    scale_color_brewer(palette = "Dark2")
  
  #### ARRANGE
  
  normplot <- normplot1/normplot2
  
  return(list(normplot = normplot, normtable_subjects2 = normtable_subjects2,
              neutralized = neutralized))

})

####

output$normplot <- renderPlot({
  Normplot()$normplot
})

output$download_plot2 <- downloadHandler(
  filename =  function() {
    paste0("NormalizationPlot_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print(Normplot()$normplot) # for GGPLOT
    dev.off()  # turn the device off
    
  }) 

