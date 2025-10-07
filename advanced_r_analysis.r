# Advanced IPL 2018 Analytics - Extended Analysis
# Additional visualizations and statistical tests

library(tidyverse)
library(ggplot2)
library(plotly)
library(ggcorrplot)
library(GGally)
library(patchwork)
library(gt)
library(htmlwidgets)

# ============================================================================
# ADVANCED STATISTICAL ANALYSIS
# ============================================================================

# 1. AGREEMENT ANALYSIS - Bland-Altman Plot
# Measures agreement between AHP and PCA rankings

bland_altman_batsmen <- batsmen_final %>%
  mutate(
    Avg_Rank = (AHP_Rank + PCA_Rank) / 2,
    Diff_Rank = AHP_Rank - PCA_Rank,
    Mean_Diff = mean(Diff_Rank, na.rm = TRUE),
    SD_Diff = sd(Diff_Rank, na.rm = TRUE),
    Upper_Limit = Mean_Diff + 1.96 * SD_Diff,
    Lower_Limit = Mean_Diff - 1.96 * SD_Diff
  )

p_bland_altman_bat <- ggplot(bland_altman_batsmen, 
                             aes(x = Avg_Rank, y = Diff_Rank)) +
  geom_point(aes(size = Runs, color = abs(Diff_Rank)), alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "blue") +
  geom_hline(aes(yintercept = Mean_Diff), color = "red", linewidth = 1) +
  geom_hline(aes(yintercept = Upper_Limit), 
             color = "red", linetype = "dashed") +
  geom_hline(aes(yintercept = Lower_Limit), 
             color = "red", linetype = "dashed") +
  geom_text(aes(label = ifelse(abs(Diff_Rank) > 5, Player, "")), 
            hjust = -0.1, size = 3) +
  scale_color_gradient(low = "green", high = "red") +
  labs(title = "Bland-Altman Plot: Batsmen Ranking Agreement",
       subtitle = "AHP vs PCA Methodology Comparison",
       x = "Average Rank (AHP + PCA) / 2",
       y = "Rank Difference (AHP - PCA)",
       color = "|Difference|",
       size = "Runs Scored") +
  theme_minimal() +
  theme(legend.position = "bottom")

print(p_bland_altman_bat)

# 2. PERFORMANCE CLUSTERING
# K-means clustering for player segments

# Batsmen clustering
bat_cluster_data <- batsmen_data %>%
  select(Runs, SR, Avg, Percentage_Boundary) %>%
  scale()

set.seed(123)
bat_clusters <- kmeans(bat_cluster_data, centers = 4)

batsmen_clustered <- batsmen_data %>%
  mutate(Cluster = factor(bat_clusters$cluster,
                         labels = c("Power Hitters", "Accumulators", 
                                   "Balanced", "Emerging")))

# Visualize clusters
p_clusters <- ggplot(batsmen_clustered, 
                     aes(x = SR, y = Runs, color = Cluster, size = Avg)) +
  geom_point(alpha = 0.7) +
  geom_text(aes(label = ifelse(Runs > 500, Player, "")), 
            hjust = -0.1, size = 3, show.legend = FALSE) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Batsmen Performance Clusters",
       subtitle = "Based on Runs, Strike Rate, Average, and Boundary %",
       x = "Strike Rate", y = "Total Runs",
       size = "Batting Average") +
  theme_minimal() +
  theme(legend.position = "right")

print(p_clusters)

# 3. EFFICIENCY ANALYSIS
# Runs per ball faced vs boundary percentage

p_efficiency <- ggplot(batsmen_data, 
                       aes(x = Percentage_Boundary, y = Runs/BF)) +
  geom_point(aes(color = SR, size = Runs), alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, color = "red", linewidth = 0.5) +
  geom_text(aes(label = ifelse(Runs > 600, Player, "")), 
            hjust = -0.1, size = 3) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(title = "Batting Efficiency Analysis",
       subtitle = "Boundary % vs Runs per Ball",
       x = "Boundary Percentage (%)",
       y = "Runs per Ball Faced",
       color = "Strike Rate",
       size = "Total Runs") +
  theme_minimal()

print(p_efficiency)

# ============================================================================
# BOWLERS ADVANCED ANALYSIS
# ============================================================================

