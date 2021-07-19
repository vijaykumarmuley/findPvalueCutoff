# Introduction

Cells respond to external and internal signals by controlling expression
of specific genes that process the signals and generate adaptive
responses (Muley and Pathania 2017). Several experimental techniques
have been developed to quantify expression of genes at genome scale.
This process is often referred to as gene expression profiling or
transcriptomics (Pathania and Muley 2017). The common theme of such
experiments is to obtain gene expression profiles from control (normal)
samples and experimental samples with specific treatment or from
diseased individuals in replicates (Law et al. 2016). Then, the
expression of each gene is compared between experimental and normal
samples. Genes with significant expression changes in the experimental
group compared to normal are more likely to be responsible for the
phenotypic differences between the groups. These genes are referred to
as differentially expressed genes. Such analyses are also commonly used
in studying developmental time points to understand which genes are
required for specific developmental time points (Muley et al. 2020).

## Differential gene expression analysis

Several statistical tools have been developed to perform differential
expression analysis (Rapaport et al. 2013; Robinson and Oshlack 2010;
Soneson and Delorenzi 2013). These tools typically perform hypothesis
significance testing under a null hypothesis that the gene has no
differential expression in the compared group and assign a test p-value
to a gene. The p-value is the probability of obtaining test results as
extreme as the results observed when the null hypothesis is correct. A
very small p-value means that such an extreme observed outcome would be
very unlikely under the null hypothesis, and hence the gene has
different expression in compared groups. Conventionally, the null
hypothesis is rejected at p-value threshold of 0.05 or less and the gene
would be considered to have significant differential expression in two
groups. Since differential expression analysis involves hypothesis
testing for thousands of genes, the resulting p-values need to be
adjusted (corrected) for multiple hypothesis testing. Most often
Benjamin and Hochberg approach is used to adjust p-values resulting from
differential expression analysis (Benjamini and Hochberg 1995). Then,
genes with adjusted p-value 0.05 or less are considered differentially
expressed. There is a great debate on whether 0.05 p-value cutoff should
be used (Amrhein and Greenland 2018) and on p-value adjustment for
multiple hypothesis testing (Colquhoun 2014; Perneger 1999). Sample
sizes of the compared groups affect the generated p-values and hence
conventional p-value cutoff may not be appropriate. To circumvent these
problems, I proposed a method which estimates the false positive error
rate at the specific p-value cutoff i.e. given a p-value threshold how
many genes are expected to be falsely identified as differentially
expressed.

## Implementation

Let’s assume that we have a vector of unadjusted p-values assigned to
genes from a differential expression analysis. These original p-values
can be used to create a random dataset (control experiment) by shuffling
their order in a vector. Technically, it is called a permutation
resample and the technique is called permutation resampling (Chihara and
Hesterberg 2018). The original p-value vector and the permutation
resample can be used to compute how many genes are expected to be
identified as differentially expressed by chance alone at a specific
p-value threshold. Let’s assume that the p-value threshold is set to
0.05. I count how many genes have 0.05 or less p-values in the original
p-value vector and consider them as true positives. Then, I count how
many of these true positive genes assigned p-value 0.05 or less in a
permutation resample. Since these genes are assigned p-values 0.05 or
less even after randomization, I consider them false positives. The
ratio of false positives to true positives represents the false positive
error rates i.e. the number of genes that are expected to be
differentially expressed by chance alone at 0.05 p-value cutoff. To get
a robust estimate, permutation resampling is repeated 10000 times to
create random datasets of original p-values. This gives rise to a 10000
false positive error rate at 0.05 p-value cutoff and forms a permutation
distribution. The mean of the permutation distribution is used as a
representative false positive error rate at 0.05 in detecting
differentially expressed genes. In practice, false positive error rates
are calculated at a series of p-value cutoffs. The p-value at which
error rate is five percent or less would be a good threshold to select
differentially expressed genes i.e. 95 percent confidence level. I have
implemented this simulation-based permutation resampling technique in
the R package referred to as *findPvalueCutoff*. The advantage with
using **findPvalueCutoff** is that the p-value cutoff is predicted based
on distribution of p-values itself by randomizing their order. This
data-driven approach avoids using arbitrary cutoff of 0.05 p-value, and
particularly useful when thousands of genes appear differentially
expressed when sample sizes are large. In the subsequent text, the
details are presented on how to compute false discovery rate at various
p-value cutoff using **findPvalueCutoff** function, and selection of
differentially expressed genes.

