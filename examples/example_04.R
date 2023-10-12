
# Specify model -----------------------------------------------------------

tune_spec_svm <- svm_rbf(cost = tune()) |> 
  set_engine("kernlab") |> 
  set_mode("classification")


# Tune hyperparameters ----------------------------------------------------

# Fit lots of values
svm_grid <- tune_grid(
  add_model(wf, tune_spec_svm),
  resamples = hf_folds,
  grid = grid_regular(cost(), levels = 20)
)

# Fit model ---------------------------------------------------------------

highest_roc_auc_svm <- svm_grid |>
  select_best("roc_auc")

final_svm <- finalize_workflow(
  add_model(wf, tune_spec_svm),
  highest_roc_auc_svm
)


# Evaluate ----------------------------------------------------------------

last_fit(final_svm, hf_split,
         metrics = metric_set(roc_auc, accuracy, f_meas)) |>
  collect_metrics()

# create a confusion matrix
last_fit(final_svm, hf_split) |> 
  collect_predictions() |> 
  conf_mat(death, .pred_class) |> 
  autoplot()
