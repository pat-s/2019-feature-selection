# Paper: "Hyperspectral"

**Objectives:**

- Using machine-learning algorithms to model defoliation at Pinus Radiata trees.
- Tackle question "high-dimensional data handling"
- Compare feature selection methods (ensemble feature selection) for multiple algorithms and datasets(?)
    - Use also statistical algs like LASSO (L1) and Ridge (L2) Penalization
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

### First version (June 18 - Sept 18)

1. Compute 90 vegetation indices + 75** normalized ratio indices for each plot
2. Extract to trees with a buffer size of 2 (~ canopy width)
3. Method comparison (SVM, xgboost, Ridge Regression) on a plot level (model using observations from all plots) and tree level
4. Tune models using Sequential-based model optimization
5. Performance on the tree level using block spCV (4-folds, each fold = 1 plot). Performance on the tree level = k-means spCV
6. Inspect most important predictors of winning model using internal variable importance of `xgboost`
7. Run another CV with the 7 most impo variables only (this is bad because the variables have already seen the complete dataset)
8. Predict to plots

### Second version (Sept 18 - now)

1. Compute 90 vegetation indices + 75xx normalized ratio indices for each plot
2. Extract to trees with a buffer size of 2 (~ canopy width)
3. Ensemble feature selection + method comparison (RF, SVM, xgboost, Ridge Regression) on a plot level (model using observations from all plots)
4. Nested feature selection (GA) and hyperparameter tuning (SMBO)
5. Performance on the tree level using block spCV (4-folds, each fold = 1 plot).

#### Praktische Probleme

- ~~`FSelector` methods are very slow, `FSelectorRcpp` PR open since forever~~
- Permutation not suitable -> too costly
- ~~"mrmr" läuft aber auch nur relativ langsam, je nach `fw.perc` Größe~~ -> now using "caching"

Featsel methods from Drotar 2017 (check = implemented in mlr)

- [ ] Fisher FS = chi-squared?
- [ ] RFS (Robust Feature selection) Nie et al (2010) -> keine R Implementierung?
- [ ] t-test
- [x] Pearson
- [x] Relieff
- [x] MIC (mututal information coefficient) -> `praznik` methods
- [x] Gini -> ranger.impurity
- [x] Anova (classif only)

**Interesting:** 
- SPSA-FSR: Simultaneous Perturbation Stochastic
Approximation for Feature Selection and Ranking (https://arxiv.org/pdf/1804.05589.pdf)
- ESVM-RFE: Ensemble Feature Learning of Genomic Data Using Support Vector Machine (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4909287/)

#### Notes

- Unterscheidung zwischen "Univariate FS" und "multivariate FS" -> Univariate berücksichtigt keine feature dependencies
- Comparing prediction performance of FS methods it is clear that low stability of FS does not result in low prediction performance (Drotar 2015)
- The results indicate that univariate FS methods are more
stable than multivariate methods [...] Therefore, for high dimensional databases, where many features
are correlated or functionally related, it results in unstable behavior. (Drotar 2015)
- Filter methods compute a score for each feature, and then select only the features with the best scores. Filter FS methods do not interact with classifier during selection process. Wrapper methods train a predictive model on subsets of
features, and select the subset with the best score. The search for subsets can be
deterministic or random. Finally, embedded methods determine the optimal subset
of features directly by the trained weights of the classification method [5, 6] (Dotar 2017)
- Stability vs. performance of Filter methods (Ensemble methods seem to help in this problem)
- Two step methods can be a solution (first filter, then featsel)

# Study design

#### Welche Merkmalsgruppen?

- Veg. Indices
- Hyperspektral
- NRIs
	
#### Welche Modelle:

- glmet (ridge, lasso, elatic net)
- randomforest
- xgboost
- svm (RBF)
		
#### Welche Vorverarbeitung / Filter (dabei Optimierung der Parameter)

- Keine
- einfache Filter (BB: ich würde einen einfachen nehmen)
- Filter Kombo mit Borda (BB: eine Borda variante mit mehrern)
- PCA	

#### Was macht man mit der response (liegt in nem Intervall)

- logistische transformation?

## Literature

- What to do first (Feature selection or tuning): https://datascience.stackexchange.com/a/19778/24475
- Hastie, T., Friedman, J., & Tibshirani, R. (2001). The Elements of Statistical Learning. Springer New York. https://doi.org/10.1007/978-0-387-21606-5 (Kapitel 16)
- FSel algs overview: http://featureselection.asu.edu/algorithms.php
- De Jay, N., Papillon-Cavanagh, S., Olsen, C., El-Hachem, N., Bontempi, G., & Haibe-Kains, B. (2013). mRMRe: an R package for parallelized mRMR ensemble feature selection. Bioinformatics, 29(18), 2365–2368. https://doi.org/10/f48vxc
- Drotár, P., Gazda, J., & Smékal, Z. (2015). An experimental comparison of feature selection methods on two-class biomedical datasets. Computers in Biology and Medicine, 66, 1–10. https://doi.org/10/f72ttc
- Drotár, P., Šimoňák, S., Pietriková, E., Chovanec, M., Chovancová, E., Ádám, N., … Biňas, M. (2017). Comparison of Filter Techniques for Two-Step Feature Selection. COMPUTING AND INFORMATICS, 36(3), 597–617. https://doi.org/10/gbntp7
- Drotár, P., Gazda, M., & Gazda, J. (2017). Heterogeneous ensemble feature selection based on weighted Borda count. In 2017 9th International Conference on Information Technology and Electrical Engineering (ICITEE) (pp. 1–4). https://doi.org/10.1109/ICITEED.2017.8250495
- Nie, F., Huang, H., Cai, X., & Ding, C. H. (2010). Efficient and Robust Feature Selection via Joint \mathscrl2,1-Norms Minimization. In J. D. Lafferty, C. K. I. Williams, J. Shawe-Taylor, R. S. Zemel, & A. Culotta (Eds.), Advances in Neural Information Processing Systems 23 (pp. 1813–1821). Curran Associates, Inc. Retrieved from http://papers.nips.cc/paper/3988-efficient-and-robust-feature-selection-via-joint-l21-norms-minimization.pdf

