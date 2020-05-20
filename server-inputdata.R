
proteinesInput <- reactive({
  
  infile <- input$proteines
    
  if (is.null(infile)){
      return(NULL)
      }
  
  else {
    proteines <- read.table(infile$datapath, header = T, sep = "\t")
    }
  })

targetInput <- reactive({
  
  infile <- input$target
  
  if (is.null(infile)){
    return(NULL)
  }
  
  else {
    target <- read.table(infile$datapath, header = T, sep = "\t")
  }
})


#################

datasetInput <- reactive({
  
  if (!is.null(proteinesInput()) & !is.null(targetInput())){
    
    proteines <- proteinesInput()
    target <- targetInput()
    
    colnames(target) <- c("Sample", "Treatment", "Batch")
    colnames(proteines)[2] <- "Accession"
    colnames(proteines)[1] <- "gene_name"
    
    proteines <- proteines %>%
      mutate(Accession = paste0(gene_name, ";", Accession))
    
    target <- column_to_rownames(target, "Sample")
    proteines <- column_to_rownames(proteines, "Accession") 
    proteines <- proteines[, colnames(proteines) %in% rownames(target)]
    
    if(!is.null(input$contents_tar_rows_selected)){
      target <- target[input$contents_tar_rows_selected ,]
      proteines <- proteines[, input$contents_tar_rows_selected]
    } 
    
    data <- MSnbase::MSnSet(exprs = as.matrix(proteines), pData = target)
    
  }
  
  return(list(data = data, proteines = proteines, target = target))
  
})

####
                  
output$contents <- DT::renderDataTable({
  
  datatable(datasetInput()$proteines, 
            class = 'cell-border stripe', 
            rownames = TRUE, options(list(scrollX = TRUE)))
  })

##

output$contents_tar <- DT::renderDataTable({
  
  datatable(targetInput(), 
            class = 'cell-border stripe', 
            rownames = FALSE, options(list(scrollX = TRUE)))
  
})

##

# output$report <- downloadHandler(
#   
#   filename = paste0(Sys.Date(), "_EDA_POMA_Report.pdf"),
#   content = function(file) {
#     
#     tempReport <- file.path(tempdir(), "EDA_POMA_Report.Rmd")
#     file.copy("EDA_POMA_Report.Rmd", tempReport, overwrite = TRUE)
#     
#     #### PREPROCESS
#     
#     proteines <- proteinesInput()
#     target <- targetInput()
#     
#     colnames(target) <- c("Sample", "Treatment", "Batch")
#     colnames(proteines)[2] <- "Accession"
#     
#     target <- column_to_rownames(target, "Sample")
#     proteines <- column_to_rownames(proteines, "Accession") 
#     proteines <- proteines[, colnames(proteines) %in% rownames(target)]
#     
#     #### RAW
#     
#     data <- MSnbase::MSnSet(exprs = as.matrix(proteines), pData = target)
#     raw <- pp.msms.data(data)
#     
#     #### NORMALIZED
#     
#     counts <- Biobase::exprs(raw)
#     tspc <- apply(counts, 2, sum)
#     div <- tspc/median(tspc)
#     norm <- norm.counts(raw, div)
#     
#     #### CORRECTED
#     
#     target <- pData(norm)
#     neutralized <- batch.neutralize(exprs(norm), target$Batch, half = TRUE, sqrt.trans = TRUE)
#     corrected <- MSnSet(exprs = as.matrix(neutralized), pData = pData(norm))
#     
#     ####
#     
#     params <- list(raw = raw, norm = norm, corrected = corrected)
#                       
#     rmarkdown::render(tempReport, 
#                       output_file = file,
#                       params = params,
#                       envir = new.env(parent = globalenv()))
#     
#   }
# )

