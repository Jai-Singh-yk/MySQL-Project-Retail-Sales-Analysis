# MySQL-Project-Retail-Sales-Analysis

# 🛒 Retail Sales Analysis SQL Project

## 📌 Project Overview

**Project Title:** Retail Sales Analysis  

This project demonstrates SQL skills applied to retail sales data. The workflow includes database creation, data cleaning, exploratory data analysis (EDA), and answering business questions using MySQL queries.

---

## 🎯 Objectives

- 🗄️ **Database Setup:** Create and organize a database to store retail sales data.  
- 🧹 **Data Cleaning:** Identify and remove incomplete or invalid records.  
- 📊 **Exploratory Data Analysis (EDA):** Understand the dataset and summarize key metrics.  
- 💡 **Business Analysis:** Answer business-driven questions using SQL to extract actionable insights.

---

### 🗂️ Project Structure

### 1️⃣ ⚙️ Database Setup

**Database Creation:**  

```sql
CREATE DATABASE IF NOT EXISTS retail_data;
USE retail_data;
```

Table Creation:
```sql
DROP TABLE IF EXISTS retail_sales;

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
```
---

### 2️⃣ 🧹 Data Cleaning

Check for missing values and remove invalid rows:
```sql
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```
---
### 3️⃣ 🔍 Data Exploration

Total sales:
```sql
SELECT COUNT(*) AS total_sales FROM retail_sales;
```

Total unique customers:
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;
```

Product categories:
```sql
SELECT DISTINCT category FROM retail_sales;
```

---

### 📊 4️⃣ Data Analysis & Business Questions

Q1: Retrieve all columns for sales made on '2022-11-05' 
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

Q2: Retrieve all clothing sales with quantity > 4 in Nov-2022 
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity > 4;
```

Q3: Calculate total sales and total orders per category 
```sql
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

Q4: Find average age of customers who purchased from 'Beauty' 
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

Q5: Find transactions with total sale > 1000 
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

Q6: Find total transactions by gender and category 
```sql
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

Q7: Find the best-selling month per year 
```sql
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
```

Q8: Find the top 5 customers by total sales 
```sql
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

Q9:  Find the number of unique customers per category 
```sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

Q10:  Create shifts and count the number of orders for each shift (Morning <= 12, Afternoon 12-17, Evening > 17)
```sql
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
```

---

### 📈 Key Findings

- 👥 Customer Demographics: Wide range of age groups, strong engagement in Clothing and Beauty.
- 💰 High-Value Transactions: Several purchases exceeded $1,000.
- 📊 Sales Trends: Monthly and seasonal peaks observed.
- 🏆 Top Customers & Categories: Identified top-spending customers and popular product categories.
- ⏰ Operational Insights: Morning and afternoon shifts have the highest number of transactions.

--- 

### 🛠️ Tools Used

- MySQL – Used for database creation, querying, and analysis
- SQL Functions & Clauses
- COUNT(), SUM(), AVG() – Aggregation functions for numeric analysis
- DISTINCT – Identifying unique values
- GROUP BY & ORDER BY – Data aggregation and sorting
- RANK() OVER(PARTITION BY … ORDER BY …) – Ranking for best-selling months
- CASE – Categorizing data into shifts (Morning, Afternoon, Evening)
- DELETE – Data cleaning to remove invalid or null rows

-- -

### ✅ Conclusion 

This Retail Sales Analysis project demonstrates a full SQL workflow for analyzing retail sales data. It includes database creation and structuring (retail_data), data cleaning by identifying and removing missing values, and exploratory analysis to understand sales volume, customer behavior, and product categories. Through answering 10 business-driven questions, the project identifies high-value customers, top-selling categories, peak sales periods, and operational trends. Overall, this project highlights how SQL can be effectively used to analyze retail data, support informed business decisions, and provide actionable insights for sales optimization, customer engagement, and operational efficiency.
