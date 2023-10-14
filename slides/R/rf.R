library(ggflowchart)
library(ggplot2)

# decision tree
plot_data <- tibble::tribble(
  ~from, ~to, ~label,
  "Is it raining?", "Will it rain later?", "No",
  "Is it raining?", "Will it be windy later?", "Yes",
  "Will it rain later?", "Walk1", "No",
  "Will it rain later?", "Don't Walk1", "Yes",
  "Will it be windy later?", "Walk2", "No",
  "Will it be windy later?", "Don't Walk2", "Yes"
)
node_data <- tibble::tibble(name = unique(c(plot_data$from, plot_data$to))) |> 
  dplyr::mutate(label = gsub("\\d+$", "", name),
                colour = c(rep("white", 3), "#bec0c2", "#b20e10", "#bec0c2", "#b20e10")) |> 
  dplyr::mutate(label = stringr::str_wrap(label, 13))
ggflowchart(plot_data, node_data, fill = colour,
            alpha = 0.5, x_nudge = 0.5,
            text_size = 4.2) +
  labs(title = "Should I walk to work?") +
  scale_fill_identity() +
  theme_void(base_size = 20)
ggsave("slides/images/rf_01.png", width = 4, height = 4, units = "in")


