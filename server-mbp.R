
Barplot <- reactive({
    
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

### BARPLOT - SCALE TO THE MEDIAN

tcnts <- apply(counts, 2, sum)
medt <- median(tcnts)
div <- data.frame(median = tcnts/medt)
div$sample <- rownames(div)
div$Group <- target$Treatment

barplot <- ggplot(div, aes(x = sample, y = median, fill = Group)) +
  geom_bar(stat="identity")+
  theme_minimal() +
  xlab("") +
  geom_hline(yintercept = 1, linetype = "dashed") +
  scale_fill_brewer(palette = "Dark2") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "top")

return(list(barplot = barplot))

})

####

output$barplot <- renderPlot({
  Barplot()$barplot
})

