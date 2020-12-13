# Iteration 1

This paper discussed the feature importance and feature combination when using filter-based machine learning methods to implement feature selection for hyperspectral remote sensing datasets.
This paper aims at discussing a great open issue for hyperspectral image processing.
However, theoretical analysis is insufficient.
The innovation part of this paper is unclear.
Moreover, there are some technical and theoretical issues unclarified.
Therefore, this paper is not suitable for publication on IEEE TGRS.
My comments are as follows.

> 1/ In P1L48, is there any reference to support the NRI index?

FIXME: add reference to NRI index

> 2/In P4L31, please give more details of the formula (1) and add a corresponding reference.

> 3/In P4L56, formula (2) is not the information gain, it is more like mutual information.
> And there is no condition entropy in the formula (2). I am confused for the description of formula (2).

> 4/There is no theoretical analysis in the experiments section. All the conclusions are obtained from observation. It is not convincing.

Thanks. Could you please clarify what you mean with "experiments" section? - There is no such section or paragraph in this study.
In case you are referring to the "discussion" section: there is a paragraph named "Comparison to other studies" which compares the results of this study against other scientific articles of the recent past.

> 5/The feature selection issue of machine learning method for hyperspectral datasets is a great issue. The designed experiments are insufficient to support your conclusions. For example, the hyperparameters have great influence on machine learning methods. How to insure the predictive results are only influenced by the feature combination rather than the hyperparameters? The current method for this issue is not convincing. Moreover, the settings of the benchmark algorithms are not provided.

Thanks.
We agree that hyperparameters play an important role in any kind of modeling.
In this work the hyperparameters of each model are optimised using model-based optimization, ensuring that the hyperparameters are tuned with respect to the variables of the respective scenario at hand (i.e. the respective subset of the data selected by the feature selection step).

In a scenario which optimises both the feature space and hyperparameter space, the results will always be dependent on both selected hyperparameters and the effectiveness of feature selection.
However, by keeping the tuning settings constant and only varying the filter methods, a fair comparison can be made for the latter.

Please clarify in more detail why the experiments should be not sufficient to support our conclusions.

> 6/ Please clarify how to choose training samples for each algorithm. If the training samples are selected randomly, the experiments should be repeated at least 30 times independently and obtain mean values and variance values of results for fair comparisons.

Training samples were not chosen at random but followed a predefined, plot-based partitioning scheme.
The same training sets were chosen for each algorithm.
Please see section "Spatial resampling" for detailed information.
