# Datasets included in dqa4mortality

#' Synthetic Death Records
#'
#' An example of data used for metric calculation, which should have a format where each row corresponds to one death record and each column corresponds to an attribute for the death record, such as "Date Certified" or "Underlying Cause of Death". ICD codes included in the data should not include periods (".").
#'
"synthetic_death_records"

#' Unsuitable Cause of Death Codes
#'
#' A data file (unsuitable_COD_codes.csv), located in the data directory, containing ICD10 codes that have been identified as unsuitable underlying causes of death as listed in (Flagg 2021).
#'
#' Note that the file contains both specific four digit ICD-10 codes, which don't include the decimal point (e.g., I959, referring to "Hypotension, unspecified") and three digit ICD-10 codes for broader categories, e.g., J18, referring to "Pneumonia, organism unspecified".
#'
#' Three digit codes imply the inclusion of all related four digit codes, e.g., J18, referring to "Pneumonia, organism unspecified", also implicitly means the inclusion of J180, referring to "Bronchopneumonia, unspecified", J181, referring to "Lobar pneumonia, unspecified", etc.
#'
#' @source Flagg, 2021 (https://stacks.cdc.gov/view/cdc/100414).
#'
"unsuitable_COD_codes"
