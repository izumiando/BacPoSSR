# test_that("filterGenRelatedness works as expected", {
#   # Generate a dummy feature matrix
#   featureMatrix <- data.frame(
#     feature1 = c(1, 0, 1, 0),
#     feature2 = c(0, 1, 0, 1),
#     feature3 = c(1, 1, 0, 0),
#     feature4 = c(0, 0, 1, 1)
#   )
#   rownames(featureMatrix) <- c("sample1", "sample2", "sample3", "sample4")
#
#   groups <- data.frame(groups = c(1, 2, 3, 3))
#   rownames(groups) <- c("sample1", "sample2", "sample3", "sample4")
#
#   # Test: Output structure and types
#   output <- filterGenRelatedness(featureMatrix = featureMatrix,
#                                  grm = NULL,
#                                  thresholdP = 0.05)
#   expect_type(output, "list")
#   expect_length(output, 2) # Expect GRM and filtered feature matrix
#   expect_true(is.data.frame(output[[1]])) # Filtered feature matrix
#   expect_true(is.matrix(output[[2]])) # GRM
#
#   # Test: Thresholding works correctly
#   filteredMatrix <- output[[1]]
#   expect_true(nrow(filteredMatrix) <= nrow(featureMatrix)) # Some rows may be filtered out
#
#   # Test: Default GRM calculation
#   expect_equal(dim(output[[2]]), c(nrow(featureMatrix), nrow(featureMatrix))) # GRM is square
#
#   # Test: Using precomputed GRM
#   grm <- output[[2]]
#   output_precomputed <- filterGenRelatedness(featureMatrix = featureMatrix, grm = grm)
#   expect_equal(output_precomputed[[2]], grm) # GRM should remain the same
#
#   # Test: Edge case - Single feature
#   singleFeatureMatrix <- featureMatrix[, 1, drop = FALSE]
#   output_single <- filterGenRelatedness(featureMatrix = singleFeatureMatrix)
#   expect_true(is.data.frame(output_single[[1]])) # Single feature should still work
#   expect_equal(ncol(output_single[[1]]), 1)
#
#   # Test: Edge case - Single sample
#   singleSampleMatrix <- featureMatrix[1, , drop = FALSE]
#   expect_error(
#     filterGenRelatedness(featureMatrix = singleSampleMatrix),
#     "GRM computation requires multiple rows."
#   )
#
#   # Test: Invalid inputs
#   expect_error(filterGenRelatedness(featureMatrix = as.matrix(featureMatrix)), "featureMatrix must be a data frame")
#   expect_error(filterGenRelatedness(featureMatrix = featureMatrix, grm = as.matrix(grm)), "grm must be a data frame or NULL")
#   expect_error(filterGenRelatedness(featureMatrix = featureMatrix, thresholdP = "not_a_number"), "threshold must be a number between 0 and 1")
#   expect_error(filterGenRelatedness(featureMatrix = featureMatrix, thresholdP = -0.1), "threshold must be a number between 0 and 1")
#
#   # Test: All features filtered out
#   output_all_filtered <- filterGenRelatedness(featureMatrix, thresholdP = 0)
#   expect_equal(nrow(output_all_filtered[[1]]), 0) # No features should pass filtering
#
#   # Test: No filtering occurs
#   output_no_filtering <- filterGenRelatedness(featureMatrix, thresholdP = 1)
#   expect_equal(nrow(output_no_filtering[[1]]), nrow(featureMatrix)) # All features remain
# })
#
# test_that("filterGenRelatedness handles extreme inputs gracefully", {
#   # Edge case: All features are identical
#   identicalFeatures <- data.frame(
#     sample1 = rep(1, 5),
#     sample2 = rep(1, 5),
#     sample3 = rep(1, 5),
#     sample4 = rep(1, 5)
#   )
#   rownames(identicalFeatures) <- paste0("feature", 1:5)
#   output_identical <- filterGenRelatedness(featureMatrix = identicalFeatures)
#   expect_equal(nrow(output_identical[[1]]), 0) # No variation, so all should be filtered
#
#   # Edge case: Completely random matrix
#   set.seed(123)
#   randomMatrix <- as.data.frame(matrix(sample(0:1, 100, replace = TRUE), nrow = 10))
#   rownames(randomMatrix) <- paste0("feature", 1:10)
#   output_random <- filterGenRelatedness(featureMatrix = randomMatrix)
#   expect_true(nrow(output_random[[1]]) <= nrow(randomMatrix)) # Some features may be filtered
# })
#
# test_that("filterGenRelatedness computes GRM correctly", {
#   # Test GRM computation consistency
#   featureMatrix <- data.frame(
#     sample1 = c(1, 0, 1, 0),
#     sample2 = c(0, 1, 0, 1),
#     sample3 = c(1, 1, 0, 0),
#     sample4 = c(0, 0, 1, 1)
#   )
#   rownames(featureMatrix) <- c("feature1", "feature2", "feature3", "feature4")
#
#   output <- filterGenRelatedness(featureMatrix = featureMatrix)
#   grm <- output[[2]]
#
#   # GRM should be symmetric
#   expect_true(all(grm == t(grm)))
#
#   # GRM diagonal should be largest (self-relatedness)
#   expect_true(all(diag(grm) >= grm[lower.tri(grm)]))
# })
#
# # [END]
