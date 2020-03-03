
QLR <- reactive({
  
  corrected <- Barplot()$corrected
  target <- pData(corrected)
  
  ### Null and alternative model
  null_f <- "y ~ 1"
  alt_f <- paste0("y ~ ", input$h1)
  
  ### Normalizing condition
  div <- apply(exprs(corrected), 2, sum)
  
  ### Quasi-likelihood GLM
  qlr_res <- msms.glm.qlll(corrected, alt_f, null_f, div = div)
  qlr_res$p.adjust <- p.adjust(qlr_res$p.value, method = input$adjustment_method_qlr)
    
  return(list(qlr_res = qlr_res))
  
  })

####

output$qlrResults <- DT::renderDataTable({
  
  DT::datatable(QLR()$qlr_res,
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=TRUE, class = 'cell-border stripe',
                options = list(
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
                  pageLength = nrow(QLR()$qlr_res)))
})

