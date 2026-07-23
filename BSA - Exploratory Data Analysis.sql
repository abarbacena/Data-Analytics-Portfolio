
-- Exploratory Data Analysis --

-- Questions: --

-- 1. Which period of the day is the busiest and least busy? --
-- 2. Which period of the week (Weekday or Weekend) has more transactions? --
-- 3. What time of day is the busiest and least busy? --
-- 4. What are the most popular items during each period of the day? --
-- 5. Which item(s) are purchased most frequently? --
-- 6. Which item combination(s) are most frequently bought together? --
-- 7. Which items are more popular on weekdays compared to weekends? --
-- 8. What month has the largest volume of transactions? --

SELECT *
FROM bakery_clean;

-- 1. Which period of the day is the busiest? --
SELECT period_day, COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY period_day
ORDER BY transaction_count DESC;

-- 2. Which period of the week (Weekday or Weekend) has more transactions? --
SELECT weekday_weekend, COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY weekday_weekend
ORDER BY transaction_count DESC;

-- 3. What time of day is the busiest and least busy? --
SELECT HOUR(date_time) AS hour_of_day, COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY HOUR(date_time)
ORDER BY transaction_count ASC;

SELECT date_time, COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY date_time
ORDER BY transaction_count ASC;

-- 4. What are the most popular items during each period of the day? --
SELECT period_day, Item, COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY period_day, Item
ORDER BY transaction_count DESC;

-- 5. Which item(s) are purchased most frequently? --
SELECT Item, COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY Item
ORDER BY transaction_count DESC;

-- 6. Which item combination(s) are most frequently bought together? --

-- check number of items per transaction first --
SELECT Transaction, COUNT(*) AS item_count
FROM bakery_clean
GROUP BY Transaction
ORDER BY item_count ASC;

SELECT Transaction, COUNT(*) AS item_count
FROM bakery_clean
GROUP BY Transaction
HAVING COUNT(*) >= 3
ORDER BY item_count DESC;

SELECT Transaction, Item
FROM bakery_clean
WHERE Transaction IN (
	SELECT Transaction
    FROM bakery_clean
    GROUP BY Transaction
    HAVING COUNT(*) >= 3
)
ORDER BY Transaction;

-- items purchased together --
SELECT a.Item AS item1, b.Item AS item2, COUNT(*) AS bought_together
FROM bakery_clean a
JOIN bakery_clean b
	ON a.Transaction = b.Transaction
    AND a.Item < b.Item
GROUP BY a.Item, b.Item
ORDER BY bought_together DESC; 

-- 7. Which items are more popular on weekdays compared to weekends? --
SELECT Item,
	SUM(CASE WHEN weekday_weekend = 'Weekday' THEN 1 ELSE 0 END) AS weekday_sales,
    SUM(CASE WHEN weekday_weekend = 'Weekend' THEN 1 ELSE 0 END) AS weekend_sales
FROM bakery_clean
GROUP BY Item
HAVING weekend_sales > weekday_sales
ORDER BY weekend_sales - weekday_sales DESC;

-- 8. What month has the largest volume of transactions? --
SELECT MONTH(date_time), COUNT(*) AS monthly_transaction
FROM bakery_clean
GROUP BY MONTH(date_time)
ORDER BY monthly_transaction DESC;

-- 9. Which items are the most purchased in every month? --
SELECT MONTH(date_time), Item, COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY MONTH(date_time), Item
ORDER BY transaction_count DESC;

SELECT
    YEAR(date_time) AS sales_year,
    MONTH(date_time) AS sales_month,
    Item,
    COUNT(*) AS transaction_count
FROM bakery_clean
GROUP BY YEAR(date_time), MONTH(date_time), Item
ORDER BY Item, sales_year, sales_month;
-- --
SELECT COUNT(DISTINCT Transaction)
FROM bakery_clean;

SELECT *, COUNT(*) cnt
FROM bakery_clean
GROUP BY Transaction, Item, date_time, period_day, weekday_weekend;

SELECT MIN(date_time), MAX(date_time)
FROM bakery_clean;

SELECT Item,
    COUNT(*) AS items_sold,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bakery_clean), 2) AS percentage_of_sales
FROM bakery_clean
GROUP BY Item
ORDER BY items_sold DESC;
