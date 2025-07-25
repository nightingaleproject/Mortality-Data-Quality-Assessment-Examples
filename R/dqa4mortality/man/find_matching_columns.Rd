% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proportion_with_incomplete_demographic.R
\name{find_matching_columns}
\alias{find_matching_columns}
\title{Find the columns in death records dataframe that match the input field}
\usage{
find_matching_columns(death_records, field)
}
\arguments{
\item{death_records}{death records dataframe with rows corresponding to
records and columns corresponding to record attributes}

\item{field}{string, field we are looking to match in death_records. If string ends with ".\*", matches fields that start with all characters preceding it. For example, "Race .\*" will search for all fields starting with "Race ".}
}
\value{
character vector of column name(s) matching field in death_records
}
\description{
Find the columns in death records dataframe that match the input field
}
\keyword{internal}
