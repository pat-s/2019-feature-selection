# Iteration 1

> The manuscript TGRS-2020-01814, “Monitoring forest health using hyperspectral imagery: Does feature selection improve the performance of machine-learning techniques?” is comparing different ML algorithms to a tree defoliation in-situ data set of Monterey Pine in northern Spain together with hyperspectral imagery.Although the general idea of the paper is sound, some major methodological and technical issues have to be solved before publication.
> My main concerns are the general spatial relation of in-situ measurements with the hyperspectral imagery, which appears to be inconsistent as well as the overall performance of all models (RMSE of max. 28 %). With such low accuracies it should be thought of the wrong timing of the data acquisition (September to October – very late in the phenological phase to detect defoliation; + low sun angle in the northern hemisphere) as well as a strange sampling of trees (buffer of 2 meters instead of a proper segmentation or linear delineation). From the point of view of applied forestry, these issues have to be solved to gain a consistent and meaningful result, before tuning and comparing filters or ML algorithms.

Thanks for reviewing our manuscript and sharing your expertise with us.
We agree that the predictive performances obtained are not overwhelming, and certainly lower than expected.
However, we also believe that "success bias" is a major issue in science which leads to rejection of studies due to low/fair accuracies of models.
We think that this manuscript might suffer from this potentially due to the reported accuracies which might lead to the feeling of an "unsuccessful" study.
Model accuracies depend on many factors (data, algorithm, preprocessing) and are therefore naturally limited by these factors.
We believe that a correct methodology is more important than the overall achieved accuracy.

We also agree that the image acquisition date may not be ideal with respect to phenology.
As so often, the actual date was not entirely controlled by phenological considerations, but it got delayed due to the timing of project funding and other practical constraints.
Nevertheless, the results do show that the data is useful for the purpose for which it was acquired.
We discuss this point in section "Data quality".

The use of segmentation techniques is also an interesting recommendation.
We agree that applying a tree-crown segmentation first could potentially increase the accuracy of some models.
However, the actual effect of such a preprocessing would be unclear and make the study more complex, involving additional hyperparameters that control the behaviour of the segmentation algorithm.
In addition it would draw the focus away from the actual main points of the study - the comparison of (ensemble) filter-based feature selection methods in combination with narrow-band remote sensing data.
We therefore consider this an excellent recommendation for future work, and in particular for the application of the proposed techniques to more heterogeneous stands.

We have also added another paragraph mentioning potential data issues leading to reduced performances in the discussion:

"In addition, data quality issues might have an influence on model performances.
These include the timing of the acquisition of the hyperspectral data (late phenological phase), field measurement errors when surveying defoliation, the influence of background reflectance (e.g. soil reflectance) and the possible positional offset of measured GPS coordinates of trees."

We very much hope that the reviewer will be satisfied with our responses and the changes made to the manuscript to address the comments and openly communicate any remaining uncertainties.

**Major Comments:**

> - Please proved more information of the hyperspectral data-set. How was the radiometric, atmospheric and geometric correction done? Why two acquisition dates?

We agree that this is an important metadata information.
Note that these preprocessing tasks were done externally by an experienced, specialized service provider (Institut Cartogràfic i Geològic de Catalunya).
Because we think that this detailed information on data preprocessing might extend the data section too much, we decided to add it to appendix F.

**Sensor Characteristics**

The AisaEAGLE II sensor was used for airborne image acquisition with a field of view of 37.7°.
Its spectral resolution is 2.4 nm in the range from 400 to 1000 nm.


**Radiometric Correction**

"The conversion of DNs to spectral radiance was made by using a software designed for the instrument. Images are originally scaled in 12 bits but they were radiometrically calibrated to 16 bits, reserving the highest value: 65535, for null values.
The procedure was applied on the 23 previously selected images. Thereafter, the geometric and atmospheric corrections were further applied on them."

**Geometric Correction**

"The aim of this procedure was to reduce the positional errors of the images.
The cartography of reference was GeoEuskadi, UTM, zone 30, datum ETRS-89.
The position was accomplished by coupling an Applanix POS AV 410 system to the sensor, which integrates GPS and IMU systems. The system provides geographic coordinates of the terrain and relative coordinates of the aircraft (attitude) at each scanned line. Additionally a DSM from GeoEuskadi with a spatial resolution of 1 m was used.
The ortorectified hyperspectral images were compared to orthoimages 1:5000 of GeoEuskadi and the RMSE was calculated, which was below the GSD in the across and along track directions"

**Atmospheric Correction**

