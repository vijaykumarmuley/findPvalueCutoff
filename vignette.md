---
title: "findPvalueCutoff"
shorttitle: "P-value Cutoff Estimation to Select Differentially Expressed Genes"
author:
- name: "Vijaykumar Yogesh Muley"
  affiliation: 
  - Instituto de Neurobiología, Universidad Nacional Autónoma de México, Querétaro, Mexico
  email: vijay.muley@gmail.com
date: "2021-07-19"
output:
    md_document:
      variant: markdown_github
    BiocStyle::html_document:
      toc: true
      toc_depth: 2
vignette: >
    %\VignetteIndexEntry{Vignette Title}
    %\VignetteEngine{knitr::rmarkdown}
    %\VignetteEncoding{UTF-8}  
---



# Introduction

Cells respond to external and internal signals by controlling expression of specific genes that process the signals and generate adaptive responses (Muley and Pathania 2017). Several experimental techniques have been developed to quantify expression of genes at genome scale. This process is often referred to as gene expression profiling or transcriptomics (Pathania and Muley 2017). The common theme of such experiments is to obtain gene expression profiles from control (normal) samples and experimental samples with specific treatment or from diseased individuals in replicates (Law et al. 2016). Then, the expression of each gene is compared between experimental and normal samples. Genes with significant expression changes in the experimental group compared to normal are more likely to be responsible for the phenotypic differences between the groups. These genes are referred to as differentially expressed genes. Such analyses are also commonly used in studying developmental time points to understand which genes are required for specific developmental time points (Muley et al. 2020). 

## Differential gene expression analysis

Several statistical tools have been developed to perform differential expression analysis (Rapaport et al. 2013; Robinson and Oshlack 2010; Soneson and Delorenzi 2013). These tools typically perform hypothesis significance testing under a null hypothesis that the gene has no differential expression in the compared group and assign a test p-value to a gene. The p-value is the probability of obtaining test results as extreme as the results observed when the null hypothesis is correct. A very small p-value means that such an extreme observed outcome would be very unlikely under the null hypothesis, and hence the gene has different expression in compared groups. Conventionally, the null hypothesis is rejected at p-value threshold of 0.05 or less and the gene would be considered to have significant differential expression in two groups. Since differential expression analysis involves hypothesis testing for thousands of genes, the resulting p-values need to be adjusted (corrected) for multiple hypothesis testing. Most often Benjamin and Hochberg approach is used to adjust p-values resulting from differential expression analysis (Benjamini and Hochberg 1995). Then, genes with adjusted p-value 0.05 or less are considered differentially expressed. There is a great debate on whether 0.05 p-value cutoff should be used (Amrhein and Greenland 2018) and on p-value adjustment for multiple hypothesis testing (Colquhoun 2014; Perneger 1999). Sample sizes of the compared groups affect the generated p-values and hence conventional p-value cutoff may not be appropriate. To circumvent these problems, I proposed a method which estimates the false positive error rate at the specific p-value cutoff i.e. given a p-value threshold how many genes are expected to be falsely identified as differentially expressed. 

## Implementation

Let’s assume that we have a vector of unadjusted p-values assigned to genes from a differential expression analysis. These original p-values can be used to create a random dataset (control experiment) by shuffling their order in a vector. Technically, it is called a permutation resample and the technique is called permutation resampling (Chihara and Hesterberg 2018). The original p-value vector and the permutation resample can be used to compute how many genes are expected to be identified as differentially expressed by chance alone at a specific p-value threshold. Let’s assume that the p-value threshold is set to 0.05. I count how many genes have 0.05 or less p-values in the original p-value vector and consider them as true positives. Then, I count how many of these true positive genes assigned p-value 0.05 or less in a permutation resample. Since these genes are assigned p-values 0.05 or less even after randomization, I consider them false positives. The ratio of false positives to true positives represents the false positive error rates i.e. the number of genes that are expected to be differentially expressed by chance alone at 0.05 p-value cutoff. To get a robust estimate, permutation resampling is repeated 10000 times to create random datasets of original p-values. This gives rise to a 10000 false positive error rate at 0.05 p-value cutoff and forms a permutation distribution. The mean of the permutation distribution is used as a representative false positive error rate at 0.05 in detecting differentially expressed genes. In practice, false positive error rates are calculated at a series of p-value cutoffs. The p-value at which error rate is five percent or less would be a good threshold to select differentially expressed genes i.e. 95 percent confidence level. I have implemented this simulation-based permutation resampling technique in the R package referred to as *findPvalueCutoff*. The advantage with using **findPvalueCutoff** is that the p-value cutoff is predicted based on distribution of p-values itself by randomizing their order. This data-driven approach avoids using arbitrary cutoff of 0.05 p-value, and particularly useful when thousands of genes appear differentially expressed when sample sizes are large. In the subsequent text, the details are presented on how to compute false discovery rate at various p-value cutoff using **findPvalueCutoff** function, and selection of differentially expressed genes.


## Contact

For questions regarding **findPvalueCutoff**, contact the author at *vijay.muley\@gmail.com*

# INSTALLATION

Few R packages are required to install **findPvalueCutoff**.  These can be installed by executing following chunk of code in R. In principle, only **devtools** package is required to install **findPvalueCutoff**. But other packages build ready to use documentation about running and working with findPvalueCutoff. For Windows operating system, RTools software should be already installed. Windows users can download and install RTools from [here](https://cran.r-project.org/bin/windows/Rtools/). 


```r
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

Then, install **findPvalueCutoff** package from the github repository as shown below.


```r
devtools::install_github("vijaykumarmuley/findPvalueCutoff", build_vignettes = TRUE)

```

In case having trouble, you can run above command by setting build_vignettes to FALSE. 

Once install, load **findPvalueCutoff** into your workspace:



```r
library(findPvalueCutoff)
```

Note that this command must be run every time you restart R in order to be able to use the
package. To get immediate help on **findPvalueCutoff**, type:



```r
?findPvalueCutoff
```


















