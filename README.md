# Paper: "Hyperspectral"

**Goal:** Using "Ridge Regression" to find the most meaningful vegeation index among 30k using defoliation as the response.

## Data

We have datasets from 2016 and 2017 with defoliation information.

From 2016 we only have data from the "demonstration plots". "Hernani" is missing here because we have no Hyperspectral flight coverage :/ :

* Laukiz 1
* Laukiz 2
* Luiando
* Oiartzun

2017: All 28 plots.

## Ridge regression

Source: https://onlinecourses.science.psu.edu/stat857/node/155

> Motivation: too many predictors
>
> It is not unusual to see the number of input variables greatly exceed the number of observations, e.g. micro-array data analysis, environmental pollution studies.
>
> With many predictors, fitting the full model without penalization will result in large prediction intervals, and LS regression estimator may not uniquely exist.

Source: https://tamino.wordpress.com/2011/02/12/ridge-regression/

> There are cases, however, for which the best linear unbiased estimator is not necessarily the “best” estimator. One pertinent case occurs when the two (or more) of the predictor variables are very strongly correlated. For instance, if we regress global temperature as a function of time, and of the logarithm of population, then we find that those two predictors are strongly correlated. Since both of them are increasing (in similar fashion), will the global temperature increase be due to one or the other (or both or neither) factor? In such cases, the matrix {\bf X^T X} has a determinant which is close to zero, which makes it “ill-conditioned” so the matrix can’t be inverted with as much precision as we’d like, there’s uncomfortably large variance in the final parameter estimates.
>
> We pay a price for this. The new estimates are no longer unbiased, their expected values are not equal to the true values. Generally they tend to underestimate the true values. However, the variance of this new estimate can be so much lower than that of the least-squares estimator, that the total expected mean squared error is also less — and that makes it (in a certain sense) a “better” estimator, surely a better-behaved one.



**R packages**

* `glmnet` (Hastie & Friedman)
* `bigRR` (from 2014, probably outdated)
* `penalized` (orphaned)
* `elasticnet` (last update 2012)
* `foba` (from 2008, probably outdated)
