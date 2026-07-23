CREATE TABLE `bakery_clean` (
  `Transaction` int DEFAULT NULL,
  `Item` text,
  `date_time` text,
  `period_day` text,
  `weekday_weekend` text,
  `count` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO bakery_clean
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY `Transaction`, Item, date_time, period_day, weekday_weekend) AS row_num
FROM bakery_data_clean;

-- duplicate deletion --

DELETE
FROM bakery_clean
WHERE count > 1;

SELECT *
FROM bakery_clean
WHERE count > 1;

SELECT COUNT(*)
FROM bakery_clean;

DELETE FROM bakery_clean
WHERE Item = 'Adjustment';

SELECT Item
FROM bakery_clean2
WHERE Item = 'Adjustment';

-- Standardization --

-- trimming --

SELECT Item, TRIM(Item)
FROM bakery_clean;

UPDATE bakery_clean 
SET Item = TRIM(Item);

SELECT date_time, TRIM(date_time)
FROM bakery_clean;

UPDATE bakery_clean
SET date_time = TRIM(date_time);

SELECT period_day, TRIM(period_day)
FROM bakery_clean;

UPDATE bakery_clean
SET period_day = TRIM(period_day);

SELECT weekday_weekend, TRIM(weekday_weekend)
FROM bakery_clean;

UPDATE bakery_clean
SET weekday_weekend = TRIM(weekday_weekend);

-- formatting --
-- date & time --
SELECT *
FROM bakery_clean;

SELECT `date_time`,
STR_TO_DATE(`date_time`, '%m/%d/%Y %H:%i')
FROM bakery_clean;

UPDATE bakery_clean
SET `date_time` = STR_TO_DATE(`date_time`, '%m/%d/%Y %H:%i');

ALTER TABLE bakery_clean
MODIFY COLUMN `date_time` DATETIME;

-- period day --

SELECT `period_day`,
CONCAT(
UPPER(LEFT(period_day, 1)),
LOWER(SUBSTRING(period_day, 2))
)
FROM bakery_clean;

UPDATE bakery_clean
SET period_day = CONCAT(
UPPER(LEFT(period_day, 1)),
LOWER(SUBSTRING(period_day, 2))
);

-- weekday_weekend --

SELECT `weekday_weekend`,
CONCAT(
UPPER(LEFT(weekday_weekend, 1)),
LOWER(SUBSTRING(weekday_weekend, 2))
)
FROM bakery_clean;

UPDATE bakery_clean
SET weekday_weekend = CONCAT(
UPPER(LEFT(weekday_weekend, 1)), 
LOWER(SUBSTRING(weekday_weekend, 2))
);

SELECT *
FROM bakery_clean;
