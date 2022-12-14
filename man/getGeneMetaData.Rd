% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-family.R
\name{getGeneMetaData}
\alias{getGeneMetaData}
\alias{getGeneMetaDf}
\title{Obtain gene meta data}
\usage{
getGeneMetaData(object, mtr_name = NULL, only_df = FALSE, of_sample = NA)

getGeneMetaDf(object, mtr_name = NULL, of_sample = NA)
}
\arguments{
\item{object}{A valid spata-object.}

\item{mtr_name}{Character value. The name of the expression matrix of interest. If set to NULL
the currently active matrix is chosen.}

\item{only_df}{Logical. If set to TRUE only the data.frame is returned.
If set to FALSE (the default) the whole list is returned.}

\item{of_sample}{This argument is currently inactive. It might be reactivated when
spata-objects can store more than one sample.}
}
\value{
A data.frame from \code{getMetaDataDf()} or a list from \code{getGeneMetaData()}.
}
\description{
Obtain gene meta data
}
