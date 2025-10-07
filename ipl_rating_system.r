# IPL 2018 Player Rating System
# Combining AHP and PCA for Player Rankings

# Load required libraries
library(tidyverse)
library(factoextra)
library(corrplot)
library(scales)

# ============================================================================
# SECTION 1: DATA PREPARATION
# ============================================================================

# Batsmen Data (Top 50 from the document)
batsmen_data <- tribble(
  ~Player, ~Matches, ~Innings, ~Runs, ~BF, ~NO, ~Avg, ~SR, ~Fours, ~Sixes, ~Fifties, ~Centuries,
  "Kane Williamson", 17, 17, 735, 516, 3, 52.5, 142.44, 64, 28, 8, 0,
  "Rishabh Pant", 14, 14, 684, 394, 1, 52.61, 173.6, 68, 37, 5, 1,
  "KL Rahul", 14, 14, 659, 416, 2, 54.91, 158.41, 66, 32, 6, 0,
  "Ambati Rayudu", 16, 16, 602, 402, 2, 43, 149.75, 53, 34, 3, 1,
  "Shane Watson", 15, 15, 555, 359, 1, 39.64, 154.59, 44, 35, 2, 2,
  "Jos Buttler", 13, 13, 548, 353, 3, 54.8, 155.24, 52, 21, 5, 0,
  "Virat Kohli", 14, 14, 530, 381, 3, 48.18, 139.1, 52, 18, 4, 0,
  "Suryakumar Yadav", 14, 14, 512, 384, 0, 36.57, 133.33, 61, 16, 4, 0,
  "Dinesh Karthik", 16, 16, 498, 337, 6, 49.8, 147.77, 49, 16, 2, 0,
  "Shikhar Dhawan", 16, 16, 497, 363, 3, 38.23, 136.91, 59, 14, 4, 0,
  "Chris Lynn", 16, 16, 491, 377, 1, 32.73, 130.23, 56, 18, 3, 0,
  "AB de Villiers", 12, 11, 480, 275, 2, 53.33, 174.54, 39, 30, 6, 0,
  "MS Dhoni", 16, 15, 455, 302, 9, 75.83, 150.66, 24, 30, 3, 0,
  "Suresh Raina", 15, 15, 445, 336, 3, 37.08, 132.44, 46, 12, 4, 0,
  "Sanju Samson", 15, 15, 441, 320, 1, 31.5, 137.81, 30, 19, 3, 0,
  "Shreyas Iyer", 14, 14, 411, 310, 0, 29.35, 132.58, 29, 21, 4, 0,
  "Evin Lewis", 13, 13, 382, 276, 0, 29.38, 138.4, 32, 24, 2, 0,
  "Ajinkya Rahane", 15, 14, 370, 313, 1, 28.46, 118.21, 39, 5, 1, 0,
  "Chris Gayle", 11, 11, 368, 252, 2, 40.88, 146.03, 30, 27, 3, 1,
  "Sunil Narine", 16, 16, 357, 188, 0, 22.31, 189.89, 40, 23, 2, 0,
  "Robin Uthappa", 16, 16, 351, 265, 0, 21.93, 132.45, 30, 21, 1, 0,
  "Andre Russell", 16, 14, 316, 171, 3, 28.72, 184.79, 17, 31, 1, 0,
  "Nitish Rana", 15, 15, 304, 232, 2, 23.38, 131.03, 26, 14, 1, 0,
  "Karun Nair", 13, 12, 301, 221, 0, 25.08, 136.19, 23, 13, 2, 0,
  "Rohit Sharma", 14, 14, 286, 215, 2, 23.83, 133.02, 25, 12, 2, 0
)

