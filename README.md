**Supporting Ecological Decision Making Using Feature-Selection and Variable Importance**

_Research project_

[![Last-changedate](https://img.shields.io/badge/last%20change-2019--05--21-brightgreen.svg)](https://github.com/pat-s/2019-feature-selection/commits/master)
[![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.1-brightgreen.svg)](https://cran.r-project.org/)
[![Licence](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)
[![Travis-CI Build Status](https://travis-ci.org/pat-s/2019-feature-selection.png?branch=master)](https://travis-ci.org/pat-s/2019-feature-selection)

See [https://pat-s.github.io/2019-feature-selection/](https://pat-s.github.io/2019-feature-selection) for a detailed description including HTML result documents.

## Project structure

:file_folder: `code/`: R scripts

:file_folder: `code/98-paper/`: LaTeX manuscripts

:file_folder: `R/`: custom R functions

:file_folder: `_drake.R`: [drake](https://docs.ropensci.org/drake/) config file 

:file_folder: `analysis/`: Reporting documents (R Markdown)

:file_folder: `docs/`: Output folder of HTML docs created from [workflowr](https://jdblischak.github.io/workflowr/) using the sources in from `analysis/`

Data is hosted at [Zenodo](https://doi.org/10.5281/zenodo.2635403) and automatically processed when starting the workflow via `drake::r_make()`.
