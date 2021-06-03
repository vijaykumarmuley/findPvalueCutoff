#' @title Estimates false positive rate at a series of p-value cutoffs
#'
#' @description Given a p-value vector, it estimates number of rejected null hypothesis at a series of p-value cutoffs
#'
#' @param x A vector of p-values.
#' @param thresholds A vector of manually selected p-value cutoffs at which false positive rate needs to be estimated.
#' @param range Limit of lower and upper p-value cutoffs within which false positive rate will be estimated. Default when thresholds parameter is NULL.
#' @param interval Interval used to generate a series of p-values within lower and upper bound given in range porameter.
#' @param nsims Number of simulated (randomized) datasets. Default is 1000 but at least 10000 datasets are recommended.
#' @export findPvalueCutoff
#' @return A named (p-value cutoffs) vector with estimated false positive rate.
#' @examples \dontrun{
#' findPvalueCutoff(x = pval, thresholds=c(0.0001, 0.001, 0.01, 0.1, 0.2), nsims = 1000)
#' findPvalueCutoff(x = pval, range= c(0,2), interval= 0.01, nsims = 1000)
#' }

findPvalueCutoff <- function(x = NULL, thresholds=NULL, range = c(0,1), interval = 0.05, nsims = 1000){

    if(!is.numeric(x)){
        cat("P-value should be numeric vector\n")
        return()
    }

    if(is.null(thresholds)){
        alpha <- seq(range[1], range[2], interval)
    }

    if(!is.null(thresholds)){
        alpha <- thresholds
    }

    results <- sapply(1:nsims, function(n) sapply(alpha, function(z) sum(sample(x)[x<=z]<x[x<=z])))

    observed <- sapply(alpha, function(j) sum(x<=j))

    fdr <- results/observed

    rownames(fdr) <- alpha
    colnames(fdr) <- 1:nsims
    fdr <- t(fdr)
    fdr[is.na(fdr)] <- 0
    fdr[is.nan(fdr)] <- 0
    colMeans(fdr)
}
