# Credit Card Fraud Analytics — Business Insights Report

## 1. Executive Summary

This project analyzes credit card transactions with a primary focus on fraud detection, fraud exposure, risk segmentation, and analytical decision support.

After data cleaning, the final analytical dataset contains **283,726 transactions**, including **473 fraudulent transactions**. Fraud represents only **0.167% of transactions**, highlighting the severe class imbalance of the problem.

Several findings are particularly relevant for fraud-risk monitoring:

- Fraud is highly concentrated in a relatively small number of transactions by monetary value. The **top 10% of fraudulent transactions account for 62.17% of total fraudulent transaction amount**.
- Fraud rates vary substantially across transaction amount bands. The highest observed rate among sufficiently populated bands occurs in the **500–1,000** range at approximately **0.405%**.
- Zero-amount transactions have a higher observed fraud rate (**1.383%**) than non-zero transactions (**0.159%**), although the zero-amount segment contains relatively few transactions.
- Fraud rates also vary by hour of day. The highest observed hourly fraud rate is at **02:00 (1.451%)**, followed by **04:00 (1.044%)**. These hourly patterns should be treated as short-period observations rather than seasonal conclusions because the dataset covers approximately two days.
- Unsupervised anomaly detection with Isolation Forest identified a subset of transactions with a substantially higher fraud prevalence than the overall dataset. Among transactions flagged as anomalies, the observed fraud rate was **23.89%**, compared with **0.127%** among transactions not flagged as anomalies.
- For supervised prediction, **Random Forest** achieved the strongest overall operational profile among the tested models, with **95.83% precision, 72.63% recall, 82.63% F1, and 0.811 PR-AUC** at the default threshold.
- Threshold selection materially changes the trade-off between false positives and missed fraud. At the selected analytical operating point of **0.20**, Random Forest achieved **91.46% precision, 78.95% recall, and 84.75% F1**.

The overall conclusion is that fraud analytics should combine **risk segmentation, anomaly prioritization, predictive scoring, and threshold-based review** rather than rely on a single metric or model.

---

## 2. Business Problem

The analytical objective is to identify patterns associated with fraudulent credit card transactions and translate those patterns into useful decision-support outputs.

The project addresses four main questions:

1. How common is fraud in the transaction population?
2. Which transaction segments show elevated fraud rates or fraud exposure?
3. Can unsupervised anomaly detection help prioritize transactions for investigation?
4. Can supervised models distinguish fraudulent transactions from normal transactions while managing the cost of false positives?

The project is intentionally designed as a **Data Analytics project** rather than a pure machine-learning project. Python, SQL, statistical analysis, and Power BI are used together to create a complete analytical workflow.

---

## 3. Dataset Overview

The dataset contains credit card transactions from European cardholders collected over approximately two days in September 2013.

The final cleaned dataset contains:

| Metric | Value |
|---|---:|
| Total transactions | 283,726 |
| Normal transactions | 283,253 |
| Fraud transactions | 473 |
| Fraud rate | 0.167% |
| Total transaction amount | 25,102,001.68 |
| Fraud transaction amount | 58,591.39 |
| Fraud amount share | 0.233% |

The original transaction table contains:

- `Time`
- `V1`–`V28`
- `Amount`
- `Class`

`Class = 1` represents fraud and `Class = 0` represents normal transactions.

The `V1`–`V28` variables are anonymized PCA-derived features. Therefore, this report does not assign business meanings to individual V-features.

---

## 4. Data Quality and Preparation

The data preparation workflow followed a structured process:

**Check → Analyze → Decide → Clean → Validate → Save**

Key preparation steps included:

- Checking data types
- Checking missing values
- Investigating exact duplicate rows
- Removing exact duplicate records after investigation
- Investigating zero-amount transactions
- Checking for negative transaction amounts
- Validating the fraud-class values
- Validating the time variable
- Checking the V1–V28 feature structure
- Revalidating the cleaned dataset

The final cleaned dataset contains **283,726 rows**, down from the original dataset size because exact duplicate records were removed.

