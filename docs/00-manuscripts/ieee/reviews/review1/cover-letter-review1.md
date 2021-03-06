Dear Editor,

this submission is a revised one initially submitted to the journal "IEEE Transaction on Geosciences and Remote Sensing" with the paper ID TGRS-2020-01814.
Hence, reviewer replies are attached in the submission.
Also there was a previous resubmission with the ID JSTARS-2021-00619 a few days ago which got rejected due to formating issues.

Please find the replies to all reviewer suggestions/questions in their respective files (labeled as `reviewer<x>.md` where `<x>` is the reviewer number starting from 1).
Also we have added a changelog section further down below summarizing all changes we have applied to the manuscript as a result of this review.
Due to the amount of suggestions by four reviewers, the level of detail which we used to address these changes and the impact of the global pandemic it took us some time to resubmit our manuscript.
However, we believe that the reviews have improved this work substantially and hope that it can be considered for publication now.

In addition, we would like to thank Reviewer 1 for her/his valuable and insightful comments.
We realize that this reviewer is very knowledgeable in the field of deep learning and spectral unmixing and has strong views regarding the importance of these topics based on the three publications by Dr. Danfeng Hong that we are asked to cite.
With this in mind, we would like to clarify the following points in a general manner beforehand in order to avoid misunderstandings and possible delays:

## Spectral unmixing

The main purpose of spectral unmixing techniques is to identify the contribution of different materials to the recorded spectral signal.
This is particularly useful when (1) mixed pixels are present, to which (2) discrete materials have contributed, and (3) when it is of interest to assess the contribution of each constituent substance, e.g. the fraction of area it covers, in order to create abundance maps (as in [Hong et al. 2019](https://ieeexplore.ieee.org/abstract/document/8528557)).

We believe that it is difficult to make the case that this applies to our situation of airborne hyperspectral imaging in a forest plantations:

1. We are confident that the extracted data corresponds to tree canopies.
2. Within these canopies, there are no discrete constituent substances (e.g. photosynthetically active / inactive plant tissue). Plant pathologists would rather identify a continuum from healthy to diseased and finally dead or photosynthetically inactive leaves.
3. As a consequence we don't see this as an attempt to identify fractions, but as an overall assessment of plant health given the spectral evidence.

Considering these points as well as the observation we gained from reviewing the literature that modeling plant disease directly as a function of spectral predictors (and not endmember contributions) is quite common, we would like to avoid addressing the possibility of performing spectral unmixing using the methods proposed by Dr. Hong in the cited paper.

## Deep learning

We acknowledge the great potentials of deep learning in remote sensing image classification, and we acknowledge that the researcher cited by the reviewer, Dr. Hong, has made valuable contributions to this field in recent years, among many other authors.
Nevertheless, the suggested papers don't appear to be a good fit in the context of our manuscript, considering the following reasons: 1.
[Hong et al. 2020](https://ieeexplore.ieee.org/abstract/document/9174822?casa_token=pSZixnENWygAAAAA:69eHYXkFWC3ZSKRLRFvQhrLaRXwcsap0EXM0v72Fp33gi7hYtkj1otYLwFKe1WoFKIDZvnBbbmA) in IEEE TGRS, "More Diverse Means Better: Multimodal Deep Learning Meets Remote-Sensing Imagery Classification" proposes multi-modal deep learning, while the submitted manuscript pursues only a single modality, i.e. hyperspectral sensing, and there is no obvious additional data source that could be added to create a multi-modal classification task 2.
[Hong et al. 2020](https://ieeexplore.ieee.org/abstract/document/9170817/?casa_token=WfBdV-3H7YsAAAAA:5bZMwI-XqmkgIJMy59dvAiRcmLpe9uCBin9-o1QQ3FptmYXLUDXsaCDWsruolJS-l6r5FcgpBx4) in IEEE TGRS: "Graph Convolutional Networks for Hyperspectral Image Classification", i.e. modelling adjacencies, which is not the focus of the submitted manuscript, and to which we do not recognize a direct connection.

Overall, from our point of view it would therefore not be appropriate to cite the suggested papers.

See also our point-by-point replies for reviewer1 in the attached file.

In addition to the point-by-point replies for each reviewer we have added a concise changelog summary listing all changes to the manuscript since the last submission.
We hope that this improved manuscript can now be considered for publication.

# Changelog

- Added references for NRI index and explain its origin in more detail
- Added table with all vegetation indices used
- Study area figure (Fig. 2) now spans across two-columns.
- Enhanced study-area image labels and metadata appearance.
- Discussed the lack of SWIR range coverage in section "Data Quality".
- Discussed the lack of multi-temporal in-situ data (which includes the lack of different phenology stages)
- Added a new figure which shows the results of a PCA for all feature sets to showcase information redundancy among the variables for each feature set (Fig. 3).
- Explicitly label the achieved model performances as "fair".
- In-situ data: added more details on how the data was surveyed.
- Explained why NDVI was chosen as the base for NRI calculation and added more references to explain the NRI concept.
- Added geometric, radiometric and atmospheric correction information (Appendix F).
- Add manual line-numbers for "review mode".
- More prominent linking of hyperparameter and benchmark settings and the availability of a research compendium (which shows the code used to generate the benchmark matrix).
- Clarified "information gain" filter formula and added more details and references with respect to its formula definition.
- Discussed segmentation as an alternative to the buffer approach for extracting hyperspectral data from trees.
- Discussed possible data limitations more prominently in section "Data quality".
- Rerunning the analysis with R 4.0.4 (instead of 3.6.3) and updated R packages versions (including a new implementation of the RelieF algorithm) brought slight changes to the leaderboard: e.g. the SVM RelieF combinations dropped from 28.07 to 28.13, the best learner SVM infogain dropped from 27.99 to 28.02
- Reduced buffer size for hyperspectral information extraction from 2 meters to 1 meter
- Altered XGBOOST parameter set to reduce tuning time. Beforehand, many settings were taking up to 15 min per step which indicated non-optimal settings.
- Due to the reduction of the buffer size, the high error measures for learners "RIDGE-MBO" changed to reasonable ones
- XGBOOST performances got a bit better, most likely due to the change of the hyperparameter ranges
- By using a buffer of one meter, the list of most important variables (according to the permutation-based variable importance) changed slightly.
  The overall pattern stayed the same.
  For the HR feature set, the importance of the SWIR area decreased a bit and B7 fell out of the top ten most important features.
  For feature set VI, the concentration on the NRI area increased slightly.
- Remove ALE plots as they were only briefly addressed and did not contribute substantially to the analysis of the results
