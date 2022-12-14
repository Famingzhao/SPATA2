% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cnv-analysis.R
\name{setCnvResults}
\alias{setCnvResults}
\title{Set cnv-results}
\usage{
setCnvResults(object, cnv_list, of_sample = NA)
}
\arguments{
\item{object}{A valid spata-object.}

\item{cnv_list}{The list containing the results from \code{runCnvAnalysis()}.}

\item{of_sample}{This argument is currently inactive. It might be reactivated when
spata-objects can store more than one sample.}
}
\value{
An updated spata-object.
}
\description{
Set cnv-results
}
\details{
All \code{set*()}-functions offer a save way to set certain
slots of your spata-object. They do check the input for validity but
effectively overwrite everything that is occupying the slot to be set -
use with caution.
}
