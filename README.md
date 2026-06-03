# Financial Econometrics Projects

This repository contains translated and cleaned reports for three R-based projects from a Financial Econometrics course.

## Repository structure

```text
financial-econometrics-course/
├── README.md
├── .gitignore
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

## Projects

1. **Project 2 - Unit Root Testing**  
   Uses ADF tests to study stationarity and unit roots in an annual Brazilian economic series from Quandl/BCB.

2. **Project 3 - Seasonal Unit Roots and SARIMA Modeling**  
   Uses leather-products and petroleum-products industry indices from TSE, converts daily data to monthly/quarterly frequency, applies HEGY seasonal unit-root tests, filters the series, and estimates SARIMA models.

3. **Project 4 - Long Memory, FI-GARCH, and Value-at-Risk**  
   Studies daily returns of the financial institutions index, fits ARMA and FI-GARCH-type models, and computes Value-at-Risk.

## Reproducibility

Install R and the required packages listed in `requirements.R`. Then run the scripts from the repository root:

```r
source("R/project2_unit_root.R")
source("R/project3_seasonal_unit_roots_sarima.R")
source("R/project4_arma_figarch_var.R")
```

To render an R Markdown report, run for example:

```r
rmarkdown::render("reports/project3/project3_report_en.Rmd")
```

## Important security note

Do not commit API keys. Project 2 uses Quandl, so define the key locally before running the script:

```r
Sys.setenv(QUANDL_API_KEY = "your-key-here")
```

The scripts in this repository use `Sys.getenv("QUANDL_API_KEY")` instead of a hard-coded key.

## Suggested GitHub commands

Create a new empty repository on GitHub, then from the folder containing this project run:

```bash
git init
git add .
git commit -m "Add translated Financial Econometrics projects"
git branch -M main
git remote add origin https://github.com/<your-username>/financial-econometrics-course.git
git push -u origin main
```

## Notes

The Excel files are included because they are required for Projects 3 and 4. If you do not want to publish the data publicly, remove the `data/` folder before pushing and add instructions for how to obtain the data.
