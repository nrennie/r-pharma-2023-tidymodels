library(ggplot2)
library(dplyr)

# lm
set.seed(20231013)
plot_data <- data.frame(x = runif(30)) |> 
  mutate(y = x + rnorm(30, 0, 0.5))
ggplot(plot_data, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_light()
ggsave("slides/images/lasso_01.png", width = 4, height = 4, units = "in")

# glm
set.seed(20231013)
plot_data <- data.frame(x = sort(runif(30)),
                        y = c(rbinom(15, size = 1, prob = 0.2),
                              rbinom(15, size = 1, prob = 0.8)))
ggplot(plot_data, aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "glm", 
              method.args = list(family = "binomial"), 
              se = FALSE) +
  geom_hline(yintercept = 0.5, colour = "red") +
  labs(y = "") +
  theme_light()
ggsave("slides/images/lasso_02.png", width = 4, height = 4, units = "in")
