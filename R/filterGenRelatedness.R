
filterGenRelatedness <- function(featureMatrix, isGRM=FALSE, threshold=0.1){
  # input check
  # compute gen relatedness matrix (grm)
  # mca of grm
  # regress grm against featureMatrix
  # filter by threshold
  output <- list(filteredFeatureMatrix, grm)
  return(output)
}