"The radiance measured by an instrument depends on the illumination geometry and the reflective properties of the observed surface.
Radiation may be absorbed or scattered (Rayleigh and Mie scattering). Scattering is responsible of the adjacency effect, i.e., radiation coming from neighbors areas to the target pixel.
The MODTRAN code was used to modelling the effect of the atmosphere on the radiation.
To represent the aerosols of the study area the rural model was used, and the optical thickness was estimated on pixels with a high vegetation cover.
Columnar water vapor was estimated by a linear regression ratio where the spectral radiance of each pixel at the band of the maximum water absorption (~906 nm) is compared to its theoretical value in absence of absorption. Nonetheless, this technique is unreliable when a spectral resolution as the one required here is used.
To resolve this, the water vapor parameter was selected manually according to the smoothness observed on the reflectance peak at 960 nm.
The mid-latitude summer atmosphere model was also used.
The output of this procedure was reflectance from the target pixel scaled between 0 and 10,000."

**Acquisition days**

"The image acquisitions were originally attempted during one day (29.10.2016) but due to the variable meteorological conditions some stands had to be imaged the next day."

> - Please provide information on in-situ data. How was the defoliation measured? Is there an estimation error included?

Defoliation was assessed visually by experienced forest pathologists supervised by E. Iturritxa (co-author).
Values were recorded at three levels of the tree in 5-percent intervals.
These three values were averaged to obtain an overall percentage.
No estimation error was recorded.
We added this information to the section describing the in-situ data.

> - The sampling of a 2 meters buffer around a centroid of each tree seems to be not the best solution. I think the authors will have major problems with overlapping samples. Let’s take the site Laukitz 1, which is has a size (according to figure 2) of 50 m x 100 m = 5000 m². Given the buffer of 2 m, at least 4 m² are included in one sample (probably more). With a sample size of 559, I estimate 2236 m² of samples: There will be definitely pixels which belong to several samples. The authors should avoid this by using a segmentation (e.g. watershed) algorithm and receive exclusive samples of each tree crown. If there is no differentiation between crowns possible it is better to work with less samples that inconsistent ones.

Thanks for discussing the use of the 2m buffer in greater detail.
We have reviewed the use of the 2m buffer and decided to reduce it to 1 m (which almost always results in four contributing pixels).
This reduces the overlap of samples and still accounts for possible geometrical offsets which is a fair compromise in our view.
Please see the paragraph below for more thoughts on this topic.

We agree that the use of a buffer (or in fact the existence of a geometric offset) provides discussion potential in this work.
There were long discussions among the authors if and how to tackle this problem.
We concluded to use a buffer and by this to average the values of the neighboring pixels of each tree observation.
We are aware that this blurs the extracted value to some degree but might as well prevent from including pure non-tree pixels.
We also did a small exploratory analysis on the effect of the buffer size: <https://pat-s.github.io/2019-feature-selection/eda.html#effects-of-different-buffer-sizes-when-extracting-values-to-trees>.
However we decided not to include this figure into the paper as no clear results can be drawn from it.
Additionally it would mainly cause more guessing and move focus away from the main topic of the paper.

We think that there might not be a perfect solution to this and all proposed ones (including doing nothing at all) will have some downside.
With respect to the suggestion to use segmentation: we agree that this would be an interesting option.
However note that there is no problem identifying the trees or their exact location.
The issue is with the potential offset of the hyperspectral image of up to 1 m, possibly resulting in a non-match of a tree point and its actual corresponding pixel.

> - As the equation of the NRIs , the generic term of the normalized indices is used (NDVI). However, there is a variety of other structured types of indices – please justify your choice.

