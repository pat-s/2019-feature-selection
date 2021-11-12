# Reviewer 1 - Iteration 1

We would like to thank the reviewer for taking time to review our manuscript.
Please find our replies inline and a general statement to the point "spectral unmixing" and "deep learning" in the general reply of ours.

> In this paper, the authors investigated the effectiveness and potential of feature selection in machine learning techniques with the application to forest health monitoring using HS data. Overall, the structure of this paper is well organized, and the presentation is relatively clear. However, there are some crucial issues that need to be carefully considered before a possible publication.
> (1) In general, machine learning techniques consist of various methods, e.g., SVM, RF, etc. listed by the authors, and also well-known deep learning methods. The reviewer suggests adding the comparison of deep learning-based methods and at least adding the detailed discussion and analysis in the introduction part or related works by citing advanced and latest works, e.g., “More Diverse Means Better: Multimodal Deep Learning Meets Remote-Sensing Imagery Classification, IEEE Transactions on Geoscience and Remote Sensing, 2020, DOI: 10.1109/TGRS.2020.3016820.” and “Graph Convolutional Networks for Hyperspectral Image Classification, IEEE Transactions on Geoscience and Remote Sensing, 2020, DOI: 10.1109/TGRS.2020.3015157.”

Thank you for suggesting to consider Deep Learning methods.
In our view machine learning and deep learning can be considered as different (sub-)fields with different applications and model purposes.
Many studies discuss this difference with no clear outcome with different applications and model purposes (compare [Shinde & Shah 2018](https://ieeexplore.ieee.org/abstract/document/8697857?casa_token=Fzft6Mye_VkAAAAA:xIy2D6XbLPeQh4znXH_ZyH1B43y3aTT4_0k-E9SOSrYdJatHd-NnEEg-IXhE2v4AonwWtb1ZAPg) and [Zhang et al 2017](https://www.sciencedirect.com/science/article/pii/S1359644616304366?casa_token=CFU2EwTw21sAAAAA:k3U9M2kdWrmaV5gQYI1xOz9FXmcXEBc0Ucg8jtxGgjHC9mnDnjUI0mFZ4HiRuj9x5aZiJbSwe_g)).
Therefore discussing the topic of deep learning in our manuscript does not seem to be beneficial and fit the scope, also because no deep learning methods were used in our study.
We also see no strong arguments why deep learning methods could potentially be better with respect to the data used in this work.
See also our more general reply in the editor summary in the section about "deep learning".

> (2) The hyperspectral image usually suffers from the material mixing, due to the limitations of imaging devices. Spectral unmixing is regarded as a preprocessing technique. The reviewer is wondering whether the feature selection is effective when spectral unmixing is not performed, since the materials in the hyperspectral image is highly coupled.

Thank you for mentioning the issue of spectral unmixing.
Due to the points listed in the general summary of our reply (please see the section on "spectral unmixing"), we believe that applying spectral unmixing techniques does not apply to this study.

> (3) It is well-known that the hyperspectral imaging tends to be degraded by various spectral variabilities, e.g., “An Augmented Linear Mixing Model to Address Spectral Variability for Hyperspectral Unmixing, IEEE Transactions on Image Processing, 2019, 28(4): 1923-1938”. So the reviewer has a great interest to see how the feature selection can be effectively made when the spectral variability exists. Please give more discussion and analysis.

Please see our answer to (2).

> (4) In the experimental part, the authors show lots of results in terms of feature importance with RMSE and SE. Why not use the classification as a potential application. This might give a more intuitive result for feature selection.

We would like to thank the reviewer for pointing out that feature selection is an important technique for both classification and regression.
However, in the Results section, we have to limit ourselves to presenting the results of this specific case study, which is a regression problem.
In addition, we do not necessarily agree that the results of classification studies would be more intuitive than regression ones.
Both have their use cases, and the type of problem encountered is a direct consequence of the type of response variable - in our case the degree of defoliation, which is an economically and ecologically relevant numerical target variable.
With respect to the present application setting, having a classification outcome of "healthy vs. diseased" would in our view even reduce the information content of the response variable because the classification into these two classes (or possibly different ones) would naturally be based on an arbitrary threshold.
With a regression response, this limitation is not present and is therefore in our view more appropriate in this context.
