#' Plot Multiple Component Analysis (MCA)
#'
#' This function conducts Multiple Component Analysis (MCA) and plots the
#' resulting graph. This can be used to visually evaluate the efficacy of the
#' filtering methods provided in the BacPoSSR package or to visualize the
#' population structure signal of any given feature matrix. The examples can be
#' run if TinySampleData.RData is loaded.
#'
#' @param featureMatrix : a presence absence matrix where features are columns,
#' and samples are rows. The format should be a data frame and col/row names
#' should be preassigned.
#' @param groups : (default=NULL) a single column data frame of the groups
#' assigned to each sample. Row names of this data frame should correspond to
#' that of the featureMatrix.
#' @param saveTo : (default="./") path to directory where you want the MCA plot
#' to be saved. If set to null, plot will not be saved.
#' @param title : (default="MCA") title of the plot.
#'
#' @return the MCA results
#' @export
#'
#' @examples plotMultCompAnalysis(featureMatrix = tinyFeatureMatrix,
#' groups = tinyGroupsMatching)
#'
#' @references
#' Lê S, Josse J, Husson F (2008). “FactoMineR: A Package for Multivariate
#' Analysis.” Journal of Statistical Software, 25(1), 1–18.
#' doi:10.18637/jss.v025.i01.
#'
#' Wickham H (2016). ggplot2: Elegant Graphics for Data Analysis.
#' Springer-Verlag New York. ISBN 978-3-319-24277-4,
#' https://ggplot2.tidyverse.org.
#'
#' @import FactoMineR
#' @import factoextra
#' @import ggplot2
#'
plotMultCompAnalysis <- function(featureMatrix, groups=NULL,
                                 saveTo="./", title="MCA"){
  # check input to prevent errors
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
  if(!is.null(saveTo)){
    if(!dir.exists(saveTo)){
      cat("Directory", saveTo, "does not currently exist. \n")
      cat("Creating new directory:", saveTo)
      dir.create(saveTo)
    }
  }

  # attach groups to samples - make sure samples names correspond in both inputs
  groupColName <- names(groups)[1] # finding the column name of groups column
  groups$samples <- row.names(groups)
  featureMatrix$samples <- row.names(featureMatrix)
  combinedFeaturesGroups <- merge(groups, featureMatrix,
                                  by = "samples",
                                  all = FALSE)
  row.names(combinedFeaturesGroups) <- combinedFeaturesGroups$samples
  combinedFeaturesGroups$samples <- NULL
  # print how many samples were removed
  numSamplesLost <- nrow(featureMatrix) - nrow(combinedFeaturesGroups)
  cat(numSamplesLost,
      "samples were removed as they were not assigned a group number. \n")

  # run Multiple Component Analysis
  combinedFeaturesGroups <- data.frame(lapply(combinedFeaturesGroups,
                                              as.factor))

  featuresOnly <- combinedFeaturesGroups[, 2:ncol(combinedFeaturesGroups)]

  if(nrow(featuresOnly)==0 || ncol(featuresOnly) == 0){
    stop("cannot conduct MCA as there are 0 rows or 0 columns")
  }

  results <- FactoMineR::MCA(featuresOnly,
                 graph = FALSE)

  # generate plot + print + save
  plot <- factoextra::fviz_mca_ind(results,
                       label = "none",
                       habillage =
                         factor(combinedFeaturesGroups[[groupColName]]),
                       addEllipses = TRUE,
                       ellipse.type = "coincidence",
                       ggtheme = theme_minimal()) + ggtitle(title)
  print(plot)
  plotFile <- file.path(saveTo, paste0(title, ".jpg"))
  if(!is.null(saveTo)){
    ggplot2::ggsave(filename = plotFile,
                    plot = plot,
                    width = 8,
                    height = 6,
                    dpi = 300)
    cat("Saving MCA plot to", plotFile)
  }
  # return MCA results
  return(results)
}

# [END]
