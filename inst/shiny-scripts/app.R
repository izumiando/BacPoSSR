library(shiny)
library(bslib)

# TODO
# write up the home page - DONE
# add comments to the current code - DONE
# fix the grm line - DONE
# convert RData to csv and see if it works
# figure out why title is not showing up - DONE
# make sure this can handle making the first column row names - DONE
### after
# how do I deal with input errors? - try to raise error if there is no input or incorrect input - DONE
# check if you need to restrict plot size
# check coding conventions
# add a message in the cards before plots are rendered
# improve text visuals in each tab, change font size, bold etc
# input checks can be a little more extensive



ui <- page_fluid(
  titlePanel("BacPoSSR Shiny App"),
  navset_card_tab(
    # Home tab : explanation on how to use the web app
    nav_panel("Home",
              div(class = "card", htmlOutput("homeContent"))
              ),

    # Procrustes Analysis tab
    nav_panel("Procrustes Analysis",
              "Filter Dataset using Procrustes Analysis",
              page_sidebar(sidebar =
                             sidebar("Input & Parameters",
                                     # file input
                                     fileInput("featureMatrixPA",
                                               "Upload a feature matrix
                                               in .csv format"),
                                     fileInput("phenotypes",
                                               "Upload a phenotype table
                                               in .csv format"),
                                     fileInput("groupsPA",
                                               "Upload a group table
                                               in .csv format"),
                                     numericInput("thresholdPA",
                                                  "Threshold",
                                                  value = 0.1,
                                                  min = 0,
                                                  max = 1),
                                     textInput("datasetPA", "Dataset Name"),
                                     actionButton("runPA", "Run")
                                             ),
                           # plot the MCA of the dataset before filtering
                           card("MCA of dataset before filtering",
                                plotOutput("originalProcAnalysisMCA")),
                           # plot the MCA of the dataset after filtering
                           card("MCA of dataset after filtering",
                                plotOutput("filteredProcAnalysisMCA"),
                                downloadButton("downloadFilteredMatrixPA",
                                               "Download Filtered Matrix"))
                           )
              ),

    # Genetic Relatedness tab
    nav_panel("Genetic Relatedness",
              "Filter Dataset by Genetic Relatedness",
              page_sidebar(sidebar =
                             sidebar("Input & Parameters",
                                     # file input
                                     fileInput("featureMatrixGR",
                                               "Upload a feature matrix or
                                               genetic relatedness matrix
                                               in .csv format"),
                                     selectInput("grmStatus",
                                                 "What type of data
                                                 is your input?",
                                                 list("Genetic Relatedness
                                                      Matrix" = "grm",
                                                      "Feature Matrix"
                                                      = "fm")),
                                     fileInput("groupsGR",
                                               "Upload a group table
                                               in .csv format"),
                                     numericInput("thresholdGR",
                                                  "Threshold",
                                                  value = 0.1,
                                                  min = 0,
                                                  max = 1),
                                     textInput("datasetGR", "Dataset Name"),
                                     actionButton("runGR", "Run")
                                     ),
                           # plot the MCA of the dataset before filtering
                           card("MCA of dataset before filtering",
                                plotOutput("originalGenRelatMCA")),
                           # plot the MCA of the dataset after filtering
                           card("MCA of dataset after filtering",
                                plotOutput("filteredGenRelatMCA"),
                                downloadButton("downloadFilteredMatrixGR",
                                               "Download Filtered Matrix"))
              )
    )
  ),
  id = "tab"
)

server <- function(input, output){
  # Home
  output$homeContent <- renderUI({
    rmdFile <- "./rshinyHome.Rmd"
    renderedHTML <- rmarkdown::render(rmdFile,
                                       output_format = "html_fragment",
                                       quiet = TRUE)
    HTML(readLines(renderedHTML, warn = FALSE))
  })

  # Procrustes Analysis
  observeEvent(input$runPA, {
    # input checks
    if (is.null(input$featureMatrixPA) ||
        is.null(input$phenotypes) ||
        is.null(input$groupsPA)) {
      showNotification("Please upload all required files before
                       running the analysis.", type = "error")
      return(NULL)
    }

    # read in data & make first column row names for each
    featureMatrixPA <- read.csv(input$featureMatrixPA$datapath, header = TRUE)
    row.names(featureMatrixPA) <- featureMatrixPA[, 1]
    featureMatrixPA <- as.data.frame(featureMatrixPA[, -1])

    phenotypes <- read.csv(input$phenotypes$datapath, header = TRUE)
    sampleNamesPh <- phenotypes[, 1]
    phenotypes <- as.data.frame(phenotypes[, -1])
    row.names(phenotypes) <- sampleNamesPh
    colnames(phenotypes) <- c("phenotypes")

    groupsPA <- read.csv(input$groupsPA$datapath, header = TRUE)
    sampleNamesG <- groupsPA[, 1]
    groupsPA <- as.data.frame(groupsPA[, -1])
    row.names(groupsPA) <- sampleNamesG
    colnames(groupsPA) <- c("groups")

    # run filterProcAnalysis

    filteredMatrixPA <- reactive({
      BacPoSSR::filterProcAnalysis(featureMatrix = featureMatrixPA,
                                   phenotypes = phenotypes,
                                   threshold = input$thresholdPA)

    })

    # plot the MCA of the dataset before filtering with filterProcAnalysis
    output$originalProcAnalysisMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = featureMatrixPA,
                                     groups = groupsPA,
                                     saveTo = NULL,
                                     title = input$datasetPA)
    })

    # plot the MCA of the dataset after filtering with filterProcAnalysis
    output$filteredProcAnalysisMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = filteredMatrixPA(),
                                     groups = groupsPA,
                                     saveTo = NULL,
                                     title = input$datasetPA)
    })

    # make filtered dataset downloadable
    output$downloadFilteredMatrixPA <- downloadHandler(
      filename = "filtered_matrix_proc_analysis.csv",
      content = function(file){write.csv(filteredMatrixPA(), file)}
    )
  })

  # Genetic Relatedness
  observeEvent(input$runGR, {
    # input checks
    if (is.null(input$featureMatrixGR) || is.null(input$groupsGR)) {
      showNotification("Please upload all required files before
                       running the analysis.", type = "error")
      return(NULL)
    }

    # read in data & make first column row names for each
    featureMatrixGR <- read.csv(input$featureMatrixGR$datapath, header = TRUE)
    row.names(featureMatrixGR) <- featureMatrixGR[, 1]
    featureMatrixGR <- as.data.frame(featureMatrixGR[, -1])

    groupsGR <- read.csv(input$groupsGR$datapath, header = TRUE)
    sampleNames <- groupsGR[, 1]
    groupsGR <- as.data.frame(groupsGR[, -1])
    row.names(groupsGR) <- sampleNames
    colnames(groupsGR) <- c("groups")

    # run filterGenRelatedness
    if(input$grmStatus=="grm"){
      filteredMatrixGR <- reactive({
        BacPoSSR::filterGenRelatedness(featureMatrix = featureMatrixGR,
                                       grm = featureMatrixGR,
                                       thresholdP = input$thresholdGR)
      })
    }else if(input$grmStatus=="fm"){
      filteredMatrixGR <- reactive({
        BacPoSSR::filterGenRelatedness(featureMatrix = featureMatrixGR,
                                       grm = NULL,
                                       thresholdP = input$thresholdGR)
      })
    }

    # plot the MCA of the dataset before filtering with filterGenRelatedness
    output$originalGenRelatMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = featureMatrixGR,
                                     groups = groupsGR,
                                     saveTo = NULL,
                                     title = input$datasetGR)
    })

    # plot the MCA of the dataset after filtering with filterGenRelatedness
    # remember, fitlerGenRelatedness returns a list of 2 matrices
    output$filteredGenRelatMCA <- renderPlot({
      BacPoSSR::plotMultCompAnalysis(featureMatrix = filteredMatrixGR()[[1]],
                                     groups = groupsGR,
                                     saveTo = NULL,
                                     title = input$datasetGR)
    })

    # make filtered dataset downloadable
    output$downloadFilteredMatrixGR <- downloadHandler(
      filename = "filtered_matrix_gen_relatedness.csv",
      content = function(file){write.csv(filteredMatrixGR()[[1]], file)}
    )
  })
}

shiny::shinyApp(ui = ui, server = server)

# [END]
