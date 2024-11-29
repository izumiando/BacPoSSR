## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
options(repos = c(CRAN = "https://cran.r-project.org"))

## -----------------------------------------------------------------------------
# install.packages("devtools")
# library("devtools")
# devtools::install_github("izumiando/BacPoSSR", build_vignettes = TRUE)
# library("BacPoSSR")

## -----------------------------------------------------------------------------
ls("package:BacPoSSR")

## -----------------------------------------------------------------------------
# replace "file.csv" with the file you want to load
# filePath <- system.file("extdata", "file.csv", package = "BacPoSSR")
# loadedData <- read.csv(filePath, header = TRUE)

