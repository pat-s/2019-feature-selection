## Changelog

- Label overall learner performance as "poor" instead of "fair"
- Remove spearman rank correlations figure showing nbins discretizations (seems to have confused reviewers more than it helped)


## Thoughts on reviewer rejection replies

> For examples, why do you choose SVM, RF and XGBOOST? How to choose parameters for ML methods in this manuscript?

SMV, RF and XGBoost are commonly used ML models.
To me, there is no further argumentation needed why these have been selected?
With respect to hyperparameter tuning, there is a lot of information about MBO tuning in this manuscript and how it was applied. Looks like this got overlooked/not understood.

> In the Introduction section, it mentioned this study aims to show how high-dimensional datasets can be handled effectively with ML methods. In the past decades, many studies were proposed to solve this problem, such as feature selection methods and feature extraction methods. While this manuscript tried to give the importance of different feature sets by using some ML methods, the authors should give a detailed theoretical analysis on it.

Unclear to me what theoretical analysis is desired?

> Deep learning methods are also explores in feature selection, the related methods should be included and discussed in this manuscript. For example, Deep Learning Based Feature Selection for Remote Sensing Scene Classification, IEEE Geoscience and Remote Sensing Letters (Volume: 12, Issue: 11, Nov. 2015).

No, Deep learning has no place and/or justification in this manuscript.

> The performances of different kernels in SVM should be included in experimental results.

The evaluation of different SVM kernels is out of scope here and would most likely not add additional benefits.

> PCA were used in assess the complexity of the three feature sets. Independent Component Analysis (ICA) is to ﬁn d a linear representation of non-Gaussian data so that the components are statistically independent, why do you choose the PCA method?

I don't know of ICA but I don't think that PCA is a wrong choice here. Even if ICA is valid, we need to make a choice for a subset of methods to be compared at some point. But as Alex already hinted, ICA might not be a good choice here.

> In the experiments, the authors did not introduce the training and testing sets. So, how to evaluate the algorithm?

This sounds like the reviewer did not read the manuscript in detail or does not understand cross-validation.

> What is the main contribution of the manuscript?

I am a bit worried about such a question.
The manuscript shows how to handle high-dimensional datasets derivded from hyperspectral data using filter-based feature-selection in the use case of forest health monitoring.
This is essentially what is being stated in the first three sentences of the abstract.
