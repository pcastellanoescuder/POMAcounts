
Poisson <- reactive({
  
  corrected <- Barplot()$corrected
  target <- pData(corrected)
  
  ### Null and alternative model
  null_f <- "y ~ 1"
  alt_f <- paste0("y ~ ", input$h1)
  
  ### Normalizing condition
  div <- apply(exprs(corrected), 2, sum)
  
  ### Poisson GLM
  pois_res <- msms.glm.pois(corrected, alt_f, null_f, div = div)
  pois_res$p.adjust <- p.adjust(pois_res$p.value, method = input$adjustment_method_poisson)
    
  return(list(pois_res = pois_res))
  
  })

####

output$poissonResults <- DT::renderDataTable({
  
  DT::datatable(Poisson()$pois_res,
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
                  pageLength = nrow(Poisson()$pois_res)))
})

