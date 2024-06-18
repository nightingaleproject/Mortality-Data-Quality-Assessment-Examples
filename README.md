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

* An example synthetic data file ([NotionalDeathRecordData.csv](data/NotionalDeathRecordData.csv)), located in the [data](data) directory, containing synthetic mortality data representing the type of data that a jurisdiction should have available for quality assessment.

* Two data files containing ICD10 codes representing unsuitable causes of death and mechanism as cause of death:

  * The [unsuitable_COD_codes.csv](data/unsuitable_COD_codes.csv) file contains ICD10 codes that have been identified as unsuitable underlying causes of death.

  * The [mechanism_COD_codes.csv](data/mechanism_COD_codes.csv) file contains ICD10 codes that have been identified as mechanisms that are not appropriate to include in cause of death.

* Example python scripts to demonstrate calculation of various metrics for assessing mortality data quality:

  * [proportion_not_certified_within_required_time.py](code/proportion_not_certified_within_required_time.py) – Proportion of records with only one cause of death condition – multiple clinical conditions are typically reported by the medical certifier within Part I and Part II of the death certificate.

  * [proportion_with_incomplete_certifier.py](code/proportion_with_incomplete_certifier.py) – Proportion of records with at least one “medical certifier” field incomplete – the medical certifier is the medical professional or authorized person who determines the cause of death and manner of death.

  * [proportion_with_incomplete_demographic.py](code/proportion_with_incomplete_demographic.py) – Proportion of records with at least one demographic field incomplete – demographic fields include variables such as age, race/ethnicity, and occupation.

  * [proportion_with_incomplete_medical.py](code/proportion_with_incomplete_medical.py) – Proportion of records with at least one “other medical factors” field incomplete – other medical factors include variables such as tobacco use and pregnancy status.

  * [proportion_with_mechanism_as_underlying.py](code/proportion_with_mechanism_as_underlying.py) – Proportion of records with a mechanism as a cause of death – mechanisms of death (e.g., homicide) provide only the condition or fact of death and do not provide any information about the cause of death.

  * [proportion_with_one_cause.py](code/proportion_with_one_cause.py) – Proportion of records with only one cause of death condition – multiple clinical conditions are typically reported by the medical certifier within Part I and Part II of the death certificate.

  * [proportion_with_unsuitable_underlying.py](code/proportion_with_unsuitable_underlying.py) – Proportion of records with unsuitable underlying cause of death (UCOD) – unsuitable UCODs are those which are unknown and ill-defined; immediate and intermediate; and nonspecific. This code example also shows how the results can be displayed on a per-certifier basis.

  * [proportion_without_other_conditions.py](code/proportion_without_other_conditions.py) – Proportion of records without other significant conditions – part II of the death certificate contains medical conditions that contributed to the death but were not considered to be part of the chain of events that led to death.

Note that there is currently no example code to determine the proportion of records with an implausible sequence for cause of death.

## Requirements

Running this example code requires

* Python 3.6 or higher
* The pandas library

You can install pandas with pip:

```
pip install pandas
```

## Usage

Running the example code can be done by invoking each script with python, e.g.:

```
> cd code
> python proportion_with_unsuitable_underlying.py   
The proportion of records with an unsuitable underlying cause of death is 0.20
```

The examples have an embedded reference to the sample mortality data file. The code is not intended to be run directly in a jurisdiction environment since each jurisdiction may organize data differently, but rather is intended to serve as examples that can be adapted as needed or simply serve as reference materials when developing systems to measure quality metrics.

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