# Bowlers Data (Top 50 from the document)
bowlers_data <- tribble(
  ~Player, ~Matches, ~Innings, ~Overs, ~Runs, ~Wickets, ~Avg, ~Econ, ~SR, ~FourW, ~FiveW,
  "Andrew Tye", 14, 14, 56, 448, 24, 18.66, 8, 14, 3, 0,
  "Rashid Khan", 17, 17, 68, 458, 21, 21.8, 6.73, 19.42, 0, 0,
  "Siddarth Kaul", 17, 17, 66, 547, 21, 26.04, 8.28, 18.85, 0, 0,
  "Umesh Yadav", 14, 14, 53.1, 418, 20, 20.9, 7.86, 15.95, 0, 0,
  "Trent Boult", 14, 14, 52.4, 466, 18, 25.88, 8.84, 17.55, 0, 0,
  "Hardik Pandya", 13, 13, 42.4, 381, 18, 21.16, 8.92, 14.22, 0, 0,
  "Sunil Narine", 16, 16, 61, 467, 17, 27.47, 7.65, 21.52, 0, 0,
  "Kuldeep Yadav", 16, 16, 51.2, 418, 17, 24.58, 8.14, 18.11, 1, 0,
  "Jasprit Bumrah", 14, 14, 54, 372, 17, 21.88, 6.88, 19.05, 0, 0,
  "Shardul Thakur", 13, 13, 46.4, 431, 16, 26.93, 9.23, 17.5, 0, 0,
  "Mayank Markande", 14, 14, 44, 368, 15, 24.53, 8.36, 17.6, 1, 0,
  "Jofra Archer", 10, 10, 38.5, 325, 15, 21.66, 8.36, 15.53, 0, 0,
  "Shakib Al Hasan", 17, 17, 57, 456, 14, 32.57, 8, 24.42, 0, 0,
  "Dwayne Bravo", 16, 16, 53.3, 533, 14, 38.07, 9.96, 22.92, 0, 0,
  "Piyush Chawla", 15, 15, 49, 412, 14, 29.42, 8.4, 21, 0, 0,
  "Mujeeb Ur Rahman", 11, 11, 41.2, 289, 14, 20.64, 6.99, 17.71, 0, 0,
  "Mitchell McClenaghan", 11, 11, 40, 332, 14, 23.71, 8.3, 17.14, 0, 0,
  "Andre Russell", 16, 15, 37.5, 355, 13, 27.3, 9.38, 17.46, 0, 0,
  "Krunal Pandya", 14, 13, 40.1, 284, 12, 23.66, 7.07, 20.08, 0, 0,
  "Yuzvendra Chahal", 14, 14, 50, 363, 12, 30.25, 7.26, 25, 0, 0,
  "Sandeep Sharma", 12, 12, 44, 333, 12, 27.75, 7.56, 22, 0, 0,
  "Amit Mishra", 10, 10, 37, 264, 12, 22, 7.13, 18.5, 0, 0,
  "Ravindra Jadeja", 16, 14, 41, 303, 11, 27.54, 7.39, 22.36, 0, 0,
  "Krishnappa Gowtham", 15, 15, 40, 312, 11, 28.36, 7.8, 21.81, 0, 0,
  "Jaydev Unadkat", 15, 15, 50.2, 486, 11, 44.18, 9.65, 27.45, 0, 0
)

# Calculate derived metrics for batsmen
batsmen_data <- batsmen_data %>%
  mutate(
    Total_Boundaries = Fours + Sixes,
    Percentage_Boundary = (Total_Boundaries / BF) * 100
  )

# ============================================================================
# SECTION 2: METHOD I - AHP WEIGHTED RATING
# ============================================================================

# Batsmen AHP Weights (from document)
bat_weights <- list(
  Runs = 0.33,
  SR = 0.37,
  Percentage_Boundary = 0.30
)

# Calculate AHP Rating for Batsmen
batsmen_ahp <- batsmen_data %>%
  mutate(
    AHP_Rating = (Runs^bat_weights$Runs) * 
                 (SR^bat_weights$SR) * 
                 (Percentage_Boundary^bat_weights$Percentage_Boundary),
    AHP_Rank = rank(-AHP_Rating, ties.method = "min")
  ) %>%
  arrange(AHP_Rank)

# Bowlers AHP Weights (from document - note: lower is better)
bowl_weights <- list(
  Econ = 0.37,
  SR = 0.33,
  Avg = 0.30
)

# Calculate AHP Rating for Bowlers (lower is better)
bowlers_ahp <- bowlers_data %>%
  mutate(
    AHP_Rating = (Econ^bowl_weights$Econ) * 
                 (SR^bowl_weights$SR) * 
                 (Avg^bowl_weights$Avg),
    AHP_Rank = rank(AHP_Rating, ties.method = "min")
  ) %>%
  arrange(AHP_Rank)

