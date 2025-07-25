% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proportion_with_unsuitable_underlying.R
\name{certifier_proportion_with_unsuitable_underlying}
\alias{certifier_proportion_with_unsuitable_underlying}
\title{Calculate proportion of records with unsuitable underlying causes of death by certifier}
\usage{
certifier_proportion_with_unsuitable_underlying(
  death_records,
  underlying_cause_of_death_column,
  certifier_name_column
)
}
\arguments{
\item{death_records}{death records dataframe with rows corresponding to
records and columns corresponding to record attributes}

\item{underlying_cause_of_death_column}{string, underlying cause of death column in death_records}

\item{certifier_name_column}{string, certifier name column in death_records}
}
\value{
dataframe with one column corresponding to the unique certifiers by name and another column corresponding to the proportions of records with unsuitable underlying causes of death
}
\description{
Calculate proportion of records with unsuitable underlying causes of death by certifier
}
\examples{
certifier_prop <- certifier_proportion_with_unsuitable_underlying(
  synthetic_death_records,
  underlying_cause_of_death_column = "Underlying COD",
  certifier_name_column = "Certifier Name"
)

}
