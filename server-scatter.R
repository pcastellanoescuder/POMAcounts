
Scatterplot <- reactive({
  
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
  
  spc_scatterplot <- function(counts, treat, trans = "log2", minSpC = 2, minLFC = 1){
    
    treat <- as.factor(treat)
    mspc <- data.frame(t(apply(counts, 1, function(x) tapply(x, treat, mean))))
    mx <- apply(mspc[, 1:2], 1, max)
    mn <- apply(mspc[, 1:2], 1, min)
    fl <- apply(mspc[, 1:2], 1, function(x) max(x) >= minSpC) & abs(log2(mx/mn)) >= minLFC
    
    if (trans == "none") {
      
      s_mspc <- mspc[fl ,]
      
      p <- ggplot(mspc, aes(mspc[,1], mspc[,2])) +
        geom_point() +
        geom_point(s_mspc, mapping = aes(x = s_mspc[,1], y = s_mspc[,2], color = "red")) +
        geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
        geom_abline(intercept = 0, slope = 2, linetype = "dashed", color = "navy") +
        geom_abline(intercept = 0, slope = 0.5, linetype = "dashed", color = "navy") +
        xlab(paste("mean SpC(", colnames(mspc)[1], ")", sep = "")) +
        ylab(paste("mean SpC(", colnames(mspc)[2], ")", sep = "")) +
        theme_minimal() +
        theme(legend.position = "none")
    }
    
    if (trans == "sqrt") {
      
      sqrtm <- sqrt(mspc)
      
      s_mspc <- sqrtm[fl ,]
      
      p <- ggplot(sqrtm, aes(sqrtm[,1], sqrtm[,2])) +
        geom_point() +
        geom_point(s_mspc, mapping = aes(x = s_mspc[,1], y = s_mspc[,2], color = "red")) +
        geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
        geom_abline(intercept = 0, slope = sqrt(2), linetype = "dashed", color = "navy") +
        geom_abline(intercept = 0, slope = 1/sqrt(2), linetype = "dashed", color = "navy") +
        xlab(paste("root mean SpC(", colnames(mspc)[1], ")", sep = "")) +
        ylab(paste("root mean SpC(", colnames(mspc)[2], ")", sep = "")) +
        theme_minimal() +
        theme(legend.position = "none")
    }
    
    if (trans == "log2") {
      
      logm <- log2(mspc + 0.01)
      mxx <- max(logm[, 1])
      mxy <- max(logm[, 2])
      mx <- max(mxx, mxy)
      
      s_mspc <- logm[fl ,]
      
      p <- ggplot(logm, aes(logm[,1], logm[,2])) +
        geom_point() +
        geom_point(s_mspc, mapping = aes(x = s_mspc[,1], y = s_mspc[,2], color = "red")) +
        geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray") +
        geom_abline(intercept = log2(2), slope = 1, linetype = "dashed", color = "navy") +
        geom_abline(intercept = -log2(2), slope = 1, linetype = "dashed", color = "navy") +
        xlab(paste("log2(mean SpC(", colnames(mspc)[1], "))", sep = "")) +
        ylab(paste("log2(mean SpC(", colnames(mspc)[2], "))", sep = "")) +
        theme_minimal() +
        theme(legend.position = "none")
    }
    
    return(p)
  }
  
  scatter <- spc_scatterplot(spcm2, target$Treatment, trans = input$trans, minSpC = input$minSpC, minLFC = input$minLFC)
    
  return(list(scatter = scatter))
  
  })

####

output$scatter <- renderPlot({
  Scatterplot()$scatter
})

output$download_plot8 <- downloadHandler(
  filename =  function() {
    paste0("ImportantFeatures_", Sys.Date())
  },
  # content is a function with argument file. content writes the plot to the device
  content = function(file) {
    pdf(file) # open the pdf device
    
    print(Scatterplot()$scatter) # for GGPLOT
    dev.off()  # turn the device off
    
  }) 

