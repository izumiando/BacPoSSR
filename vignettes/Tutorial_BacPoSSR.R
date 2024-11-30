## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
options(repos = c(CRAN = "https://cran.r-project.org"))

# Attach the package
library(BacPoSSR)

## ----eval = FALSE-------------------------------------------------------------
#  # install.packages("devtools")
#  library("devtools")
#  devtools::install_github("izumiando/BacPoSSR", build_vignettes = TRUE)
#  library("BacPoSSR")

## ----eval = FALSE-------------------------------------------------------------
#  ls("package:BacPoSSR")

## -----------------------------------------------------------------------------
# replace "file.csv" with the file you want to load
# filePath <- system.file("extdata", "file.csv", package = "BacPoSSR")
# loadedData <- read.csv(filePath, header = TRUE)

## ----eval = FALSE-------------------------------------------------------------
#  runBacPoSSR()

## ----eval = FALSE-------------------------------------------------------------
#  # getting the file paths for the sample data
#  pathFeatureMatrix <- system.file("extdata",
#                                   "sampleFeatureMatrix.csv",
#                                   package = "BacPoSSR")
#  pathPhenotypeData <- system.file("extdata",
#                                   "samplePhenotypeData.csv",
#                                   package = "BacPoSSR")
#  pathGroupAssignments <- system.file("extdata",
#                                      "sampleGroupAssignments.csv",
#                                      package = "BacPoSSR")
#  
#  # load the data from the file paths
#  sampleFeatureMatrix <- read.csv(pathFeatureMatrix, header = TRUE)
#  samplePhenotypeData <- read.csv(pathPhenotypeData, header = TRUE)
#  sampleGroupAssignments <- read.csv(pathGroupAssignments, header = TRUE)
#  
#  # format the data objects so that
#  # the column with sample names are assigned as row names
#  
#  # assigning first column as row names
#  row.names(sampleFeatureMatrix) <- sampleFeatureMatrix[, 1]
#  # removing redundant first column
#  sampleFeatureMatrix <- sampleFeatureMatrix[, -1]
#  
#  row.names(samplePhenotypeData) <- samplePhenotypeData[, 1]
#  samplePhenotypeData <- samplePhenotypeData[, -1]
#  # making sure object stays a data frame
#  samplePhenotypeData <- as.data.frame(samplePhenotypeData)
#  
#  row.names(sampleGroupAssignments) <- sampleGroupAssignments[, 1]
#  sampleGroupAssignments <- sampleGroupAssignments[, -1]
#  sampleGroupAssignments <- as.data.frame(sampleGroupAssignments)
#  

## ----eval = FALSE-------------------------------------------------------------
#  sampleUnfilteredMCA <-
#    BacPoSSR::plotMultCompAnalysis(featureMatrix = sampleFeatureMatrix,
#                                   groups = sampleGroupAssignments,
#                                   saveTo = NULL,
#                                   title = "Sample Unfiltered Dataaset")

## ----eval = FALSE-------------------------------------------------------------
#  sampleFilteredMatrixPA <-
#    BacPoSSR::filterProcAnalysis(featureMatrix = sampleFeatureMatrix,
#                                 phenotypes = samplePhenotypeData,
#                                 threshold = 0.1)
#  
#  sampleFilteredMatrixGR <-
#    BacPoSSR::filterGenRelatedness(featureMatrix = sampleFeatureMatrix,
#                                   grm = NULL,
#                                   thresholdP = 0.05)
#  sampleFilteredMatrixGR <- sampleFilteredMatrixGR[[1]]

## ----eval = FALSE-------------------------------------------------------------
#  # plotting the sample dataset post filtering with filterProcAnalysis
#  # with a threshold of 0.1
#  sampleFilteredProcAnalysisMCA <-
#    BacPoSSR::plotMultCompAnalysis(featureMatrix = sampleFilteredMatrixPA,
#                                   groups = sampleGroupAssignments,
#                                   saveTo = NULL,
#                                   title = "Sample Filtered Dataaset, PA, 0.1")
#  # plotting the sample dataset post filtering with filterGenRelatedness
#  # with a p-value threshold of 0.05
#  sampleFilteredGenRelMCA <-
#    BacPoSSR::plotMultCompAnalysis(featureMatrix = sampleFilteredMatrixGR,
#                                   groups = sampleGroupAssignments,
#                                   saveTo = NULL,
#                                   title = "Sample Filtered Dataaset, GR, 0.05")

## -----------------------------------------------------------------------------
# sessionInfo()

