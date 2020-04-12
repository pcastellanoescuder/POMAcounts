observe_helpers(help_dir = "help_mds")

QLR <- reactive({
  
  corrected <- Barplot()$corrected
  target <- pData(corrected)
  
  validate(
    need(length(levels(as.factor(target$Treatment))) == 2, paste0(clisymbols::symbol$cross, " Select two groups in the 'Input Data' panel"))
  )
  
  ### compute means
  
  my_counts <- exprs(corrected) %>% t() %>% as.data.frame() %>% mutate(Treatment = target$Treatment)
  
  means <- data.frame(aggregate(my_counts, by = list(my_counts$Treatment), FUN = mean)) %>% 
    column_to_rownames("Group.1") %>% t() %>% as.data.frame() %>% round(2) %>% filter(rownames(.) != "Treatment")
  
  colnames(means) <- paste0("Mean", colnames(means))
  
  ### Null and alternative model
  null_f <- "y ~ 1"
  alt_f <- paste0("y ~ ", input$h1_2)
  
  ### Normalizing condition
  div <- apply(exprs(corrected), 2, sum)
  
  ### Quasi-likelihood GLM
  qlr_res <- msms.glm.qlll(corrected, alt_f, null_f, div = div)
  qlr_res$p.adjust <- p.adjust(qlr_res$p.value, method = input$adjustment_method_qlr)
  
  my_names <- rownames(qlr_res)
  qlr_res <- cbind(means, qlr_res) %>% rename(log2FC = LogFC) %>% mutate(log2FC = round(log2FC, 2),
                                                                         D = round(D, 3))
  rownames(qlr_res) <- my_names
  
  return(qlr_res)
  
  })

####

output$qlrResults <- DT::renderDataTable({
  
  DT::datatable(QLR(),
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="Poma_Quasi-likelihood"),
                                   list(extend="excel",
                                        filename="Poma_Quasi-likelihood"),
                                   list(extend="pdf",
                                        filename="Poma_Quasi-likelihood")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(QLR())))
})

output$volcano2 <- renderPlotly({
  
  df <- QLR()
  
  names <- rownames(df)
  
  df <- df %>% mutate(counts = rowMeans(select(., starts_with("Mean")), na.rm = TRUE))
  
  if(input$pval2 == "raw"){
    
    df <- data.frame(pvalue = df$p.value, FC = round(df$log2FC, 2), names = names, counts = round(df$counts, 2))
    
  }
  
  else {
    
    df <- data.frame(pvalue = df$p.adjust, FC = round(df$log2FC, 2), names = names, counts = round(df$counts, 2))
    
  }
  
  log2FC2 <- 2^(input$log2FC2)
  
  df <- mutate(df, threshold = as.factor(ifelse(df$pvalue >= input$pval_cutoff2,
                                                yes = "none",
                                                no = ifelse(df$FC < log2(log2FC2),
                                                            yes = ifelse(df$FC < -log2(log2FC2),
                                                                         yes = "Down-regulated",
                                                                         no = "none"),
                                                            no = "Up-regulated"))))
  
  if(!isTRUE(input$show_counts2)){
    
    ggplotly(ggplot(data = df, aes(x = FC, y = -log10(pvalue), color = threshold, labels = names)) +
               geom_point(size = 1.75, alpha = 0.8) +
               xlim(c(-(input$xlim2), input$xlim2)) +
               xlab("log2 Fold Change") +
               ylab("-log10 p-value") +
               scale_y_continuous(trans = "log1p") +
               geom_vline(xintercept = -log2(log2FC2), colour = "black", linetype = "dashed") +
               geom_vline(xintercept = log2(log2FC2), colour = "black", linetype = "dashed") +
               geom_hline(yintercept = -log10(input$pval_cutoff2), colour = "black", linetype = "dashed") +
               theme(legend.position = "none") +
               theme_bw() +
               labs(color = "") +
               scale_color_manual(values = c("Down-regulated" = "#E64B35", "Up-regulated" = "#3182bd", "none" = "#636363")))
    
  }
  
  else{
    
    ggplotly(ggplot(data = df, aes(x = FC, y = -log10(pvalue), color = counts, labels = names)) +
               geom_point(size = 1.75, alpha = 0.8) +
               xlim(c(-(input$xlim2), input$xlim2)) +
               xlab("log2 Fold Change") +
               ylab("-log10 p-value") +
               scale_y_continuous(trans = "log1p") +
               geom_vline(xintercept = -log2(log2FC2), colour = "black", linetype = "dashed") +
               geom_vline(xintercept = log2(log2FC2), colour = "black", linetype = "dashed") +
               geom_hline(yintercept = -log10(input$pval_cutoff2), colour = "black", linetype = "dashed") +
               theme_bw())
  }
  
})

####

output$heatmap_qlr <- renderPlot({
  
  corrected <- Barplot()$corrected
  qlr_res <- QLR()
  qlr_res_names <- rownames(qlr_res[qlr_res$p.adjust < input$pval_cutoff2 ,])
  
  total <- exprs(corrected)
  total <- total[rownames(total) %in% qlr_res_names ,]
  
  ####
  
  target <- pData(corrected)
  
  my_group <- as.numeric(as.factor(target$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)
  
  heatmap(t(scale(t(total))), ColSideColors = colSide, col = colMain, labRow = NA)
  
})

##

output$expanded_heatmap_qlr <- downloadHandler(
  
  filename = paste0(Sys.Date(), "_TEST_POMA_Expanded_Heatmap_qlr.pdf"),
  content = function(file) {
    
    corrected <- Barplot()$corrected
    qlr_res <- QLR()
    qlr_res_names <- rownames(qlr_res[qlr_res$p.adjust < input$pval_cutoff2 ,])
    
    total <- exprs(corrected)
    total <- total[rownames(total) %in% qlr_res_names ,]
    target <- pData(corrected)
    
    new_corrected <- MSnbase::MSnSet(exprs = as.matrix(total), pData = target)
    
    ####
    
    h <- nrow(exprs(new_corrected))/(2.54/0.35)
    pdf(file = file, width = 7, height = h)
    exp.heatmap(new_corrected, "Treatment", h = h, tit = "")
    dev.off()
  }
)

