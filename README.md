# Financial Econometrics Projects in R

This repository includes three projects from my Financial Econometrics course.  
The original reports were written in Persian using R Markdown. I translated and cleaned them in English while keeping the R code and main results.

The projects mainly focus on unit root tests, seasonal unit roots, ARMA models, FI-GARCH models, and Value-at-Risk.

## Repository Structure

```text
Financial-Econometrics-ARMA-GARCH-VAR/
├── README.md
├── requirements.R
├── data/
│   ├── leather.xlsx
│   ├── oil.xlsx
│   ├── index.xlsx
│   └── sarmaye.xlsx
├── R/
│   ├── project2_unit_root.R
│   ├── project3_seasonal_unit_roots_sarima.R
│   └── project4_arma_figarch_var.R
└── reports/
    ├── project2/
    │   ├── project2_report_en.Rmd
    │   ├── project2_report_en.tex
    │   └── project2_report_en.pdf
    ├── project3/
    │   ├── project3_report_en.Rmd
    │   ├── project3_report_en.tex
    │   └── project3_report_en.pdf
    └── project4/
        ├── project4_report_en.Rmd
        ├── project4_report_en.tex
        └── project4_report_en.pdf
```

## Project 2: Unit Root Test

In this project, I worked with an annual Brazilian economic time series from Quandl/BCB.  
I plotted the series, estimated a simple regression, and used the Augmented Dickey-Fuller test to check for a unit root.

Main topics:

- Time series plot
- OLS regression
- ADF unit root test
- First difference of the series

## Project 3: Seasonal Unit Roots and SARIMA

This project uses two TSE industry indices: leather products and petroleum products.  
The daily data were converted to monthly and quarterly frequencies. Then I used HEGY tests to check seasonal unit roots and estimated SARIMA models.

Main topics:

- Merging data
- Changing data frequency
- Daily, monthly, and quarterly plots
- HEGY seasonal unit root test
- SARIMA modeling

## Project 4: ARMA, FI-GARCH, and VaR

In this project, I analyzed daily returns of a financial institutions index.  
I estimated an ARMA model for the mean equation, checked the residuals, fitted FI-GARCH-type volatility models, and calculated Value-at-Risk.

Main topics:

- Return calculation
- Long memory
- ARMA model selection
- Residual diagnostics
- ARCH effect
- FI-GARCH modeling
- Value-at-Risk

## How to Run

First install the required R packages:

```r
source("requirements.R")
```

Then run each script from the root folder of the repository:

```r
source("R/project2_unit_root.R")
source("R/project3_seasonal_unit_roots_sarima.R")
source("R/project4_arma_figarch_var.R")
```

To render one of the reports:

```r
rmarkdown::render("reports/project3/project3_report_en.Rmd")
```

## Note about the Quandl API Key

Project 2 uses Quandl data. I did not put the API key directly in the code.

Before running Project 2, set your key in R:

```r
Sys.setenv(QUANDL_API_KEY = "your-key-here")
```

The script reads it with:

```r
Sys.getenv("QUANDL_API_KEY")
```

## Data

The Excel files used in Projects 3 and 4 are included in the `data/` folder.  
The data were cleaned before being used in R.
