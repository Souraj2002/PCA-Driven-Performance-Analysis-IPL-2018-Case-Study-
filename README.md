# IPL 2018 Player Ranking System

## Advanced Cricket Analytics using AHP & PCA Methodologies

A comprehensive player performance evaluation system for limited-overs cricket, specifically analyzing IPL 2018 season data using two distinct statistical approaches: Analytic Hierarchy Process (AHP) and Principal Component Analysis (PCA).

---

## 📊 Project Overview

This project develops an objective ranking system for cricket players by combining domain expertise with advanced statistical methods. It addresses the challenge of quantifying athletic performance in a sport with multiple correlated performance indicators.

### Key Achievements

- ✅ Developed dual-methodology ranking system (AHP + PCA)
- ✅ Analyzed 88 batsmen and 65 bowlers from IPL 2018
- ✅ PCA's first principal component explains **75% of batting variance**
- ✅ PCA's first principal component explains **66% of bowling variance**
- ✅ Rank correlation coefficient: **0.947** (batsmen), **0.936** (bowlers)
- ✅ Interactive visualization dashboard for comparative analysis

---

## 🎯 Research Objectives

1. **Develop Transparent Rating Methods**: Create objective, reproducible player ranking systems
2. **Handle Multivariate Correlation**: Address highly correlated performance metrics
3. **Compare Methodologies**: Evaluate subjective (AHP) vs. objective (PCA) approaches
4. **Provide Actionable Insights**: Support team selection and player valuation decisions
5. **Establish Foundation**: Create framework for future sports analytics research

---

## 📈 Methodologies

### Method I: Analytic Hierarchy Process (AHP)

**Subjective weighted approach based on domain expertise**

#### Batsmen Formula
```
Rating = (Runs^0.33) × (Strike Rate^0.37) × (Boundary %^0.30)
```

**Key Variables:**
- **Runs** (weight: 0.33) - Total runs scored
- **Strike Rate** (weight: 0.37) - Runs per 100 balls (most important for T20)
- **Boundary Percentage** (weight: 0.30) - Boundaries per 100 balls

**Rationale:** In T20 cricket, strike rate and boundary-hitting ability are crucial. Aggressive batsmen who score quickly rank higher than slow accumulator.

#### Bowlers Formula
```
Rating = (Economy Rate^0.37) × (Strike Rate^0.33) × (Bowling Average^0.30)
```

**Key Variables:**
- **Economy Rate** (weight: 0.37) - Runs conceded per over (most critical)
- **Bowling Strike Rate** (weight: 0.33) - Balls per wicket
- **Bowling Average** (weight: 0.30) - Runs conceded per wicket

**Rationale:** Economy rate is paramount in T20 bowling - containing runs is often more valuable than taking wickets.

---

### Method II: Principal Component Analysis (PCA)

**Objective statistical approach using eigenvalue decomposition**

#### Batsmen Analysis

**Variables Analyzed:**
- Runs, Batting Average, Strike Rate, Fours, Sixes, Half-centuries

**Correlation Matrix:** 6×6 matrix showing high correlation among performance metrics

**Eigenvalue Results:**
| PC | Eigenvalue | Variance % | Cumulative % |
|----|-----------|-----------|--------------|
| PC1 | 4.5004 | 75.0% | 75.0% |
| PC2 | 0.8482 | 14.1% | 89.1% |
| PC3 | 0.2818 | 4.7% | 93.8% |

**First Principal Component Loadings:**
```
Rating = Runs(0.459) + Average(0.416) + Strike Rate(0.25) + 
         Fours(0.433) + Sixes(0.429) + Half-centuries(0.427)
```

**Interpretation:** PC1 captures overall batting excellence with balanced emphasis on run-scoring, consistency, and boundary-hitting.

#### Bowlers Analysis

**Variables Analyzed:**
- Wickets, Bowling Average, Economy Rate, Strike Rate

**Correlation Matrix:** 4×4 matrix revealing strong negative correlation between wickets and economy/average

**Eigenvalue Results:**
| PC | Eigenvalue | Variance % | Cumulative % |
|----|-----------|-----------|--------------|
| PC1 | 2.6366 | 65.9% | 65.9% |
| PC2 | 0.8493 | 21.2% | 87.1% |
| PC3 | 0.5085 | 12.7% | 99.8% |

**First Principal Component Loadings:**
```
Rating = Wickets(-0.477) + Average(0.59) + 
         Economy(0.35) + Strike Rate(0.549)
```

