# Foreign Ownership and Firm Productivity in Laos  
*Econometric Analysis using World Bank Enterprise Survey Data (2009–2018)*

## Overview  
This project investigates whether foreign-owned firms in Laos exhibit higher productivity than domestic firms. Using panel data from the World Bank Enterprise Survey and a Cobb–Douglas production framework, the analysis applies fixed-effects OLS, instrumental variables (2SLS), and propensity score matching (PSM) to address endogeneity and estimate the foreign-ownership productivity premium.

## Main Findings  
- Foreign-owned firms consistently show a significant productivity advantage across model specifications.  
- Robustness checks demonstrate how sensitive causal estimates are to specification choices—highlighting the importance of strong identification strategies in applied econometrics.

## Repository Structure  
`laos_dissertation/`

`├── B202054.do`

`├── Final Dissertation Quentin.pdf`

`└── STATA files/`


## Methods & Tools  
- **Econometrics:** Fixed-effects OLS, IV (2SLS) using financial-access instruments, PSM  
- **Data:** WBES firm-level panel (2009–2018)  
- **Software:** Stata  
- **Productivity Measure:** TFP estimated via Cobb–Douglas production function

## How to Reproduce  
1. Open the `.do` files in the `/scripts/` folder.  
2. Set your data directory within the scripts.  
3. Run the main script to reproduce the baseline and extended results.  
4. Generated graphs will populate the `/graphs/` folder.

## 📄 Citation  
If referencing this work, please cite the dissertation PDF included in the repository.
