**Monitoring forest health using hyperspectral imagery: Does feature selection improve the performance of machine-learning techniques?**

_Research study_

<!-- badges: start -->

[![R version](https://img.shields.io/badge/R_Version-4.0.4-brightgreen.svg)](https://cran.r-project.org/) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)

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

## Reproducibility

This study makes heavy use of the R packages [{drake}](https://docs.ropensci.org/drake/), [{renv}](https://rstudio.github.io/renv/index.html) and [{workflowr}](https://jdblischak.github.io/workflowr/) to streamline workflow execution, manage R package versions and the creation of a research website to complete the study.

By calling `drake::r_make()` from the repository root, the creation of R objects used in this study is initiated (including data download from [Zenodo](https://doi.org/10.5281/zenodo.2635403)).
Intermediate/single objects can be computed by specifying their names explicitly in `drake_config(targets = <target name>)` in `_drake.R`.

While most targets are cheap to compute, the modeling part is pretty expensive.
These were run on a High-Performance-Computing (HPC) system and attempting to create those on a local desktop machine is not recommended.

## Known Issues

Parts of this work (and some targets) depend on the download of Sentinel2 images.
For this task the R package [{getSpatialData}](https://github.com/16EAGLE/getSpatialData) was used.
After a required refactoring to the latest version of the package in November 2020 (due to outdated/non-working functionality with the initial package version of {getSpatialData} from 2019), the Sentinel2 download is currently broken.

This issue does not affect the recreation of the targets used for the scientific manuscript.

## Creating targets with {drake}

(Before creating any target/object, make sure to call `renv::restore()` to install all required packages.)

Calling `r_make()` will create targets specified in `drake_config(targets = <target>)` in `_drake.R` with the additional drake settings specified.

**Important:** If you do have access to a Slurm cluster, set `options(clustermq.scheduler = "slurm")` in `_drake.R` (around l.73).

### Required disk space

The `data/` folder will contain data about 5.5GB in size.

### Important intermediate targets

Out of the 400+ intermediate targets/objects in this project, the following targets are considered important, i.e. they might want to be created/inspected in more detail.

- `task_reduced_cor`: List of all `mlr` tasks used for benchmarking.
- `bm_aggregated`: Aggregated benchmark results of all models using a 1 meter buffer for hyperspectral data extraction.
- `eda_wfr`: Creates the [report which shows Exploratory Data Analysis (EDA) plots and tables](https://pat-s.github.io/2019-feature-selection/eda.html).
- `eval_performance_wfr`: Creates the [report which evaluates the model performances](https://pat-s.github.io/2019-feature-selection/eval-performance.html).
- `spectral_signatures_wfr`: Creates the [report which inspects the spectral signatures of the hyperspectral data](https://pat-s.github.io/2019-feature-selection/spectral-signatures.html).
- `feature_importance_wfr`: Creates the [report which inspects the feature importance of variables](https://pat-s.github.io/2019-feature-selection/feature-importance.html).
- `filter_correlations_wfr`: Creates the [report which inspects correlations among filter methods](https://pat-s.github.io/2019-feature-selection/feature-importance.html).

Note that most reports require some/all fitted models.
Creating these (e.g. target `benchmark_no_models`) is a costly process and takes several days on a HPC and way longer on a single machine.
