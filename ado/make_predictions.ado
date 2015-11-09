*! make_predictions.ado
*! Stata command to calculate the predicted cumulative incidence of
*! lung cancer based on given data provided and the UK Biobank lung 
*! cancer risk prediction model
*!
*! dcmuller
progr define make_predictions
version 12
syntax , nyears(integer) time0(varname)

quietly estimates use ./model_binaries/m05_lung_cur.ster
quietly estimates store lung_cur
quietly estimates use ./model_binaries/m05_lung_fmr.ster
quietly estimates store lung_fmr
quietly estimates use ./model_binaries/m05_lung_nev.ster
quietly estimates store lung_nev
quietly estimates use ./model_binaries/m05_mort.ster
quietly estimates store mort

tempvar tempid
gen `tempid' = _n
tempfile nev fmr cur
qui count
local n_before = r(N)
qui count if smoke_stat==0
if `=r(N)' != 0 {
  preserve
  qui keep if smoke_stat==0
  cr_cif lung_nev mort , ///
    time(`nyears') stub(cif) time0(`time0') idvar(`tempid') intpoints(2)
  rename cif_lung_nev cif_lung
  qui save `nev', replace
  restore
}
qui count if smoke_stat==1
if `=r(N)' != 0 {
  preserve
  qui keep if smoke_stat==1
  cr_cif lung_fmr mort , ///
    time(`nyears') stub(cif) time0(`time0') idvar(`tempid') intpoints(2)
  rename cif_lung_fmr cif_lung
  qui save `fmr', replace
  restore
}
qui count if smoke_stat==2
if `=r(N)' != 0 {
  preserve
  qui keep if smoke_stat==2
  cr_cif lung_cur mort , ///
    time(`nyears') stub(cif) time0(`time0') idvar(`tempid') intpoints(2)
  rename cif_lung_cur cif_lung
  qui save `cur', replace
  restore
}
qui drop in 1/`=_N'
cap append using `nev'
cap append using `fmr'
cap append using `cur'
qui count
local n_after = r(N)
assert `n_before'==`n_after'
drop cif_*_raw cif_mort
end



