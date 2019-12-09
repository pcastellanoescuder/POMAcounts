
Normplot <- reactive({
  
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
  
  ### NORMALIZATION
  
  normtable_subjects <- total %>% reshape2::melt()
  
  normplot <- normtable_subjects %>% 
    ggplot(aes(Sample, log2(value + 1), color = Group)) + 
    geom_jitter() + 
    geom_boxplot(color = "black", outlier.colour = NA) + 
    theme(legend.position = "none") + 
    theme_minimal() + 
    xlab("") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1), 
          legend.position = "top") +
    scale_color_brewer(palette = "Dark2")

return(list(normplot = normplot))

})

####

output$normplot <- renderPlot({
  Normplot()$normplot
})

