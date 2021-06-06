# findPvalueCutoff

#### P-value Cutoff Estimation to Select Differentially Expressed Genes


**findPvalueCutoff** is a R package, intended to use with uncorrected p-values obtained from differential gene expression analysis to estimate the accurate p-value threshold to select differentially expressed genes. This data-driven approach avoids using arbitrary cutoff of 0.05 p-value, and particularly useful when thousands of genes appear differentially expressed when sample sizes are large. 



# Installation

The **devtools** package is required to install **findPvalueCutoff**. This can be done by installing devtools by typing *install.packages(devtools)* command in R. If the **devtools** package is already installed, then it should be loaded in the current R environment as shown below,

```
library(devtools)

```

Copy and paste following command in R console to Install **findPvalueCutoff**

```
devtools::install_github("vijaykumarmuley/findPvalueCutoff", build_vignettes = TRUE)

```

Load **findPvalueCutoff** into your R workspace using following command after its installation.


```
library(findPvalueCutoff)
```

Browse **findPvalueCutoff** documentation using following command. It has details on how to use findPvalueCutoff with demonstrated examples, and also theoretical background behind it.


```
browseVignettes("findPvalueCutoff")
```

# Contact

For questions regarding **findPvalueCutoff**, contact the author at *vijay.muley\@gmail.com*
