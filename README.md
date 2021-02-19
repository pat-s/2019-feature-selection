**Monitoring forest health using hyperspectral imagery: Does feature selection improve the performance of machine-learning techniques?**

*Research study*

<!-- badges: start -->

[![R version](https://img.shields.io/badge/R_Version-4.0.3-brightgreen.svg)](https://cran.r-project.org/) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)

<!-- badges: end -->

See [https://pat-s.github.io/2019-feature-selection/](https://pat-s.github.io/2019-feature-selection) for a detailed description including HTML result documents.

## Project structure

:notebook_with_decorative_cover: `code/`: R scripts

:notebook_with_decorative_cover: `docs/00-manuscripts/ieee`: LaTeX manuscripts

:notebook_with_decorative_cover: `R/`: R functions

:notebook_with_decorative_cover: `_drake.R`: [{drake}](https://docs.ropensci.org/drake/) config file.
Specifies execution order of all steps to reproduce this study.

:notebook_with_decorative_cover: `analysis/`: Reporting documents (R Markdown)

:notebook_with_decorative_cover: `docs/`: HTML docs created via [{workflowr}](https://jdblischak.github.io/workflowr/) using the .Rmd sources from the `analysis/` directory.

The data is hosted at [Zenodo](https://doi.org/10.5281/zenodo.2635403) and automatically downloaded and processed when invoking the workflow via `drake::r_make()`.

**Reproducibility**

Besides making use of [{drake}](https://docs.ropensci.org/drake/) for streamlining the workflow execution, [{renv}](https://rstudio.github.io/renv/index.html) is used in this project to ensure a consistent set of fixed R package versions.

By calling `r_make()` from the repository root, the recreation of the complete study is started.
Intermediate/single objects can be computed by specifying these explicitly in `drake_config(targets = )` in `_drake.R`.
Note that while most targets are cheap to compute, the modeling part is pretty expensive.
These were run on a High-Performance-Computing (HPC) system and executing those on a local desktop machine is not recommended.

**Known Issues**

This study relies partly on the download of Sentinel2 images.
For this task the R package [{getSpatialData}](https://github.com/16EAGLE/getSpatialData) is used.
After a required refactoring to the latest version of the package in November 2020 (due to outdated/non-working functionality with the initial implementation from 2019), the Sentinel2 download became very unstable.

### Creating targets with {drake}

Calling `r_make()` will create targets specified in `drake_config(targets = <target>)` in `_drake.R` with the additional drake settings specified.

Out of the 400+ targets in this project, the following targets are important:

-   `bm_aggregated_new_buffer2`: Aggregated benchmark results of all models using a 2 meter buffer for hyperspectral data extraction.
-   `eda_wfr`: Creates the [report which shows Exploratory Data Analysis (EDA) plots and tables](https://pat-s.github.io/2019-feature-selection/eda.html).
-   `eval_performance_wfr`: Creates the [report which evaluates the model performances](https://pat-s.github.io/2019-feature-selection/eval-performance.html).
-   `spectral_signatures_wfr`: Creates the [report which inspects the spectral signatures of the hyperspectral data](https://pat-s.github.io/2019-feature-selection/spectral-signatures.html).
-   `feature_importance_wfr`: Creates the [report which inspects the feature importance of variables](https://pat-s.github.io/2019-feature-selection/feature-importance.html).
-   `filter_correlations_wfr`: Creates the [report which inspects correlations among filter methods](https://pat-s.github.io/2019-feature-selection/feature-importance.html).

Note that most reports require some/all fitted models.
Creating these (e.g. target `benchmark_no_models_new_buffer2`) is a costly process and takes several days on a HPC and way longer on a single machine.
