**Monitoring forest health using hyperspectral imagery: Does feature selection improve the performance of machine-learning techniques?**

_Research study_

<!-- badges: start -->
[![minimal R version](https://img.shields.io/badge/R=-3.6.1-brightgreen.svg)](https://cran.r-project.org/)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)
<!-- badges: end -->

See [https://pat-s.github.io/2019-feature-selection/](https://pat-s.github.io/2019-feature-selection) for a detailed description including HTML result documents.

## Project structure

:notebook_with_decorative_cover: `code/`: R scripts

:notebook_with_decorative_cover: `docs/00-manuscripts/ieee`: LaTeX manuscripts

:notebook_with_decorative_cover: `R/`: R functions

:notebook_with_decorative_cover: `_drake.R`: [{drake}](https://docs.ropensci.org/drake/) config file.
  Specifies execution order of all steps to reproduce this study.

:notebook_with_decorative_cover: `analysis/`: Reporting documents (R Markdown)

:notebook_with_decorative_cover: `docs/`: HTML docs created via [workflowr](https://jdblischak.github.io/workflowr/) using the .Rmd sources from the `analysis/` directory.

The data is hosted at [Zenodo](https://doi.org/10.5281/zenodo.2635403) and automatically downloaded and processed when invoking the workflow via `drake::r_make()`.

**Reproducibility**

Besides making use of [{drake}](https://docs.ropensci.org/drake/) for streamlining the workflow execution, [{renv}](https://rstudio.github.io/renv/index.html) was used in this project to ensure a consistent set of fixed package versions that corresponds to the one which were used to create this study.
