# Reviewer 1

```sh
Yes	Can be improved	Must be improved	Not applicable
Does the introduction provide sufficient background and include all relevant references? ( )	(x)	( )	( )
Is the research design appropriate?							 ( )	(x)	( )	( )
Are the methods adequately described? 							 ( )	(x)	( )	( )
Are the results clearly presented? 							 ( )	(x)	( )	( )
Are the conclusions supported by the results? 						 ( )	( )	(x)	( )
```

> Establishing a quantitative linkage between defoliation and hyperspectral reflectance is useful in the monitor of forest health.Due to the highly correlated, feature-rich characteristics of hyperspectral data, feature selection has become a common procedure. However, given a real scenario, how to select a proper feature selection method is still an opening problem. This study empirically studied the effectiveness of six typical filter-based feature selection methods in the context of tree defoliation estimation using airborne hyperspectral data. The paper is well written and easy to follow. However, as a scientific publication, I have three comments as follows.

Thanks for reviewing our manuscript!
We are glad you are having an overall positive opinion on our work and enjoyed reading it.
Please see our replies below.

> (1) the manuscript is a bit lengthy. I suggest the authors revise the paper to make it more focused. For example, between lines 521-526, the selected indices can be directly listed in table 9 rather than using the way in the paper.

Thank you for the feedback.
As mentioned in the "Methods" section, 89 vegetation indices were used in this study (with 86 remaining after a pairwise-correlation check).
Listing all of these in a table within the manuscript body would mean to include a multi-page table which would break the reading flow of the manuscript.
Hence we decided that placing the table in the appendix is probably the most concise way to include the information.

With respect to length, the manuscript essentially ends on page 20 with the remaining pages being appendices and references.
We believe that removing parts of the manuscript would introduce disturbance with respect to reading flow and content.
In addition, we have not seen similar requests from other reviewers and therefore would prefer to not remove parts of the manuscript just for the sake of shortening the manuscript.

> (2）The authors concluded that no clear pattern is found in terms of the behavior of the selected feature selection techniques in the experiments. The conclusion makes the contribution of the work a bit weak. The experimental results may be further analyzed from a positive perspective for the benefit of practical use of the feature selection methods.

Thank you for the feedback.
As often in science, results do not always present a clear and easy pattern which can be communicated in a definitive way.
More often instead, results show a fuzzy picture which should also be communicated this way.
Nevertheless, we are firmly convinced that the scientific community also needs to learn about research outcomes that are not exactly as expected, as this is necessary for scientific progress and avoids the well-known file drawer effect concerning unpublished research outcomes.
On the upside, the absence of strong and universal differences among feature selection techniques allows modelers to choose a methods based on criteria other than performance, such as, for example, computational efficiency, as pointed out in the Discussion in section 4.3:

"While filters can improve the performance of models, they might be more interesting in other aspects than performance: reducing variables can reduce computational efforts in high-dimensional scenarios and might enhance the interpretability of models.".

With respect to positive practical recommendations of this study, we would like to highlight some already existing points throughout the discussion (l.421 - l.426, l.443 - l.455) as well as in the Methods section, e.g. when explaining why and how filters can be used instead of wrapper methods for feature selection (section 2.3.1.), or why model-based optimization might be superior to simpler methods such as random search (section 2.4.3).
Also we mentioned the ease of integration filter methods into the optimization step and avoiding another dedicated feature selection layer on top, which comes with additional computational overhead (l.442).

> (3) The authors need to check the typo errors in the manuscript on the whole.  For example, in line 320, 28.09 p.p. can not be found in table 3 and RMSE in Table 3 may be wrongly placed.

Thank you checking Table 3 in detail.
The reference is in fact correct as it references the table with the best learner results.
The value itself (28.09) was in fact a typo as it should have been 28.12.
We have corrected this in the manuscript and apologize for the oversight.
As part of including feedback from other reviewers we also decided to use three digits instead of two for this table to better reflect differences between the model results.

In addition we have used a professional software to check for style and grammar issues.
We hope this improved the overall language quality of the manuscript.
