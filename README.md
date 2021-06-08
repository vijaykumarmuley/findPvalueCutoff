# findPvalueCutoff

#### P-value Cutoff Estimation to Select Differentially Expressed Genes


**findPvalueCutoff** is a R package, intended to use with uncorrected p-values obtained from differential gene expression analysis to estimate the accurate p-value threshold to select differentially expressed genes. This data-driven approach avoids using arbitrary cutoff of 0.05 p-value, and particularly useful when thousands of genes appear differentially expressed when sample sizes are large. 



# Installation

Few R packages are required to install **findPvalueCutoff**.  These can be installed by executing following chunk of code in R. In principle, only **devtools** package is required to install **findPvalueCutoff**. But other packages build ready to use documentation about running and working with **findPvalueCutoff**. For Windows operating system, RTools software should be already installed. Windows users can download and install RTools from [here](https://cran.r-project.org/bin/windows/Rtools/). 


```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
if (!requireNamespace("BiocStyle", quietly = TRUE))
    BiocManager::install("BiocStyle")
if (!requireNamespace("knitr", quietly = TRUE))
    install.packages("knitr")
if (!requireNamespace("rmarkdown", quietly = TRUE))
    install.packages("rmarkdown")
if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")
```

Then, copy and paste following command in R console to Install **findPvalueCutoff**

```
devtools::install_github("vijaykumarmuley/findPvalueCutoff", build_vignettes = TRUE)

```

In case having trouble, try running above command by setting *build_vignettes* to FALSE. 

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
