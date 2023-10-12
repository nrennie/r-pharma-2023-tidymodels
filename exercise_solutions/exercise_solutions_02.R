
# Specify the model -------------------------------------------------------
# use the `logistic_reg` and `set_engine` functions
tune_spec <- logistic_reg(penalty = tune(), mixture = 1) |>
  set_engine("glmnet")


# Tune the model ----------------------------------------------------------

# Fit lots of values using `tune_grid()`
lasso_grid <- tune_grid(
  add_model(ex_wf, tune_spec),
  resamples = ex_folds,
  grid = grid_regular(penalty(), levels = 50)
)

# Choose the best value using `select_best()`
highest_roc_auc <- lasso_grid |>
  select_best("roc_auc")


# Fit the final model -----------------------------------------------------
# use the `finalize_workflow` function and `add_model`
final_lasso <- finalize_workflow(
  add_model(wf, tune_spec),
  highest_roc_auc
)


# Model evaluation --------------------------------------------------------
# use `last_fit()` and `collect_metrics()`
last_fit(final_lasso, ex_split) |>
  collect_metrics()

# which variables were most important?
final_lasso |>
  fit(ex_train) |>
  extract_fit_parsnip() |>
  vip::vi(lambda = highest_roc_auc$penalty) |>
  mutate(
    Importance = abs(Importance),
    Variable = fct_reorder(Variable, Importance)
  ) |>
  ggplot(mapping = aes(x = Importance, y = Variable, fill = Sign)) +
  geom_col()

