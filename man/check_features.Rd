% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check-family-adjusting.R
\name{check_features}
\alias{check_features}
\title{Check feature variables input}
\usage{
check_features(
  object,
  features,
  valid_classes = NULL,
  max_length = NULL,
  of_sample = NA
)
}
\arguments{
\item{object}{A valid spata-object.}

\item{features}{The features of interest specified as a character vector.}

\item{valid_classes}{The feature-classes that are allowed.}

\item{max_length}{The maximum number of features allowed.}
}
\value{
The original input, an adjusted version of it or an error. In the latter two
cases they print an informative message about what was going on.
}
\description{
A member of the \code{adjusting-check_*()}-family. Takes a character
vector of feature names, checks which of the features exist and checks additionally
if these features match the class requirements of \code{valid_classes}.

Returns an adjusted features-vector or raises an error.
}
\details{
Members of the \code{adjusting-check_*()}-family take their
arguments input and compare it to a variety of requirement settings by
running several logical tests. If the input turns out to be appropriate
for the main-function they return it the way it is supposed to be returned.
If not, depending on the degree of deviation from the optimum, they either adjust
the input in order not to interrupt the function or - if not adjustable - raise an
error. In both cases informative messages will be printed in order to let the user
know what has been adjusted or what part of the input was insufficient.
}
