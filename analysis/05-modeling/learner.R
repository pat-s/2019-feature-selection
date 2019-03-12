lrn_xgboost <- makeLearner("regr.xgboost",
                           par.vals = list(
                             objective = "reg:linear",
                             eval_metric = "error"
                           ))
