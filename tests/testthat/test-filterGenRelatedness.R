# tests for filterGenRelatedness

test_that("input checks are working in filterGenRelatedness", {
  feature1 <- c(0, 1, 0)
  feature2 <- c(0, 1, 0)
  feature3 <- c(0, 1, 0)
  rowNames <- c("sample1", "sample2", "sample3")
  fm <- data.frame(feature1 = feature1,
                   feature2 = feature2,
                   feature3 = feature3)
  row.names(fm) <- rowNames

  ### 1) catches when featureMatrix is not a data frame
  testthat::expect_error(
    BacPoSSR::filterGenRelatedness(featureMatrix = feature1,
                                   grm = NULL,
                                   thresholdP = 0.05),
    "featureMatrix must be a data frame")

  ### 2) catches when groups is neither a data frame or null
  testthat::expect_error(
    BacPoSSR::filterGenRelatedness(featureMatrix = fm,
                                   grm = feature1,
                                   thresholdP = 0.05),
    "grm must be a data frame or NULL")

  ### 3) catches when thresholdP is not a double
  testthat::expect_error(
    BacPoSSR::filterGenRelatedness(featureMatrix = fm,
                                   grm = NULL,
                                   thresholdP = "apple"),
    "threshold must be a number between 0 and 1")

  ### 4) catches when thresholdP is less than 0
  testthat::expect_error(
    BacPoSSR::filterGenRelatedness(featureMatrix = fm,
                                   grm = NULL,
                                   thresholdP = -5),
    "threshold must be a number between 0 and 1")

  ### 5) catches when thresholdP is greater than 1
  testthat::expect_error(
    BacPoSSR::filterGenRelatedness(featureMatrix = fm,
                                   grm = NULL,
                                   thresholdP = 3),
    "threshold must be a number between 0 and 1")
})

test_that("filterGenRelatedness functions as designed", {
  testMatrix <- read.csv("testMatrix.csv", header = TRUE)
  row.names(testMatrix) <- testMatrix[, 1]
  testMatrix <- testMatrix[, -1]

  output <- BacPoSSR::filterGenRelatedness(featureMatrix = testMatrix,
                                           grm = NULL,
                                           thresholdP = 0.05)

  ### 1) returns a list
  testthat::expect_type(output, "list")

  ### 2) return value includes two data frames
  testthat::expect_s3_class(output[[1]], "data.frame")
  testthat::expect_s3_class(output[[2]], "data.frame")
})

# [END]
