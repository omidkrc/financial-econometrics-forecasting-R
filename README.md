# Financial Econometrics and Forecasting in R

## Overview

This repository contains three applied projects from a Financial Econometrics course, implemented in **R**. Together they cover unit-root testing, seasonal time-series modeling, ARMA mean equations, long-memory volatility models, forecasting, and Value-at-Risk.

The repository is particularly focused on the workflow behind empirical financial research: importing and transforming data, selecting time-series specifications, diagnosing residuals, estimating volatility, producing forecasts, and interpreting risk measures.

## Skills Demonstrated

- R for empirical and financial data analysis
- Time-series transformation and frequency conversion
- Augmented Dickey-Fuller and HEGY unit-root testing
- SARIMA modeling
- ARMA specification and model selection
- Long-memory and FI-GARCH volatility modeling
- Volatility and return forecasting
- Value-at-Risk estimation
- Residual diagnostics and statistical testing
- Reproducible reporting with R Markdown / LaTeX

## Repository Structure

```text
Fin_metrics/
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
    ├── project3/
    └── project4/
```

The report folders contain English R Markdown / LaTeX versions of the course reports together with generated PDFs where available.

## Project 2 — Unit Roots

This project works with an annual Brazilian economic time series obtained through Quandl/BCB. The analysis examines persistence using an Augmented Dickey-Fuller framework and first differences.

Main methods:

- time-series visualization;
- autoregressive regression;
- ADF testing under trend, drift, and no-deterministic-term specifications; and
- first-difference analysis.

## Project 3 — Seasonal Unit Roots and SARIMA

This project analyzes two Tehran Stock Exchange industry indices for leather products and petroleum products. Daily observations are transformed to monthly and quarterly frequencies before seasonal-unit-root and SARIMA analysis.

Main methods:

- data merging and frequency conversion;
- daily, monthly, and quarterly time-series analysis;
- HEGY seasonal-unit-root testing; and
- SARIMA specification.

## Project 4 — ARMA, FI-GARCH, Forecasting, and VaR

This project analyzes daily returns for a financial-institutions index. It combines mean-equation modeling with volatility and risk analysis.

Main methods:

- log-return construction;
- long-memory diagnostics;
- ARMA order comparison using information criteria;
- residual and ARCH diagnostics;
- FI-GARCH volatility modeling;
- short-horizon volatility / return forecasting; and
- modified, Gaussian, and historical Value-at-Risk calculations.

## How to Run

Install any missing R packages by running:

```r
source("requirements.R")
```

Then run the scripts from the repository root:

```r
source("R/project2_unit_root.R")
source("R/project3_seasonal_unit_roots_sarima.R")
source("R/project4_arma_figarch_var.R")
```

Project 2 requires a Quandl API key. Set it in the environment rather than storing it in source code:

```r
Sys.setenv(QUANDL_API_KEY = "your-key-here")
```

## Data

The Excel files used in Projects 3 and 4 are included under `data/`. Project 2 retrieves its series through the Quandl interface.

## Author

**Omid Karami**

Financial Econometrics coursework and portfolio project.