# 1. Economy vs Wickets Trade-off
p_bowl_tradeoff <- ggplot(bowlers_data, 
                          aes(x = Econ, y = Wickets)) +
  geom_point(aes(size = Matches, color = SR), alpha = 0.6) +
  geom_smooth(method = "loess", se = TRUE, color = "blue") +
  geom_vline(xintercept = mean(bowlers_data$Econ), 
             linetype = "dashed", color = "red") +
  geom_hline(yintercept = mean(bowlers_data$Wickets), 
             linetype = "dashed", color = "red") +
  geom_text(aes(label = ifelse(Wickets >= 18, Player, "")), 
            hjust = -0.1, size = 3) +
  scale_color_gradient(low = "green", high = "orange") +
  labs(title = "Bowling Economy vs Wickets Trade-off",
       subtitle = "Quadrant Analysis (Dashed lines = League Average)",
       x = "Economy Rate (Runs per Over)",
       y = "Total Wickets",
       color = "Strike Rate",
       size = "Matches") +
  annotate("text", x = 6.5, y = 22, label = "Elite Zone", 
           color = "darkgreen", fontface = "bold") +
  annotate("text", x = 9.5, y = 8, label = "Improvement Zone", 
           color = "red", fontface = "bold") +
  theme_minimal()

print(p_bowl_tradeoff)

# 2. Wickets per Match Analysis
bowlers_efficiency <- bowlers_data %>%
  mutate(Wickets_Per_Match = Wickets / Matches) %>%
  arrange(desc(Wickets_Per_Match))

p_wpm <- ggplot(head(bowlers_efficiency, 15), 
                aes(x = reorder(Player, Wickets_Per_Match), 
                    y = Wickets_Per_Match)) +
  geom_col(aes(fill = Econ), width = 0.7) +
  geom_text(aes(label = round(Wickets_Per_Match, 2)), 
            hjust = -0.2, size = 3) +
  scale_fill_gradient(low = "lightgreen", high = "red") +
  coord_flip() +
  labs(title = "Top 15 Bowlers: Wickets per Match",
       subtitle = "Color indicates Economy Rate",
       x = NULL, y = "Wickets per Match",
       fill = "Economy") +
  theme_minimal()

print(p_wpm)

# ============================================================================
# INTERACTIVE VISUALIZATIONS (for HTML export)
# ============================================================================

# 1. Interactive Scatter: AHP vs PCA with Plotly
p_interactive_bat <- plot_ly(
  data = batsmen_final,
  x = ~AHP_Rank,
  y = ~PCA_Rank,
  size = ~Runs,
  color = ~SR,
  colors = "YlOrRd",
  text = ~paste("Player:", Player,
                "<br>Runs:", Runs,
                "<br>SR:", SR,
                "<br>AHP Rank:", AHP_Rank,
                "<br>PCA Rank:", PCA_Rank),
  hoverinfo = "text",
  type = "scatter",
  mode = "markers"
) %>%
  layout(
    title = "Interactive Batsmen Rankings: AHP vs PCA",
    xaxis = list(title = "AHP Rank", autorange = "reversed"),
    yaxis = list(title = "PCA Rank", autorange = "reversed"),
    hovermode = "closest"
  ) %>%
  add_trace(
    x = c(1, 25), y = c(1, 25),
    mode = "lines",
    line = list(dash = "dash", color = "gray"),
    showlegend = FALSE,
    hoverinfo = "none"
  )

# Save interactive plot
htmlwidgets::saveWidget(p_interactive_bat, 
                        "interactive_batsmen_rankings.html")

# 2. Interactive Bowling Analysis
p_interactive_bowl <- plot_ly(
  data = bowlers_final,
  x = ~Econ,
  y = ~Wickets,
  size = ~Matches,
  color = ~AHP_Rank,
  colors = "RdYlGn",
  text = ~paste("Player:", Player,
                "<br>Wickets:", Wickets,
                "<br>Economy:", Econ,
                "<br>Average:", Avg,
                "<br>AHP Rank:", AHP_Rank),
  hoverinfo = "text",
  type = "scatter",
  mode = "markers"
) %>%
  layout(
    title = "Interactive Bowler Performance: Economy vs Wickets",
    xaxis = list(title = "Economy Rate"),
    yaxis = list(title = "Wickets Taken")
  )

htmlwidgets::saveWidget(p_interactive_bowl, 
                        "interactive_bowlers_analysis.html")

# ============================================================================
# BEAUTIFUL SUMMARY TABLES
# ============================================================================