**Interpretation:** Lower rating is better. Negative wicket coefficient shows wicket-taking reduces rating when combined with high economy/average.

---

## 🏆 Key Findings

### Top Ranked Batsmen (PCA Method)

| Rank | Player | Runs | Avg | SR | Rating |
|------|--------|------|-----|-----|--------|
| 1 | Kane Williamson | 735 | 52.5 | 142.44 | 580.87 |
| 2 | Rishabh Pant | 684 | 52.61 | 173.6 | 567.01 |
| 3 | KL Rahul | 659 | 54.91 | 158.41 | 553.67 |
| 4 | AB de Villiers | 480 | 53.33 | 174.54 | 443.44 |
| 5 | Jos Buttler | 548 | 54.8 | 155.24 | 415.30 |

### Top Ranked Bowlers (PCA Method)

| Rank | Player | Wickets | Avg | Econ | SR | Rating |
|------|--------|---------|-----|------|-----|--------|
| 1 | Andrew Tye | 24 | 18.66 | 8.0 | 14.0 | -2.45 |
| 2 | Rashid Khan | 21 | 21.8 | 6.73 | 19.42 | -2.13 |
| 3 | Lungi Ngidi | 11 | 14.18 | 6.0 | 14.18 | -2.03 |
| 4 | Umesh Yadav | 20 | 20.9 | 7.86 | 15.95 | -1.97 |
| 5 | Jasprit Bumrah | 17 | 21.88 | 6.88 | 19.05 | -1.77 |

### Comparative Insights

**AHP vs PCA Agreement:**
- Batsmen rank correlation: **r = 0.947** (very high agreement)
- Bowlers rank correlation: **r = 0.936** (very high agreement)

**Key Observations:**

1. **Strike Rate Dominance in T20:**
   - Rishabh Pant (SR: 173.6) ranks #1 in AHP despite fewer runs than Williamson
   - Sunil Narine (SR: 189.89) jumps to #3 in AHP from #20 by runs

2. **Economy Rate Critical for Bowlers:**
   - Lungi Ngidi (Econ: 6.0) ranks #3 despite only 11 wickets
   - High wicket-takers with poor economy (Jaydev Unadkat: 11 wickets, 9.65 econ) rank lower

3. **PCA Captures Comprehensive Performance:**
   - Balanced weightings across all performance dimensions
   - Less volatile to single-metric dominance

4. **Methodology Choice Matters:**
   - AHP emphasizes specific strategic priorities (strike rate, economy)
   - PCA provides holistic, statistically-driven assessment

---

## 🛠️ Technical Implementation

### Data Processing

**Dataset:** IPL 2018 Complete Season
- **Batsmen:** 88 players (minimum 5 matches played)
- **Bowlers:** 65 players (minimum 5 matches, 1+ wicket)

**Data Sources:**
- Official IPL statistics portal
- Match-by-match performance data
- Standardized cricket metrics

### Statistical Analysis

**Tools & Technologies:**
- R Programming for PCA calculations
- Minitab (v21.3.0) for eigenvalue decomposition
- Correlation matrix analysis
- Scree plot generation

**PCA Implementation Steps:**

1. **Data Standardization**
   ```
   Z = (X - μ) / σ
   ```
   Standardize variables to zero mean, unit variance

2. **Correlation Matrix Computation**
   ```
   R = (1/n) × Z'Z
   ```
   Calculate correlation between all variable pairs

3. **Eigenvalue Decomposition**
   ```
   R × v = λ × v
   ```
   Solve for eigenvalues (λ) and eigenvectors (v)

4. **Principal Component Selection**
   - Use scree plot to identify "elbow"
   - Select components explaining >80% variance

5. **Rating Formula Construction**
   ```
   Rating = Σ(variable_i × loading_i)
   ```
   Use first PC loadings as weights

---

## 📊 Visualization Features

### Interactive Dashboard

**Components:**
1. **Method Toggle:** Switch between AHP and PCA rankings
2. **Category Selection:** View Batsmen or Bowlers
3. **Performance Charts:** Top 10 bar charts with ratings
4. **Detailed Tables:** Complete rankings with statistics
5. **Key Insights:** Methodology-specific observations

**Visual Design:**
- Color-coded by category (green: batsmen, red: bowlers)
- Interactive tooltips with detailed metrics
- Responsive layout for all devices

---

## 🎓 Academic Significance

### Contributions to Sports Analytics

