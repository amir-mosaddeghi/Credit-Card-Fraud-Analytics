# Credit Card Fraud Analytics

## Project Overview

This project analyzes credit card transactions to identify fraud patterns, quantify fraud exposure, prioritize unusual transactions, evaluate predictive models, and communicate findings through SQL, Python, and Power BI.

The project is designed as a Data Analytics / Data Analyst portfolio project, with machine learning used as one component of a broader analytical workflow.

## Dashboard Preview

The project includes an interactive Power BI dashboard with three pages covering executive KPIs, fraud and risk analysis, and model performance.

### Executive Overview

### Fraud & Risk Analysis

### Model Performance

## Business Questions

* How prevalent is fraud in the transaction population?
* Which transaction amount segments show elevated fraud rates?
* How does fraud risk vary by hour of day?
* Are anomalous transactions more concentrated in fraud?
* Which predictive model provides the strongest fraud-detection trade-off?
* How should probability thresholds be selected for operational review?
* How can the results be communicated through an interactive BI dashboard?

## Dataset

The project uses the **Credit Card Fraud Detection** dataset containing transactions from European cardholders over approximately two days in September 2013.

**Dataset source:** [Kaggle – Credit Card Fraud Detection](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)

The dataset contains:

* `Time`
* `V1`–`V28`
* `Amount`
* `Class`

`Class = 1` represents fraud and `Class = 0` represents normal transactions.

The `V1`–`V28` variables are anonymized PCA-derived features, so the project does not assign business meanings to individual V-features.

## Final Dataset

After data-quality checks and duplicate handling:

* Transactions: 283,726
* Fraud transactions: 473
* Fraud rate: 0.167%
* Total transaction amount: 25,102,001.68
* Fraud transaction amount: 58,591.39
* Fraud amount share: 0.233%

## Analytical Workflow

```text
Data Understanding
        ↓
Data Cleaning
        ↓
Exploratory Data Analysis
        ↓
Fraud Analysis
        ↓
Anomaly Detection
        ↓
Predictive Modeling
        ↓
SQL Analysis
        ↓
Power BI Dashboard
        ↓
Business Insights
```

## Key Findings

* Fraud represents only 0.167% of transactions, making class imbalance a central analytical challenge.
* The top 10% of fraudulent transactions by amount account for 62.17% of total fraudulent transaction amount.
* The 500–1,000 amount band has an observed fraud rate of approximately 0.405%.
* Zero-amount transactions show an observed fraud rate of 1.383%, compared with 0.159% for non-zero transactions.
* The highest observed hourly fraud rate is at 02:00 (1.451%).
* Isolation Forest anomaly ranking creates a highly concentrated review population; the anomaly group has an observed fraud rate of 23.89%.
* The top 10% of transactions ranked by anomaly score capture 93.28% of total fraud amount.
* Random Forest achieved 95.83% precision, 72.63% recall, 82.63% F1, and 0.811 PR-AUC at the default threshold.
* At the selected analytical threshold of 0.20, Random Forest achieved 91.46% precision, 78.95% recall, and 84.75% F1.

## Repository Structure

```text
Credit-Card-Fraud-Analytics/
│
├── data/
│   ├── creditcard.csv
│   ├── creditcard_clean.csv
│   └── analytical_outputs
│
├── notebooks/
│   ├── 01_data_understanding.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_exploratory_data_analysis.ipynb
│   ├── 04_fraud_analysis.ipynb
│   ├── 05_anomaly_detection.ipynb
│   ├── 06_predictive_analysis.ipynb
│   └── 07_sql_analysis.ipynb
│
├── sql/
│   ├── 01_data_overview.sql
│   ├── 02_fraud_kpis.sql
│   └── 03_fraud_segmentation.sql
│
├── powerbi/
│   └── fraud_analysis_dashboard.pbix
│
├── reports/
│   ├── business_insights.md
│   └── images/
│       ├── executive_overview.png
│       ├── fraud_risk_analysis.png
│       └── model_performance.png
│
└── README.md
```

## Power BI Dashboard

The Power BI dashboard contains three pages:

### 1. Executive Overview

* Transaction and fraud KPIs
* Fraud rate
* Fraud amount
* Fraud amount share
* Fraud rate by hour
* Fraud transactions by amount band

### 2. Fraud & Risk Analysis

* Fraud amount distribution
* Fraud vs. normal transaction patterns
* Fraud rate by amount band
* Hourly fraud exposure
* Zero-amount analysis
* High-value transaction analysis

### 3. Model Performance

* Predictive model comparison
* F1 score
* PR-AUC
* Precision and recall
* Selected operating points
* Confusion matrices

## Model Evaluation

Because the fraud class is extremely imbalanced, the project emphasizes:

* Precision
* Recall
* F1
* ROC-AUC
* PR-AUC
* Confusion Matrix

Accuracy is not used as the primary decision metric.

## Business Recommendations

The analysis supports a risk-prioritization approach that combines:

* Predictive fraud probability
* Anomaly score
* Transaction amount
* Amount band
* Hour of day
* Zero-amount indicator

High-exposure anomalies should receive particular attention because a small proportion of highly ranked transactions captures a large share of fraud monetary exposure.

## Limitations

* The dataset covers approximately two days.
* No customer ID is available.
* No merchant ID is available.
* No geographic information is available.
* No merchant category is available.
* V1–V28 are anonymized PCA-derived features.
* Observed relationships do not establish causality.
* Model thresholds are analytical operating points rather than production decisions.

## Detailed Report

See [`reports/business_insights.md`](reports/business_insights.md) for the complete business-oriented analysis and recommendations.

## Reproducibility

The notebooks contain the analytical workflow from data understanding through predictive modeling and SQL analysis. Generated CSV outputs are included where available to support dashboard reporting.

## Portfolio Focus

This project demonstrates practical Data Analytics skills across:

* Data cleaning
* Exploratory analysis
* Statistical testing
* Risk segmentation
* SQL analysis
* Anomaly detection
* Predictive analytics
* KPI development
* Power BI dashboarding
* Business insight generation
