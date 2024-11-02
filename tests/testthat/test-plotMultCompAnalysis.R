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
