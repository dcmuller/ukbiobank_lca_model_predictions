# Predicted risk of lung cancer based on the UK Biobank risk prediction model
This repository provides Stata code to calculate the predicted risk of
lung cancer based on supplied information and the UK Biobank risk
prediction model.

## How to use this code
You will need a copy of Stata, version 12.1 or higher, with the
user-written command stpm2 installed (-ssc install stpm2-). Open stata
and change directory to the root of this repository. Running
```
do predict_lca_risk.do
```
will calculate the predicted risk of lung cancer. By default this will
take covariate information from the file 'input.csv', calculate the
5-year cumulative probability of lung cancer for each record therein,
and save the results in the file 'output.csv'. These default input,
output, and time-horizons can be changed by editing the parameters in
the configuration block at the beginning of the file
'predict\_lca\_risk.do'.

## Input specification
The input file must be an ASCII plain text CSV file, and must contain
the following variables:

variable name | description | type | valid values
--------------|:------------|:-----|:-------------
age | age in years | real | [40,70]
smoke\_stat | smoking status | integer | 0 (never smoker), 1 (former smoker), 2 (current smoker)
male | male sex | integer | 0 (female), 1 (male)
previous\_cancer | Previously diagnosed with an invasive cancer | integer | 0 (no), 1 (yes)
fhist\_lungca | one or more first-degree relatives who have been diagnosed with lung cancer | integer | 0 (no), 1 (yes)
emph\_bronch | history of emphysema or bronchitis | integer | 0 (no), 1 (yes)
allergy | history of hayfever, allergic rhinitis, or eczema | integer | 0 (no), 1 (yes)
fev1\_max | forced expiratory volume in one second (FEV1) | real | [0.5,10]
smkfmr\_quitage | for former smokers only, the age at which they quit | real | less than current age
ncig | for current and former smokers only, the average number of cigarettes smoked per day | real | (0,80]
stop1day\_easy | for current smokers only, how difficult would it be to not smoke for one day | integer | 0 (difficult or very difficult), 1 (easy or very easy)

Other variables can be included in the input file, but they are
ignored by the program.

## Output file
The output file contains the same variables as the input file, with
the addition of the variable 'cif\_lung' which contains the predicted
probability (Cumulative Incidence Function evaluated at a given time
horizon) for each input observation.
