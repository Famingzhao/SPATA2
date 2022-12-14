% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add-family.R
\name{discardExpressionMatrix}
\alias{discardExpressionMatrix}
\title{Discard an expression matrix}
\usage{
discardExpressionMatrix(object, mtr_name, of_sample = NA)
}
\arguments{
\item{object}{A valid spata-object.}

\item{mtr_name}{Character value. The name of the expression matrix of interest. If set to NULL
the currently active matrix is chosen.}

\item{of_sample}{This argument is currently inactive. It might be reactivated when
spata-objects can store more than one sample.}
}
\value{
An updated spata-object.
}
\description{
Discards the expression matrix of choice.
}
