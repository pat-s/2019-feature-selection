# Reviewer 2

```sh
Yes	Can be improved	Must be improved	Not applicable
Does the introduction provide sufficient background and include all relevant references? (x)	( )	( )	( )
Is the research design appropriate? 							 ( )	(x)	( )	( )
Are the methods adequately described? 							 ( )	(x)	( )	( )
Are the results clearly presented?							 ( )	(x)	( )	( )
Are the conclusions supported by the results?						 (x)	( )	( )	( )
```

> This study aimed to investigate if feature selection could affect tree defoliation estimation using hyperspectral data. The authors mainly focused on comparing the performance of different machine learners, feature sets and feature selection algorithms, which makes it just a comparison study. Also, due to the very small study sites, I think the results are not transferable in other contexts. My major concern is that the study did not well explain the relationship between the technical results and the response variable. The results and discussion were presented mainly focusing on the algorithms, which is not consistent with the title.

Thank you for the feedback and for reviewing this manuscript!
A sample of 1808 observations might appear small compared to other machine learning applications these days, however, sampling such an amount of observations in the field requires intense work over several days/weeks.
We also would have liked to work with even more observations; being able to even better showcase intra-plot differences and possible fitting better models.
Unfortunately in environmental work there are always practical limits, especially with respect to data collection.
We have discussed the limitations of the data used in section 4.5 and also mentioned the poor performance of the models.
Nevertheless, we still believe that the content of this study adds value for the community, event though more from a methodological than a practicable point of view.

Yet we agree that the relationship between the results and the response variable (and by that with tree health) were not addressed in greater detail so far.
Hence we have added the following section to improve this:

\subsection{Practical implications on defoliation and tree health mapping}
Even though this work has a strong methodological focus by comparing different benchmark settings on highly-correlated feature sets, implications on tree health should be briefly discussed in the following.
Due to the outlined dataset issues in \autoref{subsec:data-quality}, which are mainly responsible for the resulting poor model performances, the trained models are not suited for practical use, e.g. to predict defoliation in unknown area, due to the high mapping uncertainty.
Yet the general approach of utilizing hyperspectral data to classify the health status of trees partly lead to promising results:
For example, due to the narrow bandwidth of the hyperspectral sensor small parts of the spectra (mainly in the infrared region) were of higher importance to the models (e.g. see \autoref{fig:fi-permut-vi-hr}), meaning they helped the models to distinguish between low and high tree defoliation.
If spatial offset errors of the image data and possible background noise can be reduced (possibly by making use of image segmentation), we believe that model performances could be substantially enhanced.
Such improved models, starting around an RMSE of 20\% and less, should be able to provide added value to support the longterm monitoring of forest health and early detection of fungi affected tree plots.
Though overall the usage of defoliation as a proxy to forest health should be critically questioned as it comes with various practical issues, starting from potential offsets during data collection, varying leaf density due to tree age and differing effects between tree species, to just name a few.

> Tree defoliation is an important indicator of tree health and is the response variable of this study. However, I only saw two sentences mentioning it.

Thanks for the feedback.
Defoliation is an important part of this manuscript and we've reviewed our introduction of the terminology:
"Defoliation" was already six times mentioned in the introduction section.
Nevertheless, we have added more context to why defoliation can be a promising proxy for tree health in l.33 - l43.
We hope that overall the provided information will now suffice to introduce the topic of defoliation to the reader.
Please note that besides analyzing tree defoliation there is a strong focus on methodology in this work, which is why defoliation has been introduced only briefly compared to tree defoliation studies found in forest ecology journals.

> Lines 55-57, there are many studies using ML and hyperspectral data to assess defoliation. It seems that the authors didn't do any literature review on this topic?

Thanks for sharing your expertise with us.
We have done another literature research and it seems we have indeed missed related research on this topic.
We have now added five more references which relate to the overarching topic of hyperspectral data in relation to tree health and rephrased the paragraph as follows:

"In recent years, various studies which have utilized hyperspectral data to analyse pest/fungi infections on trees were published:
Pinto et al. \citep{pinto2020} successfully used hyperspectral imagery to characterize pest infections on peanut leafs using random forest while Yu et. al \cite{yu2021} aimed to detect Pine wilt disease in pine plots in China using vegetation indices derived from hyperspectral data.
Other studies which applied hyperspectral data for forest health monitoring are \cite{lin2014,kayet2019,dash2017}.
Building upon these successful applications of hyperspectral remote sensing usage in the field of leaf and tree health monitoring, this work analyses tree defoliation in northern Spain using airborne hyperspectral data."

> Lines 58-62 should be moved to the end of the introduction where you briefly introduce the overall methodology of your study.

Thanks for the suggestion.
We moved the mentioned paragraph to the end of the introduction.

---

Commenting on the remarks of grammar and style, we'd like to mention that we have used a professional software to check for style and grammar issues.
We hope this improved the language quality of the manuscript.
