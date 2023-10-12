
# Specify the model -------------------------------------------------------
# use the `logistic_reg` and `set_engine` functions
ex_lasso_tune_spec <- logistic_reg(penalty = tune(), mixture = 1) |>
  set_engine("glmnet")


# Tune the model ----------------------------------------------------------

# Fit lots of values using `tune_grid()`
ex_lasso_grid <- tune_grid(
  add_model(ex_wf, ex_lasso_tune_spec),
  resamples = ex_folds,
  grid = grid_regular(penalty(), levels = 50)
)

# Choose the best value using `select_best()`
ex_lasso_highest_roc_auc <- ex_lasso_grid |>
  select_best("roc_auc")


# Fit the final model -----------------------------------------------------
# use the `finalize_workflow` function and `add_model`
ex_final_lasso <- finalize_workflow(
  add_model(ex_wf, ex_lasso_tune_spec),
  ex_lasso_highest_roc_auc
)


# Model evaluation --------------------------------------------------------
# use `last_fit()` and `collect_metrics()`
last_fit(ex_final_lasso, ex_split) |>
  collect_metrics()

# which variables were most important?
ex_final_lasso |>
  fit(ex_train) |>
  extract_fit_parsnip() |>
  vip::vi(lambda = ex_lasso_highest_roc_auc$penalty) |>
  mutate(
    Importance = abs(Importance),
    Variable = fct_reorder(Variable, Importance)
  ) |>
  ggplot(mapping = aes(x = Importance, y = Variable, fill = Sign)) +
  geom_col()

