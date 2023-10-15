set.seed(20231018)

# Specify model -----------------------------------------------------------

tune_spec_rf <- rand_forest(
  mtry = tune(),
  trees = 100,
  min_n = tune()
) |>
  set_mode("classification") |>
  set_engine("ranger")

# Tune hyperparameters ----------------------------------------------------

rf_grid <- tune_grid(
  add_model(wf, tune_spec_rf),
  resamples = hf_folds,
  grid = grid_regular(
    mtry(range = c(5, 8)),
    min_n(), #default c(2, 40)
    levels = 5)
)

# Fit model ---------------------------------------------------------------

highest_roc_auc_rf <- rf_grid |>
  select_best("roc_auc")

final_rf <- finalize_workflow(
  add_model(wf, tune_spec_rf),
  highest_roc_auc_rf
)

# Evaluate ----------------------------------------------------------------

last_fit(final_rf, hf_split) |>
  collect_metrics()

# create a confusion matrix
last_fit(final_rf, hf_split) |> 
  collect_predictions() |> 
  conf_mat(death, .pred_class) |> 
  autoplot()