1. **Transparent Methodology:** Provides reproducible, objective ranking system
2. **Multivariate Solution:** Addresses correlated performance indicators elegantly
3. **Comparative Framework:** Demonstrates value of multiple analytical approaches
4. **Practical Application:** Directly applicable to team selection and player valuation

### Educational Value

**Demonstrates:**
- Principal Component Analysis application to real-world data
- Handling of multicollinearity in regression contexts
- Subjective vs. objective weighting approaches
- Dimensionality reduction techniques

**Target Audience:**
- Upper undergraduate statistics students
- Graduate sports analytics programs
- Cricket team analysts and scouts
- Sports data scientists

---

## 🚀 Future Research Directions

### Potential Extensions

1. **Temporal Analysis:**
   - Track player performance evolution across seasons
   - Identify career trajectory patterns
   - Predict future performance trends

2. **Situational Metrics:**
   - Performance under pressure (death overs, powerplay)
   - Match-winning contributions
   - Home/away performance differentials

3. **Team Synergy:**
   - Optimize team composition using player rankings
   - Account for player complementarity
   - Balance between specialists and all-rounders

4. **Machine Learning Integration:**
   - Neural networks for non-linear performance modeling
   - Clustering analysis for player archetypes
   - Predictive modeling for auction valuations

5. **Cross-Format Analysis:**
   - Compare T20, ODI, and Test performance
   - Format-specific weightings
   - Player versatility metrics

6. **Advanced PCA Techniques:**
   - Functional PCA for trajectory analysis
   - Sparse PCA for interpretability
   - Robust PCA for outlier handling

---

## 📚 References

### Academic Literature

1. **Principal Component Analysis:**
   - Anderson, T.W. (2003). *An Introduction to Multivariate Statistical Analysis* (3rd ed.)
   - Jolliffe, I.T. (2002). *Principal Component Analysis* (2nd ed.)

2. **Sports Analytics:**
   - Scariano, S.M. (2013). "Ranking Players in Limited-Overs Cricket Using PCA." *Journal of Statistics Education*
   - Lewis, M. (2003). *Moneyball: The Art of Winning an Unfair Game*

3. **Decision Theory:**
   - Saaty, T.L. (2008). "Decision making with the analytic hierarchy process." *International Journal of Services Sciences*

### Data Sources

- IPL Official Statistics: www.iplt20.com/stats/2018
- Cricket Analytics Research Archive
- ESPN Cricinfo Database

---

## 👨‍🎓 Project Information

**Author:** Souraj Chakraborty  
**Institution:** Asutosh College, University of Calcutta  
**Department:** Statistics Honours  
**Academic Year:** 2022-2023  
**Supervisor:** Ms. Oindrila Bose

**Course:** B.Sc. Semester-6, Paper DSE-B2  
**Project Title:** "A Ranking System of IPL Players of 2018"

---

## 📝 Citation

If you use this work in your research, please cite:

```
Chakraborty, S. (2021). A Ranking System of IPL Players of 2018: 
Integrating Analytic Hierarchy Process with Principal Component Analysis. 
Unpublished undergraduate thesis, Department of Statistics, 
Asutosh College, University of Calcutta.
```

---

## 📧 Contact

For questions, collaborations, or feedback regarding this project:

**Academic Inquiries:**
- Department of Statistics, Asutosh College
- University of Calcutta

**Technical Support:**
- Refer to documentation and methodology sections
- Check correlation matrices and eigenvalue tables for implementation details

---

## 🙏 Acknowledgments

Special thanks to:
- **Ms. Oindrila Bose** - Project Supervisor
- **Dr. Dhiman Dutta** - Head, Department of Statistics
- **Faculty Members:** Dr. Shirsendu Mukherjee, Dr. Sankha Bhattacharya, Dr. Parthasarathi Bera
- **Dr. Apurba Roy** - Vice-Principal, Asutosh College

---

## 📄 License

This project is submitted as academic work for educational purposes. 

**Usage Guidelines:**
- Academic and educational use permitted with citation
- Commercial use requires explicit permission
- Data sourced from public IPL statistics
- Methodology freely reproducible for research

---

## 🔍 Keywords

Cricket Analytics, Player Rating Systems, Principal Component Analysis, Analytic Hierarchy Process, Sports Statistics, Multivariate Analysis, IPL 2018, Performance Evaluation, T20 Cricket, Data Science, Statistical Modeling, Dimensionality Reduction

---

**Last Updated:** 2025  
**Version:** 1.0  
**Status:** Completed Academic Project
