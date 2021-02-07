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

The formula is a generic one with the idea to create data-driven indices which can possibly find patterns in the data taht are not covered by traditional indices.
It is based on the "Optimized multiple narrow-band reflectance" (OMNBR) approach by [Thenkabail et al. (2000)](thenkabail2000) and also described in [Thenkabail et al 2018](https://www.taylorfrancis.com/books/hyperspectral-indices-image-classifications-agriculture-vegetation-prasad-thenkabail-john-lyon-alfredo-huete/e/10.1201/9781315159331).
In addition it was programmatically implemented in the R package [{hsdar}](https://cran.r-project.org/web/packages/hsdar/index.html) in the function [nri()](https://rdrr.io/cran/hsdar/man/normalized.ratio.index.html)
NRIs can be calculated in various ways and are not limited to follow the NDVI index.
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
The Shannon formula is more often recognized as the "information gain" formula.

We've added this additional information and the Shannon reference to the manuscript.

> 4/There is no theoretical analysis in the experiments section. All the conclusions are obtained from observation. It is not convincing.

We are sorry to hear that you are not satisfied with parts of the manuscript.
Obtaining conclusions from results of a study is good scientific practice which is why we framed the discussion around it.
The discussion section (5) discusses various aspect of this study, from data quality to performance results, the effect of feature selection methods over to how the resulting feature importance measures can be linked back to the spectral characteristics of the data.
Last we compare our work with similar studies from recent years.
We believe that our work is a valuable contribution to the fields of environmental modeling and feature-selection, bridging the gap between applied modelling and simulated benchmarking studies, especially by incorporating your valuable remarks to this manuscript.

> 5/The feature selection issue of machine learning method for hyperspectral datasets is a great issue. The designed experiments are insufficient to support your conclusions. For example, the hyperparameters have great influence on machine learning methods. How to insure the predictive results are only influenced by the feature combination rather than the hyperparameters? The current method for this issue is not convincing. Moreover, the settings of the benchmark algorithms are not provided.

We would like to thank the reviewer for raising the issue of optimizing hyperparameters and features jointly.
We agree that optimizing both is not a trivial task and has potential for mistakes.
In this work the hyperparameters of each model were optimized using model-based optimization, ensuring that the hyperparameters are tuned with respect to the variables of the respective scenario at hand (i.e. the respective subset of the data selected by the feature selection step).
Feature selection parameters were treated in the same way as model hyperparameters, i.e. they were optimized during the same stage as model hyperparameters.
This makes it possible to avoid a two-stage optimization procedure as it would be the case when using wrapper methods instead of filters.
In our believe there is no way to fully denote the influence of the respective feature selection method on the final performance result due to the joint optimization process.
However, model hyperparameters needs to be trained and by fixing the tuning range of such and only varying the filter method, we to some degree judge the influence of the chosen method.
In addition we tried making the used benchmark settings more visible in the manuscript by linking Tables VIII (Hyperparameter settings) and VII (best ten benchmark settings overall) more dominantly.
Also at the end of section 3.3 (Benchmarking design) we describe the full benchmarking setting and how it is composed

> 6/ Please clarify how to choose training samples for each algorithm. If the training samples are selected randomly, the experiments should be repeated at least 30 times independently and obtain mean values and variance values of results for fair comparisons.

Training samples were not chosen at random but followed a predefined, plot-based partitioning scheme.
The same training sets were chosen for each algorithm.
Please see section "Spatial resampling" for detailed information.
