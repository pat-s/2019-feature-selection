# Reviewer 3 - Iteration 1

Thanks for taking time to review our manuscript.
Please find our replies inline.

> This study analyzed defoliation of trees in northern Spain by using hyperspectral data as input for machine learning models which used hyperparameter tuning and filter-based feature selection.
The idea of this paper is interesting and the technical presentation sounds reasonable.
However, I still feel that the paper is much more suitable for JSTARS since it focuses on very specific domain and application field, whereas the methodological novelty is not significant for publication in TGRS.
Some detailed comments are as follows:

> 1. I would like to see what is the SNR level of the hyperspectral data, because usually the SNR makes it possible or not to identify the hyperspectral information.

We would like to thank the reviewer to consider discussing the Signal-to-Noise ratio (SNR) of the input data.
Unfortunately the SNR is unknown to us and was not provided along with the spatial data from the company which acquired the images.
To our knowledge there is no way to retrieve this information post-hoc.
Hence we did not discuss this point in the manuscript.
On the other we believe that not discussing the SNR of the hyperspectral data is not a heavy shortcoming in this study.

> 2. I also would like to see the information redundancy that existed in the original bands, as well as in the very high dimensional constructed 7471 NRIs.

Thanks for pointing towards the information redundancy characteristic of the dataset.
We agree this is an interesting point to look at.
We added the results of a PCA for all feature sets in Figure 3 and briefly described the results in the manuscript.

Depending on the feature set between two (HR) and five (VI) PC are needed to explain 90% of variance.
The less PC are needed to reach a high proportion of variance explained the more similar are the individual features to each other.
Hence, a high intra-feature correlation can be observed for feature set HR which only requires 2 PC to reach 90% of variance explained.
Feature sets NRI and VI are more diverse and require four (NRI) and five (VI) PC to explain 90% of the variance in the data.

> 3. RF is usually effected by the randomization of the training process, did you only run one shot, or it is the average result from multiple trails?

As outlined in "Methods - Benchmarking Design - Spatial Resampling" a fixed spatial CV on the fold level was conducted.
This means that each model was fitted four times with different training and test sets.
With respect to RF, 500 trees (hyperparameter `n_trees`) were fitted in each model fit.
This hyperparameter value is not listed in the table of used hyperparameters because it was kept static (with 500 trees being the default of RF) and not tuned.

Because we used a partioning method which relies on fixed data splits (1 fold = 1 plot), no more than four runs were possible.

> 4. The main novelty should be emphasized again which to me it is not significant and clear at this stage of presentation. Some conclusions are commonly known to all for hyperspectral feature extraction and classification. So which are the unique contributions or novelties from this work should be highlighted again.

Thanks for pointing this out.
Apart from showcasing best practices of hyperspectral data processing and modelling, so far no work was done using filter methods (and especially ensemble filters) in a high-dimensional feature space retrieved from hyperspectral remote sensing data.
The special case here is that hyperspectral-based high-dimensional data is different to high-dimensional data from non-hyperspectral datasets due to the high similarity of the input layers.
In our view, the use of filters methods in machine learning is pretty much non-existent yet, especially in environmental modeling.
This study shows how these can possibly be used in high-dimensional scenarios on a real world dataset.
In addition, it compares the performance of ensemble filters in such a scenario.
Last, the complete study is embedded in a single ML framework with the full code being provided to make the study fully reproducible and possibly reusable in future studies.
