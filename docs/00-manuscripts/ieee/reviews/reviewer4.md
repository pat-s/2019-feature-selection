# Iteration 1

The manuscript TGRS-2020-01814, “Monitoring forest health using hyperspectral imagery: Does feature selection improve the performance of machine-learning techniques?” is comparing different ML algorithms to a tree defoliation in-situ data set of Monterey Pine in northern Spain together with hyperspectral imagery. Although the general idea of the paper is sound, some major methodological and technical issues have to be solved before publication.

> My main concerns are the general spatial relation of in-situ measurements with the hyperspectral imagery, which appears to be inconsistent as well as the overall performance of all models (RMSE of max. 28 %). With such low accuracies it should be thought of the wrong timing of the data acquisition (September to October – very late in the phenological phase to detect defoliation; + low sun angle in the northern hemisphere) as well as a strange sampling of trees (buffer of 2 meters instead of a proper segmentation or linear delineation). From the point of view of applied forestry, these issues have to be solved to gain a consistent and meaningful result, before tuning and comparing filters or ML algorithms.

Major Comments:

> - Please proved more information of the hyperspectral data-set. How was the radiometric, atmospheric and geometric correction done? Why two acquisition dates?
> - Please provide information on in-situ data. How was the defoliation measured? Is there an estimation error included?
> - The sampling of a 2 meters buffer around a centroid of each tree seems to be not the best solution. I think the authors will have major problems with overlapping samples. Let’s take the site Laukitz 1, which is has a size (according to figure 2) of 50 m x 100 m = 5000 m². Given the buffer of 2 m, at least 4 m² are included in one sample (probably more). With a sample size of 559, I estimate 2236 m² of samples: There will be definitely pixels which belong to several samples. The authors should avoid this by using a segmentation (e.g. watershed) algorithm and receive exclusive samples of each tree crown. If there is no differentiation between crowns possible it is better to work with less samples that inconsistent ones.
> - As the equation of the NRIs , the generic term of the normalized indices is used (NDVI). However, there is a variety of other structured types of indices – please justify your choice.
> - The RMSE alone is not a good quality measure, since it is highly dependent on the variance of the sample (as the authors describe themselves in the manuscript). Please supplement this measure with another one, e.g. R² (but there are more sophisticated ones around) to evaluate the quality of your results.
> - Moreover, I would suggest to show a few scatterplots (Observed vs predicted) of the models, e.g. from the best performing combination, to show effects, such as clustering of values or over/underprediction.
>   Minor comments:
> - Fig.2: This figure is really small, perhaps you can enlarge it a bit, at least for a subset of one of the sites
> - III.B / 1) Filter methods: large parts of the text are general information on filters and no method – you should move it to the introduction section
> - Vegetation indices: the authors work with 86 pre-defined indices but never name them (and use later, e.g. Fig.6 abbreviations of them) – please provide a consistent list (with references), probably best in the appendix
> - ALE seems to have to really huge effect – consider to skip this part of your analysis
> - You mention problems with low defoliation levels, but in practical terms these are the most important for early detection of a disease. Consider to sub-divide your sample in high and low defoliation levels and investigate on the detection rates, since to has some value for later application.
> - V.E: You should at least mention that a multi-temporal data-set might have a huge advantage + the SWIR bands are missing, which are mentioned in the body of literature of forest diseases as highly important.

Last point: I do not state all small points I noted down, because this is almost impossible in an already fully formatted manuscript. Please provide next time a single-columned manuscript with a clear line numbering to make a reference in the text possible!
