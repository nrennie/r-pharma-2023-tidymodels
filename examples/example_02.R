
# Specify the model -------------------------------------------------------

tune_spec_lasso <- logistic_reg(penalty = tune(), mixture = 1) |>
  set_engine("glmnet")


# Tune the model ----------------------------------------------------------

# Fit lots of values
lasso_grid <- tune_grid(
  add_model(wf, tune_spec_lasso),
  resamples = hf_folds,
  grid = grid_regular(penalty(), levels = 50)
)

# Choose the best value
highest_roc_auc_lasso <- lasso_grid |>
  select_best("roc_auc")


# Fit the final model -----------------------------------------------------

final_lasso <- finalize_workflow(
  add_model(wf, tune_spec_lasso),
  highest_roc_auc_lasso
)


# Model evaluation --------------------------------------------------------

last_fit(final_lasso, hf_split) |>
  collect_metrics()

# which variables were most important?
final_lasso |>
  fit(hf_train) |>
  extract_fit_parsnip() |>
  vip::vi(lambda = highest_roc_auc_lasso$penalty) |>
  mutate(
    Importance = abs(Importance),
    Variable = fct_reorder(Variable, Importance)
  ) |>
  ggplot(mapping = aes(x = Importance, y = Variable, fill = Sign)) +
  geom_col()

