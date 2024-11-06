# BacPoSSR

## Description

The objective of this tool is to help users filter their single nucleotide polymorphism (SNP) or k-mer data to reduce population structure signal in the dataset before it is used in bacterial genotype-phenotype association or predictive studies. It aims to improve the flow of these studies, especially methods that use machine learning models to compute these mappings because scientists must build in their own methods to account for population structure within their models, unlike more established genome-wide association studies (GWAS) tools such as pyseer (Lees et al., 2018). When population structure is not accounted for, association/predictive studies can easily lead to false positives by inferring phenotypes from population structure (Karlsen et al., 2023).

This package was developed in the following environment:
R Version: 4.4.1 (2024-06-14) -- "Race for Your Life"
Platform: macOS Sonoma 14.4

## Installation

To install the lastest version of the package:
```
install.packages("devtools")
library("devtools")
devtools::install_github("izumiando/BacPoSSR", build_vignettes = TRUE)
library("BacPoSSR")
```

To run shinyApp: Under Construction

## Overview

## Contributions

The author of BacPoSSR is Izumi Ando. BacPoSSR contains three functions, all of which were written by the author. However, some functions utilize core functions from third-party packages as follows. <add more text here later>. ChatGPT developed by OpenAI was used in the creation of this package only for the purpose of debugging the code.


## References

Karlsen, S. T., Rau, M. H., Sánchez, B. J., Jensen, K., & Zeidan, A. A. (2023). From genotype to phenotype: Computational approaches for inferring microbial traits relevant to the food industry. FEMS Microbiology Reviews, 47(4), fuad030. https://doi.org/10.1093/femsre/fuad030

Lees, J. A., Galardini, M., Bentley, S. D., Weiser, J. N., & Corander, J. (2018). pyseer: A comprehensive tool for microbial pangenome-wide association studies. Bioinformatics, 34(24), 4310–4312. https://doi.org/10.1093/bioinformatics/bty539

Lê S, Josse J, Husson F (2008). “FactoMineR: A Package for Multivariate Analysis.” Journal of Statistical Software, 25(1), 1–18. doi:10.18637/jss.v025.i01.

Oksanen J, Simpson G, Blanchet F, Kindt R, Legendre P, Minchin P, O'Hara R, Solymos P, Stevens M, Szoecs E, Wagner H, Barbour M, Bedward M, Bolker B, Borcard D, Carvalho G, Chirico M, De Caceres M, Durand S, Evangelista H, FitzJohn R, Friendly M, Furneaux B, Hannigan G, Hill M, Lahti L, McGlinn D, Ouellette M, Ribeiro Cunha E, Smith T, Stier A, Ter Braak C, Weedon J (2024). _vegan: Community Ecology Package_. R package version 2.6-8, <https://CRAN.R-project.org/package=vegan>.

Wickham H (2016). ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York. ISBN 978-3-319-24277-4, https://ggplot2.tidyverse.org.

## Acknowledgements

This package was developed as a part of an assessment for 2024 BCB410H: Applied Bioinformatics course at the University of Toronto, Toronto, CANADA. BacPoSSR welcomes issues, enhancement requests, and other contributions. To submit an issue, use GitHub issues.
