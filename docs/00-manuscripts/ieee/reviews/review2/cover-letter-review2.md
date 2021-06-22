Dear Editor,

Please find the replies to all reviewer suggestions/questions in their respective files (labeled as `reviewer<x>.md` where `<x>` is the reviewer number starting from 1).
Also we have added a changelog section further down below summarizing all changes we have applied to the manuscript as a result of this review.

With respect to the many helpful remarks of both reviewers, we did not implement the following suggested changes:

- The use of smoothing techniques as a preprocessing task for the hyperspectral data.
- Adding the spectral response function of the hyperspectral sensor.
- The inapplicability of using a buffer to reduce the influence of non-vegetation pixels and accounting for possible geometric offsets.
- A potentially inconsistent numbering of Figures / Tables.
- The request to include wrapper methods for feature selection.

We have outlined our reasons in detail in the respective in-line replies.

In summary, we believe that we have addressed most reviewer remarks and incorporated a lot of helpful ideas from the reviewers into the current version of the manuscript.

# Changelog

- Updated caption of Table VII according to feedback from reviewer2
- Clarified the presence of inconsistent (= non 5% interval) defoliation values for plot Laukiz2
- Updated the study area map according to feedback from reviewer2
- Added a featureless learner to the benchmark results table as a baseline reference for performance comparison
- Updated the legend ordering and color palette in Fig. 3 according to feedback from reviewer2
- Rephrased the section discussion the performance of models which used PCA as a filter after feedback from reviewer2
- Clarified the removal of features with a pairwise correlation of 1 after feedback from reviewer2
- Added a reference why RBF Kernel was chosen as the kernel for the SVM learner after feedback from reviewer1
- Revised the use of abbreviations after feedback from reviewer2
- Rephrased the usefulness of machine learning for this study
- Added references to paragraph P.2, 2nd column on LL.47-5 as suggested by reviewer 1
