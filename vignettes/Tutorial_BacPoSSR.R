## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
options(repos = c(CRAN = "https://cran.r-project.org"))

## ----setup--------------------------------------------------------------------
library(BacPoSSR)

## -----------------------------------------------------------------------------
install.packages("devtools")
library("devtools")
devtools::install_github("izumiando/BacPoSSR", build_vignettes = TRUE)
library("BacPoSSR")

## -----------------------------------------------------------------------------
ls("package:BacPoSSR")

## -----------------------------------------------------------------------------
data(package = "BacPoSSR")

