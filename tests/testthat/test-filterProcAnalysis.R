# tests for filterProcAnalysis

test_that("input checks are working in filterProcAnalysis", {
  # setting up some variables
  notDF <- c(0, 1, 0)
  # mini feature matrix
  feature1 <- c(0, 1, 0)
  feature2 <- c(0, 1, 0)
  feature3 <- c(0, 1, 0)
  rowNames <- c("sample1", "sample2", "sample3")
  fm <- data.frame(feature1 = feature1,
                   feature2 = feature2,
                   feature3 = feature3)
  row.names(fm) <- rowNames
  # mini phenotypes
  phenotypes <- c(0, 1, 0)
  miniPhenotypes <- data.frame(rowNames = rowNames, phenotypes = phenotypes)
  row.names(miniPhenotypes) <- miniPhenotypes[, 1]
  miniPhenotypes1Col <- as.data.frame(miniPhenotypes[, -1])

  ### 1) catches when featureMatrix is not a data frame
  testthat::expect_error(
    BacPoSSR::filterProcAnalysis(featureMatrix = notDF,
                                 phenotypes = miniPhenotypes1Col,
                                 threshold = 0.1),
    "featureMatrix must be a data frame")

  ### 2) catches when phenotypes is not a data frame
  testthat::expect_error(
    BacPoSSR::filterProcAnalysis(featureMatrix = fm,
                                 phenotypes = notDF,
                                 threshold = 0.1),
    "phenotypes must be a data frame")

  ### 3) catches when phenotypes has more than 1 column
  testthat::expect_error(
    BacPoSSR::filterProcAnalysis(featureMatrix = fm,
                                 phenotypes = miniPhenotypes,
                                 threshold = 0.1),
    "phenotypes should have 1 column only")

  ### 4) catches when threshold is not a double
  testthat::expect_error(
    BacPoSSR::filterProcAnalysis(featureMatrix = fm,
                                 phenotypes = miniPhenotypes1Col,
                                 threshold = "apple"),
    "threshold must be a number between 0 and 1")

  ### 5) catches when threshold is less than 0
  testthat::expect_error(
    BacPoSSR::filterProcAnalysis(featureMatrix = fm,
                                 phenotypes = miniPhenotypes1Col,
                                 threshold = -5),
    "threshold must be a number between 0 and 1")

  ### 6) catches when threshold is greater than 1
  testthat::expect_error(
    BacPoSSR::filterProcAnalysis(featureMatrix = fm,
                                 phenotypes = miniPhenotypes1Col,
                                 threshold = 4),
    "threshold must be a number between 0 and 1")
})

test_that("filterProcAnalysis functions as designed", {
  # loading test data
  testMatrix <- read.csv("testMatrix.csv", header = TRUE)
  row.names(testMatrix) <- testMatrix[, 1]
  testMatrix <- testMatrix[, -1]

  testPhenotypes <- read.csv("testPhenotypes.csv", header = TRUE)
  row.names(testPhenotypes) <- testPhenotypes[, 1]
  testPhenotypes <- as.data.frame(testPhenotypes[, -1])

  output <- BacPoSSR::filterProcAnalysis(featureMatrix = testMatrix,
                                         phenotypes = testPhenotypes,
                                         threshold = 0.1)

  ### 1) returns a data frame
  testthat::expect_s3_class(output, "data.frame")
})

# [END]