Zero-amount transactions were retained because they were not automatically treated as invalid records. Instead, they were analyzed as a separate risk segment.

---

## 5. Fraud Profile

Fraud is extremely rare in the overall transaction population:

- **473 fraudulent transactions**
- **0.167% fraud rate**

The monetary profile is more nuanced.

| Metric | Fraud |
|---|---:|
| Average amount | 123.87 |
| Median amount | 9.82 |
| Maximum amount | 2,125.87 |
| Total fraud amount | 58,591.39 |

The average fraud amount is much higher than the median fraud amount. This indicates that a relatively small number of larger fraudulent transactions have a strong influence on the average.

This is important for analysis because relying only on the mean would hide the concentration of fraudulent transactions at lower transaction amounts.

---

## 6. Amount-Based Risk Analysis

Transaction amount is one of the strongest practical segmentation variables available in the dataset.

Observed fraud rates by amount band include:

| Amount Band | Transactions | Fraud Transactions | Fraud Rate |
|---|---:|---:|---:|
| 0–10 | 99,821 | 238 | 0.238% |
| 10–25 | 49,819 | 27 | 0.054% |
| 25–50 | 40,508 | 28 | 0.069% |
| 50–100 | 37,179 | 55 | 0.148% |
| 100–250 | 33,828 | 54 | 0.160% |
| 250–500 | 13,462 | 37 | 0.275% |
| 500–1,000 | 6,174 | 25 | 0.405% |
| 1,000–2,500 | 2,495 | 9 | 0.361% |
| 2,500–5,000 | 385 | 0 | 0.000% |
| 5,000+ | 55 | 0 | 0.000% |

Two different risk perspectives emerge.

### Transaction-frequency perspective

The **0–10** segment contains the largest number of fraudulent transactions: **238**, representing approximately half of all fraud transactions.

Therefore, fraud is not limited to large-value transactions.

### Risk-rate perspective

The **500–1,000** segment has the highest observed fraud rate among the main populated bands at approximately **0.405%**.

The **1,000–2,500** segment also shows an elevated fraud rate of approximately **0.361%**.

### Fraud-amount perspective

Fraud monetary exposure is concentrated more strongly in higher-value fraud transactions.

The top 10% of fraudulent transactions by amount represent **48 transactions** but account for **62.17% of total fraudulent transaction amount**.

This suggests that operational monitoring can benefit from considering both:

- the probability of fraud, and
- the potential financial exposure.

---

## 7. Zero-Amount Transactions

Zero-amount transactions were analyzed separately rather than removed automatically.

Results:

| Segment | Transactions | Fraud | Fraud Rate |
|---|---:|---:|---:|
| Zero Amount | 1,808 | 25 | 1.383% |
| Non-Zero Amount | 281,918 | 448 | 0.159% |

The observed fraud rate for zero-amount transactions is therefore substantially higher than the overall fraud rate.

However, the zero-amount segment is relatively small, so this finding should be treated as a **risk signal requiring further investigation**, not as evidence that every zero-amount transaction is suspicious.

---

## 8. Statistical Analysis of Transaction Amount

Because transaction amounts are strongly skewed, a **Mann–Whitney U test** was used to compare the amount distributions of normal and fraudulent transactions.

Results:

- U statistic: **74,461,539.5**
- p-value: **2.69 × 10⁻⁵**
- Rank-biserial effect size: **-0.112**

The statistical test provides evidence that the transaction-amount distributions of fraud and normal transactions differ.

However, the effect size is relatively small. Therefore, transaction amount alone should not be treated as a sufficient fraud-detection rule.

The practical implication is that amount is useful for **segmentation and prioritization**, especially when combined with other transaction characteristics.

---

## 9. Time-Based Risk Analysis

The dataset covers approximately two days, so time analysis is limited to **hour-of-day patterns**.

The highest observed fraud rates were:

| Hour | Transactions | Fraud Transactions | Fraud Rate |
|---:|---:|---:|---:|
| 02:00 | 3,308 | 48 | 1.451% |
| 04:00 | 2,204 | 23 | 1.044% |
| 03:00 | 3,487 | 17 | 0.488% |
| 05:00 | 2,988 | 11 | 0.368% |
| 07:00 | 7,233 | 23 | 0.318% |
| 11:00 | 16,781 | 53 | 0.316% |

The 02:00 and 04:00 periods show particularly elevated observed fraud rates.

These findings can be useful for **monitoring and prioritization**, but they should not be interpreted as stable seasonal or long-term patterns because the available data covers only approximately two days.

---

## 10. Anomaly Detection

Isolation Forest was used as an unsupervised anomaly-detection method.

The model was trained without using the fraud label as a training feature. The base anomaly model used:

- V1–V28
- Amount

Time was excluded from the base anomaly model so that elapsed time would not dominate the anomaly structure.

The contamination parameter was set close to the observed fraud prevalence as an analytical operating-point choice. This does **not** mean that every anomaly is fraud.

### Overall anomaly results

| Metric | Result |
|---|---:|
| Precision | 23.89% |
| Recall | 23.89% |
| F1 | 23.89% |
| ROC-AUC | 0.949 |
| PR-AUC | 0.135 |

The anomaly confusion matrix was:

| | Predicted Normal | Predicted Fraud |
|---|---:|---:|
| Actual Normal | 282,893 | 360 |
| Actual Fraud | 360 | 113 |

The most important operational finding is the difference in fraud prevalence:

- Fraud rate among flagged anomalies: **23.89%**
- Fraud rate among non-anomalies: **0.127%**

This means the anomaly detector creates a substantially more concentrated review population.

### Review prioritization

When ranking transactions by anomaly score:

- Reviewing the top 1% captured **62.40% of total fraud amount**
- Reviewing the top 5% captured **86.20% of total fraud amount**
- Reviewing the top 10% captured **93.28% of total fraud amount**

This is especially relevant from a financial-risk perspective because anomaly ranking appears useful for prioritizing transactions with high fraud monetary exposure.

Anomaly detection should therefore be viewed primarily as a **triage and prioritization mechanism**, not as a standalone fraud classifier.

---

## 11. Predictive Modeling

Two supervised models were evaluated:

1. Logistic Regression
2. Random Forest

The dataset was split using a stratified train/test split, and preprocessing was performed within the modeling pipeline to avoid data leakage.

Because fraud is extremely imbalanced, the evaluation emphasized:

- Precision
- Recall
- F1
- ROC-AUC
- PR-AUC
- Confusion Matrix

Accuracy was intentionally not used as the main decision metric.

### Model comparison

| Model | Precision | Recall | F1 | ROC-AUC | PR-AUC |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 5.64% | 87.37% | 10.60% | 96.57% | 67.37% |
| Random Forest | 95.83% | 72.63% | 82.63% | 94.27% | 81.09% |

### Logistic Regression

Logistic Regression achieved higher recall and ROC-AUC at the default threshold.

However, its default operating point produced:

- **83 true positives**
- **12 false negatives**
- **1,388 false positives**

This means it captures many fraudulent transactions but creates a very large review population.

### Random Forest

Random Forest produced:

- **69 true positives**
- **26 false negatives**
- **3 false positives**
- **56,648 true negatives**

Its substantially higher precision and F1 make it more attractive when the cost of false alarms is important.

It also achieved a higher PR-AUC than Logistic Regression, which is particularly relevant for this highly imbalanced fraud problem.

---

## 12. Threshold Analysis

A model's default probability threshold is not necessarily the best operational threshold.

The selected analytical operating points were:

| Model | Threshold | Precision | Recall | F1 | Predicted Fraud |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | 0.95 | 43.43% | 80.00% | 56.30% | 175 |
| Random Forest | 0.20 | 91.46% | 78.95% | 84.75% | 82 |

The Random Forest threshold of **0.20** provides a useful balance between precision and recall in this analysis.

At this operating point:

- Approximately **91% of flagged transactions are fraudulent**
- Approximately **79% of actual fraud is captured**
- The resulting F1 score is **84.75%**