# ============================================================================
# SECTION 3: METHOD II - PRINCIPAL COMPONENT ANALYSIS
# ============================================================================

# --- BATSMEN PCA ---
bat_pca_vars <- batsmen_data %>%
  select(Runs, Avg, SR, Fours, Sixes, Fifties) %>%
  scale()

bat_pca <- prcomp(bat_pca_vars, scale. = FALSE)

# Extract PC1 loadings
bat_pc1_loadings <- bat_pca$rotation[, 1]
print("Batsmen PC1 Loadings:")
print(round(bat_pc1_loadings, 3))

# Calculate PCA Rating using PC1
batsmen_pca <- batsmen_data %>%
  mutate(
    PCA_Rating = (Runs * abs(bat_pc1_loadings[1])) +
                 (Avg * abs(bat_pc1_loadings[2])) +
                 (SR * abs(bat_pc1_loadings[3])) +
                 (Fours * abs(bat_pc1_loadings[4])) +
                 (Sixes * abs(bat_pc1_loadings[5])) +
                 (Fifties * abs(bat_pc1_loadings[6])),
    PCA_Rank = rank(-PCA_Rating, ties.method = "min")
  ) %>%
  arrange(PCA_Rank)

# --- BOWLERS PCA ---
bowl_pca_vars <- bowlers_data %>%
  select(Wickets, Avg, Econ, SR) %>%
  scale()

bowl_pca <- prcomp(bowl_pca_vars, scale. = FALSE)

# Extract PC1 loadings
bowl_pc1_loadings <- bowl_pca$rotation[, 1]
print("\nBowlers PC1 Loadings:")
print(round(bowl_pc1_loadings, 3))

# Calculate PCA Rating using PC1 (adjusted for direction)
bowlers_pca <- bowlers_data %>%
  mutate(
    PCA_Rating = (Wickets * -abs(bowl_pc1_loadings[1])) +
                 (Avg * abs(bowl_pc1_loadings[2])) +
                 (Econ * abs(bowl_pc1_loadings[3])) +
                 (SR * abs(bowl_pc1_loadings[4])),
    PCA_Rank = rank(PCA_Rating, ties.method = "min")
  ) %>%
  arrange(PCA_Rank)

# ============================================================================
# SECTION 4: COMBINED RESULTS & CORRELATION
# ============================================================================

# Combine both ranking methods for batsmen
batsmen_final <- batsmen_data %>%
  left_join(
    batsmen_ahp %>% select(Player, AHP_Rating, AHP_Rank),
    by = "Player"
  ) %>%
  left_join(
    batsmen_pca %>% select(Player, PCA_Rating, PCA_Rank),
    by = "Player"
  )

# Combine both ranking methods for bowlers
bowlers_final <- bowlers_data %>%
  left_join(
    bowlers_ahp %>% select(Player, AHP_Rating, AHP_Rank),
    by = "Player"
  ) %>%
  left_join(
    bowlers_pca %>% select(Player, PCA_Rating, PCA_Rank),
    by = "Player"
  )

# Calculate Spearman correlation between ranking methods
bat_rank_cor <- cor(batsmen_final$AHP_Rank, batsmen_final$PCA_Rank, 
                    method = "spearman", use = "complete.obs")
bowl_rank_cor <- cor(bowlers_final$AHP_Rank, bowlers_final$PCA_Rank, 
                     method = "spearman", use = "complete.obs")

cat("\n=== RANKING CORRELATION ===\n")
cat("Batsmen Rank Correlation (AHP vs PCA):", round(bat_rank_cor, 4), "\n")
cat("Bowlers Rank Correlation (AHP vs PCA):", round(bowl_rank_cor, 4), "\n")

# ============================================================================
# SECTION 5: VISUALIZATIONS
# ============================================================================

# 1. Batsmen PCA Scree Plot
fviz_eig(bat_pca, addlabels = TRUE, 
         main = "Batsmen PCA - Variance Explained")

# 2. Batsmen Correlation Matrix
bat_cor_matrix <- cor(batsmen_data %>% 
                      select(Runs, Avg, SR, Fours, Sixes, Fifties))
corrplot(bat_cor_matrix, method = "color", type = "upper",
         addCoef.col = "black", number.cex = 0.7,
         title = "Batsmen Variables Correlation Matrix",
         mar = c(0,0,2,0))

