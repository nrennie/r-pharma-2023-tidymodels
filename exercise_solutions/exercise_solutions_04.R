
# Specify model -----------------------------------------------------------

ex_svm_tune_spec <- svm_rbf(cost = tune()) |> 
  set_engine("kernlab") |> 
  set_mode("classification")


# Tune hyperparameters ----------------------------------------------------

# Fit lots of values using `tune_grid()`
ex_svm_grid <- tune_grid(
  add_model(ex_wf, ex_svm_tune_spec),
  resamples = ex_folds,
  grid = grid_regular(cost(), levels = 20)
)

# Fit model ---------------------------------------------------------------

ex_svm_highest_roc_auc <- ex_svm_grid |>
  select_best("roc_auc")

ex_final_svm <- finalize_workflow(
  add_model(ex_wf, ex_svm_tune_spec),
  ex_svm_highest_roc_auc
)


# Evaluate ----------------------------------------------------------------
# select a different metric set using `metric_set` if you want!
last_fit(ex_final_svm, ex_split,
         metrics = metric_set(roc_auc, accuracy, f_meas)) |>
  collect_metrics()

# create a confusion matrix
last_fit(ex_final_svm, ex_split) |> 
  collect_predictions() |> 
  conf_mat(SAE, .pred_class) |> 
  autoplot()
