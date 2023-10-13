library(ggplot2)

set.seed(20231013)
plot_data <- data.frame(x = c(runif(15, 0.5, 1), runif(15, 0, 0.5)),
                        y = c(runif(15, 0.5, 1), runif(15, 0, 0.5)),
                        type = c(rep("A", 15), rep("B", 15)))

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
