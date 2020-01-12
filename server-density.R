
Densityplot <- reactive({
  
  normtable_subjects2 <- Normplot()$normtable_subjects2
  
  ### DENSITY
  
  densityplot <- normtable_subjects2 %>% 
    ggplot(aes(x = value)) +
    geom_density(aes(group = Sample, color = Treatment), alpha = 0.4) +
    theme_minimal() +
    theme(legend.position = "top") +
    scale_color_brewer(palette = "Dark2") +
    xlim(0, input$xlim)

return(list(densityplot = densityplot))

})

####

output$densityplot <- renderPlot({
  Densityplot()$densityplot
})

output$download_plot3 <- downloadHandler(
  filename =  function() {
    paste0("DensityPlot_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print(Densityplot()$densityplot) # for GGPLOT
    dev.off()  # turn the device off
    
  }) 

