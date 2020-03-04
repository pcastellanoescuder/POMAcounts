observe_helpers(help_dir = "help_mds")

BINOMIAL <- reactive({
  
  corrected <- Barplot()$corrected
  target <- pData(corrected)
  
  ### Null and alternative model
  null_f <- "y ~ 1"
  alt_f <- paste0("y ~ ", input$h1_3)
  
  ### Normalizing condition
  div <- apply(exprs(corrected), 2, sum)
  
  ### Quasi-likelihood GLM
  binomial_res <- msms.edgeR(corrected, alt_f, null_f, div = div, fnm = "Treatment")
  binomial_res$p.adjust <- p.adjust(binomial_res$p.value, method = input$adjustment_method_binomial)
    
  return(list(binomial_res = binomial_res))
  
  })

####

output$binomialResults <- DT::renderDataTable({
  
  DT::datatable(BINOMIAL()$binomial_res,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="Poma_Negative-Binomial"),
                                   list(extend="excel",
                                        filename="Poma_Negative-Binomial"),
                                   list(extend="pdf",
                                        filename="Poma_Negative-Binomial")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(BINOMIAL()$binomial_res)))
})

output$volcano3 <- renderPlotly({
  
  df <- BINOMIAL()$binomial_res
  
  names <- rownames(df)
  
  if(input$pval3 == "raw"){
    
    df <- data.frame(pvalue = df$p.value, FC = round(df$LogFC, 2), names = names)
    
  }
  
  else {
    
    df <- data.frame(pvalue = df$p.adjust, FC = round(df$LogFC, 2), names = names)
    
  }
  
  df <- mutate(df, threshold = as.factor(ifelse(df$pvalue >= input$pval_cutoff3,
                                                yes = "none",
                                                no = ifelse(df$FC < log2(input$log2FC3),
                                                            yes = ifelse(df$FC < -log2(input$log2FC3),
                                                                         yes = "Down-regulated",
                                                                         no = "none"),
                                                            no = "Up-regulated"))))
  
  ggplotly(ggplot(data = df, aes(x = FC, y = -log10(pvalue), color = threshold, labels = names)) +
             geom_point(size = 1.75, alpha = 0.8) +
             xlim(c(-(input$xlim3), input$xlim3)) +
             xlab("log2 Fold Change") +
             ylab("-log10 p-value") +
             scale_y_continuous(trans = "log1p") +
             geom_vline(xintercept = -log2(input$log2FC3), colour = "black", linetype = "dashed") +
             geom_vline(xintercept = log2(input$log2FC3), colour = "black", linetype = "dashed") +
             geom_hline(yintercept = -log10(input$pval_cutoff3), colour = "black", linetype = "dashed") +
             theme(legend.position = "none") +
             theme_minimal() +
             scale_color_manual(values = c("Down-regulated" = "#E64B35", "Up-regulated" = "#3182bd", "none" = "#636363")))
  
})

