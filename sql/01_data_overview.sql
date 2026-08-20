-- 01_data_overview.sql
-- SQLite-compatible SQL

SELECT COUNT(*) AS total_transactions
FROM credit_card_transactions;

SELECT
    SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS null_time,
    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS null_amount,
    SUM(CASE WHEN Class IS NULL THEN 1 ELSE 0 END) AS null_class
FROM credit_card_transactions;

SELECT
    Class,
    COUNT(*) AS transaction_count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_card_transactions), 4) AS transaction_share_pct
FROM credit_card_transactions
GROUP BY Class
ORDER BY Class;

SELECT
    COUNT(*) AS transactions,
    ROUND(SUM(Amount), 2) AS total_amount,
    ROUND(AVG(Amount), 2) AS average_amount,
    ROUND(MIN(Amount), 2) AS minimum_amount,
    ROUND(MAX(Amount), 2) AS maximum_amount
FROM credit_card_transactions;

SELECT
    MIN(Time) AS minimum_time_seconds,
    MAX(Time) AS maximum_time_seconds,
    ROUND((MAX(Time) - MIN(Time)) / 3600.0, 2) AS time_span_hours
FROM credit_card_transactions;

SELECT DISTINCT Class
FROM credit_card_transactions
WHERE Class NOT IN (0, 1);

SELECT COUNT(*) AS negative_amount_transactions
FROM credit_card_transactions
WHERE Amount < 0;

SELECT
    COUNT(*) AS zero_amount_transactions,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM credit_card_transactions), 4) AS zero_amount_share_pct
FROM credit_card_transactions
WHERE Amount = 0;
