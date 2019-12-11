
Densityplot <- reactive({
  
  proteines <- proteinesInput()
  target <- targetInput()
  
  colnames(target) <- c("Sample", "Treatment", "Batch")
  
  rownames(proteines) <- proteines$Accession
  remove <- ncol(proteines) - nrow(target)
  proteines <- proteines[, -c(1:remove)]
  
  prot_names <- rownames(proteines)
  counts <- apply(proteines, 2, function(x) as.numeric(as.character(x)))
  
  ## PRE-PROCESSING (pp.msms.data)
  
  if (sum(is.na(counts))) {
    counts[is.na(counts)] <- 0
  }
  
  fl1 <- apply(counts, 1, function(x) sum(x) > 0)
  
  fl2 <- substring(prot_names, nchar(prot_names) - 1) == "-R"
  flags <- (!fl2 & fl1)
  counts <- counts[flags, ]
  
  ###
  
  spcm2 <- batch.neutralize(counts, target$Batch, half = TRUE, sqrt.trans = TRUE)
  
  total <- as.data.frame(t(spcm2))
  colnames(total) <- prot_names
  
  total <- cbind(target[, 1:2], total)
  colnames(total)[1:2] <- c("Sample", "Group")
  
  normtable_subjects <- total %>% reshape2::melt()
  
  ### DENSITY
  
  densityplot <- normtable_subjects %>% 
    ggplot(aes(x = value)) +
    geom_density(aes(group = Sample, color = Group), alpha = 0.4) +
    theme_minimal() +
    theme(legend.position = "top") +
    scale_color_brewer(palette = "Dark2") +
    xlim(0, input$xlim)

return(list(densityplot = densityplot, total = total))

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

