# Reviewer 2 - Iteration 1

Thanks for taking time to review our manuscript.
Please find our replies inline.

> This paper discussed the feature importance and feature combination when using filter-based machine learning methods to implement feature selection for hyperspectral remote sensing datasets.
This paper aims at discussing a great open issue for hyperspectral image processing.
However, theoretical analysis is insufficient.
The innovation part of this paper is unclear.
Moreover, there are some technical and theoretical issues unclarified.
Therefore, this paper is not suitable for publication on IEEE TGRS.
My comments are as follows.

> 1/ In P1L48, is there any reference to support the NRI index?

We added two references to support the definition of the NRI index.

> 2/In P4L31, please give more details of the formula (1) and add a corresponding reference.

The formula is a generic one with the idea to create data-driven indices which can possibly find patterns in the data that are not covered by traditional indices.
It is based on the "Optimized multiple narrow-band reflectance" (OMNBR) approach by [Thenkabail et al. (2000)](thenkabail2000) and also described in [Thenkabail et al 2018](https://www.taylorfrancis.com/books/hyperspectral-indices-image-classifications-agriculture-vegetation-prasad-thenkabail-john-lyon-alfredo-huete/e/10.1201/9781315159331).
In addition it was programmatically implemented in the R package [{hsdar}](https://cran.r-project.org/web/packages/hsdar/index.html) in the function [nri()](https://rdrr.io/cran/hsdar/man/normalized.ratio.index.html)
NRIs can be calculated in various ways and are not limited to follow the 'difference divided by sum' scheme of the NDVI index.
Nevertheless, different index formulations involving the same spectral bands will be very highly correlated, providing little to no additional useful information.
Since the {hsdar} package uses the NDVI formula for NRI calculation this index was used for NRI calculation in this study.
We have added the additional information to the manuscript.

> 3/In P4L56, formula (2) is not the information gain, it is more like mutual information.
> And there is no condition entropy in the formula (2). I am confused for the description of formula (2).

Thanks for suggesting to double-check the information gain equation.
We agree that some references and additional information can help the reader to understand the formula more easily.
The {FSelectorRcpp} package makes use of "Shannon Entropy" as shown in the formula and in its [package documentation](http://mi2-warsaw.github.io/FSelectorRcpp/reference/information_gain.html).
Here Shannon Entropy is defined as `H(X)` which itself is defined as

$H(X) = - \sum_{i=1}^{n} P(x_i)\log_2P(x_i)$

as in [Shannon 1948](https://ieeexplore.ieee.org/document/6773024).
The Shannon formula is more often referred to as "information gain".

We've added this additional information and the Shannon reference to the manuscript.

> 4/There is no theoretical analysis in the experiments section. All the conclusions are obtained from observation. It is not convincing.

Thank you for these useful suggestions for improving this part of the manuscript.
Given the unique characteristics of different applications, like detecting forest disease from hyperspectral imagery, it is necessary to learn from representative case studies, since there is not theoretical proof of the superiority of one algorithm in this application.
Nevertheless, we believe that we have found clear empirical evidence of the superiority of one machine-learning model in this use case, and we have identified potentials but also limitations of feature selection techniques in this setting.
We have attempted to highlight these findings more clearly in the revised manuscript.

In the discussion section (5) we specifically discuss various aspect of this study, from data quality to empirical performance results, the effect of feature selection methods over to how the resulting feature importance measures can be linked back to the spectral characteristics of the data.
Last we compare our work with similar studies from recent years.
We believe that our work is a valuable contribution to the fields of environmental modeling and feature-selection, bridging the gap between applied modelling and simulated benchmarking studies, especially by incorporating your valuable remarks to this manuscript.

> 5/The feature selection issue of machine learning method for hyperspectral datasets is a great issue. The designed experiments are insufficient to support your conclusions. For example, the hyperparameters have great influence on machine learning methods. How to insure the predictive results are only influenced by the feature combination rather than the hyperparameters? The current method for this issue is not convincing. Moreover, the settings of the benchmark algorithms are not provided.

We would like to thank the reviewer for addressing these issues, which encourages us to explain these important technical aspects in more detail.

First, we completely agree that hyperparameters play a critical role in controlling the flexibility of machine-learning techniques, especially in the case of SVM.
Since hyperparameters implement penalization and shrinkage, their optimal values will inevitably also depend on the features being selected, or the decision to perform feature selection at all.
This is exactly the reason why model hyperparameters and feature selection hyperparameters were tuned jointly.
In our manuscript we specifically state this by saying that "the percentage of features was added as a hyperparameter".

This joint tuning is precisely *necessary* to address the second issue raised by the reviewer, the ability to separate hyperparameter from feature selection influences.
If we didn't re-tune the (model) hyperparameters for each feature selection setting, we'd be using non-optimal hyperparameter, which would be an unrealistic and unfair disadvantage for feature selection techniques.
We are comparing feature selection techniques with each other, and with models without feature selection, under otherwise equal experimental conditions - i.e. optimal hyperparameters for all.

Hyperparameters were optimized using model-based optimization, which is a state-of-the-art tuning approach.
We tried making the used benchmark settings more visible in the revised manuscript by linking Tables VIII (Hyperparameter settings) and VII (best ten benchmark settings overall) more dominantly.
Also at the end of section 3.3 (Benchmarking design) we describe the full benchmarking setting and how it is composed.

Finally, the entire code is made available in an open-access Github repository.
This will not only make the present research reproducible, but it will also allow other researchers to apply the same settings to other use cases.

> 6/ Please clarify how to choose training samples for each algorithm. If the training samples are selected randomly, the experiments should be repeated at least 30 times independently and obtain mean values and variance values of results for fair comparisons.

Training samples were not chosen at random but followed a predefined, plot-based partitioning scheme, i.e. a spatial cross-validation.
This is designed to assess the transferability of the learned relationship to other forest plots.
The same training sets were chosen for each algorithm to ensure comparability.
Please see section "Spatial resampling" for detailed information.
