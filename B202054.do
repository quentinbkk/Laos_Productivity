
// DissertationDOFILE_final
clear all

cd "/Users/quentingeoffroy/Desktop/Dissertation/assets/Stata Project"

capture log close

use "/Users/quentingeoffroy/Desktop/Dissertation/assets/Stata Project/Lao PDR_2009_2012_2016_2018.dta"

//ssc install asdoc, replace

xtset panelid year

// Data inspection

describe // Whole data set inspection

// Data inspection: Exp. Variable of interest

describe b2b 

sum b2b, detail 

tabulate b2b // Percentage frequency

tabulate b2b if b2b < 0

list panelid year b2b if b2b < 0, nolabel // There 4 negative values, which are substitutes to 'don't know' answer

drop if b2b < 0 // drop negative values from data set 


//\\ Step 2: Summarize data //\\

tabulate b2b if b2b < 0

describe b2b

asdoc sum b2b, detail save(b2bsum.doc) replace

asdoc tabulate b2b, details save(b2btabulate.doc) replace

// Unique firms

xtdescribe



// Creating foreign ownership dummy variable

gen ownershipb2b = 1 if b2b > 0

replace ownershipb2b = 0 if missing(ownershipb2b)

asdoc tab ownershipb2b, save(tabownershipb2b.doc)


// Creating Labour Productivity variable

gen labourprod = log(d2/l1)

tabulate labourprod

summarize labourprod

describe labourprod


// Creating export variable: Combining total exports

gen totalexports = d3b + d3c

drop if totalexports < 0 

asdoc tabulate totalexports, save(tabtotalexports.doc) replace



// Creating Total Factor Productivity (TFP) variable

gen log_sales = ln(d2)

gen log_labor = ln(n2a)

gen log_capital = ln(n7a)

gen log_inter = ln(n2e)

gen log_energy = ln(_2009_2012_2016_n2f + n2b) // For TFP 4

tabulate log_capital

summarize log_capital

xtreg log_sales log_labor log_capital log_inter i.year, fe robust
predict res

gen tfp_resid = res

sum tfp_resid


summarize tfp_resid labourprod //Table 1




// Endogeneity

							
			//\\ ---- Main model ---- //\\

// Firm-level controls: Total exports, Firm size, Firm age, Percentage owned by largest owner, Industry (1 = Manufacturing, 2 = Retail Services, 3 = Other Services), Manager Exp., Size of city

rename ownershipb2b foreign_ownership
rename l1 firm_size
rename b3 owner_pct
rename a4a industry
rename b7 manager_exp
rename a3 location_size
rename k30 finance_access

gen firm_age = a14y - b5

tabstat firm_age

replace firm_age = r(mean) if firm_age > 200

// Pearson Correlation

pwcorr tfp_resid labourprod foreign_ownership totalexports firm_size firm_age location_size industry manager_exp location_size, sig // Do not observe any correlations with an absolute value higher than 0.5 --> Issue of multicollinearity is unlikely

// Labour productivity (labourprod)
xtreg labourprod foreign_ownership firm_size firm_age owner_pct manager_exp location_size finance_access i.year i.industry, fe robust // Beta

// TFP (tfp_resid)
xtreg tfp_resid foreign_ownership firm_size firm_age owner_pct manager_exp location_size finance_access i.year i.industry, fe robust
predict resi

xtreg foreign_ownership resi  // Endogeneity present



// IV


// Check overdraft variable overdraft

rename _2009_2016_2018_k7 overdraft 

xtreg foreign_ownership overdraft i.year, fe robust

pwcorr foreign_ownership overdraft tfp_resid labourprod

xtreg foreign_ownership overdraft firm_size firm_age owner_pct industry manager_exp location_size i.year k6 k8, fe robust


ivregress 2sls tfp_resid (foreign_ownership = overdraft) firm_size firm_age owner_pct manager_exp location_size industry k8 d1a3 l6 i.year, first robust
ivregress 2sls labourprod (foreign_ownership = overdraft) firm_size firm_age owner_pct manager_exp location_size industry k8 b8 c30a d1a3 i.year, first robust // Final variable (overdraft as IV)?????




// k8 b8 c30a d1a3 

// Overdraft seems to be a valid instrument





// Robustness


// Replacing foreign_ownership with foreign_pct

rename b2b foreign_pct

xtreg labourprod foreign_pct firm_size firm_age owner_pct industry manager_exp location_size i.year finance_access, fe robust // Beta

xtreg tfp_resid foreign_pct firm_size firm_age owner_pct industry manager_exp location_size i.year finance_access, fe robust // Beta

ivregress 2sls tfp_resid (foreign_pct = totalexports) firm_size firm_age owner_pct industry manager_exp location_size finance_access i.year, robust 


collapse (mean) foreign_ownership, by(panelid)

gen foreign_cat = .
replace foreign_cat = 1 if foreign_ownership == 0
replace foreign_cat = 2 if foreign_ownership == 1
label define foreign_cat_lbl 1 "no foreign ownership" 2 "foreign ownership > 0%"
label values foreign_cat foreign_cat_lbl

graph bar (count), over(foreign_cat, label(angle(0))) ///
    bar(1, color(navy)) ///
    title("Fig.2: Distribution of Firms by Dummy Variable for Foreign Ownership") ///
    ytitle("Number of Firms") ///
    blabel(bar, format(%9.0g))
graph export "firmdistdummy.png", replace as(png)



