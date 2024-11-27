library(shiny)
library(bslib)

# TODO
# make sure coding conventions are followed

ui <- page_fluid(
  # this is not showing up for some reason
  title = "BacPoSSR Web App",
  navset_card_tab(
    # Home tab : explanation on how to use the webapp
    nav_panel("Home",
              "Explanation"
              ),
    # Procrustes Analysis tab
    nav_panel("Procrustes Analysis",
              "Filter dataset using Procrustes Analysis",
              page_sidebar(sidebar = sidebar("Input & Parameters",
                                             # file input
                                             fileInput("featureMatrixPA", "Upload a feature matrix in .csv format"),
                                             fileInput("phenotypes", "Upload a phenotype table in .csv format"),
                                             numericInput("thresholdPA", "Threshold", value = 1, min = 0, max = 1),
                                             textInput("datasetPA", "Dataset Name")
                                             ),
                           card("MCA of dataset before filtering"),
                           card("MCA of dataset after filtering"))
              ),
    # Genetic Relatedness Analysis tab
    nav_panel("Genetic Relatedness",
              "Filter dataset by Genetic Relatedness",
              page_sidebar(sidebar = sidebar("Input & Parameters"),
                           card("MCA of dataset before filtering"),
                           card("MCA of dataset after filtering"))
              ),
  ),
  id = "tab"
)

server <- function(input, output){
  #output$mcaOriginalPA
}

shiny::shinyApp(ui, server)

# [END]
