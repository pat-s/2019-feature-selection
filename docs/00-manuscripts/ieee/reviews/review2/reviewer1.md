# Reviewer 1 - iteration 2

> I. Introduction
> You said that enough indices developed for different purposes.
> Could you give some examples after that sentence?

Thanks. This sentence might leave room for quite some interpretation and we've rewritten it to make it more clear.
What we mean here is that utilizing all sorts of (vegetation) indices can have a positive effect on the analysis even though some indices were developed with a specific use case in mind (only).
For example, our results showed that the NCPI index ([Penuaels et al.](https://www.sciencedirect.com/science/article/abs/pii/0034425794901368?via%3Dihub)) had a substantial contribution to the model performance (Fig. 6).
Its main use case is related to nitrogen- and water-limited sunflower leaves, which is different to the defoliation use case in our study.

We've changed the sentence as follows

"However, indices developed/applied for different purposes than the one to be analyzed (i.e. defoliation at pine trees) may help to explain complex underlying relationships which are not obvious on the first look."

> Why didn't you conduct the derivative analysis?
> Some vegetation indices were based on derivative spectra.

Thanks for suggesting a derivative analysis.
In our view such an analysis is out of scope for this study as the focus of this work is not an analyzing the input data but on the comparison of models, filters and feature importance.

> P.2
> 2nd column
> LL.47-53
> References are missing.

Thank you, we have added two references to this paragraph.

> III. Methods
> C. Benchmarking design
> 3) Hyperparameter Optimization
> Which hyperparameters were optimized?
> Why did you choose RBF Kernel for SVM?

Table VIII lists all hyperparameters which were optimized, including their tuning ranges and default parameter values.
RBF kernel is the default SVM kernel in most implementation (and to our knowledge in all R implementation).
It is a general purpose kernel which has proven to produce good results in other studies.
In our view there was no need trying to experiment with custom kernels here; instead we focuses on optimizing hyperparameters $C$ and $\sigma$.

> V. Discussion
> Could you offer the spectral response function of the hyperspectral sensor?
> That also has some effect on the variable importance.

We are sorry but we unfortunately do not have access to this information ourselves.
As mentioned in the first round of review, the processing of the hyperspectral data was done externally.
