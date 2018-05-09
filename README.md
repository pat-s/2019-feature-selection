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


## Workflow

1. Compute 90 vegetation indices + 75** normalized ratio indices for each plot
2. Extract to trees with a buffer size of 2 (~ canopy width)
3. Method comparison (Lasso, Ridge, Elasticnet) for each plot (different plot structures)
4. Apply winning method to merged dataset of all plots ("supermodel")
  1. Performance using block based spCV (plot base)
5. In case of Lasso winning: Visualize RMSE with x number of variables
6. Inspect most important predictors of winning model

5 fold 5 fold nested CV (2 reps)

Model/Plot  | Lasso  | Ridge  | Elasticnet |
--|      ---|---     |---     |--
Laukiz 1  | 82.19  |   |  80.88 |
Laukiz 2  |   |   |   |
Luiando   |   |   |   |
Oiartzun  |   |   |   |

10 fold/10 fold nested CV (2 reps)

For "all plots" plot-wise CV at the performance level (4 plots) and SpCV with 10 folds at the tuning level.

Model/Plot  | Lasso  | Ridge  | Elasticnet |
--|      ---|---     |---     |--
Laukiz 1  | 146.33  | 87.76  | 135.58
Laukiz 2  | 30.54  | 30.54  |  37.16
Luiando   | 74.84  | 76.08  | 74.79
Oiartzun  | 327.93  | 106.65  | 260.38
All Plots |  56.88 | 55.88  | 56.76

Best coefficients:

| Laukiz 1 | Laukiz 2 | Luiando | Oiartzun  | all plots
-- | --- | -- | --- |
  |   |   | b95-b93 (1.5e-36)   | b23-b18 (-0.0090)   | b78-b77 (0.058)
  |   |   | b109-b106 (1.4e-36) | b23-b19 (-0.0074)   | b115-b113 (0.054)
  |   |   | b92-b95 (1.4e-36)   | b99-b98 (0.0073)    | b82-b77 (0.052)
  |   |   | b114-b6 (-1.2e-36)  | b23-b20 (-0.0070)   | b79-b77 (0.049)
  |   |   | b96-b93 (1.2e-36)   | b10-b8 (-0.0063)    | b80-b77 (0.049)
  |   |   | b116-b6 (-1.2e-36)  | b102-b98 (0.0062)   | b81-b77 (0.049)
  |   |   | b114-b5 (-1.2e-36)  | b124-b115 (0.0062)  | b81-b78 (-0.048)
  |   |   | b115-b114 (1.2e-36) | b23-b15 (-0.0060)   | b124-b115 (-0.047)
  |   |   | b95-b91 (1.1e-36)   | b126-b115 (-0.0060) | b23-b20 (-0.047)
  |   |   | b114-b8 (-1.1e-36)  | b118-b115 (-0.0059) | b80-b78 (-0.046)


## Ridge regression

Books:
* Elements of statistical learning Friedman Hastie
* James et al (2013) An Introduction to Statistical Learning (p 215+)

> However, as λ → ∞, the impact of
> the shrinkage penalty grows, and the ridge regression coefficient estimates
> will approach zero.
> Unlike least squares, which generates only one set of co-
> efficient estimates, ridge regression will produce a different set of coefficient
> estimates, β̂λ R , for each value of λ.

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

### Summary

* Bias-variance tradeoff to minimize the loss function (e.g. error measure MSE) -> At some point the variance does not decrease anymore but bias increases highly (see Figure 6.5 in James et al). CV finds the optimal value between regularization and flexibility to minimize the loss function as a function of bias and variance
* regularization is achieved by shrinking the coefficients towards zero. By this, bias is increased and variance reduced
* When n(pred) is high, the least squares estimate is extremly variable -> reducing variance by L2 penalization at the cost of an increased bias

### Difference to LASSO (L1)

* Ridge will always include all predictors and shrink them but never set them to zero
* Lasso actucally shrinks coefficients towards zero which is similar to "best subset selection"
* Thereofore, Lasso produces "sparse" models and performs "variable selection" as some predictors are set to zero

## L2 vs L1

* Can be split into L1/L2 regularization and L1/L2 loss function.
* L1 also called "lasso"
* L2 also called "ridge"
* Loss function = function to estimate residuals (residual sum of squares)
* regularization function = Penalization of coefficients
* Comparison:
  - https://stats.stackexchange.com/questions/179611/why-cant-ridge-regression-provide-better-interpretability-than-lasso
  - https://stats.stackexchange.com/questions/331782/if-only-prediction-is-of-interest-why-use-lasso-over-ridge?rq=1
  - https://www4.stat.ncsu.edu/~post/josh/LASSO_Ridge_Elastic_Net_-_Examples.html#generate-data-2

**R packages**

* `glmnet` (Hastie & Friedman)
* `bigRR` (from 2014, probably outdated)
* `penalized` (orphaned)
* `elasticnet` (last update 2012)
* `foba` (from 2008, probably outdated)
* `liblineaR` (from 2017, wrapper around C++ liblinear)
