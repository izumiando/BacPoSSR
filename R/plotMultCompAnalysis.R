# PRECONDITIONS:
# featureMatrix : features (col), samples (row), should have col/row names
# saveTo : should be a path to directory

# remove later
library(FactoMineR)
library(factoextra)

plotMultCompAnalysisV1 <- function(featureMatrix, groups=NULL, saveTo="./", saveName=""){
  # check input
  if(!is.data.frame(featureMatrix)){
    stop("featureMatrix must be a data frame")
  }else if(is.null(groups)){
    print("Since no groups were assigned, all samples will be assigned
          to the same group \"1\". \n")
    sampleNames <- row.names(featureMatrix)
    groups <- data.frame(groups = rep(1, length(sampleNames)),
                         row.names = sampleNames)
  }else if(!is.data.frame(groups)){
    stop("groups must be a data frame")
  }else if(ncol(groups)!=1){
    stop("groups should have 1 column only")
  }
  # creates directory is saveTo (path) does not exist
  if(!dir.exists(saveTo)){
    cat("Directory", saveTo, "does not currently exist. \n")
    cat("Creating new directory:", saveTo)
    dir.create(saveTo)
  }

  # attach groups to samples - make sure samples names correspond in both inputs
  groupColName <- names(groups)[1]
  groups$samples <- row.names(groups)
  featureMatrix$samples <- row.names(featureMatrix)
  combinedFeaturesGroups <- merge(groups, featureMatrix,
                                  by = "samples",
                                  all = FALSE)
  row.names(combinedFeaturesGroups) <- combinedFeaturesGroups$samples
  combinedFeaturesGroups$samples <- NULL
  # print how many samples were removed
  numSamplesLost <- nrow(featureMatrix) - nrow(combinedFeaturesGroups)
  cat(numSamplesLost, "samples were removed as they were not assigned
      a group number. \n")

  # run Multiple Component Analysis
  results <- MCA(combinedFeaturesGroups[, !names(combinedFeaturesGroups) %in%
                                          "groupColName"],
                 graph = FALSE)

  # generate plot + print + save
  plot <- fviz_mca_ind(results,
                       label = "none",
                       habillage = factor(combinedFeaturesGroups$groupColName),
                       addEllipses = TRUE,
                       ellipse.type = "coincidence",
                       ggtheme = theme_minimal())

  cat("Saving MCA plot to", saveTo)

  # return MCA results
  return(results)
}
