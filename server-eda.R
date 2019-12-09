
AllPlots <- reactive({
    
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
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "top")

###

spcm2 <- batch.neutralize(counts, target$Batch, half = TRUE, sqrt.trans = TRUE)

total <- as.data.frame(t(spcm2))
colnames(total) <- prot_names

total <- cbind(target[, 1:2], total)
colnames(total)[1:2] <- c("Sample", "Group")

# total <- POMA::PomaImpute(total, ZerosAsNA = T, method = "none")
# total <- POMA::PomaNorm(total, method = "auto_scaling")

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

### DENSITY

density <- normtable_subjects %>% 
  ggplot(aes(x = value)) +
  geom_density(aes(group = Sample, color = Group), alpha = 0.4) +
  theme_minimal() +
  theme(legend.position = "top") +
  scale_color_brewer(palette = "Dark2")

### PCA

res_pca1 <- mixOmics::pca(total[, 3:ncol(total)])
res_pca <- cbind(target, res_pca1$x)

# pcaplot <- ggplot(res_pca, aes(PC1, PC2, color = Treatment)) +
#   ggrepel::geom_text_repel(aes(label = Sample), show.legend = F) +
#   theme_minimal() +
#   xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
#   ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
#   scale_color_brewer(palette = "Dark2")

# ggplot(res_pca, aes(PC1, PC2, color = Treatment, shape = Batch)) +
#   geom_point(size = 3, alpha = 0.8) +
#   theme_minimal() +
#   xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
#   ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
#   scale_color_brewer(palette = "Dark2")

pcaplot <- ggplot(res_pca, aes(PC1, PC2, color = Treatment, shape = Batch)) +
  geom_point(size = 3, alpha = 0.8) +
  ggrepel::geom_label_repel(aes(label = Sample), show.legend = F) +
  theme_minimal() +
  xlab(paste0("PC1 (", round(100*(res_pca1$explained_variance)[1], 2), "%)")) +
  ylab(paste0("PC2 (", round(100*(res_pca1$explained_variance)[2], 2), "%)")) +
  scale_color_brewer(palette = "Dark2")

### DENDROGRAM

# group

dend1 <- total[, 3:ncol(total)] %>% 
  dist %>% 
  hclust 
order <- dend1$order
target2 <- target[order, ]
my_group <- as.numeric(as.factor(target2$Treatment))
colSide <- brewer.pal(8, "Dark2")[my_group]

dend1 <- dend1 %>%
  as.dendrogram() %>%
  set("labels_colors", colSide)
  # plot(horiz = F) 

# batch

dend2 <- total[, 3:ncol(total)] %>% 
  dist %>% 
  hclust 
order <- dend2$order
target2 <- target[order, ]
my_group <- as.numeric(as.factor(target2$Batch))
colSide <- brewer.pal(8, "Dark2")[my_group]

dend2 <- dend2 %>%
  as.dendrogram() %>%
  set("labels_colors", colSide)
  # plot(horiz = F) 

### HEATMAP

my_group <- as.numeric(as.factor(target$Treatment))
colSide <- brewer.pal(8, "Dark2")[my_group]
colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)

# heat <- heatmap(t(total[, 3:ncol(total)]), ColSideColors = colSide, col = colMain, labRow = NA)

### BATCH

# plot(density(as.vector(counts-spcm2)))

### DISPERSION

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

scatter <- spc_scatterplot(spcm2, target$Treatment, trans = "sqrt", minSpC = 2, minLFC = 1)

return(list(barplot = barplot, pcaplot = pcaplot, my_group = my_group, colSide = colSide,
            colMain = colMain, scatter = scatter, dend1 = dend1, dend2 = dend2, 
            density = density, normplot = normplot, total = total))

})

####

output$barplot <- renderPlot({
  AllPlots()$barplot
})

output$pca <- renderPlot({
  AllPlots()$pcaplot
})

output$normplot <- renderPlot({
  AllPlots()$normplot
})

output$densityplot <- renderPlot({
  AllPlots()$density
})

output$clust_g <- renderPlot({
  AllPlots()$dend1 %>%
    plot()
})

output$clust_b <- renderPlot({
  AllPlots()$dend2 %>%
    plot()
})

output$heatmap <- renderPlot({
  my_group <- AllPlots()$my_group
  colSide <- AllPlots()$colSide
  colMain <- AllPlots()$colMain
  total <- AllPlots()$total
  
  heatmap(t(total[, 3:ncol(total)]), ColSideColors = colSide, col = colMain, labRow = NA)
  
})

output$scatter <- renderPlot({
  AllPlots()$scatter
})

