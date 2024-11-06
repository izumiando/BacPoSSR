
filterProcAnalysis <- function(featureMatrix, phenotypes, threshold=0.1){
  # run Procrustes analysis featureMatrix vs phenotypes
  procResults <- vegan::procrustes(featureMatrix, phenotypes)
  # calculate Procrustes distances for each feature
  featuresTransformed <- procResults$Yrot
  print(featuresTransformed)
  featureDistances <- apply(featuresTransformed, 2, function(feature){
    residuals <- feature - phenotypes[,1]
    sqrt(sum(residuals^2))
  })

  # sort featureMatrix based on featureDistances
  filteredFeatureMatrix <- rbind(featureMatrix, featureDistances)
  sorted_indices <- order(as.vector(featureDistances))
  filteredFeatureMatrix <- filteredFeatureMatrix[, sorted_indices]
  print(filteredFeatureMatrix)

  # filter featureMatrix based on threshold
  firstCol <- ceiling(ncol(featureMatrix) * threshold)
  filteredFeatureMatrix <-
    filteredFeatureMatrix[, firstCol:ncol(filteredFeatureMatrix)]
  # remove Procrustes distances
  filteredFeatureMatrix <- filteredFeatureMatrix[-nrow(filteredFeatureMatrix), ]

  return(filteredFeatureMatrix)
}
