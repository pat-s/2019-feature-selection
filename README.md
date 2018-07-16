# Paper: "Hyperspectral"

**Objectives:** 

- Using machine-learning algorithms to model defoliation at Pinus Radiata trees.  t
- Find most important indices 
- Predict to remaining plots (24)

## Data

We have datasets from 2016 and 2017 with defoliation information.

From 2016 we only have data from the "demonstration plots". "Hernani" is missing here because we have no Hyperspectral flight coverage :

- Laukiz 1
- Laukiz 2
- Luiando
- Oiartzun

2017: All 28 plots.

We used the 2016 data because the flight campaign was at the same time (September 2016).
## Workflow

1. Compute 90 vegetation indices + 75** normalized ratio indices for each plot
2. Extract to trees with a buffer size of 2 (~ canopy width)
3. Method comparison (SVM, xgboost, Ridge Regression) on a plot level (model using observations from all plots) and tree level
4. Tune models using Sequential-based model optimization
5. Performance on the tree level using block spCV (4-folds, each fold = 1 plot). Performance on the tree level = k-means spCV
6. Inspect most important predictors of winning model
7. Partial dependence analysis