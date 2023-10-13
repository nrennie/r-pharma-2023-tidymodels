library(ggplot2)
library(tidymodels)

set.seed(20231013)
plot_data <- data.frame(x = c(runif(15, 0.5, 1), runif(15, 0, 0.5)),
                        y = c(runif(15, 0.5, 1), runif(15, 0, 0.5)),
                        type = factor(c(rep("A", 15), rep("B", 15))))

# scatter plot
ggplot() +
  geom_point(data = plot_data,
             mapping = aes(x = x, y = y, colour = type),
             size = 3) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(0, 1)) +
  theme_light() +
  theme(legend.position = "none")
ggsave("slides/images/svm_01.png", width = 4, height = 4, units = "in")

# scatter plot with lines
ggplot() +
  geom_point(data = plot_data,
             mapping = aes(x = x, y = y, colour = type),
             size = 3) +
  geom_abline(slope = -1, intercept = 1) +
  geom_abline(slope = -0.9, intercept = 0.95, linetype = "dashed") +
  geom_abline(slope = -1.1, intercept = 1.05, linetype = "dotted") +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(limits = c(0, 1)) +
  scale_y_continuous(limits = c(0, 1)) +
  theme_light() +
  theme(legend.position = "none")
ggsave("slides/images/svm_02.png", width = 4, height = 4, units = "in")

# linear
png("slides/images/svm_03.png", width = 5, height = 5, units = "in", res=200)
svm_linear() |>
  set_mode("classification") |>
  set_engine("kernlab") |> 
  set_args(cost = 0.5) |>
  fit(type ~ x + y, data = plot_data) |>
  extract_fit_engine() |> 
  plot(data = plot_data)
dev.off()

# poly
png("slides/images/svm_04.png", width = 5, height = 5, units = "in", res=200)
svm_poly(degree = 3) |>
  set_mode("classification") |>
  set_engine("kernlab") |> 
  set_args(cost = 10) |>
  fit(type ~ x + y, data = plot_data) |>
  extract_fit_engine() |> 
  plot(data = plot_data)
dev.off()

# rbf
png("slides/images/svm_05.png", width = 5, height = 5, units = "in", res=200)
svm_rbf() |>
  set_mode("classification") |>
  set_engine("kernlab") |> 
  set_args(cost = 0.5) |>
  fit(type ~ x + y, data = plot_data) |>
  extract_fit_engine() |> 
  plot(data = plot_data, main = "RBF")
dev.off()
