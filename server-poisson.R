observe_helpers(help_dir = "help_mds")

Poisson <- reactive({
  
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
  alt_f <- paste0("y ~ ", input$h1_1)
  
  ### Normalizing condition
  div <- apply(exprs(corrected), 2, sum)
  
  ### Poisson GLM
  pois_res <- msms.glm.pois(corrected, alt_f, null_f, div = div)
  pois_res$p.adjust <- p.adjust(pois_res$p.value, method = input$adjustment_method_poisson)
  
  my_names <- rownames(pois_res)
  
  pois_res <- cbind(means, pois_res) %>% 
    rename(log2FC = LogFC) %>% 
    mutate(log2FC = round(log2FC, 2), 
           D = round(D, 3),
           names = my_names,
           GeneName = stringr::str_remove(names, pattern = "^.*GN="),
           GeneName = stringr::str_remove(GeneName, pattern = "(?s) .*"),
           Protein = stringr::str_remove(names, pattern = "^.*;")) %>%
    remove_rownames() %>%
    column_to_rownames("Protein") %>%
    select(GeneName, everything()) %>%
    select(-names)
  
  return(pois_res)
  
  })

####

output$poissonResults <- DT::renderDataTable({
  
  DT::datatable(Poisson(),
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="Poma_Poisson"),
                                   list(extend="excel",
                                        filename="Poma_Poisson"),
                                   list(extend="pdf",
                                        filename="Poma_Poisson")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(Poisson())))
})

output$volcano1 <- renderPlotly({
  
  df <- Poisson()
  
  names <- rownames(df) %>%
    stringr::str_remove(pattern = "^.*;")
  
  df <- df %>% mutate(counts = rowMeans(select(., starts_with("Mean")), na.rm = TRUE))
  
  if(input$pval1 == "raw"){
    
    df <- data.frame(pvalue = df$p.value, FC = round(df$log2FC, 2), names = names, counts = round(df$counts, 2))
    
  }
  
  else {
    
    df <- data.frame(pvalue = df$p.adjust, FC = round(df$log2FC, 2), names = names, counts = round(df$counts, 2))
    
  }
  
  log2FC1 <- 2^(input$log2FC1)
  
  df <- mutate(df, threshold = as.factor(ifelse(df$pvalue >= input$pval_cutoff1,
                                                yes = "none",
                                                no = ifelse(df$FC < log2(log2FC1),
                                                            yes = ifelse(df$FC < -log2(log2FC1),
                                                                         yes = "Down-regulated",
                                                                         no = "none"),
                                                            no = "Up-regulated"))))
  
  ggplotly(ggplot(data = df, aes(x = FC, y = -log10(pvalue), color = threshold, labels = names)) +
             {if(!input$show_counts1)geom_point(size = 1.75, alpha = 0.8)} +
             {if(input$show_counts1)geom_point(aes(size = counts), alpha = 0.8)} +
             xlim(c(-(input$xlim1), input$xlim1)) +
             xlab("log2 Fold Change") +
             ylab("-log10 p-value") +
             scale_y_continuous(trans = "log1p") +
             geom_vline(xintercept = -log2(log2FC1), colour = "black", linetype = "dashed") +
             geom_vline(xintercept = log2(log2FC1), colour = "black", linetype = "dashed") +
             geom_hline(yintercept = -log10(input$pval_cutoff1), colour = "black", linetype = "dashed") +
             theme(legend.position = "none") +
             theme_bw() +
             labs(color = "") +
             scale_color_manual(values = c("Down-regulated" = "#E64B35", "Up-regulated" = "#3182bd", "none" = "#636363")))
   
})

##

output$annotated_volcano1 <- renderPlot({
  
  df <- Poisson()
  
  names <- rownames(df) %>%
    stringr::str_remove(pattern = "^.*;")
  
  df <- df %>% mutate(counts = rowMeans(select(., starts_with("Mean")), na.rm = TRUE))
  
  if(input$pval1 == "raw"){
    
    df <- data.frame(pvalue = df$p.value, FC = round(df$log2FC, 2), names = names, counts = round(df$counts, 2))
    
  }
  
  else {
    
    df <- data.frame(pvalue = df$p.adjust, FC = round(df$log2FC, 2), names = names, counts = round(df$counts, 2))
    
  }
  
  log2FC1 <- 2^(input$log2FC1)
  
  df <- mutate(df, threshold = as.factor(ifelse(df$pvalue >= input$pval_cutoff1,
                                                yes = "none",
                                                no = ifelse(df$FC < log2(log2FC1),
                                                            yes = ifelse(df$FC < -log2(log2FC1),
                                                                         yes = "Down-regulated",
                                                                         no = "none"),
                                                            no = "Up-regulated"))))
  
  ggplot(data = df, aes(x = FC, y = -log10(pvalue), color = threshold, labels = names)) +
    {if(!input$show_counts1)geom_point(size = 1.75, alpha = 0.8)} +
    {if(input$show_counts1)geom_point(aes(size = counts), alpha = 0.8)} +
    xlim(c(-(input$xlim1), input$xlim1)) +
    xlab("log2 Fold Change") +
    ylab("-log10 p-value") +
    scale_y_continuous(trans = "log1p") +
    geom_vline(xintercept = -log2(log2FC1), colour = "black", linetype = "dashed") +
    geom_vline(xintercept = log2(log2FC1), colour = "black", linetype = "dashed") +
    geom_hline(yintercept = -log10(input$pval_cutoff1), colour = "black", linetype = "dashed") +
    theme(legend.position = "none") +
    theme_bw() +
    labs(color = "") +
    ggrepel::geom_label_repel(data = df[df$threshold != "none" ,], aes(label = names), show.legend = F) +
    scale_color_manual(values = c("Down-regulated" = "#E64B35", "Up-regulated" = "#3182bd", "none" = "#636363"))
  
})

##

output$heatmap_poisson <- renderPlot({
  
  corrected <- Barplot()$corrected
  pois_res <- Poisson()
  pois_res_names <- rownames(pois_res[pois_res$p.adjust < input$pval_cutoff1 ,])

  total <- exprs(corrected)
  rownames(total) <- rownames(total) %>%
    stringr::str_remove(pattern = "^.*;")
  total <- total[rownames(total) %in% pois_res_names ,]
  
  ####
  
  target <- pData(corrected)
  
  my_group <- as.numeric(as.factor(target$Treatment))
  colSide <- brewer.pal(8, "Dark2")[my_group]
  colMain <- colorRampPalette( c("green", "black", "red"), space = "rgb")(64)
  
  heatmap(t(scale(t(total))), ColSideColors = colSide, col = colMain, labRow = NA)
  
})

output$expanded_heatmap_poisson <- downloadHandler(

  filename = paste0(Sys.Date(), "_TEST_POMA_Expanded_Heatmap_poisson.pdf"),
  content = function(file) {

    corrected <- Barplot()$corrected
    pois_res <- Poisson()
    pois_res_names <- rownames(pois_res[pois_res$p.adjust < input$pval_cutoff1 ,])

    total <- exprs(corrected)
    rownames(total) <- rownames(total) %>%
      stringr::str_remove(pattern = "^.*;")
    total <- total[rownames(total) %in% pois_res_names ,]
    target <- pData(corrected)

    new_corrected <- MSnbase::MSnSet(exprs = as.matrix(total), pData = target)

    ####

    h <- nrow(exprs(new_corrected))/(2.54/0.35)
    pdf(file = file, width = 7, height = h)
    exp.heatmap(new_corrected, "Treatment", h = h, tit = "")
    dev.off()
  }
)

