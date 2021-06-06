# Reviewer 2 - Iteration 2

> The manuscript deals with the optimization of input data for the detection of different damage classes in trees. The different feature selection approaches should simplify the evaluation of hyperspectral data and lead to better results. The topic and the methods are exciting and deal with current interesting problems. The manuscript is well structured and well written even if some minor shortcomings are noticeable.

## General comments

> The biggest problem I see in the hyperspectral data which were analyzed. The spectral signatures are too noisy and do not correspond to any physical basis. Such ups and downs are not justifiable and therefore the data must be filtered/smoothed beforehand - as usual in other studies.

FIXME: Thought: I don't think we need to filter, we do not make any further analysis based on the spectral signatures and they are only shown for reference in Fig.9. It is unclear to me if such a smoothing would have a positive effect and it would probably cause changes in all results.

> I would like to see examples of all damage classes from both the field response and the canopy delineated in the EO data.

FIXME:
- Thought: Don't want to add so many pictures, also partly because we do not have this information.
- Thought: We can offer to send him some in private if he wants to unmask? Or maybe add some to the data repository?

> It is not clear how the hyperspectral information was extracted for each tree. I expect that they had GNSS points for each tree. The approach of using a buffer to avoid the use of non-tree pixels is not correct. If the point is outside the tree crown also the have of the four pixels will be outside. On the other hand, if the pixel is on the tree crown the buffer can lead to include pixels from outside. Therefore, the tree crowns should (manual) delineated, and e.g. the mean of each object should be used!

Thanks for discussing the use of the buffer again.
The tree positions were referenced via GPS sensors in the field, correct.
We believe that the use helps to reduce possible positional errors and disagree that this approach is not correct.
Manual delineation is an alternative approach which is fine to use but which we did not do in this study.

> The discussion chapter is mainly a description of the results and doesn’t include a real discussion. I have to be revised and some parts should be shifted to the results. I want to see more comparison with other studies, both dealing with feature selection and hyperspectral data but also some tree health studies should be included.

FIXME:
- Thought: Does discussion always need to be mainly focus on comparison with other studies? There is even a section only related to this.
- Thought: How to react to such a request?

> Abbreviations introduced should be used consistently afterward.

We harmonized the use of abbreviatons.

> The citation style is sometimes strange and I am not sure if it meets the journal's requirements. If there are multiple sources, I would put all numbers in one square bracket. If the source is used in the body text, I think the name of the author should be also given.

We've used the LaTeX citation style as recommended by the author instructions of the Journal.
We are using the following options

```tex
\documentclass[final]{IEEEtran}
\usepackage[noadjust]{cite}
\bibliographystyle{IEEEtran}
```

