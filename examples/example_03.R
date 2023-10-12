set.seed(20231018)

# Specify model -----------------------------------------------------------

tune_spec <- rand_forest(
  mtry = tune(),
  trees = 1000,
  min_n = tune()
) |>
  set_mode("classification") |>
  set_engine("ranger")

# Tune hyperparameters ----------------------------------------------------

rf_grid <- tune_grid(
  add_model(wf, tune_spec),
  resamples = hf_folds,
  grid = grid_regular(mtry(range = c(5, 25)), min_n(range = c(1, 25)), levels = 5)
)

# Fit model ---------------------------------------------------------------

highest_roc_auc <- rf_grid |>
  select_best("roc_auc")

final_rf <- finalize_workflow(
  add_model(wf, tune_spec),
  highest_roc_auc
)

# Evaluate ----------------------------------------------------------------

last_fit(final_rf, hf_split) |>
  collect_metrics()
