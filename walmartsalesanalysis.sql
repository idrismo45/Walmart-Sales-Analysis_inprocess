-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "05:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

SELECT *
FROM sales;

-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch
FROM sales;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;

-- What is the most selling product line
SELECT product_line, COUNT(*) AS total_sales
FROM sales
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;

-- What is the most common payment method
SELECT payment_method, COUNT(*) AS COUNT
FROM sales
GROUP BY payment_method
ORDER BY COUNT DESC
LIMIT 1;

-- What is the total revenue by month
SELECT month_name, SUM(total)/1000 AS total_sales_K
FROM sales
GROUP BY month_name
ORDER BY total_sales_K DESC;

-- What month had the largest COGS?
SELECT month_name, SUM(cogs)/1000 cogs_K
FROM sales
GROUP BY month_name
ORDER BY cogs_K DESC;

-- What product line had the largest revenue?
SELECT product_line, SUM(total)/1000 as revenue_K
FROM sales
GROUP BY product_line
ORDER BY revenue_K DESC;

-- What is the city with the largest revenue?
SELECT city,branch, SUM(total)/1000 as revenue_K
FROM sales
GROUP BY city, branch
ORDER BY revenue_K DESC;

-- What product line had the largest VAT?
SELECT product_line, AVG(VAT)
FROM sales
GROUP BY product_line
ORDER BY AVG(VAT) DESC;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line, AVG(quantity),
	CASE
		WHEN AVG(quantity) > 5.4995 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?

SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING qnty > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender

SELECT gender, product_line, COUNT(gender) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY COUNT(gender) DESC;

WITH RankedSales AS (
    SELECT 
        gender, product_line, COUNT(gender) AS total_count, ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(gender) DESC) AS row_num
    FROM sales
    GROUP BY gender, product_line
)
SELECT gender, product_line, total_count
FROM RankedSales
WHERE row_num = 1;

-- What is the average rating of each product line
SELECT product_line, ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekeday

SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name NOT IN ('Saturday', 'Sunday')
GROUP BY time_of_day
ORDER BY total_sales DESC;

SELECT time_of_day, day_name, COUNT(*) AS total_sales
FROM sales
WHERE day_name NOT IN ('Saturday', 'Sunday')
GROUP BY time_of_day, day_name
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?

SELECT customer_type, SUM(total)/1000 AS revenue_K
FROM sales
GROUP BY customer_type
ORDER BY revenue_K DESC;

-- Which city has the largest tax/VAT percent?

SELECT city, AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?

SELECT customer_type, AVG(VAT) as VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- How many unique customer types does the data have?

SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment_method
FROM sales;

-- What is the most common customer type?

SELECT  customer_type, COUNT(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- What is the gender of most of the customers?

SELECT gender, COUNT(*) AS count
FROM sales
GROUP BY gender
ORDER BY count DESC;

-- What is the gender distribution per branch?

SELECT 
    gender, 
    branch,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender, branch
ORDER BY gender_count DESC;

-- Which time of the day do customers give most ratings?

SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?

SELECT branch ,time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;

-- Which day of the week has the best avg ratings?

SELECT day_name, AVG(rating) as avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?

SELECT branch, day_name, AVG(rating) as avg_rating
FROM sales
GROUP BY day_name, branch
ORDER BY avg_rating DESC;











