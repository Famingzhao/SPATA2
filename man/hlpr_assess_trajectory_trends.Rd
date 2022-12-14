% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trajectory-analysis.R
\name{hlpr_assess_trajectory_trends}
\alias{hlpr_assess_trajectory_trends}
\alias{hlpr_assess_trajectory_trends_customized}
\title{Assess trajectory ranking.}
\usage{
hlpr_assess_trajectory_trends(rtdf, verbose = TRUE)

hlpr_assess_trajectory_trends_customized(rtdf, verbose = TRUE)
}
\arguments{
\item{rtdf}{A ranked trajectory data.frame.}

\item{pattern}{The pattern(s) you are interested in specified as a character
vector. If set to NULL all patterns are included.}

\item{max_auc}{Numeric value. The maximum area-under-the-curve-value allowed.}

\item{names_only}{Logical. If set to TRUE only the names of the assessed ranking
are returned as a character vector. (Convenient to use as input for functions
taking gene set- or gene vectors as input.)}
}
\value{
A data.frame arranged by the residuals area-under-the-curve-values describing
how well a model fitted the expression trend of a gene or gene set.
}
\description{
Takes a ranked trajectory data.frame and returns a data.frame
that informs about how well the ranked gene- or gene set expression-trends
fitted certain patterns.
}
