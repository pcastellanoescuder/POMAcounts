
Barplot <- reactive({
    
  proteines <- proteinesInput()
  target <- targetInput()
  
  colnames(target) <- c("Sample", "Treatment", "Batch")
  colnames(proteines)[2] <- "Accession"
  
  target <- column_to_rownames(target, "Sample")
  proteines <- column_to_rownames(proteines, "Accession") 
  proteines <- proteines[, colnames(proteines) %in% rownames(target)]
  
  data <- MSnbase::MSnSet(exprs = as.matrix(proteines), pData = target)
  
  ## PRE-PROCESSING (pp.msms.data)
  
  raw <- pp.msms.data(data)
  
  ### BARPLOT - SCALE TO THE MEDIAN RAW
  
  counts <- Biobase::exprs(raw)
  
  tcnts <- apply(counts, 2, sum)
  medt <- median(tcnts)
  div <- data.frame(median = tcnts/medt) 
  div$sample <- rownames(div)
  div$Treatment <- target$Treatment
  
  barplot1 <- ggplot(div, aes(x = sample, y = median, fill = Treatment)) +
    geom_bar(stat="identity")+
    theme_minimal() +
    xlab("") +
    geom_hline(yintercept = 1, linetype = "dashed") +
    scale_fill_brewer(palette = "Dark2") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = "top")
  
  ### BARPLOT - SCALE TO THE MEDIAN NORMALIZED
  
  counts <- Biobase::exprs(raw)
  
  tspc <- apply(counts, 2, sum)
  div <- tspc/median(tspc)
  norm <- norm.counts(raw, div)
  
  ##
  
  counts <- Biobase::exprs(norm)
  
  tcnts <- apply(counts, 2, sum)
  medt <- median(tcnts)
  div <- data.frame(median = tcnts/medt) 
  div$sample <- rownames(div)
  div$Treatment <- target$Treatment
  
  ##
  
  barplot2 <- ggplot(div, aes(x = sample, y = median, fill = Treatment)) +
    geom_bar(stat="identity")+
    theme_minimal() +
    xlab("") +
    geom_hline(yintercept = 1, linetype = "dashed") +
    scale_fill_brewer(palette = "Dark2") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = "top")
  
  ### BARPLOT - SCALE TO THE MEDIAN CORRECTED
  
  target <- pData(norm)
  neutralized <- batch.neutralize(exprs(norm), target$Batch, half = TRUE, sqrt.trans = TRUE)
  
  corrected <- MSnSet(exprs = as.matrix(neutralized), pData = pData(norm))
  
  ##
  
  counts <- Biobase::exprs(corrected)
  
  tcnts <- apply(counts, 2, sum)
  medt <- median(tcnts)
  div <- data.frame(median = tcnts/medt) 
  div$sample <- rownames(div)
  div$Treatment <- target$Treatment
  
  ##
  
  barplot3 <- ggplot(div, aes(x = sample, y = median, fill = Treatment)) +
    geom_bar(stat="identity")+
    theme_minimal() +
    xlab("") +
    geom_hline(yintercept = 1, linetype = "dashed") +
    scale_fill_brewer(palette = "Dark2") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          legend.position = "top")
  
  return(list(barplot1 = barplot1, barplot2 = barplot2, barplot3 = barplot3, 
              raw = raw, norm = norm, corrected = corrected))

})

####

output$barplot1 <- renderPlot({
  Barplot()$barplot1
})

output$barplot2 <- renderPlot({
  Barplot()$barplot2
})

output$barplot3 <- renderPlot({
  Barplot()$barplot3
})

# output$download_plot1 <- downloadHandler(
#   filename =  function() {
#     paste0("raw_barplot_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
# 
#     print(Barplot()$barplot1) # for GGPLOT
#     dev.off()  # turn the device off
# 
#   })
# 
# output$download_plot2 <- downloadHandler(
#   filename =  function() {
#     paste0("normalized_barplot_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print(Barplot()$barplot2) # for GGPLOT
#     dev.off()  # turn the device off
#     
#   })
# 
# output$download_plot3 <- downloadHandler(
#   filename =  function() {
#     paste0("normalized_corrected_barplot_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print(Barplot()$barplot3) # for GGPLOT
#     dev.off()  # turn the device off
#     
#   })

