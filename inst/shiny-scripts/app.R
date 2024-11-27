library(shiny)
library(bslib)

# TODO
# make sure coding conventions are followed
# how do I deal with input errors? - try to raise error if there is no input or incorrect input
# test to make sure this works
# do i need to restrict the size of the plots?


ui <- page_fluid(
  # this is not showing up for some reason
  title = "BacPoSSR Web App",
  navset_card_tab(
    # Home tab : explanation on how to use the webapp
    nav_panel("Home",
              "Explanation" # TODO figure out how to do the markdown text, fill it in
              ),
    # Procrustes Analysis tab
    nav_panel("Procrustes Analysis",
              "Filter dataset using Procrustes Analysis",
              page_sidebar(sidebar = sidebar("Input & Parameters",
                                             # file input
                                             fileInput("featureMatrixPA", "Upload a feature matrix in .csv format"),
                                             fileInput("phenotypes", "Upload a phenotype table in .csv format"),
                                             fileInput("groupsPA", "Upload a group table in .csv format"),
                                             numericInput("thresholdPA", "Threshold", value = 1, min = 0, max = 1),
                                             textInput("datasetPA", "Dataset Name"),
                                             actionButton("runPA", "Run")
                                             ),
                           card("MCA of dataset before filtering",
                                plotOutput("originalProcAnalysisMCA")),
                           card("MCA of dataset after filtering",
                                plotOutput("filteredProcAnalysisMCA"),
                                downloadButton("downloadFilteredMatrixPA", "Download Filtered Matrix"))
                           )
              ),
    # Genetic Relatedness Analysis tab
    nav_panel("Genetic Relatedness",
              "Filter dataset by Genetic Relatedness",
              page_sidebar(sidebar = sidebar("Input & Parameters",
                                             # file input
                                             fileInput("featureMatrixGR", "Upload a feature matrix or  in .csv format"),
                                             selectInput("grmStatus", "What type of data is your input?", list("Genetic Relatedness Matrix" = "grm", "Feature Matrix" = "null")),
                                             fileInput("groupsGR", "Upload a group table in .csv format"),
                                             numericInput("thresholdGR", "Threshold", value = 1, min = 0, max = 1),
                                             textInput("datasetGR", "Dataset Name"),
                                             actionButton("runGR", "Run")
                                             ),
                           card("MCA of dataset before filtering",
                                plotOutput("originalGenRelatMCA")),
                           card("MCA of dataset after filtering",
                                plotOutput("filteredGenRelatMCA"),
                                downloadButton("downloadFilteredMatrixGR", "Download Filtered Matrix"))
              )
    )
  ),
  id = "tab"
)

server <- function(input, output){
  # Procrustes Analysis
  observeEvent(input$runPA, {
    # read in data
    featureMatrixPA <- read.csv(input$featureMatrixPA$datapath, header = TRUE)
    phenotypes <- read.csv(input$phenotypes$datapath, header = TRUE)
    groupsPA <- read.csv(input$groupsPA$datapath, header = TRUE)
    output$filteredMatrixPA <- BacPoSSR::filterProcAnalysis(featureMatrix = featureMatrixPA,
                                                          phenotypes = phenotypes,
                                                          threshold = input$thresholdPA)
    output$originalProcAnalysisMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = featureMatrixPA,
                                     groups = groupsPA,
                                     saveTo = "./", # update this
                                     title = input$datasetPA)
    })
    output$filteredProcAnalysisMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = output$filteredMatrixPA,
                                     groups = groupsPA,
                                     saveTo = "./", # update this
                                     title = input$datasetPA)
    })

    # want to make data downloadable if possible
    output$downloadFilteredMatrixPA <- downloadHandler(
      filename = "filtered_matrix_proc_analysis.csv",
      content = function(file){write.csv(output$filteredMatrixPA, file)}
    )
  })

  # Genetic Relatedness
  observeEvent(input$runGR, {
    # read in data
    featureMatrixGR <- read.csv(input$featureMatrixGR$datapath, header = TRUE)
    # grm fix this
    groupsGR <- read.csv(input$groupsGR$datapath, header = TRUE)
    output$filteredMatrixGR <- BacPoSSR::filterGenRelatedness(featureMatrix = featureMatrixGR,
                                                            grm = grm,
                                                            thresholdP = input$thresholdGR)
    output$originalGenRelatMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = featureMatrixGR,
                                     groups = groupsGR,
                                     saveTo = "./", # update this
                                     title = input$datasetGR)
    })
    output$filteredGenRelatMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = output$filteredMatrixGR,
                                     groups = groupsGR,
                                     saveTo = "./", # update this
                                     title = input$datasetGR)
    })

    # want to make data downloadable if possible
    output$downloadFilteredMatrixGR <- downloadHandler(
      filename = "filtered_matrix_gen_relatedness.csv",
      content = function(file){write.csv(output$filteredMatrixGR, file)}
    )
  })
}

shiny::shinyApp(ui = ui, server = server)

# [END]