## Contact

For questions regarding **findPvalueCutoff**, contact the author at
*vijay.muley@gmail.com*

# INSTALLATION

Few R packages are required to install **findPvalueCutoff**. These can
be installed by executing following chunk of code in R. In principle,
only **devtools** package is required to install **findPvalueCutoff**.
But other packages build ready to use documentation about running and
working with findPvalueCutoff. For Windows operating system, RTools
software should be already installed. Windows users can download and
install RTools from
[here](https://cran.r-project.org/bin/windows/Rtools/).

``` r
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

Then, install **findPvalueCutoff** package from the github repository as
shown below.

``` r
devtools::install_github("vijaykumarmuley/findPvalueCutoff", build_vignettes = TRUE)
```

In case having trouble, you can run above command by setting
build_vignettes to FALSE.

Once install, load **findPvalueCutoff** into your workspace:

``` r
library(findPvalueCutoff)
```

Note that this command must be run every time you restart R in order to
be able to use the package. To get immediate help on
**findPvalueCutoff**, type:

``` r
?findPvalueCutoff
```

**findPvalueCutoff** function needs a vector of uncorrected p-values
resulting from differential gene expression analysis tools. Some
parameters need to be adjusted and details are given below.

# Estimating false positive rates at various p-value cutoffs

I will use example data of differential expression provided with the
package, which was obtained from my previous published work (Muley et
al. 2020). It contains output typically generated by differential gene
expression analysis tools such as limma, edgeR or DESeq (Rapaport et
al. 2013; Soneson and Delorenzi 2013). The following command will load
the data which is a data.frame named pvalue.

``` r
data(pvalue)
```

To check first few lines of the data, you can type following commands

``` r
head(pvalue)
#>                       logFC  AveExpr        t      P.Value    adj.P.Val
#> ENSMUSG00000032446 4.512662 5.119289 30.38802 4.581155e-12 5.349873e-08
#> ENSMUSG00000010505 3.760632 5.272638 27.08535 1.623325e-11 9.478597e-08
#> ENSMUSG00000041911 2.984226 4.981805 23.49275 7.717584e-11 3.004198e-07
#> ENSMUSG00000036306 2.501910 5.373344 19.93014 4.629336e-10 9.809627e-07
#> ENSMUSG00000033740 5.002689 3.895736 20.09526 4.232737e-10 9.809627e-07
#> ENSMUSG00000022053 3.993880 3.656121 19.77461 5.040055e-10 9.809627e-07
#>                           B  gene                                    genename
#> ENSMUSG00000032446 17.81065 Eomes                                eomesodermin
#> ENSMUSG00000010505 16.85906  Myt1               myelin transcription factor 1
#> ENSMUSG00000041911 15.42690  Dlx1                      distal-less homeobox 1
#> ENSMUSG00000036306 13.74247 Lzts1 leucine zipper, putative tumor suppressor 1
#> ENSMUSG00000033740 13.49772  St18            suppression of tumorigenicity 18
#> ENSMUSG00000022053 13.38696  Ebf2                       early B cell factor 2
```

There are two ways to run **findPvalueCutoff**. 1) use a vector of
predefined p-value cutoffs (manually selected set) or 2) set a lower and
upper range and choose an interval so that this function generates a
series of p-value cutoffs from lower to upper bound by incrementing
lower bound with desired number that provided using interval parameter.
I demonstrated both ways with example data below.

## Using predefined p-value thresholds

**findPvalueCutoff** function generates random samples of the input
p-values. Hence, the output would be a little bit different with each
run on the same data. Therefore, I first set a seed to a random number
using the set.seed function to reproduce the same results. Then I run
**findPvalueCutoff** by setting up:

1.  x paramater to differential expression values from the column
    *P.Value* in the pvalue data.frame,
2.  thresholds parameter to manually selected p-value cutoffs at which I
    would like to compute false positive rates,
3.  nsims parameter to 100 to create 100 randomized datasets from the
    given p-values

In practice, I recommend setting nsims value to at least 1000, and best
would be to set 10000 for accurate results.

After setting these parameters, I run **findPvalueCutoff** function and
store its output in fdr object.

``` r
set.seed(1979)
fdr <- findPvalueCutoff(x = pvalue$P.Value, thresholds = c(0.0001, 0.001, 0.01, 0.1, 0.15, 0.2), nsims = 100)
```

As shown below the fdr object is a numeric vector containing false
positive rates in percentages computed at a given series of p-value
cutoffs, which are names of the elements in the fdr object. For
instance, approximately 5 percent of the differentially expressed genes
are likely to be falsely detected by chance alone at the p-value cutoff
of 0.001 i.e. 95% confidence level would be achieved in detecting
differentially expressed genes if applied to the 0.001 p-value cutoff.

``` r
fdr
#>     1e-04     0.001      0.01       0.1      0.15       0.2 
#>  2.563427  4.957118  9.096970 18.373228 21.323553 23.694279
```

Let’s compare how many genes are differentially expressed using
conventional cutoff of 0.05 after adjusted p-values, and the 0.001
cutoff on unadjusted p-values suggested by **findPvalueCutoff**
function.

``` r
sum(pvalue$adj.P.Val<=0.05)
#> [1] 2087
sum(pvalue$P.Value<=0.001)
#> [1] 1166
```

As shown above, 2087 genes were identified as differentially expressed
using conventional p-value cutoff, while only 1166 genes are
differentially expressed according to p-value cutoff estimated by
**findPvalueCutoff** function. The expected detection error rate at this
cutoff is close to five percent of the total identified genes.

These results can be plotted as follows and can be saved for later use.

``` r
barplot(fdr, names = names(fdr), col =  "black", border = "white", xlab = "P-value cutoff", ylab = "False Positive Rate (in percent)")
```

![False positive error rates predicted from random datasets according to
the uncorrected differential expression p-values. The false positive
error rate represents the ratio of the number of significant p-values
from the randomized dataset (control experiment) to the number of
significant p-values from the real dataset below a certain p-value.
False positive error rate is close to 5 percent at p-value cutoff of
0.001.](vignette_files/figure-markdown_github/unnamed-chunk-10-1.png)

The plot shows the false positive rate is close to five at 0.001 p-value
cutoff. This should be used for selecting differentially expressed
genes.

## Using a range of p-values at specific interval

**findPvalueCutoff** provide two more parameters to quickly get an idea
about false positive rates at a series of p-value cutoffs. This can be
done by running with following parameters.

1.  x paramater to differential expression values from the column
    *P.Value* in the pvalue data.frame,
2.  range parameter to provide a lower and upper bound of the p-values,
3.  interval parameter to a number to increment lower bound of the
    p-value progressively until upper bound provided with range
    parameter,
4.  nsims parameter to 100 to create 100 randomized datasets from the
    given p-values

In this example, I set range between 0 to 0.2 with interval 0.02, and
execute the function as shown below,

``` r
set.seed(1979)
fdr <- findPvalueCutoff(x = pvalue$P.Value, range = c(0, 0.2), interval = 0.02, nsims = 100)
```

These results can be plotted as follow

``` r
barplot(fdr, names = names(fdr), col =  "black", border = "white", xlab = "P-value cutoff", ylab = "False Positive Rate (in percent)")
```

![False positive error rates predicted from random datasets according to
the uncorrected differential expression p-values. The false positive
error rate represents the ratio of the number of significant p-values
from the randomized dataset (control experiment) to the number of
significant p-values from the real dataset below a certain p-value. This
plot gives an idea that false positive error rate is five percent or
less between p-values 0 to 0.02. One can now use p-values between this
range to get more finer false positive rate and corresponding p-value
cutoff.](vignette_files/figure-markdown_github/unnamed-chunk-12-1.png)

Plot shows that a false positive rate of 5 is estimated between the
range of 0 and 0.02 p-value cutoffs. This range can be used to get a
finer false positive rate and the corresponding p-values.

# References

Amrhein, Valentin, and Sander Greenland. 2018. “Remove, Rather than
Redefine, Statistical Significance.” Nature Human Behaviour 2 (1): 4.
<https://doi.org/10.1038/s41562-017-0224-0>.

Benjamini, Yoav, and Yosef Hochberg. 1995. “Controlling the False
Discovery Rate: A Practical and Powerful Approach to Multiple Testing.”
Journal of the Royal Statistical Society: Series B (Methodological) 57
(1): 289–300. <https://doi.org/10.1111/j.2517-6161.1995.tb02031.x>.

Chihara, Laura M., and Tim C. Hesterberg. 2018. Mathematical Statistics
with Resampling and R. Mathematical Statistics with Resampling and R.
Hoboken, NJ, USA: John Wiley & Sons,
Inc. <https://doi.org/10.1002/9781119505969>.

Colquhoun, David. 2014. “An Investigation of the False Discovery Rate
and the Misinterpretation of P-Values.” Royal Society Open Science 1
(3): 140216. <https://doi.org/10.1098/rsos.140216>.

Law, Charity W., Monther Alhamdoosh, Shian Su, Gordon K. Smyth, and
Matthew E. Ritchie. 2016. “RNA-Seq Analysis Is Easy as 1-2-3 with Limma,
Glimma and EdgeR.” F1000Research 5 (November): 1408.
<https://doi.org/10.12688/f1000research.9005.2>.

Muley, Vijaykumar Yogesh, Carlos Javier López-Victorio, Jorge Tonatiuh
Ayala-Sumuano, Adriana González-Gallardo, Leopoldo González-Santos,
Carlos Lozano-Flores, Gregory Wray, Maribel Hernández-Rosales, and
Alfredo Varela-Echavarría. 2020. “Conserved and Divergent Expression
Dynamics during Early Patterning of the Telencephalon in Mouse and Chick
Embryos.” Progress in Neurobiology 186 (March).
<https://doi.org/10.1016/j.pneurobio.2019.101735>.

Muley, Vijaykumar Yogesh, and Amit Pathania. 2017. “Gene Expression.”
In: Vonk J., Shackelford T. (Eds) Encyclopedia of Animal Cognition and
Behavior. Springer, Cham.
<https://doi.org/10.1007/978-3-319-47829-6_49-2>.

Pathania, Amit, and Vijaykumar Yogesh Muley. 2017. “Gene Expression
Profiling.” In: Vonk J., Shackelford T. (Eds) Encyclopedia of Animal
Cognition and Behavior. Springer, Cham.
<https://doi.org/10.1007/978-3-319-47829-6_9-1>.

Perneger, Thomas V. 1999. “Adjusting for Multiple Testing in Studies Is
Less Important than Other Concerns.” BMJ 318 (7193): 1288–1288.
<https://doi.org/10.1136/bmj.318.7193.1288a>.

Rapaport, Franck, Raya Khanin, Yupu Liang, Mono Pirun, Azra Krek, Paul
Zumbo, Christopher E Mason, Nicholas D Socci, and Doron Betel. 2013.
“Comprehensive Evaluation of Differential Gene Expression Analysis
Methods for RNA-Seq Data.” Genome Biology 14 (9): 3158.
<https://doi.org/10.1186/gb-2013-14-9-r95>.

Robinson, Mark D, and Alicia Oshlack. 2010. “A Scaling Normalization
Method for Differential Expression Analysis of RNA-Seq Data.” Genome
Biology 11 (3): R25. <https://doi.org/10.1186/gb-2010-11-3-r25>.

Soneson, Charlotte, and Mauro Delorenzi. 2013. “A Comparison of Methods
for Differential Expression Analysis of RNA-Seq Data.” BMC
Bioinformatics 14 (1): 91. <https://doi.org/10.1186/1471-2105-14-91>.

``` r
sessionInfo()
#> R version 4.0.3 (2020-10-10)
#> Platform: x86_64-apple-darwin17.0 (64-bit)
#> Running under: macOS Big Sur 10.16
#> 
#> Matrix products: default
#> BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
#> LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
#> 
#> locale:
#> [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] findPvalueCutoff_0.1.0
#> 
#> loaded via a namespace (and not attached):
#>  [1] compiler_4.0.3    magrittr_2.0.1    tools_4.0.3       htmltools_0.5.1.1
#>  [5] yaml_2.2.1        stringi_1.6.2     rmarkdown_2.8     highr_0.9        
#>  [9] knitr_1.33        stringr_1.4.0     xfun_0.23         digest_0.6.27    
#> [13] rlang_0.4.11      evaluate_0.14
```