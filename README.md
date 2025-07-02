# Mortality Data Quality Assessment Framework Example Code

The National Vital Statistics System (NVSS) is managed by the U.S. Centers for Disease Control and
Prevention and is the system of record for all vital events (e.g., births, deaths) in the United
States. This system, for example, is used to manage approximately 2.8 million death records annually
and was constructed to ensure accurate and timely data availability (NCHS 2024). Death certificate
data, however, have at times been found to incomplete, inaccurate, and untimely, affecting the
utility of the death certificate data
([Flagg 2021](https://stacks.cdc.gov/view/cdc/100414)).
To address some of these challenges, over the
last decade, 54 of 57 jurisdictions implemented an electronic death reporting system (EDRS). These
EDRSs allow for electronic capture of data, thus gaining efficiency in data sharing and reporting.

Although the use of EDRSs, especially with embedded edit check tools (e.g.,
[Validations and Interactive Edits Web Service](https://www.cdc.gov/nchs/data/nvss/modernization/VIEWS-Technical-User-Info-508.pdf)),
has improved data quality,
[challenges persist (Flagg 2021)](https://stacks.cdc.gov/view/cdc/100414).
Comprehensive, monitoring of data quality over time is essential to identify gaps and identify
opportunities to improve data quality.

This library of simple code examples complements the recently developed Data Quality Assessment
Framework and complementary Jurisdictional Playbook for Implementation of Mortality Data Quality
Assessment Framework.

## Overview

This code repository contains

* [python](python): A set of Python scripts and Jupyter notebooks to demonstrate calculation of several metrics for assessing mortality data quality, as seen in the Data Quality Assessment Framework. Contains information on installation and usage of scripts.

* [dqa4mortality](dqa4mortality): An R package to calculate metrics for assessing mortality data quality, as seen in the Data Quality Assessment Framework. Contains information on installation and usage.

* An example synthetic data file ([SyntheticDeathRecordData.csv](data/SyntheticDeathRecordData.csv)), located in the [data](data) directory, containing synthetic mortality data representing the type of data that a jurisdiction should have available for quality assessment.

* A data file ([unsuitable_COD_codes.csv](data/unsuitable_COD_codes.csv)), located in the [data](data) directory, containing ICD10 codes that have been identified as unsuitable underlying causes of death as listed in ([Flagg 2021](https://stacks.cdc.gov/view/cdc/100414)).

    * Note that the file contains both specific four digit ICD-10 codes, which don't include the decimal point (e.g., I959, referring to "Hypotension, unspecified") and three digit ICD-10 codes for broader categories, e.g., J18, referring to "Pneumonia, organism unspecified".

    * Three digit codes imply the inclusion of all related four digit codes, e.g., J18, referring to "Pneumonia, organism unspecified", also implicitly means the inclusion of J180, referring to "Bronchopneumonia, unspecified", J181, referring to "Lobar pneumonia, unspecified", etc.

    * Software that tests for matches to the list of unsuitable underlying causes of death should simply test if the underlying code in a record begins with an unsuitable code from the data file, e.g., J189 appearing as the underlying code in a record should match against J18 from the list of unsuitable codes since J189 begins with J18.

## Data Requirements

Data used for metric calculation should have a format where each row corresponds to one death record and each column corresponds to an attribute for the death record, such as "Date Certified" or "Underlying Cause of Death". ICD codes included in the data should not include periods (".").

For an example of data in the correct format, please see [SyntheticDeathRecordData.csv](data/SyntheticDeathRecordData.csv).

## Disclosure

Artificial Intelligence (AI) software was consulted in the development of this code and to ensure that R and Python versions of the code run identically.

## License

Copyright 2024 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

### Contact Information

For questions or comments about this code repository please send email to

    nvssmodernization@cdc.gov
