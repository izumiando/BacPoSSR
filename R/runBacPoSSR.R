#' Launch Shiny App for BacPoSSR
#'
#' This function launches the Shiny app for BacPoSSR. This app is intended for
#' those who are less accustomed to using R packages in code format. The app
#' should give you an interactive idea of what BacPoSSR can do.
#' The code for the app can be found in \code{./inst/shiny-scripts}.
#'
#' @return launches Shiny app, does not return any values.
#'
#' @examples
#' \dontrun{
#'
#' BacPoSSR::runBacPoSSR()
#' }
#'
#' @export
#' @importFrom shiny runApp

runBacPoSSR <- function() {
  appLocation <- system.file("shiny-scripts", package = "BacPoSSR")
  actionShiny <- shiny::runApp(appLocation, display.mode = "normal")
  return(actionShiny)
}
# [END]
