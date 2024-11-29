## Input catching
### 1) catches when featureMatrix is not a data frame
### 2) catches when groups is not a data frame
### 3) catches when groups has more than 1 column

## Output
### 1) saves image to specified directory
### 2) returns a list
### 3) does not save image when saveTo is null

test_that("input checks are working in plotMultCompAnalysis", {
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
  groups <- c(1, 2, 3)
  groupsDF <- data.frame(rowNames = rowNames, groups = groups)
  row.names(groupsDF) <- groupsDF[, 1]
  groupsNotDF <- groupsDF[, -1]
  groupsDF1Col <- as.data.frame(groupsNotDF)

  ### 1) catches when featureMatrix is not a data frame
  testthat::expect_error(
    BacPoSSR::plotMultCompAnalysis(featureMatrix = notDF,
                                   groups = NULL,
                                   saveTo = NULL,
                                   title = "MCA"),
    "featureMatrix must be a data frame")

  ### 2) catches when groups is not a data frame
  testthat::expect_error(
    BacPoSSR::plotMultCompAnalysis(featureMatrix = fm,
                                   groups = groupsNotDF,
                                   saveTo = NULL,
                                   title = "MCA"),
    "groups must be a data frame")

  ### 3) catches when groups has more than 1 column
  testthat::expect_error(
    BacPoSSR::plotMultCompAnalysis(featureMatrix = fm,
                                   groups = fm,
                                   saveTo = NULL,
                                   title = "MCA"),
    "groups should have 1 column only")
})

test_that("plotMultCompAnalysis functions as designed", {
  # loading test data
  testMatrix <- read.csv("testMatrix.csv", header = TRUE)
  row.names(testMatrix) <- testMatrix[, 1]
  testMatrix <- testMatrix[, -1]

  testGroups <- read.csv("testGroups.csv", header = TRUE)
  row.names(testGroups) <- testGroups[, 1]
  testGroups <- as.data.frame(testGroups[, -1])

  output <- BacPoSSR::plotMultCompAnalysis(featureMatrix = testMatrix,
                                           groups = testGroups,
                                           saveTo = "./",
                                           title = "testMCA")

  ### 1) saves image to specified directory
  testthat::expect_true(file.exists("testMCA.jpg"))
  system("rm testMCA.jpg")

  ### 2) returns a list
  testthat::expect_type(output, "list")

})




# [END]
