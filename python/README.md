# Mortality Data Quality Assessment Framework Example Code: Python

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

This library of simple Python code examples complements the recently developed Data Quality Assessment
Framework and complementary Jurisdictional Playbook for Implementation of Mortality Data Quality
Assessment Framework.

All code in this section of the repository is intended for Python users. If you prefer to use R, please see [R/dqa4mortality](../R/dqa4mortality).

## Overview

This folder contains:

* A Jupyter Notebook ([MortalityDataQualityAssessment.ipynb](jupyter/MortalityDataQualityAssessment.ipynb)) that demonstrates calculation of several metrics for assessing mortality data quality.

* Example python scripts in [dqa4mortality](dqa4mortality) to demonstrate calculation of various metrics for assessing mortality data quality:

  * [proportion_not_certified_within_required_period.py](dqa4mortality/proportion_not_certified_within_required_period.py) – Proportion of records that were not certified within the expected time – jurisdictions typically specify how quickly a death should be certified after the actual date of death.

  * [proportion_with_incomplete_funeral_director_fields.py](dqa4mortality/proportion_with_incomplete_funeral_director_fields.py) – Proportion of records with at least one “funeral director” field incomplete – funeral directors are typically responsible for providing identifying information and some demographic information.

  * [proportion_with_incomplete_medical_certifier_fields.py](dqa4mortality/proportion_with_incomplete_medical_certifier_fields.py) – Proportion of records with at least one “medical certifier” field incomplete – the medical certifier is the medical professional or authorized person who determines the cause of death and manner of death.

  * [proportion_with_incomplete_demographic.py](dqa4mortality/proportion_with_incomplete_demographic.py) – Proportion of records with incomplete information for any of several demographic fields – demographic fields include variables such as age, race/ethnicity, and occupation.

  * [proportion_with_one_cause.py](dqa4mortality/proportion_with_one_cause.py) – Proportion of records with only one cause of death condition – multiple clinical conditions are typically reported by the medical certifier within Part I and Part II of the death certificate.

  * [proportion_with_unsuitable_underlying.py](dqa4mortality/proportion_with_unsuitable_underlying.py) – Proportion of records with unsuitable underlying cause of death (UCOD) – unsuitable UCODs are those which are unknown and ill-defined; immediate and intermediate; and nonspecific. This code example also shows how the results can be displayed on a per-certifier basis.

Note that there is currently no example code to determine the proportion of records with an implausible sequence for cause of death.

## Data Requirements

Data used for metric calculation should have a format where each row corresponds to one death record and each column corresponds to an attribute for the death record, such as "Date Certified" or "Underlying Cause of Death". ICD codes included in the data should not include periods (".").

For an example of data in the correct format, please see [SyntheticDeathRecordData.csv](../data/SyntheticDeathRecordData.csv).

## Requirements: Python

Running the standalone example code requires

* Python 3.6 or higher
* The pandas library

You can install pandas with pip:

```
pip install pandas
```

Running the Jupyter Notebook example requires Jupyter Notebook to be installed. Jupyter Notebook can be installed with pip:

```
pip install notebook
```

## Usage: Python

Running the example code can be done by invoking each script with python, e.g.:

```
> cd code
> python proportion_with_unsuitable_underlying.py   
The proportion of records with an unsuitable underlying cause of death is 0.20
```

Running the Jupyter Notebook can be done by starting the Jupyter Notebook server:

```
jupyter notebook
```

Once Jupyter Notebook is running you can open the `MortalityDataQualityAssessment.ipynb` notebook file within Jupyter.

The examples have an embedded reference to the sample mortality data file. The code is not intended to be run directly in a jurisdiction environment since each jurisdiction may organize data differently, but rather is intended to serve as examples that can be adapted as needed or simply serve as reference materials when developing systems to measure quality metrics.

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
