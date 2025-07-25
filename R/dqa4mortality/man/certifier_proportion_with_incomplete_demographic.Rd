% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/proportion_with_incomplete_demographic.R
\name{certifier_proportion_with_incomplete_demographic}
\alias{certifier_proportion_with_incomplete_demographic}
\title{Calculate proportion of records with incomplete demographic fields by certifier}
\usage{
certifier_proportion_with_incomplete_demographic(
  death_records,
  demographic_fields = c("Age", "County of Death", "Date of Death", "Education",
    "Hispanic .*", "Manner of Death", "Place of Death", "Pregnancy Status", "Race .*",
    "Tobacco Use Contributed to Death"),
  unknown_responses = c(),
  sex_column = "Sex",
  pregnancy_column = "Pregnancy Status",
  age_column = "Age",
  age_pregnancy_low = 5,
  age_pregnancy_high = 75,
  marital_status_column = NULL,
  age_marital_low = 12,
  occupation_column = NULL,
  age_occupation_low = 14,
  industry_column = NULL,
  age_industry_low = 14,
  armed_forces_column = NULL,
  age_armed_low = 14,
  certifier_name_column,
  number_certifier_proportions = 3
)
}
\arguments{
\item{death_records}{death records dataframe with rows corresponding to
records and columns corresponding to record attributes}

\item{demographic_fields}{character vector of column strings in death_records for fields related to demographics. If string ends with ".\*", matches fields that start with all characters preceding it. For example, "Race .\*" will search for all fields starting with "Race ". Default to vector of demographic fields in standard death certificate.}

\item{unknown_responses}{character vector of strings corresponding to "unknown" in funeral director fields. Default to empty vector.}

\item{sex_column}{string, sex column in death_records}

\item{pregnancy_column}{string, pregnancy column in death_records}

\item{age_column}{string, age column in death_records}

\item{age_pregnancy_low}{number, low cutoff for pregnancy age}

\item{age_pregnancy_high}{number, high cutoff for pregnancy age}

\item{marital_status_column}{string, marital status column in death_records. NULL if not in death_records.}

\item{age_marital_low}{number, low cutoff for marital status age}

\item{occupation_column}{string, occupation column in death_records. NULL if not in death_records.}

\item{age_occupation_low}{number, low cutoff for occupation age}

\item{industry_column}{string, industry column in death_records. NULL if not in death_records.}

\item{age_industry_low}{number, low cutoff for industry age}

\item{armed_forces_column}{string, armed forces column in death_records. NULL if not in death_records.}

\item{age_armed_low}{number, low cutoff for armed forces age}

\item{certifier_name_column}{string, certifier name column in death_records}

\item{number_certifier_proportions}{number of certifier proportions to display. Default 3.}
}
\value{
data frame with 4 columns:
   Column Name: demographic fields
   Certifier Name: certifier name
   Proportion Blank: proportion missing for a given demographic field and certifier name
   Proportion Unknown: proportion unknown for a given demographic field and certifier name
}
\description{
Calculate proportion of records with incomplete demographic fields by certifier
}
\examples{
certifier_prop <- certifier_proportion_with_incomplete_demographic(
  synthetic_death_records,
  demographic_fields = c(
    "Age",
    "County of Death",
    "Date of Death",
    "Education",
    "Hispanic .*", #' Match any field starting with 'Hispanic'
    "Manner of Death",
    "Place of Death",
    "Pregnancy Status",
    "Race .*", #' Match any field starting with 'Race'
    "Tobacco Use Contributed to Death"
  ),
  unknown_responses = c("Unknown", "UNK"),
  sex_column = "Sex",
  pregnancy_column = "Pregnancy Status",
  age_column = "Age",
  age_pregnancy_low = 5,
  age_pregnancy_high = 74,
  marital_status_column = NULL,
  age_marital_low = 10,
  occupation_column = NULL,
  age_occupation_low = 14,
  industry_column = NULL,
  age_industry_low = 14,
  armed_forces_column = NULL,
  age_armed_low = 14,
  certifier_name_column = "Certifier Name",
  number_certifier_proportions = 3
)


}