which should be accepted by the journal and community judging from [this Texexchange post](https://tex.stackexchange.com/a/44086/104937).


> Tables and Figures have to be understandable stand-alone. Therefore, the captions are often not sufficient. Please revise it and provide more details. Also, units are often missing and abbreviations are not explained.

FIXME

> The quality of the maps should be improved.

FIXME Thought: Quite subjective, to me the map is fine.

> Page 2, Column 2, Line 22: Please use the already introduced abbreviation ML

Thanks, we replaced all instances of machine-learning/machine learning with the abbreviation ML.

> P2, C2, L25: citation style is strange

We've used the LaTeX citation style as recommended by the author instructions of the Journal.
We are using the following options

```
\documentclass[final]{IEEEtran}
\usepackage[noadjust]{cite}
\bibliographystyle{IEEEtran}
```

which should be accepted by the journal and community judging from [this Texexchange post](https://tex.stackexchange.com/a/44086/104937).

> P2, C2, L25: I didn’t get it, please revise the sentence.

Thanks, we clarified the sentence as follows:
"The ability of predicting into unknown space qualifies ML algorithms as a helpful tool for such environmental analyses."

> P2, C2, L46: the index type is well known, but you are right, often not all possible combinations were tested.

> P3, C1, L3, L17: ML instead of machine-learning

Thanks, we replaced all instances of machine-learning/machine learning with the abbreviation ML.

> P3, C1, L44: Are you sure that all these pathogens are invasive?

We believe they are but given that we have no sure proof for this argument in all instances, we removed the term "invasive".

> P3, C1, L54: How was this data obtained? Please add some more details.

We have added "by visual inspection of experts in the field" to make the data collection even more clear.

> P3, C2, Figure 1, L36: The 5% intervals are clear for three test plots. Four Laukiz 2 the intervals between 0 and 15 are smaller. Please clarify. I am also not sure if you can use these values for a regression approach because they are not really metric data.

FIXME: check this

> P3, C2, L29: Standardize the spelling of the plot names (with or without spaces).

We have not found any instances of Laukiz1 or Laukiz2 with spaces between "Laukiz" and its respective count ID, also not in the sentence you referenced.

> P4, Figure 2: Please revise the maps. Add a detailed view of the tree crowns. What is the background image? Single coordinates are not meaningful.

We do not have custom images showing the plots from a birds-eye perspective.
The background images shown are "Bing Aerial" maps queried from within QGIS.
The purpose of these is not to show a high-resolution bird-eye view of the plots but just to give a rough overview of the plot area and its surroundings.

> P4, C1, L44: Spatial resolution instead of geometric resolution?

The difference between these terms is not fully clear, often is assumed that they are the same.
See also [this discussion](https://gis.stackexchange.com/a/170324/43409).

> P5, C1, L15: I traditionally use wrapper methods that obtain sufficient results. Therefore, a comparison of the used filter methods with wrapper methods would be very interesting, both in terms of time and accuracy.

We agree that the comparison of both concepts is an interesting topic, though it is out of scope for this study as the focus is on filter methods.
A literature research for this dedicated question might give more interesting insights.

> P5, C1, L21: I am not a statistician but for me, a filter changes something in the data and does not only rank the original data, but maybe I am wrong.

Filters do not change the data, they simply create a ranking of variables based on their heuristic.
Such rankings can then be used for further variable selection or combined with rankings from other filters (in an ensemble filter scenario).

> P5, C1, L58: Not clear to me. I expect that specific filters work better for specific algorithms. Therefore, I am skeptical that the combination is better if every filter results in different ranks?

The effectiveness of filters is a function of the algorithm, dataset and tuning method used.
Varying one of these parameters might yield substantially different results.
Therefore a benchmarking matrix covering multiple settings and/or combining filter methods is usually used (as also done in this work).
This paragraph refers to the weighing of single filter in the ensemble compilations, which is an important precondition for an unbiased application.

> P5, C2, L41: use the already introduces abbreviation RF

Thanks, we replaced all instances with the acronym.

> P6, C1, L6: The last Table was II, what is the reason to place the next table after five other tables?

Table VIII is placed in the appendix, hence the numbering. We appended the term "appendix" to make this more clear.

> P6, C1, L21: Include Author’s name in the sentence

We manually added it even though it seems not officially supported by the citation style.

> P6, C1, L33-38: I don’t agree. From my experience, the feature selection should be connected to the following method. Therefore, the importance of the features is not the same for all models. Also, high correlated input data are problematic for some algorithms but not for others.

You might potentially misunderstand the content of this paragraph: we removed features with a pairwise correlation of 1.
It is unclear to us what point you want to make here.

> P6, C2, L47: not clear to me. Please explain.

For the permutation-based feature importance on the HR dataset, a learner is required.
We've used the learner which performed best on this task, i.e. SVM.

> P7, C1, L27: What is PCA-based correlation analysis?

We've explained the use of a PCA for correlation analysis in the paragraph.
To make it more clear hopefully, we've changed it slightly to the following:

"PCA was used for a correlation analysis of the feature sets by inspecting the summed percentages of the principal components.
The fewer PCs are needed to reach a high proportion of variance explained the more similar the individual features are to each other."

> P7, C1, L44: use the introduced abbreviation p.p.

Thanks, using the abbreviation now.

> P8, C1, Table III, and IV: From my point of view the Tasks with all input data should outperform the others if the feature selections work well. Therefore, I prefer wrapper algorithms and again I think they should be included for comparison (e.g. stepwise feature reduction based on the RF importance measure).

This study is not about comparing filters to wrapper methods and there is no evidence why tasks with all input data should outperform others.
If there would be, there would be no need a feature selection at all.
Everyone is free to choose their method set and we hope you agree on this point with us.

> The order in Table 3 is not clear, 2 to 10 have the same RMSE. Also, the different SE in 8 is not clear.

The results in table VIII are simply the model results. They are highly similar for the SVM learner, which can happen and is just normal.
Learner SVM on the HR-NR-VI dataset has a slightly higher standard error.

>Table IV: Why does PCA not work and again it is not clear why PCA based on VI only outperforms PCA based on HR-NRI-VI. Also, the better results (compared to PCA) without filters are not clear.

If we would know why certain combinations of learners, feature sets and filters result in certain performances, we would have solved the issue of black-box modeling.
It looks like PCA does not go very well with XGBoost - in our view this is everything one can draw from these non-optimal results in Table IV.

> P8, C1, Table VI: Why did you present these results based on the models without filters? I also want to see the best results using filters.

The purpose of this table is to showcase the fold variance only without making a deliberate choice which filter to use to estimate such.
There is no added value to us in showing this information for all learner/filter/dataset combinations, given that it would require a table with four rows for each.
Also there is no reasoning to assume that different filters would show substantially different fold performances.

You are welcome to compute and visualize these results yourself though, the code and dataset is freely accessible in the linked research compendium.

> P8, C1, L50: p.p. instead of percentage points

Thanks, using the abbreviation now.

> P8, C2 Table VII: Please explain Features (%) and values of 0.999, Values are sorted by test plots not ascending RMSE; # means the number of input data? RMSE Values are strange because higher as without filter and also the completely different results for the test plots are not clear to me: Luiandro achieved the best result without filter, Laukiz 2 (the worst without filter) the best result with RF, Oiartzum the best with XGB and SVM

- `#` denote the absolute number of features used. We've updated the caption.
- `features (%)` refer to the relative percentage of features used judging from the total amount of features (7675). However values were not in percent, we've updated them now. Thanks.
- Correct, values are sorted by test plot name, we've updated it. Thanks.

FIXME: He's right about the strange RMSE results, need to look into it

> P8, C2, Figure 3, include a unit for RMSE, change order of the learners (and also colors) Lasso and Ridge should be next to each other. Why did you include MBO in the name?

- We omitted the unit for RMSE in all other tables/figures. Adding it only here would make things inconsistent. We believe that it should be clear to readers of the study that the unit is percentage points as it is mentioned in various places.
- FIXME: check if MBO labels can be removed
- We see no clear reason putting Lasso and Ridge next to each other, we rather prefer an alphabetical order here. Also we see no reasons to change the color palette.

> P9, Figure 4: The filters improved the results mainly for the task HR. For all others, the no Filter results are within the best results. Please explain how can a filter worsen the performance?

There is no guarantee that the use of filters always improves the result, even though the selection of features is optimized via tuning.
As mentioned and discussed in the study, the outcome is a combination of learner+dataset+filter and using a subset of features might not always result in the best performance.
Also the ranking of certain filters might simply not have a positive effect and result in features being removed even though they would have been helpful to the model in the end.

> P9, Figure 5: Why did you highlight Borda Filter?

Because the use of ensemble filters (i.e. the Borda filter) is a central evaluation point of this work.

> P10, Figure 6: As I mentioned in the general comments you have to apply smoothing before analyzing the spectral signatures. The peak around 950nm is also very strange.

The spectral signatures are only displayed for reference and are not analyzed in more detail, therefore we believe that no smoothing is required here.
The spike around 950nm is visible for all plots and even though the spectral signature of Oiartzun is substantially different compared to the other plots, this is what the data contains.

> What does scaled Reflectance or in the caption normalized reflectance mean?

Normalized reflectance between [0, 1] as shown on the axis title.

> P11, C1, L47: not instead of no

Thanks.

> P11, C1, L56-58: PCA obtained the worst results!

It did and this is what we wrote in l.52 - 56.
It also reduced model fitting times, which is fair to mention.
Your comment is not clear to us here.

> P11, C2, L10-11: Instead of “not surprisingly” I would prefer citing other studies which obtained similar results.

We believe that this statement does not need to backed up by additional references.

> P11, C2, L36-37: Sentence is not necessary.

Thanks, we removed it.

> P11, C2, L48: Why only in almost all cases. I don’t see an option to get less or more pixels. Anyway, this approach is not a solution for your mentioned problem of pixels outside the tree. On the contrary, the method leads to the fact that neighboring pixels are included.

As mentioned, we believe that this approach is a good compromise for the issue at hand and disagree with your view here.
We agree that there are no possibilities to get a different amount of pixels than exactly four and removed "almost" from the sentence.

> P13, C1, 56: Please avoid citations in the conclusion.

We see no problems including citations in the conclusion.

> The appendix is often not mentioned in the manuscript except Table VIII.

That's why the resources are listed in the appendix.

> Why do some of the Figures and Tables have regular numbering and some not?

As mentioned we are using the IEEE Tran Latex class and numbering is determined by such.
