% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proportion_with_one_cause.R
\name{proportion_with_one_cause}
\alias{proportion_with_one_cause}
\title{Calculate proportion of records with one cause of death}
\usage{
proportion_with_one_cause(death_records, cause_of_death_columns)
}
\arguments{
\item{death_records}{death records dataframe with rows corresponding to
records and columns corresponding to record attributes}

\item{cause_of_death_columns}{character vector, cause of death columns in death_records}
}
\value{
number, proportion of records with one cause of death
}
\description{
Calculate proportion of records with one cause of death
}
\examples{
prop <- proportion_with_one_cause(
  synthetic_death_records,
  # in synthetic data, many columns matching "Record Axis COD" represent the causes of death
  cause_of_death_columns = c(
    colnames(synthetic_death_records)[
      startsWith(colnames(synthetic_death_records), "Record Axis COD")
    ]
  )
)

}
