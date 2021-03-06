% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_cleaner.R
\name{data_cleaner}
\alias{data_cleaner}
\title{Cleans data}
\usage{
data_cleaner(PCD)
}
\arguments{
\item{PCD}{Protezione Civile dataset}
}
\value{
the cleaned dataset
}
\description{
Introduces NAs when data is biased, e.g. when cumulative counts are decreasing.
}
\examples{
\dontrun{
sicily <- get_regionTS()$Sicilia
sicily_cl <- data_cleaner(sicily)
}
}
