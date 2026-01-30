-- ==========================================
-- Project: Retail Sales Analysis
-- Description: Retail sales database creation,
--              data cleaning, exploration,
--              and analysis queries.
-- Database: retail_data
-- ==========================================

-- ========================
-- 1. Database Setup
-- ========================

-- Create database
CREATE DATABASE IF NOT EXISTS retail_data;
USE retail_data;

-- Drop table if it exists
DROP TABLE IF EXISTS retail_sales;

-- Create retail_sales table
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- View the table structure
SELECT * FROM retail_sales;

-- ========================
-- 2. Data Cleaning
-- ========================

-- Check for missing transaction IDs
SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

-- Check for missing sale dates
SELECT * FROM retail_sales
WHERE sale_date IS NULL;

-- Check for missing sale times
SELECT * FROM retail_sales
WHERE sale_time IS NULL;

-- Check for any missing critical data
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Remove rows with missing critical data
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- ========================
-- 3. Data Exploration
-- ========================

-- Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Total number of unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;

-- Distinct product categories
SELECT DISTINCT category FROM retail_sales;

-- ========================
-- 4. Data Analysis & Business Questions
-- ========================

-- Q1: Retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Retrieve all transactions where the category is 'Clothing' 
--     and the quantity sold is more than 4 in November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity > 4;

-- Q3: Calculate total sales and total orders for each category
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4: Find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Find all transactions where the total sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Find the total number of transactions made by each gender in each category
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7: Calculate the average sale for each month and find the best-selling month per year
SELECT 
       year,
       month,
       avg_sale
FROM 
(    
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) 
                    ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE rank = 1;

-- Q8: Find the top 5 customers based on the highest total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9: Find the number of unique customers who purchased items from each category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10: Create shifts and count the number of orders for each shift
--      Morning <= 12, Afternoon 12-17, Evening > 17
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;

-- ==========================================
-- End of Project
-- ==========================================
