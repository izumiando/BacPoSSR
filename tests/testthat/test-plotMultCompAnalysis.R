# test_that("multiplication works", {
#   expect_equal(2 * 2, 4)
# })

# Things to test
## Input catching
### 1) catches when featureMatrix is not a data frame
### 2) creates groups data frame when groups is NULL
### 3) catches when groups is not a data frame
### 4) catches when groups has more than 1 column
### 5) creates a new directory if the assigned one does not already exist

## Output
### 1) creates default jpg image in the default directory
### 2) creates default jpg image in the assigned directory
### 3) creates assigned jpg image in the default directory
### 4) creates assigned jpg image in the assigned directory
### 5) returns a list (i think)

library(BacPoSSR)

test_that("plotMultCompAnalysis works as expected", {
  #
  # Create dummy feature matrix
  featureMatrix <- data.frame(
    feature1 = c(1, 0, 1, 0),
    feature2 = c(0, 1, 0, 1),
    feature3 = c(1, 1, 0, 0)
  )
  rownames(featureMatrix) <- c("sample1", "sample2", "sample3", "sample4")

  # Create dummy groups
  groups <- data.frame(groups = c("A", "B", "A", "B"))
  rownames(groups) <- c("sample1", "sample2", "sample3", "sample4")

  # Test: Valid input should return MCA results
  results <- plotMultCompAnalysis(featureMatrix, groups, saveTo = NULL, title = "Test Plot")
  expect_s3_class(results, "MCA")
  expect_true("eig" %in% names(results))

  # Test: Groups are NULL
  expect_message(
    results_no_groups <- plotMultCompAnalysis(featureMatrix, groups = NULL, saveTo = NULL),
    "Since no groups were assigned, all samples will be assigned to the same group"
  )
  expect_s3_class(results_no_groups, "MCA")

  # Test: Directory creation
  temp_dir <- tempdir()
  non_existent_dir <- file.path(temp_dir, "nonexistent")
  expect_message(
    plotMultCompAnalysis(featureMatrix, groups, saveTo = non_existent_dir),
    "Creating new directory"
  )
  expect_true(dir.exists(non_existent_dir))

  # Test: Samples without groups are removed
  featureMatrix_with_extra_sample <- featureMatrix
  featureMatrix_with_extra_sample <- rbind(
    featureMatrix_with_extra_sample,
    c(0, 1, 1)
  )
  rownames(featureMatrix_with_extra_sample)[5] <- "sample5"
  expect_message(
    results_sample_removed <- plotMultCompAnalysis(
      featureMatrix_with_extra_sample, groups, saveTo = NULL
    ),
    "1 samples were removed as they were not assigned a group number."
  )
  expect_s3_class(results_sample_removed, "MCA")

  # Test: Invalid featureMatrix (not a data frame)
  expect_error(
    plotMultCompAnalysis(as.matrix(featureMatrix), groups),
    "featureMatrix must be a data frame"
  )

  # Test: Invalid groups (not a data frame)
  expect_error(
    plotMultCompAnalysis(featureMatrix, as.matrix(groups)),
    "groups must be a data frame"
  )

  # Test: Groups with more than one column
  invalid_groups <- cbind(groups, extra_col = c("X", "Y", "Z", "W"))
  expect_error(
    plotMultCompAnalysis(featureMatrix, invalid_groups),
    "groups should have 1 column only"
  )

  # Test: Missing samples in groups
  incomplete_groups <- groups[-4, , drop = FALSE]
  expect_message(
    results_missing_samples <- plotMultCompAnalysis(
      featureMatrix, incomplete_groups, saveTo = NULL
    ),
    "1 samples were removed as they were not assigned a group number."
  )
  expect_s3_class(results_missing_samples, "MCA")

  # Test: Plot saved successfully
  save_dir <- tempdir()
  plot_file <- file.path(save_dir, "MCA_Test.jpg")
  plotMultCompAnalysis(featureMatrix, groups, saveTo = save_dir, title = "MCA_Test")
  expect_true(file.exists(plot_file))
})

test_that("Edge cases are handled gracefully", {
  # Empty feature matrix
  empty_featureMatrix <- data.frame()
  expect_error(
    plotMultCompAnalysis(empty_featureMatrix, groups),
    "data frame with 0 rows"
  )

  # Empty groups
  empty_groups <- data.frame(groups = character(0))
  expect_error(
    plotMultCompAnalysis(featureMatrix, empty_groups),
    "Row names of this data frame should correspond to that of the featureMatrix"
  )
})


# [END]
