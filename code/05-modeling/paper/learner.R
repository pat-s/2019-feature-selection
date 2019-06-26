# Random Forest -----------------------------------------------------------

lrn_rf <- makeLearner(
  "regr.ranger.pow"
)

# XGBOOST -----------------------------------------------------------------

lrn_xgboost <- makeLearner(
  "regr.xgboost",
  par.vals = list(
    objective = "reg:linear",
    eval_metric = "error"
  )
)

# SVM ---------------------------------------------------------------------

lrn_svm <- makeLearner(
  "regr.ksvm",
  scaled = FALSE,
  fit = FALSE
)

# LASSO ---------------------------------------------------------------------

lrn_lasso <- makeLearner("regr.glmnet", id = "lasso",
                         alpha = 1,
                         standardize = FALSE,
                         intercept = FALSE
)

# RIDGE ---------------------------------------------------------------------

lrn_ridge = makeLearner("regr.glmnet", id = "ridge",
                        alpha = 0,
                        standardize = FALSE,
                        intercept = FALSE)

# LM ---------------------------------------------------------------------

lrn_lm = makeLearner("regr.glm", id = "lm")
