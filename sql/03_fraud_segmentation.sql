-- 03_fraud_segmentation.sql
-- SQLite-compatible SQL

WITH hourly AS (
    SELECT
        CAST((Time / 3600) AS INTEGER) % 24 AS hour_of_day,
        COUNT(*) AS transactions,
        SUM(Class) AS fraud_transactions
    FROM credit_card_transactions
    GROUP BY CAST((Time / 3600) AS INTEGER) % 24
)
SELECT
    hour_of_day,
    transactions,
    fraud_transactions,
    ROUND(100.0 * fraud_transactions / transactions, 4) AS fraud_rate_pct
FROM hourly
ORDER BY fraud_rate_pct DESC, transactions DESC;

WITH banded AS (
    SELECT
        Class,
        Amount,
        CASE
            WHEN Amount <= 10 THEN '0-10'
            WHEN Amount <= 25 THEN '10-25'
            WHEN Amount <= 50 THEN '25-50'
            WHEN Amount <= 100 THEN '50-100'
            WHEN Amount <= 250 THEN '100-250'
            WHEN Amount <= 500 THEN '250-500'
            WHEN Amount <= 1000 THEN '500-1000'
            WHEN Amount <= 2500 THEN '1000-2500'
            WHEN Amount <= 5000 THEN '2500-5000'
            ELSE '5000+'
        END AS amount_band
    FROM credit_card_transactions
),
summary AS (
    SELECT
        amount_band,
        COUNT(*) AS transactions,
        SUM(Class) AS fraud_transactions,
        SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END) AS fraud_amount
    FROM banded
    GROUP BY amount_band
)
SELECT
    amount_band,
    transactions,
    fraud_transactions,
    ROUND(100.0 * fraud_transactions / transactions, 4) AS fraud_rate_pct,
    ROUND(fraud_amount, 2) AS fraud_amount
FROM summary
ORDER BY fraud_rate_pct DESC, transactions DESC;

SELECT
    CASE WHEN Amount >= 1000 THEN '1000+' ELSE '<1000' END AS value_segment,
    COUNT(*) AS transactions,
    SUM(Class) AS fraud_transactions,
    ROUND(100.0 * SUM(Class) / COUNT(*), 4) AS fraud_rate_pct,
    ROUND(SUM(Amount), 2) AS total_amount,
    ROUND(SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END), 2) AS fraud_amount
FROM credit_card_transactions
GROUP BY value_segment
ORDER BY fraud_rate_pct DESC;

SELECT
    CASE WHEN Amount = 0 THEN 'Zero Amount' ELSE 'Non-Zero Amount' END AS amount_status,
    COUNT(*) AS transactions,
    SUM(Class) AS fraud_transactions,
    ROUND(100.0 * SUM(Class) / COUNT(*), 4) AS fraud_rate_pct
FROM credit_card_transactions
GROUP BY amount_status
ORDER BY fraud_rate_pct DESC;