The threshold should be considered an **analytical operating point**, not a production threshold. A real production threshold would depend on investigation capacity, fraud losses, customer impact, false-positive costs, and business risk tolerance.

---

## 13. Model Feature Insights

The Random Forest feature-importance analysis identified several V-features as influential:

1. V14
2. V10
3. V4
4. V12
5. V17
6. V11
7. V16
8. V3

Logistic Regression also identified several of these variables among the strongest absolute coefficients, along with Amount.

Because V1–V28 are anonymized PCA-derived features, these results should be interpreted as **statistical predictive signals**, not as business explanations of why a transaction is fraudulent.

Feature importance does not establish causality.

---

## 14. SQL Analysis Findings

SQL was used to reproduce core analytical questions in a relational workflow.

The SQL analysis covered:

- Data overview
- Fraud KPIs
- Fraud vs. normal amount profiles
- Amount-band segmentation
- Hourly fraud rates
- Hour ranking
- High-value transactions
- Zero-amount transactions

The SQL results support the same major findings identified through Python:

- Fraud is highly imbalanced.
- Fraud rates differ across amount segments.
- The 500–1,000 amount band has an elevated observed fraud rate.
- Hour-of-day risk varies considerably.
- Zero-amount transactions show a higher observed fraud rate than non-zero transactions.
- High-value transactions can be isolated as a separate analytical segment.

This demonstrates that the analysis is not dependent on a single programming environment and can be reproduced using SQL-oriented workflows.

---

## 15. Power BI Dashboard

The Power BI dashboard translates the analytical results into three decision-support pages:

### Executive Overview

Focuses on:

- Total transactions
- Fraud transactions
- Fraud rate
- Fraud amount
- Fraud amount share
- Fraud rate by hour
- Fraud rate by amount band

### Fraud & Risk Analysis

Focuses on:

- Fraud amount distribution
- Fraud vs. normal transaction patterns
- Amount-band risk
- Hourly fraud exposure
- Zero-amount transactions
- High-value transactions

### Model Performance

Focuses on:

- Model comparison
- F1 score
- PR-AUC
- Precision and recall
- Selected operating points
- Random Forest confusion matrix
- Logistic Regression confusion matrix

The dashboard is designed to support analytical interpretation rather than simply display model outputs.

---

## 16. Key Business Insights

### Insight 1 — Fraud is rare, but highly concentrated

Only **0.167%** of transactions are fraudulent. This makes naive accuracy-based evaluation misleading and reinforces the need for precision/recall-oriented analysis.

### Insight 2 — High-value fraud drives a disproportionate share of monetary exposure

The top 10% of fraudulent transactions account for **62.17% of fraud amount**.

A risk-management process should therefore consider potential financial exposure in addition to fraud probability.

### Insight 3 — Small transactions should not be ignored

The 0–10 amount band contains **238 fraud transactions**, approximately half of all fraud transactions.

Therefore, a strategy focused only on large transactions would miss a substantial number of fraudulent events.

### Insight 4 — Some amount bands have elevated fraud rates

The 500–1,000 band has an observed fraud rate of approximately **0.405%**, higher than the overall fraud rate.

Amount segmentation can therefore be useful as one component of risk prioritization.

### Insight 5 — Zero-amount transactions deserve attention

Zero-amount transactions have an observed fraud rate of **1.383%**, compared with **0.159%** for non-zero transactions.

This is a strong relative signal, although the segment is small and requires further investigation before becoming a business rule.

### Insight 6 — Fraud risk varies by time of day

The highest observed fraud rate occurs at **02:00**, followed by **04:00**.

These results suggest that time-of-day can contribute to transaction prioritization, but the short observation window prevents broader temporal conclusions.

### Insight 7 — Anomaly detection can reduce the review population

Only a small subset of transactions is flagged as anomalous, yet the flagged population has a **23.89% fraud rate**.

The top 10% of transactions ranked by anomaly score captured **93.28% of total fraud amount**, making anomaly ranking particularly useful for financial-exposure prioritization.

