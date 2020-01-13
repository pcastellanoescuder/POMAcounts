
# Clusterplot <- reactive({
#   
#   e <- Barplot()$e
#   neutralized <- Normplot()$neutralized
#   
#   data2 <- MSnSet(exprs = neutralized, pData = pData(e))
#   
#   # treatment
#   
#   dend1 <- counts.hc(data2, facs = pData(data2)[, "Treatment", drop = FALSE])
#   
#   # batch
#   
#   dend2 <- counts.hc(data2, facs = pData(data2)[, "Batch", drop = FALSE])
#   
#   return(list(dend1 = dend1, dend2 = dend2))
# 
# })

####

output$cluster_groups1 <- renderPlot({
  
  raw <- Barplot()$raw
  # treatment
  counts.hc(raw, facs = pData(raw)[, "Treatment", drop = FALSE])
  
})

output$cluster_batch1 <- renderPlot({
  
  raw <- Barplot()$raw
  # batch
  counts.hc(raw, facs = pData(raw)[, "Batch", drop = FALSE])
  
})

####

output$cluster_groups2 <- renderPlot({
  
  norm <- Barplot()$norm
  # treatment
  counts.hc(norm, facs = pData(norm)[, "Treatment", drop = FALSE])
  
})

output$cluster_batch2 <- renderPlot({
  
  norm <- Barplot()$norm
  # batch
  counts.hc(norm, facs = pData(norm)[, "Batch", drop = FALSE])
  
})

####

output$cluster_groups3 <- renderPlot({
  
  corrected <- Barplot()$corrected
  # treatment
  counts.hc(corrected, facs = pData(corrected)[, "Treatment", drop = FALSE])
  
})

output$cluster_batch3 <- renderPlot({
  
  corrected <- Barplot()$corrected
  # batch
  counts.hc(corrected, facs = pData(corrected)[, "Batch", drop = FALSE])
  
})

# output$download_plot5 <- downloadHandler(
#   filename =  function() {
#     paste0("ClusterByGroups_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print(Clusterplot()$dend1) # for GGPLOT
#     dev.off()  # turn the device off
#     
#   }) 
# 
# output$download_plot6 <- downloadHandler(
#   filename =  function() {
#     paste0("ClusterByBatch_", Sys.Date())
#   },
#   # content is a function with argument file. content writes the plot to the device
#   content = function(file) {
#     pdf(file) # open the pdf device
#     
#     print(Clusterplot()$dend2) # for GGPLOT
#     dev.off()  # turn the device off
#     
#   }) 


