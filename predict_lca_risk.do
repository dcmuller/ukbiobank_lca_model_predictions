clear all
clear mata
version 12.1
adopath ++ ./ado
*************************************************************
// configuration
local nyears 5 // 5-year predicted probability, change to any reasonable horizon
local input_file "input.csv"
local output_file "output.csv"
*************************************************************
insheet using `input_file', comma names

// get list of variable names
qui ds
local vars `r(varlist)'

// generate a unique id for sorting the data as they were entered
gen sid=_n

// generate splines for cigs/day
rcsgen ncig if smoke_stat==1, knots(4 15 30) gen(smkfmr_ncig_sp2_)
rcsgen ncig if smoke_stat==2, knots(4 15 30) gen(smkcur_ncig_sp2_)

// new variables to match those from the models 
gen prebl_cancer=previous_cancer
gen atnd_age=age
gen sex=male
gen smkcur_stop1day_easy=stop1day_easy

gen outcome=1
gen exit=age+1
stset exit, enter(age) fail(outcome)

make_predictions, nyears(`nyears') time0(age)
sort sid
keep `vars' cif_lung
outsheet using `output_file', c replace

exit
*************************************************************

