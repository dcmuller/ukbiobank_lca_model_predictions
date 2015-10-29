*! cr_cif
** program to calculate cumulative probabilities in
** the presence of competing risks
** dcmuller

program define cr_cif
version 11
syntax namelist, ///
  idvar(varname) time(real) stub(string) [intpoints(integer 10) time0(varname)]
local models "`namelist'"
foreach m of local models {
  confirm new var `stub'_`m'
  confirm new var `stub'_`m'_raw
}
preserve
local s0vars ""
local sfunvars ""
local hfunvars ""
local prodhfunvars ""
foreach m of local models {
  local s0vars `s0vars' s_`m'_0
  local sfunvars `sfunvars' s_`m'_fun
  local hfunvars `hfunvars' h_`m'_fun
  local prodhfunvars `prodhfunvars' prod_`m'
}

tempvar t0 tv s0 s_fun `s0vars' `sfunvars' `hfunvars' `prodhfunvars'
qui expand `intpoints'
if "`time0'" == "" {
  gen double `t0' = 0
}
else {
  gen double `t0' = `time0'
}
bys `idvar': gen double `tv' = `t0' + (_n-1)*`time'/(_N-1)

foreach m of local models {
  qui est restore `m'
  qui predict double `s_`m'_0', surv timevar(`t0')
  qui predict double `s_`m'_fun', surv timevar(`tv')
  qui predict double `h_`m'_fun', haz timevar(`tv')
}

gen double `s0' = 1
gen double `s_fun' = 1
foreach m of local models {
  qui replace `s0' = `s0'*`s_`m'_0'
  qui replace `s_fun' = `s_fun'*`s_`m'_fun'
}
foreach m of local models  {
  qui gen `prod_`m'' = `h_`m'_fun'*`s_fun'
}
// cif of each competing risk 
foreach m of local models {
  bys `idvar' (`tv'): integ `prod_`m'' `tv', gen(`stub'_`m'_raw)
  qui gen double `stub'_`m' = `stub'_`m'_raw/`s0'
}

qui bys `idvar' (`tv'): keep if _n==_N
restore, not
end
