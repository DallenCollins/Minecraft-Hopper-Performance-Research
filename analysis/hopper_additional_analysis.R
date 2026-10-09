# ==========================================
# HOPPER EXPERIMENT - ADDITIONAL ANALYSIS
# 48 Trials / 8 Randomized Blocks
# ==========================================

library(ggplot2)
library(dplyr)

# Load original data
data <- read.csv("hopper_randomized_trials.csv")

stopifnot(nrow(data) == 48)
stopifnot(!anyNA(data$MSPT))
stopifnot(identical(data$Trial, 1:48))

# ------------------------------------------
# 1. Additional Spark measurements
# Entered in trial order (1 through 48)
# ------------------------------------------

data$P95_MSPT <- c(
  7.66, 4.82, 6.77, 5.85, 9.18, 9.10, 8.79, 5.53,
  2.65, 13.10, 6.33, 7.25, 5.84, 1.94, 5.12, 9.91,
  7.09, 5.06, 7.99, 5.07, 1.49, 4.37, 6.73, 4.53,
  4.84, 4.46, 1.88, 9.67, 4.99, 5.47, 6.26, 10.10,
  2.16, 4.88, 5.99, 6.54, 6.91, 8.81, 4.33, 4.91,
  4.54, 2.34, 4.39, 5.04, 7.10, 11.20, 6.65, 2.29
)

data$Max_MSPT <- c(
  64.1, 188, 2140, 1410, 1460, 172, 1560, 230,
  271, 363, 181, 156, 1450, 214, 1490, 1500,
  1690, 1280, 1430, 1730, 192, 172, 1240, 1240,
  1180, 1450, 219, 1070, 122, 197, 1440, 116,
  100, 186, 1340, 96.1, 1290, 1260, 186, 1200,
  118, 181, 1440, 1580, 139, 95.9, 191, 113
)

data$CPU_1min <- c(
  4.17, 5.16, 6.15, 5.44, 8.63, 6.58, 7.84, 6.15,
  4.17, 8.48, 5.18, 6.24, 5.33, 5.38, 6.38, 7.68,
  8.16, 6.14, 7.84, 6.89, 3.92, 5.23, 5.37, 6.04,
  6.58, 5.06, 4.17, 9.18, 5.58, 5.79, 5.43, 8.08,
  5.24, 7.03, 5.62, 7.98, 8.51, 8.84, 6.48, 6.58,
  5.78, 6.42, 5.61, 6.26, 6.08, 8.72, 8.13, 4.13
)

data$CPU_15min <- c(
  9.52, 6.74, 12.63, 11.84, 7.94, 11.81, 12.80, 8.05,
  9.60, 9.28, 8.70, 12.17, 7.47, 7.63, 6.47, 12.86,
  10.99, 5.62, 8.62, 8.92, 5.82, 8.80, 11.01, 10.19,
  8.51, 7.86, 7.00, 10.17, 6.13, 7.85, 7.41, 8.28,
  4.71, 6.12, 11.20, 9.07, 10.07, 9.59, 6.59, 10.97,
  6.93, 9.08, 7.47, 12.09, 7.36, 10.72, 11.05, 4.87
)

# Save to a NEW CSV
write.csv(
  data,
  "hopper_complete_data.csv",
  row.names = FALSE
)

# ------------------------------------------
# 2. Summary statistics
# ------------------------------------------

data$Condition <- factor(
  data$Condition,
  levels = c(
    "Baseline", "HC 1", "HC 2",
    "HC 4", "HC 8", "HC 16"
  )
)

summary_data <- data %>%
  group_by(Condition) %>%
  summarise(
    Median_MSPT = mean(MSPT),
    P95_MSPT = mean(P95_MSPT),
    Max_MSPT = mean(Max_MSPT),
    CPU_1min = mean(CPU_1min),
    .groups = "drop"
  )

print(summary_data)

# Create output folder
dir.create("figures", showWarnings = FALSE)

# ------------------------------------------
# 3. Graph: Median vs 95th percentile
# ------------------------------------------

graph_data <- data.frame(
  Condition = rep(summary_data$Condition, 2),
  MSPT = c(
    summary_data$Median_MSPT,
    summary_data$P95_MSPT
  ),
  Metric = rep(
    c("Median MSPT", "95th Percentile MSPT"),
    each = 6
  )
)

p1 <- ggplot(
  graph_data,
  aes(x = Condition, y = MSPT,
      color = Metric, group = Metric)
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3.5) +
  scale_color_manual(
    values = c(
      "Median MSPT" = "#168aad",
      "95th Percentile MSPT" = "#ef476f"
    )
  ) +
  labs(
    title = "Minecraft Hopper Performance",
    subtitle = "Median vs. 95th Percentile | 48 Trials",
    x = "Hopper-Check Setting",
    y = "MSPT (ms)",
    color = "Measurement",
    caption = "Paper 26.2 | 10,000 hoppers | 8 randomized blocks"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(
      face = "bold", size = 20
    ),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    legend.position = "bottom"
  )

print(p1)

ggsave(
  "figures/median_vs_p95.png",
  p1, width = 11
  
  