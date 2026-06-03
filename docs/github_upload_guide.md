# How to Put the Projects on GitHub

1. Create a new repository on GitHub, for example `financial-econometrics-course`.
2. Keep the folder structure in this package.
3. Before the first commit, check that no API keys or personal paths appear in the code.
4. From a terminal opened in this folder, run:

```bash
git init
git add .
git commit -m "Add translated Financial Econometrics reports"
git branch -M main
git remote add origin https://github.com/<your-username>/financial-econometrics-course.git
git push -u origin main
```

5. In the GitHub repository description, write:

> Translated and cleaned R/R Markdown reports for a Financial Econometrics course, covering unit-root testing, seasonal unit roots, SARIMA modeling, FI-GARCH volatility modeling, and Value-at-Risk.

6. Suggested topics: `r`, `financial-econometrics`, `time-series`, `unit-root`, `sarima`, `garch`, `value-at-risk`.
