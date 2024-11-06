# although this will work for kmer and unitig data, it is ideally for SNP matrices


filterGenRelatedness <- function(featureMatrix, grm=NULL, thresholdP=0.05){
  numSamples <- nrow(featureMatrix)
  # compute Genetic Relatedness Matrix (grm) if featureMatrix is not a GRM
  if (is.null(grm)){
    # compute minor allele frequencies (maf)
    maf <- apply(featureMatrix, 2, function(features){
      # only checking 1 and 0 because bacteria are haploid
      numPresence <- sum(features == 1)
      numAbsence <- sum(features == 0)
      # the maf of a single SNP or feature
      singleMAF <- min(numPresence, numAbsence) / length(features)
    })

    # creating a centered genotype matrix (cgm)
    maf <- maf*2
    cgm <- as.matrix(featureMatrix)
    cgm <- sweep(cgm, 2, maf, FUN="-")

    # creating the GRM by doing matrix multiplication of cgm and its transpose
    # normalizing by the number of features
    numFeatures <- ncol(cgm)
    grm <- (cgm %*% t(cgm)) / numFeatures
    # grm <- as.data.frame(grm)
  }

  # compute the first 10 principal components of the grm
  pcs <- prcomp(grm)$x[, 1:10]  # Extract first 10 PCs

  # computing p-values for each PC after regression
  numFeatures <- ncol(featureMatrix)
  pValuesList <- list()

  for (index in 1:10) {
    pc <- pcs[, index]
    pValues <- numeric(numFeatures)

    # regress features on PC & extract p-values
    for (i in 1:numFeatures) {
      feature <- featureMatrix[, i]
      model <- lm(feature ~ pc)
      modelSummary <- summary(model)
      pValues[i] <- coef(modelSummary)["pc", "Pr(>|t|)"]
    }

    pValuesList[[index]] <- pValues
  }

  # finding the average p-value for each feature
  pValuesDFComb <- as.data.frame(do.call(rbind, pValuesList))
  colnames(pValuesDFComb) <- colnames(featureMatrix)
  rownames(pValuesDFComb) <- paste0("PC", 1:10)

  # Calculate the average p-value across all PCs for each feature
  avgPValues <- colMeans(pValuesDFComb)

  # filter by threshold
  filteredFeatureMatrix <- rbind(featureMatrix, avgPValues)
  filteredFeatureMatrix <- subset(filteredFeatureMatrix,
                                  avgPValues <= thresholdP)
  filteredFeatureMatrix <- filteredFeatureMatrix[1:numSamples, ]

  output <- list(filteredFeatureMatrix, grm)
  return(output)
}
