
Barplot <- reactive({
    
  proteines <- proteinesInput()
  target <- targetInput()
  
  colnames(target) <- c("Sample", "Treatment", "Batch")
  
  target <- column_to_rownames(target, "Sample")
  proteines <- column_to_rownames(proteines, "Accession") 
  proteines <- proteines[, colnames(proteines) %in% rownames(target)]
  
  data <- MSnbase::MSnSet(exprs = as.matrix(proteines), pData = target)
  
  ## PRE-PROCESSING (pp.msms.data)
  
  e <- pp.msms.data(data)
  
  ### BARPLOT - SCALE TO THE MEDIAN
  
  counts <- Biobase::exprs(e)
  
  tcnts <- apply(counts, 2, sum)
  medt <- median(tcnts)
  div <- data.frame(median = tcnts/medt)
  div$sample <- rownames(div)
  div$Treatment <- target$Treatment
  
  barplot <- ggplot(div, aes(x = sample, y = median, fill = Treatment)) +
    geom_bar(stat="identity")+
    theme_minimal() +
    xlab("") +
    geom_hline(yintercept = 1, linetype = "dashed") +
    scale_fill_brewer(palette = "Dark2") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = "top")
  
  return(list(barplot = barplot, e = e))

})

####

output$barplot <- renderPlot({
  Barplot()$barplot
})

output$download_plot <- downloadHandler(
  filename =  function() {
    paste0("BarPlot_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print(Barplot()$barplot) # for GGPLOT
    dev.off()  # turn the device off
    
  }) 

