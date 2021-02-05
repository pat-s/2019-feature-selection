# Reviewer 1 - Iteration 1

Thanks for taking time to review our manuscript.
Please find our replies inline.

> In this paper, the authors investigated the effectiveness and potential of feature selection in machine learning techniques with the application to forest health monitoring using HS data. Overall, the structure of this paper is well organized, and the presentation is relatively clear. However, there are some crucial issues that need to be carefully considered before a possible publication.

> (1) In general, machine learning techniques consist of various methods, e.g., SVM, RF, etc. listed by the authors, and also well-known deep learning methods. The reviewer suggests adding the comparison of deep learning-based methods and at least adding the detailed discussion and analysis in the introduction part or related works by citing advanced and latest works, e.g., “More Diverse Means Better: Multimodal Deep Learning Meets Remote-Sensing Imagery Classification, IEEE Transactions on Geoscience and Remote Sensing, 2020, DOI: 10.1109/TGRS.2020.3016820.” and “Graph Convolutional Networks for Hyperspectral Image Classification, IEEE Transactions on Geoscience and Remote Sensing, 2020, DOI: 10.1109/TGRS.2020.3015157.”

Thanks for the suggestion to consider Deep Learning methods.
In our view machine learning and deep learning can be considered as different (sub-)fields (many studies discuss this difference with no clear outcome) with different applications and model purposes.
Therefore adding references and/or comparing this work to articles making use of deep learning methods does not seem beneficial to us, also because no DL methods were used in this study.

> (2) The hyperspectral image usually suffers from the material mixing, due to the limitations of imaging devices. Spectral unmixing is regarded as a preprocessing technique. The reviewer is wondering whether the feature selection is effective when spectral unmixing is not performed, since the materials in the hyperspectral image is highly coupled.

Thanks for mentioning the issue of spectral unmixing.
We do not see an issue related to the imaging device in this study.
Which limitation should the image device have?

Note that the spatial resolution of 1m is not a limiting factor here for accurate value extraction and does not necessarily cause mixed pixels.
The issue is the potential spatial offset which we decided to account for by using a buffer during extraction.

We do not see a direct relation between the effectiveness of feature-selection and spectral unmixing in this work.
Could you elaborate and give references why feature selection in general should be non-effective in a scenario where spectral unmixing was not performed?
Also it is not clear to us what is meant with "since the materials in the hyperspectral image is highly coupled" - could you please rephrase?

> (3) It is well-known that the hyperspectral imaging tends to be degraded by various spectral variabilities, e.g., “An Augmented Linear Mixing Model to Address Spectral Variability for Hyperspectral Unmixing, IEEE Transactions on Image Processing, 2019, 28(4): 1923-1938”. So the reviewer has a great interest to see how the feature selection can be effectively made when the spectral variability exists. Please give more discussion and analysis.

This question is almost identical to question (2). Please see our answer to (2).

> (4) In the experimental part, the authors show lots of results in terms of feature importance with RMSE and SE. Why not use the classification as a potential application. This might give a more intuitive result for feature selection.

We are not sure what you mean here.
Could you please rephrase?
Especially the part on

> Why not use the classification as a potential application. This might give a more intuitive result for feature selection."

is unclear to us.
