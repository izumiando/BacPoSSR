
# question - should I be returning the MCA results, or the plot itself > save the plot, return MCA res
# question - what happens to points without a group in the MCA?

plotMultCompAnalysisV1 <- function(featureMatrix, groups, saveTo="./", saveName=""){
  # check input
  # featureMatrix should be features (columns), samples (rows), should have row & column names


  # attach groups to samples - make sure samples names correspond in both inputs

  combinedFeaturesGroups <- merge()
  # print how many samples were lost
  # rename the group columns

  # run Multiple Component Analysis
  results <- MCA(combinedFeaturesGroups[, 2:ncol(combinedFeaturesGroups)],
                 graph = FALSE)

  # generate plot + print + save
  plot <- fviz_mca_ind(results,
                       label = "none",
                       habillage = factor(results$groups),
                       addEllipses = TRUE,
                       ellipse.type = "coincidence",
                       ggtheme = theme_minimal())

  cat("Saving MCA plot to", saveTo)

  # return MCA results
  return(results)
}
