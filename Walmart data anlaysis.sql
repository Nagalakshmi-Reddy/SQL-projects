CREATE DATABASE IF NOT EXISTS WalmartSales;

CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    COGS DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4) NOT NULL,
    rating DECIMAL(2, 1)
);

----------------- FEATURE ENGINEERING ---------------------------------------------------

-- 1. time_of_day

SELECT 
	time,
	(CASE
           WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
           WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
           ELSE "Evening"
           END 
	) AS time_of_day
FROM sales;

ALTER TABLE sales ADD time_of_day VARCHAR(20);

UPDATE sales SET time_of_day = 
(CASE
      WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
      WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
      ELSE "Evening"
      END 
);

-- 2. day_name

SELECT 
   date,
   DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD day_name VARCHAR(20);

UPDATE sales 
  SET day_name = DAYNAME(date);

-- 3. month_name

SELECT
  date,
  MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD month_name VARCHAR(20);

UPDATE sales 
  SET month_name = monthname(date);
  

----------- Explorartory Data Analysis (Generic Questions)--------------------------

-- 1. How many unique cities does the data have?
SELECT
  DISTINCT city
FROM sales;
  
-- 2. In which city is each branch?
SELECT
  DISTINCT city, branch
FROM sales;
  
--------------------- Product based questions ------------------- 
  
-- 1. How many unique product lines does the data have?
SELECT
  COUNT(DISTINCT product_line)
FROM sales;

-- 2. What is the most common payment method;
SELECT payment_method FROM
(SELECT
  payment_method, COUNT(payment_method) AS cnt
  FROM sales 
  GROUP BY payment_method ORDER BY cnt DESC) AS tmp limit 1;

-- 3. What is the most selling product line?
SELECT
  product_line, COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line ORDER BY cnt DESC limit 1;

-- 4. What is the total Revenue by month?
SELECT
  month_name AS Month,
  SUM(total) AS total_revenue
FROM sales
GROUP BY month_name ORDER BY total_revenue DESC;

-- 5. What month had the largest COGS?
SELECT
  month_name AS month,
  SUM(COGS) AS COGS_sum
FROM sales
GROUP BY month ORDER BY COGS_sum DESC;

-- 6. What product_line had the largest revenue?
SELECT
  product_line,
  SUM(total) AS total_revenue
FROM sales
GROUP BY product_line ORDER BY total_revenue DESC;

-- 7. What is the city with the largest revenue?
SELECT
  city, branch,
  SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch ORDER BY total_revenue DESC;

-- 8. What product line had the largest VAT?
SELECT
  product_line,
  AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line ORDER BY avg_tax DESC;

-- 9. Which branch sold more products than average product sold?
SELECT 
   branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch HAVING qty > (SELECT AVG(quantity) FROM SALES);

-- 10. What is the most common product line by gender
SELECT
   gender,
   product_line,
   COUNT(gender) as cnt
FROM sales
GROUP BY gender, product_line
ORDER BY cnt DESC;

-- 11. What is the average rating of each product line?
SELECT
  product_line,
  ROUND(AVG(rating),2)
FROM sales
GROUP BY product_line;

-- 12. Fetch each product line and add a column to those productline showing "Good", "Bad".
-- Good if its greater than average sales


---------------------------- Sales based Questions ----------------------------------

-- 1. Number of sales made in each time of the day per weekday
SELECT
  day_name,
  time_of_day,
  COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day, day_name
ORDER BY day_name, total_sales DESC;

-- 2. Which of the customer types brings the most revenue?
SELECT 
   customer_type,
   SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
   city,
   AVG(VAT) AS tax
FROM sales
GROUP BY city
ORDER BY tax DESC;

-- 4. Which customer type pays the most in VAT?
SELECT
   customer_type,
   AVG(VAT) AS tax
FROM sales
GROUP BY customer_type
ORDER BY tax DESC;

--------------------- Custoemer Information -------------------------------------

-- 1. How many unique customer types does the data have?
SELECT DISTINCT customer_type 
FROM sales;

-- 2. How many unique payment methods does the data have?
SELECT DISTINCT payment_method 
FROM sales;

-- 3. What is the most customer type?
SELECT customer_type, COUNT(customer_type) AS cnt 
FROM sales GROUP BY customer_type ORDER BY cnt DESC;

-- 4. What is the gender of most of the customers?
SELECT gender, COUNT(gender) AS cnt 
FROM sales GROUP BY gender ORDER BY cnt DESC;

-- 5. What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS cnt 
FROM sales GROUP BY branch, gender ORDER BY branch DESC;

-- 6. Which time of the day do customers give more ratings?
SELECT
  time_of_day,
  AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day ORDER BY avg_rating DESC;

-- 7. Which time of the day do customers give more ratings per branch?
SELECT
  branch,
  time_of_day,
  AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day, branch ORDER BY branch, avg_rating DESC;

-- 8. Which day of the week has the best avg rating?
SELECT
   day_name,
   AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name ORDER BY avg_rating DESC;

-- 9. Which day of the week has the best avg rating per branch?
SELECT
   branch,
   day_name,
   AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name,branch ORDER BY branch, avg_rating DESC;
