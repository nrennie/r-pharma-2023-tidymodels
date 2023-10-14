set.seed(20231018)

# Specify model -----------------------------------------------------------

ex_rf_tune_spec <- rand_forest(
  mtry = tune(),
  trees = 100,
  min_n = tune()
) |>
  set_mode("classification") |>
  set_engine("ranger")

# Tune hyperparameters ----------------------------------------------------

ex_rf_grid <- tune_grid(
  add_model(ex_wf, ex_rf_tune_spec),
  resamples = ex_folds,
  grid = grid_regular(mtry(range = c(5, 10)), # smaller ranges will run quicker
                      min_n(range = c(2, 25)),
                      levels = 3)
)

# Fit model ---------------------------------------------------------------

ex_rf_highest_roc_auc <- ex_rf_grid |>
  select_best("roc_auc")

ex_final_rf <- finalize_workflow(
  add_model(ex_wf, ex_rf_tune_spec),
  ex_rf_highest_roc_auc
)

# Evaluate ----------------------------------------------------------------

last_fit(ex_final_rf, ex_split) |>
  collect_metrics()