We would like to thank the reviewer for pointing out the existence of alternative base formulas for NRI calculation.
In general the NRI concept is based on the "Optimized multiple narrow-band reflectance" (OMNBR) approach by [Thenkabail et al. (2000)](thenkabail2000) and also described in [Thenkabail et al 2018](https://www.taylorfrancis.com/books/hyperspectral-indices-image-classifications-agriculture-vegetation-prasad-thenkabail-john-lyon-alfredo-huete/e/10.1201/9781315159331).
One reason to use the NDVI-type index formulation for NRI calculation was its availability in the R package [{hsdar}](https://cran.r-project.org/web/packages/hsdar/index.html) in the function [nri()](https://rdrr.io/cran/hsdar/man/normalized.ratio.index.html).
Other indices, e.g. obtained by simple ratioing, would be expected to be very strongly correlated with the corresponding NRIs.
Corresponding the already remarkably high dimensionality of feature space, it would be less likely that such further enhancement of feature space would lead to any improvements.
Our data and code are of course available for follow-up studies that might focus on different feature extraction strategies.

> - The RMSE alone is not a good quality measure, since it is highly dependent on the variance of the sample (as the authors describe themselves in the manuscript). Please supplement this measure with another one, e.g. R² (but there are more sophisticated ones around) to evaluate the quality of your results.

FIXME: schauen was bei r-sq im neuen run raus kommt.
Thanks for suggesting to take another look at the chosen measure(s).
We have chosen RMSE as it is defined in the unit of the response variable and the resulting value can therefore be interpreted by domain experts.
In contrast the $R^2$ shows how much variance of the response variable has been explained by the model and might be more complex to interpret in the current case.
It may also be problematic to average $R^2$ values across multiple cross-validation test sets since each of them has a different variance of the response variable, which changes the denominator of $R^2$ between test sets.
Nevertheless we have added the $R^2$ values for the best performing models to supplement the RMSE measure.

> - Moreover, I would suggest to show a few scatterplots (Observed vs predicted) of the models, e.g. from the best performing combination, to show effects, such as clustering of values or over/underprediction.

Thanks for suggesting to include observed vs. predicted plots to enhance this article.
While this is in general an interesting evaluation approach if there is a single final prediction which can be compared against observed values, the comparison here would need take place on the partition levels of the cross-validation, hence with just subsets of the data.
We also think such plots would add another layer of side-analysis which would not complement the overall scope of the article.

>   Minor comments:
> - Fig.2: This figure is really small, perhaps you can enlarge it a bit, at least for a subset of one of the sites

Thanks for noticing.
We modified the figure to now span across the full page width.
In addition, some UI improvements were applied to the figure.

> - III.B / 1) Filter methods: large parts of the text are general information on filters and no method – you should move it to the introduction section

Thanks for discussing the topic of filters and their role in this manuscript.
Filters play an important role in this study which is why we explain their theory in general in the methods section.
Due to the extra focus on ensemble filters in this article we also see the need to explain their specific theory in this context.
In our view this part is essential and shifting it to the introduction would make the introduction too long and include too much theoretical content, even when reducing the amount of information.
We therefore think that the section about filter methods, wrapped inside the "feature selection" section, is fine in this article.

> - Vegetation indices: the authors work with 86 pre-defined indices but never name them (and use later, e.g. Fig.6 abbreviations of them) – please provide a consistent list (with references), probably best in the appendix

Thanks for being interested in the used vegetation indices.
We added a new table to the appendix listing all used vegetation indices, their formulas and references as Appendix E.

> - ALE seems to have to really huge effect – consider to skip this part of your analysis

Thanks for reconsidering ALE plots in this study.
We are aware that ALE plots are hard to interpret and not the main focus of this study.
That is why we discussed them only briefly in the manuscript and put the figure into the appendix.
However, we would prefer to keep them in the manuscript to make readers aware of their existence and advantages in such situations, possibly leading to more studies making use of ALE plots in a more prominent way.

> - You mention problems with low defoliation levels, but in practical terms these are the most important for early detection of a disease. Consider to sub-divide your sample in high and low defoliation levels and investigate on the detection rates, since to has some value for later application.

Thanks for discussing the issue of low defoliation levels in this study.
The problems we refer to relate to the lack of observations with a small defoliation value across most plots.
Due to the existence of low defoliation values in only one plot, the fitted models on all other plots, which predict on Laukiz2 (the plot with the most low defoliation values), will likely make poor predictions because they lack training data with low defoliation values.
Because we aim to fit general models that span across all defoliation values, we would not be able to conduct the desired analyses and discussions by splitting the dataset in subsets containing only low or high defoliation values.
In addition we would need to justify at which defoliation rate the data would be split.
Moreover this would double the amount of datasets and hence the models to be fitted which would result in an unfeasible benchmark matrix setting.

> - V.E: You should at least mention that a multi-temporal data-set might have a huge advantage + the SWIR bands are missing, which are mentioned in the body of literature of forest diseases as highly important.

Thanks for discussing the importance of the sensor's wavelength range.
We agree that bands in the SWIR region could help in this study and in general when working with vegetation data.
A multi-temporal dataset consisting of matching RS and ground-truth information might also help to enhance the performance of models in such scenarios, especially if different phenology stages are included.
We have added a paragraph which discussed this shortcoming in section "Data Quality":

"The available hyperspectral data covered a wavelength between 400 nm and 1000 nm.
Hence, the wavelength range of the shortwave infrared (SWIR) region is not covered in this study.
Given that this wavelength range is often used in forest health studies \cite{hais2019}, e.g. when calculating the \ac{NDMI} index \cite{gao1996}, this marks a clear limitation of the dataset at hand."

> Last point: I do not state all small points I noted down, because this is almost impossible in an already fully formatted manuscript. Please provide next time a single-columned manuscript with a clear line numbering to make a reference in the text possible!

We are sorry that you had trouble with the submitted manuscript format.
We tried to submit the manuscript using the "draft" option in a one-column format in the first place (which has numbered lines and a larger linewidth).
This submission was not accepted by the system for some reasons and we were asked to resubmit a PDF in the current form (without draft settings).
We try to submit again in a format more suitable for review purposes.
In case we miss something obvious with respect to LaTeX submissions, please contact us directly.
