-- 02_fraud_kpis.sql
-- SQLite-compatible SQL

SELECT
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraud_transactions,
    ROUND(100.0 * SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS fraud_rate_pct,
    ROUND(SUM(Amount), 2) AS total_transaction_amount,
    ROUND(SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END), 2) AS fraud_amount,
    ROUND(100.0 * SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END) / NULLIF(SUM(Amount), 0), 4) AS fraud_amount_share_pct
FROM credit_card_transactions;

SELECT
    CASE WHEN Class = 1 THEN 'Fraud' ELSE 'Normal' END AS transaction_class,
    COUNT(*) AS transactions,
    ROUND(AVG(Amount), 2) AS average_amount,
    ROUND(MIN(Amount), 2) AS minimum_amount,
    ROUND(MAX(Amount), 2) AS maximum_amount,
    ROUND(SUM(Amount), 2) AS total_amount
FROM credit_card_transactions
GROUP BY Class
ORDER BY Class;

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
)
SELECT
    amount_band,
    COUNT(*) AS transactions,
    SUM(Class) AS fraud_transactions,
    ROUND(100.0 * SUM(Class) / COUNT(*), 4) AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END), 2) AS fraud_amount
FROM banded
GROUP BY amount_band
ORDER BY
    CASE amount_band
        WHEN '0-10' THEN 1
        WHEN '10-25' THEN 2
        WHEN '25-50' THEN 3
        WHEN '50-100' THEN 4
        WHEN '100-250' THEN 5
        WHEN '250-500' THEN 6
        WHEN '500-1000' THEN 7
        WHEN '1000-2500' THEN 8
        WHEN '2500-5000' THEN 9
        ELSE 10
    END;

WITH hourly AS (
    SELECT
        CAST((Time / 3600) AS INTEGER) % 24 AS hour_of_day,
        Class,
        Amount
    FROM credit_card_transactions
)
SELECT
    hour_of_day,
    COUNT(*) AS transactions,
    SUM(Class) AS fraud_transactions,
    ROUND(100.0 * SUM(Class) / COUNT(*), 4) AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END), 2) AS fraud_amount
FROM hourly
GROUP BY hour_of_day
ORDER BY hour_of_day;
