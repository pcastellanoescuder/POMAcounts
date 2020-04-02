
Normplot <- reactive({
  
  raw <- Barplot()$raw
  target <- pData(raw)
  
  ###

  total <- as.data.frame(t(exprs(raw)))
  total <- cbind(Sample = rownames(target), Treatment = target$Treatment, total)
  
  #### RAW
  
  normtable_subjectsX <- total %>% reshape2::melt()
  
  normtable_subjects1 <- normtable_subjectsX %>%
    filter(value >= input$minSpC)

  normplot1 <- normtable_subjects1 %>%
    ggplot(aes(Sample, log2(value), color = Treatment)) +
    geom_jitter() +
    geom_boxplot(color = "black", outlier.colour = NA) +
    theme(legend.position = "none") +
    theme_bw() +
    xlab("") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = "top") +
    scale_color_brewer(palette = "Dark2")
  
  #### NORMALIZED
  
  norm <- Barplot()$norm
  target <- pData(norm)
  
  total2 <- as.data.frame(t(exprs(norm)))
  total2 <- cbind(Sample = rownames(target), Treatment = target$Treatment, total2)
  
  normtable_subjectsXX <- total2 %>% reshape2::melt()
  
  normtable_subjects2 <- normtable_subjectsXX %>%
    filter(value >= input$minSpC)
  
  normplot2 <- normtable_subjects2 %>% 
    ggplot(aes(Sample, log2(value), color = Treatment)) + 
    geom_jitter() + 
    geom_boxplot(color = "black", outlier.colour = NA) + 
    theme(legend.position = "top") + 
    theme_bw() + 
    xlab("") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          legend.position = "top") +
    scale_color_brewer(palette = "Dark2")
  
  #### CORRECTED
  
  corrected <- Barplot()$corrected
  target <- pData(corrected)
  
  total3 <- as.data.frame(t(exprs(corrected)))
  total3 <- cbind(Sample = rownames(target), Treatment = target$Treatment, total3)
  
  normtable_subjectsXXX <- total3 %>% reshape2::melt()
  
  normtable_subjects3 <- normtable_subjectsXXX %>%
    filter(value >= input$minSpC)
  
  normplot3 <- normtable_subjects3 %>% 
    ggplot(aes(Sample, log2(value), color = Treatment)) + 
    geom_jitter() + 
    geom_boxplot(color = "black", outlier.colour = NA) + 
    theme(legend.position = "top") + 
    theme_bw() + 
    xlab("") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          legend.position = "top") +
    scale_color_brewer(palette = "Dark2")
  
  return(list(normplot1 = normplot1, 
              normplot2 = normplot2, 
              normplot3 = normplot3,
              normtable_subjectsX = normtable_subjectsX, 
              normtable_subjectsXX = normtable_subjectsXX, 
              normtable_subjectsXXX = normtable_subjectsXXX))

})

####

output$normplot1 <- renderPlot({
  Normplot()$normplot1
})

output$normplot2 <- renderPlot({
  Normplot()$normplot2
})

output$normplot3 <- renderPlot({
  Normplot()$normplot3
})

# output$download_plot2 <- downloadHandler(
#   filename =  function() {
#     paste0("NormalizationPlot_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print(Normplot()$normplot) # for GGPLOT
#     dev.off()  # turn the device off
#     
#   }) 

