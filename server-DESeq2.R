observe_helpers(help_dir = "help_mds")

DESeq2_fun <- reactive({
  
  data <- datasetInput()$data
  target <- pData(data)
  
  validate(
    need(length(levels(as.factor(target$Treatment))) == 2, paste0(clisymbols::symbol$cross, " Select two groups in the 'Input Data' panel"))
  )

  counts <- data %>%
    MSnbase::exprs()
  
  coldata <- target %>% 
    rownames_to_column("sample") %>% 
    mutate(Treatment = as.factor(Treatment))
  
  # Construct a DESeqDataSet object
  dds <- DESeqDataSetFromMatrix(countData = counts,
                                colData = coldata,
                                design = ~ Treatment # input$h1_deseq
                                )
  
  # Run DESeq2
  res_df <- dds %>% 
    DESeq() %>% 
    results() %>% 
    as_tibble(rownames = "GenaName")
  
  return(res_df)
  
  })

####

output$DESeq2Results <- DT::renderDataTable({
  
  DT::datatable(DESeq2_fun(),
                filter = 'none',extensions = 'Buttons',
                escape=FALSE,  rownames=FALSE, class = 'cell-border stripe',
                options = list(
                  scrollX = TRUE,
                  dom = 'Bfrtip',
                  buttons = 
                    list("copy", "print", list(
                      extend="collection",
                      buttons=list(list(extend="csv",
                                        filename="POMAcounts_DESeq2"),
                                   list(extend="excel",
                                        filename="POMAcounts_DESeq2"),
                                   list(extend="pdf",
                                        filename="POMAcounts_DESeq2")),
                      text="Dowload")),
                  order=list(list(2, "desc")),
                  pageLength = nrow(DESeq2_fun())))
})

