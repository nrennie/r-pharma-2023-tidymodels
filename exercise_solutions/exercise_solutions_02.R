
# Build a recipe ----------------------------------------------------------

ex_recipe <- recipe(SAE ~ ., data = ex_train) |> 
  step_dummy(Treatment:VE_Cardio) |> 
  step_normalize(all_numeric())

wf <- workflow() |> 
  add_recipe(ex_recipe)


# Specify the model -------------------------------------------------------

tune_spec <- logistic_reg(penalty = tune(), mixture = 1) |>
  set_engine("glmnet")


# Tune the model ----------------------------------------------------------

# Create cross validation folds
set.seed(20231018)
ex_folds <- vfold_cv(ex_train, v = 10)

# Fit lots of values
lasso_grid <- tune_grid(
  add_model(wf, tune_spec),
  resamples = ex_folds,
  grid = grid_regular(penalty(), levels = 50)
)

# Choose the best value
highest_roc_auc <- lasso_grid |>
  select_best("roc_auc")


# Fit the final model -----------------------------------------------------

final_lasso <- finalize_workflow(
  add_model(wf, tune_spec),
  highest_roc_auc
)


# Model evaluation --------------------------------------------------------

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

