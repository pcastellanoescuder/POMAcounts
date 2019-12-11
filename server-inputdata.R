
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
                  
output$contents <- DT::renderDataTable(proteinesInput(), class = 'cell-border stripe', 
                                       rownames = FALSE)

output$contents_tar <- DT::renderDataTable(targetInput(), class = 'cell-border stripe', 
                                       rownames = FALSE)

output$report <- downloadHandler(
  
  filename = "EDA_POMA_Report.html",
  content = function(file) {
    
    tempReport <- file.path(tempdir(), "EDA_POMA_Report.Rmd") 
    file.copy("EDA_POMA_Report.Rmd", tempReport, overwrite = TRUE) 
    
    params <- list(n = proteinesInput(), t = targetInput())
    
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  }
)