### Insight 8 — Random Forest provides the strongest predictive operating profile

Random Forest achieved higher precision, F1, and PR-AUC than Logistic Regression.

At the selected threshold of 0.20, it provides a strong balance between fraud capture and review efficiency.

### Insight 9 — Threshold selection is a business decision

There is no universally correct probability threshold.

A lower threshold generally increases fraud capture but can increase false positives. A higher threshold can improve precision while allowing more fraud to remain undetected.

The appropriate threshold should therefore be determined using operational capacity and business costs.

---

## 17. Business Recommendations

### 1. Use risk-based transaction prioritization

Instead of treating all transactions equally, prioritize transactions using multiple signals:

- Predicted fraud probability
- Anomaly score
- Transaction amount
- Amount band
- Hour of day
- Zero-amount indicator

### 2. Prioritize high-exposure anomalies

Anomaly ranking can be particularly useful for investigation queues because the top-ranked transactions capture a large share of fraud amount.

### 3. Monitor elevated amount bands

The 250–500, 500–1,000, and 1,000–2,500 ranges show elevated fraud rates relative to several lower-value segments.

These segments can be monitored as part of a broader risk strategy rather than used as standalone fraud rules.

### 4. Investigate zero-amount activity

The higher fraud rate among zero-amount transactions makes this segment worth investigating separately.

Before applying an automated rule, the business should determine why these transactions occur and whether they represent authorization, verification, or other legitimate processes.

### 5. Use model thresholds according to review capacity

If investigation capacity is limited, a higher-precision operating point may be preferable.

If missing fraud is substantially more costly, a lower threshold may be justified.

### 6. Combine supervised and unsupervised analytics

Predictive models and anomaly detection provide different types of information.

A combined review framework can use:

- supervised probability for fraud likelihood
- anomaly score for unusual behavior
- transaction amount for financial exposure

This creates a more flexible analytical risk-prioritization framework.

---

## 18. Project Limitations

Several limitations should be considered when interpreting the results.

### Dataset limitations

- The dataset covers approximately two days.
- There is no customer identifier.
- There is no merchant identifier.
- There is no geographic information.
- There is no merchant category.
- V1–V28 are anonymized PCA-derived variables.

Therefore, the project cannot support customer-level, merchant-level, geographic, category-level, or long-term seasonal conclusions.

### Statistical limitations

Observed differences do not establish causality.

For example, an elevated fraud rate at a particular hour does not prove that the hour itself causes fraud.

### Modeling limitations

The predictive models are evaluated on this historical dataset and should not be interpreted as production-ready fraud systems.

The selected Random Forest threshold of 0.20 is an analytical operating point. A production threshold would require additional information about:

- fraud investigation capacity
- financial loss
- false-positive cost
- customer experience
- regulatory requirements
- model stability over time

### Anomaly detection limitations

Isolation Forest identifies unusual transactions, not necessarily fraudulent transactions.

Its strongest value in this project is transaction prioritization and review concentration.

---

## 19. Final Conclusion

This project demonstrates a complete Data Analytics workflow for credit card fraud analysis.

The analysis moves from:

**data understanding → data cleaning → exploratory analysis → fraud analysis → anomaly detection → predictive modeling → SQL analysis → Power BI reporting**

The most important business lesson is that fraud detection is not simply a classification problem.

The dataset shows:

- extreme class imbalance,
- concentration of fraud monetary exposure,
- meaningful differences across transaction segments,
- elevated risk in selected time periods,
- strong anomaly concentration,
- and significant trade-offs between precision and recall.

Random Forest provides the strongest predictive performance among the tested models, while Isolation Forest provides an additional mechanism for prioritizing unusual transactions.

The final analytical approach therefore combines **descriptive analytics, diagnostic analysis, statistical testing, anomaly detection, predictive modeling, SQL, and interactive BI reporting**.

This makes the project suitable as a **Data Analyst / Data Analytics portfolio project** because the emphasis is on translating transaction data into measurable risk insights and decision-support outputs rather than focusing solely on machine-learning model development.
