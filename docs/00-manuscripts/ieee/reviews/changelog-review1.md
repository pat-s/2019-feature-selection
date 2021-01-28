Dear Editor,

We would like to thank Reviewer 1 for her/his valuable and insightful comments.
We realize that this reviewer is very knowledgeable in the field of deep learning and spectral unmixing and has strong views regarding the importance of these topics based on the three publications by Dr. Danfeng Hong that we are asked to cite.
With this in mind, we would like to clarify the following points beforehand in order to avoid misunderstandings and possible delays:

**Spectral unmixing**

The main purpose of spectral unmixing techniques is to identify the contribution of different materials to the recorded spectral signal.
This is particularly useful when (1) mixed pixels are present, to which (2) discrete materials have contributed, and (3) when it is of interest to assess the contribution of each constituent substance, e.g. the fraction of area it covers, in order to create abundance maps (as in [Hong et al. 2019](https://ieeexplore.ieee.org/abstract/document/8528557)).

We believe that it is difficult to make the case that this applies to our situation of airborne hyperspectral imaging in a forest plantations:

1. We are confident that the extracted data corresponds to tree canopies.
2. Within these canopies, there are no discrete constituent substances (e.g. photosynthetically active / inactive plant tissue). Plant pathologists would rather identify a continuum from healthy to diseased and finally dead or photosynthetically inactive leaves.
3. As a consequence we don’t see this as an attempt to identify fractions, but as an overall assessment of plant health given the spectral evidence.

Considering these points as well as the observation we gained from reviewing the literature  that modeling plant disease directly as a function of spectral predictors (and not endmember contributions) is quite common, we would like to avoid addressing the possibility of performing spectral unmixing using the methods proposed by Dr. Hong in the cited paper.

**Deep learning**

We acknowledge the great potentials of deep learning in remote sensing image classification, and we acknowledge that the researcher cited by the reviewer, Dr. Hong, has made valuable contributions to this field in recent years, among many other authors.
Nevertheless, the suggested papers don’t appear to be a good fit in the context of our manuscript, considering the following reasons:
1. [Hong et al. 2020](https://ieeexplore.ieee.org/abstract/document/9174822?casa_token=pSZixnENWygAAAAA:69eHYXkFWC3ZSKRLRFvQhrLaRXwcsap0EXM0v72Fp33gi7hYtkj1otYLwFKe1WoFKIDZvnBbbmA) in IEEE TGRS, "More Diverse Means Better: Multimodal Deep Learning Meets Remote-Sensing Imagery Classification" proposes multi-modal deep learning, while the submitted manuscript pursues only a single modality, i.e. hyperspectral sensing, and there is no obvious additional data source that could be added to create a multi-modal classification task
2. [Hong et al. 2020](https://ieeexplore.ieee.org/abstract/document/9170817/?casa_token=WfBdV-3H7YsAAAAA:5bZMwI-XqmkgIJMy59dvAiRcmLpe9uCBin9-o1QQ3FptmYXLUDXsaCDWsruolJS-l6r5FcgpBx4) in IEEE TGRS: "Graph Convolutional Networks for Hyperspectral Image Classification", i.e. modelling adjacencies, which is not the focus of the submitted manuscript, and to which we do not recognize a direct connection.

Overall, from our point of view it would therefore not be appropriate to cite the suggested papers.

See also our point-by-point replies for reviewer1 in the attached file.


## Changelog

- Add references for NRI index
- Add table with all vegetation indices used
- Study area figure now spans across two-columns
- Enhanced study-area image labels and metadata appearance
- Discuss the lack of SWIR range coverage
- Discuss the lack of multi-temporal in-situ data (which includes the lack of different phenology stages)
- Add PCA for all feature sets to showcase the information redundancy among the variables of each feature set (Fig. 3)
- explicitly label the achieved performance as "fair"
- In-situ data: add details how the data was surveyed
- Explain why NDVI was chosen as the base for NRI calculation
- Add geometric, radiometric and atmospheric correction information to appendix F
- Add line-numbers for peerreview mode