# Top 10 Batsmen Comparison Table
top10_batsmen_table <- batsmen_final %>%
  arrange(AHP_Rank) %>%
  head(10) %>%
  select(Player, Runs, SR, Avg, AHP_Rank, PCA_Rank, 
         Percentage_Boundary) %>%
  gt() %>%
  tab_header(
    title = "IPL 2018: Top 10 Batsmen",
    subtitle = "Comparing AHP and PCA Rankings"
  ) %>%
  cols_label(
    Player = "Player",
    Runs = "Runs",
    SR = "Strike Rate",
    Avg = "Average",
    AHP_Rank = "AHP Rank",
    PCA_Rank = "PCA Rank",
    Percentage_Boundary = "Boundary %"
  ) %>%
  fmt_number(
    columns = c(SR, Avg, Percentage_Boundary),
    decimals = 2
  ) %>%
  data_color(
    columns = c(Runs),
    colors = scales::col_numeric(
      palette = c("white", "lightgreen", "darkgreen"),
      domain = NULL
    )
  ) %>%
  data_color(
    columns = c(SR),
    colors = scales::col_numeric(
      palette = c("white", "lightyellow", "orange"),
      domain = NULL
    )
  ) %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_column_labels()
  ) %>%
  tab_options(
    heading.background.color = "#1E3A8A",
    heading.title.font.size = 18,
    column_labels.font.weight = "bold"
  )

gtsave(top10_batsmen_table, "top10_batsmen_table.html")

# Top 10 Bowlers Comparison Table
top10_bowlers_table <- bowlers_final %>%
  arrange(AHP_Rank) %>%
  head(10) %>%
  select(Player, Wickets, Econ, Avg, SR, AHP_Rank, PCA_Rank) %>%
  gt() %>%
  tab_header(
    title = "IPL 2018: Top 10 Bowlers",
    subtitle = "Comparing AHP and PCA Rankings"
  ) %>%
  cols_label(
    Player = "Player",
    Wickets = "Wickets",
    Econ = "Economy",
    Avg = "Average",
    SR = "Strike Rate",
    AHP_Rank = "AHP Rank",
    PCA_Rank = "PCA Rank"
  ) %>%
  fmt_number(
    columns = c(Econ, Avg, SR),
    decimals = 2
  ) %>%
  data_color(
    columns = c(Wickets),
    colors = scales::col_numeric(
      palette = c("white", "lightblue", "darkblue"),
      domain = NULL
    )
  ) %>%
  data_color(
    columns = c(Econ),
    colors = scales::col_numeric(
      palette = c("darkgreen", "yellow", "red"),
      domain = NULL
    )
  ) %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_column_labels()
  ) %>%
  tab_options(
    heading.background.color = "#1E3A8A",
    heading.title.font.size = 18
  )

gtsave(top10_bowlers_table, "top10_bowlers_table.html")

# ============================================================================
# CORRELATION HEATMAP WITH SIGNIFICANCE
# ============================================================================

# Batsmen correlation with p-values
bat_cor_test <- function(x, y) {
  test <- cor.test(x, y, method = "pearson")
  return(c(cor = test$estimate, pval = test$p.value))
}

bat_vars <- batsmen_data %>%
  select(Runs, Avg, SR, Fours, Sixes, Fifties)

# Create correlation heatmap
p_bat_cor <- ggcorrplot(
  cor(bat_vars),
  method = "circle",
  type = "upper",
  lab = TRUE,
  lab_size = 3,
  colors = c("#6D9EC1", "white", "#E46726"),
  title = "Batsmen Performance Variables Correlation",
  ggtheme = theme_minimal()
)

print(p_bat_cor)

# Bowlers correlation
bowl_vars <- bowlers_data %>%
  select(Wickets, Avg, Econ, SR)

p_bowl_cor <- ggcorrplot(
  cor(bowl_vars),
  method = "circle",
  type = "upper",
  lab = TRUE,
  lab_size = 3,
  colors = c("#6D9EC1", "white", "#E46726"),
  title = "Bowlers Performance Variables Correlation",
  ggtheme = theme_minimal()
)

print(p_bowl_cor)

# ============================================================================
# COMBINED DASHBOARD LAYOUT
# ============================================================================

# Create multi-panel visualization
combined_viz <- (p_bland_altman_bat | p_clusters) /
                (p_efficiency | p_bowl_tradeoff) +
  plot_annotation(
    title = "IPL 2018 Comprehensive Performance Analysis",
    subtitle = "AHP vs PCA Methodology Comparison",
    theme = theme(plot.title = element_text(size = 16, face = "bold"))
  )

ggsave("combined_analysis_dashboard.png", 
       combined_viz, 
       width = 16, height = 12, dpi = 300)

# ============================================================================
# EXPORT SUMMARY STATISTICS
# ============================================================================

summary_report <- list(
  batsmen_stats = batsmen_data %>%
    summarise(
      Total_Players = n(),
      Avg_Runs = mean(Runs),
      Avg_SR = mean(SR),