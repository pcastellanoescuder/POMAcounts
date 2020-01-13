
Densityplot <- reactive({
  
  normtable_subjectsX <- Normplot()$normtable_subjectsX
  normtable_subjectsXX <- Normplot()$normtable_subjectsXX
  normtable_subjectsXXX <- Normplot()$normtable_subjectsXXX
  
  ### RAW
  
  densityplot1 <- normtable_subjectsX %>% 
    ggplot(aes(x = value)) +
    geom_density(aes(group = Sample, color = Treatment), alpha = 0.4) +
    theme_minimal() +
    theme(legend.position = "top") +
    scale_color_brewer(palette = "Dark2") +
    xlim(0, input$xlim)
  
  ### NORM
  
  densityplot2 <- normtable_subjectsXX %>% 
    ggplot(aes(x = value)) +
    geom_density(aes(group = Sample, color = Treatment), alpha = 0.4) +
    theme_minimal() +
    theme(legend.position = "top") +
    scale_color_brewer(palette = "Dark2") +
    xlim(0, input$xlim)
  
  ### CORR

  densityplot3 <- normtable_subjectsXXX %>% 
    ggplot(aes(x = value)) +
    geom_density(aes(group = Sample, color = Treatment), alpha = 0.4) +
    theme_minimal() +
    theme(legend.position = "top") +
    scale_color_brewer(palette = "Dark2") +
    xlim(0, input$xlim)
  
return(list(densityplot1 = densityplot1, 
            densityplot2 = densityplot2, 
            densityplot3 = densityplot3))

})

####

output$densityplot1 <- renderPlot({
  Densityplot()$densityplot1
})

output$densityplot2 <- renderPlot({
  Densityplot()$densityplot2
})

output$densityplot3 <- renderPlot({
  Densityplot()$densityplot3
})

# output$download_plot3 <- downloadHandler(
#   filename =  function() {
#     paste0("DensityPlot_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print(Densityplot()$densityplot) # for GGPLOT
#     dev.off()  # turn the device off
#     
#   }) 

