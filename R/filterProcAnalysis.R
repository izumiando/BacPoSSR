#' Filter Feature Matrix Using Procrustes Distances
#'
#' @description This function conducts Procrustes Analysis on feature matrices against
#' phenotype data to compute the Procrustes Distance of each feature. Features
#' with lower distances are more likely to be associated with population
#' structure signal, thus will be removed from the dataset. To further enhance
#' the efficacy of this function, dimensionality reduction can be done on the
#' featureMatrix and be used as input. The examples can be run if
#' TinySampleData.RData is loaded.
#'
#' @param featureMatrix : a presence absence matrix where features are columns,
#' and samples are rows. The format should be a data frame and col/row names
#' should be preassigned.
#' @param phenotypes : a single column data frame of the phenotypes
#' assigned to each sample. Row names of this data frame should correspond to
#' that of the featureMatrix.
#' @param threshold : (default=0.1) Value between 0 and 1 that determines what
#' proportion of the features get filtered out. The features in the bottom
#' threshold*100% when sorted by Procrustes distances will be filtered out.
#'
#' @return a subset of the input featureMatrix
#' @export
#'
#' @examples filterProcAnalysis(featureMatrix = tinyFeatureMatrix,
#' phenotypes = phenotypes)
#'
#' @references
#' Oksanen J, Simpson G, Blanchet F, Kindt R, Legendre P, Minchin P, O'Hara R,
#' Solymos P, Stevens M, Szoecs E, Wagner H, Barbour M, Bedward M, Bolker B,
#' Borcard D, Carvalho G, Chirico M, De Caceres M, Durand S, Evangelista H,
#' FitzJohn R, Friendly M, Furneaux B, Hannigan G, Hill M, Lahti L, McGlinn D,
#' Ouellette M, Ribeiro Cunha E, Smith T, Stier A, Ter Braak C,
#' Weedon J (2024). _vegan: Community Ecology Package_. Rpackage version 2.6-8,
#' <https://CRAN.R-project.org/package=vegan>.
#'
#' @import vegan
#'
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

# [END]