# 3. Bowlers PCA Scree Plot
fviz_eig(bowl_pca, addlabels = TRUE,
         main = "Bowlers PCA - Variance Explained")

# 4. Bowlers Correlation Matrix
bowl_cor_matrix <- cor(bowlers_data %>% 
                       select(Wickets, Avg, Econ, SR))
corrplot(bowl_cor_matrix, method = "color", type = "upper",
         addCoef.col = "black", number.cex = 0.7,
         title = "Bowlers Variables Correlation Matrix",
         mar = c(0,0,2,0))

# 5. Top 10 Batsmen Comparison
top_batsmen <- batsmen_final %>%
  arrange(AHP_Rank) %>%
  head(10) %>%
  select(Player, AHP_Rank, PCA_Rank) %>%
  pivot_longer(cols = c(AHP_Rank, PCA_Rank),
               names_to = "Method", values_to = "Rank")

ggplot(top_batsmen, aes(x = reorder(Player, -Rank), y = Rank, fill = Method)) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_reverse() +
  labs(title = "Top 10 Batsmen: AHP vs PCA Rankings",
       x = "Player", y = "Rank (Lower is Better)") +
  theme_minimal() +
  theme(legend.position = "top")

# 6. Top 10 Bowlers Comparison
top_bowlers <- bowlers_final %>%
  arrange(AHP_Rank) %>%
  head(10) %>%
  select(Player, AHP_Rank, PCA_Rank) %>%
  pivot_longer(cols = c(AHP_Rank, PCA_Rank),
               names_to = "Method", values_to = "Rank")

ggplot(top_bowlers, aes(x = reorder(Player, -Rank), y = Rank, fill = Method)) +
  geom_col(position = "dodge") +
  coord_flip() +
  scale_y_reverse() +
  labs(title = "Top 10 Bowlers: AHP vs PCA Rankings",
       x = "Player", y = "Rank (Lower is Better)") +
  theme_minimal() +
  theme(legend.position = "top")

# ============================================================================
# SECTION 6: EXPORT FOR POWER BI
# ============================================================================

# Export final datasets for Power BI
write.csv(batsmen_final, "IPL2018_Batsmen_Rankings.csv", row.names = FALSE)
write.csv(bowlers_final, "IPL2018_Bowlers_Rankings.csv", row.names = FALSE)

# Create summary statistics for dashboard
summary_stats <- data.frame(
  Metric = c("Batsmen Analyzed", "Bowlers Analyzed", 
             "Batsmen Rank Correlation", "Bowlers Rank Correlation",
             "Top Batsman (AHP)", "Top Bowler (AHP)",
             "Top Batsman (PCA)", "Top Bowler (PCA)"),
  Value = c(nrow(batsmen_final), nrow(bowlers_final),
            round(bat_rank_cor, 4), round(bowl_rank_cor, 4),
            batsmen_ahp$Player[1], bowlers_ahp$Player[1],
            batsmen_pca$Player[1], bowlers_pca$Player[1])
)

write.csv(summary_stats, "IPL2018_Summary_Statistics.csv", row.names = FALSE)

# Print summary
cat("\n=== TOP 5 BATSMEN (AHP METHOD) ===\n")
print(batsmen_ahp %>% select(AHP_Rank, Player, Runs, SR, AHP_Rating) %>% head(5))

cat("\n=== TOP 5 BATSMEN (PCA METHOD) ===\n")
print(batsmen_pca %>% select(PCA_Rank, Player, Runs, Avg, PCA_Rating) %>% head(5))

cat("\n=== TOP 5 BOWLERS (AHP METHOD) ===\n")
print(bowlers_ahp %>% select(AHP_Rank, Player, Wickets, Econ, AHP_Rating) %>% head(5))

cat("\n=== TOP 5 BOWLERS (PCA METHOD) ===\n")
print(bowlers_pca %>% select(PCA_Rank, Player, Wickets, Avg, PCA_Rating) %>% head(5))

cat("\n✓ Data exported successfully for Power BI!\n")
cat("  - IPL2018_Batsmen_Rankings.csv\n")
cat("  - IPL2018_Bowlers_Rankings.csv\n")
cat("  - IPL2018_Summary_Statistics.csv\n")
