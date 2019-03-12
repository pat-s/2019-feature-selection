
[![Last-changedate](https://img.shields.io/badge/last%20change-2019--03--12-brightgreen.svg)](https://github.com/pat-s/paper_hyperspectral/commits/master)  
[![minimal R
version](https://img.shields.io/badge/R%3E%3D-3.5.0-brightgreen.svg)](https://cran.r-project.org/)  
[![Licence](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/)  
<!-- [![Travis-CI Build Status](https://travis-ci.org/pat-s/paper_hyperspectral.png?branch=master)](https://travis-ci.org/pat-s/paper_hyperspectral)  -->

**title**

# Authors

**Patrick Schratz** (<patrick.schratz@gmail.com>)
[![](https://orcid.org/sites/default/files/images/orcid_16x16.png)](http://orcid.org/0000-0003-0748-6624)  
Jannes Muenchow
[![](https://orcid.org/sites/default/files/images/orcid_16x16.png)](http://orcid.org/0000-0001-7834-4717)  
Bernd Bischl
[![](https://orcid.org/sites/default/files/images/orcid_16x16.png)](http://orcid.org/0000-0001-6002-6980)  
Alexander Brenning
[![](https://orcid.org/sites/default/files/images/orcid_16x16.png)](http://orcid.org/0000-0001-6640-679X)

# Contents

This repository contains the research compendium of our work on
comparing algorithms across multiple feature sets and filtering methods
(including ensemble filter methods).

  - Using machine-learning algorithms to model defoliation of *Pinus
    Radiata* trees.

  - keywords
    
      - high-dimensional data handling
      - feature selection
      - machine-learning
      - ecology

  - Compare filtering methods (ensemble filter methods) across various
    algorithms and datasets

  - Predict defoliation to all available plots (24) and the whole Basque
    Country (at 200 m resolution)

# How to use

## Read the code, access the data

See the
[`analysis`](https://github.com/pat-s/paper_hyperspectral/tree/master/analysis)
directory on GitHub for the source code that generated the figures and
statistical results contained in the manuscript. See the
[`data`](https://github.com/pat-s/paper_hyperspectral/tree/master/analysis/data)
directory for instructions how to access the raw data discussed in the
manuscript.

## Install the R package

[![Build
Status](https://travis-ci.org/pat-s/paper_hyperspectral.svg?branch=master)](https://travis-ci.org/pat-s/paper_hyperspectral)

This repository is organized as an R package, providing functions and
raw data to reproduce and extend the analysis reported in the
publication. Note that this package has been written explicitly for this
project and may not be suitable for more general use.

This project is setup with a [drake
workflow](https://github.com/ropensci/drake), ensuring reproducibility.
Intermediate targets/objects will be stored in a hidden `.drake`
directory.

The R library of this project is managed by
[packrat](https://rstudio.github.io/packrat/). This makes sure that the
exact same package versions are used when recreating the project. When
calling `packrat::restore()`, all required packages will be installed
with their specific version.

Please note that this project was built with R version 3.5.2 on a Debian
9 operating system. The packrat packages from this project **are not
compatible with R versions prior version 3.5.0.** For reproducibility,
it is recommended to replicate the analysis using the included
Dockerfile. Instructions can be found
[ħere](https://github.com/pat-s/paper_hyperspectral#docker). (In
general, it should be possible to reproduce the analysis on any other
operating system.)

To clone the project, a working installation of `git` is required. Open
a terminal in the directory of your choice and execute:

``` sh
git clone git@github.com:pat-s/paper_hyperspectral.git
```

Then start R in this directory and run

``` r
packrat::restore()
r_make()
```

# Runtime

Predicted total runtime. The time is based on all targets that have been
created so far in the project. Estimated time will differ depending on
the CPU speed and possible availability of a HPC.

``` r
r_predict_runtime()
```

    ## [38;5;153mcache[39m /home/patrick/paper-hyperspectral/.drake
    ## [38;5;153manalyze[39m environment
    ## [38;5;153mconstruct[39m priority queue

    ## [1] "0s"

# Licenses

Text: CC-BY-4.0 <http://creativecommons.org/licenses/by/4.0/>

Code: MIT <http://opensource.org/licenses/MIT> year: 2019, copyright
holder: Patrick Schratz

Data: CC0 <http://creativecommons.org/publicdomain/zero/1.0/>

# Notes and resources

  - The [issues
    tracker](https://github.com/pat-s/paper_hyperspectral/issues) is the
    place to report problems or ask questions

  - See the repository
    [history](https://github.com/pat-s/paper_hyperspectral/commits/master)
    for a fine-grained view of progress and changes.

  - The organisation of this compendium is based on the work of [Carl
    Boettiger](http://www.carlboettiger.info/) and [Ben
    Marwick](https://github.com/benmarwick).

# Literature

  - What to do first (Feature selection or tuning):
    <https://datascience.stackexchange.com/a/19778/24475>
  - Hastie, T., Friedman, J., & Tibshirani, R. (2001). The Elements of
    Statistical Learning. Springer New York.
    <https://doi.org/10.1007/978-0-387-21606-5> (Kapitel 16)
  - FSel algs overview: <http://featureselection.asu.edu/algorithms.php>
  - De Jay, N., Papillon-Cavanagh, S., Olsen, C., El-Hachem, N.,
    Bontempi, G., & Haibe-Kains, B. (2013). mRMRe: an R package for
    parallelized mRMR ensemble feature selection. Bioinformatics,
    29(18), 2365–2368. <https://doi.org/10/f48vxc>
  - Drotár, P., Gazda, J., & Smékal, Z. (2015). An experimental
    comparison of feature selection methods on two-class biomedical
    datasets. Computers in Biology and Medicine, 66, 1–10.
    <https://doi.org/10/f72ttc>
  - Drotár, P., Šimoňák, S., Pietriková, E., Chovanec, M., Chovancová,
    E., Ádám, N., … Biňas, M. (2017). Comparison of Filter Techniques
    for Two-Step Feature Selection. COMPUTING AND INFORMATICS, 36(3),
    597–617. <https://doi.org/10/gbntp7>
  - Drotár, P., Gazda, M., & Gazda, J. (2017). Heterogeneous ensemble
    feature selection based on weighted Borda count. In 2017 9th
    International Conference on Information Technology and Electrical
    Engineering (ICITEE) (pp. 1–4).
    <https://doi.org/10.1109/ICITEED.2017.8250495>
  - Nie, F., Huang, H., Cai, X., & Ding, C. H. (2010). Efficient and
    Robust Feature Selection via Joint 2,1-Norms Minimization. In J. D.
    Lafferty, C. K. I. Williams, J. Shawe-Taylor, R. S. Zemel, & A.
    Culotta (Eds.), Advances in Neural Information Processing Systems 23
    (pp. 1813–1821). Curran Associates, Inc. Retrieved from
    <http://papers.nips.cc/paper/3988-efficient-and-robust-feature-selection-via-joint-l21-norms-minimization.pdf>
