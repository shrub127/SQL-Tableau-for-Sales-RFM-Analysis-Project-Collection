create database sales1;
use sales1;


select * from sales_data_sample;

-- Checking unique values
select distinct status from sales_data_sample;
select distinct year_id from sales_data_sample;
select distinct productline from sales_data_sample;
select distinct country from sales_data_sample;
select distinct dealsize from sales_data_sample;
select distinct territory from sales_data_sample;


-- Analysis 
-- SQL query to find the total sales for each product line  
SELECT 
    productline, ROUND(SUM(sales), 2) AS Total_Sales
FROM
    sales_data_sample
GROUP BY 1
ORDER BY 2 DESC;


-- Total sales for each Year 
SELECT 
    year_id, ROUND(SUM(sales), 2) AS Total_Sales
FROM
    sales_data_sample
GROUP BY 1
ORDER BY 2 DESC;


-- How many months were operated in 2005(least sales generated in 2005)
SELECT DISTINCT
    month_id
FROM
    sales_data_sample
WHERE
    year_id = '2005';


-- How many months were operated in 2004(most sales generated in 2004)
SELECT DISTINCT
    month_id
FROM
    sales_data_sample
WHERE
    year_id = '2004';


-- Total sales for each size
SELECT 
    dealsize, ROUND(SUM(sales), 2)  AS Total_sales
FROM
    sales_data_sample
GROUP BY 1
ORDER BY 2 DESC;


-- What was the best month for sales in a specific year? How much was earned that month?
SELECT 
    month_id, ROUND(SUM(sales), 2) as revenue ,count(ordernumber) as frequency
FROM
    sales_data_sample
GROUP BY 1
ORDER BY 2 DESC;


-- Highest sales were generated in November and for the product Classic
SELECT 
    month_id,
    productline,
    ROUND(SUM(sales), 2) AS revenue,
    COUNT(ordernumber) AS frequency
FROM
    sales_data_sample
WHERE
    year_id = 2003 AND month_id = 11
GROUP BY month_id , productline
ORDER BY 3 DESC;


-- Which products are often sold together?  
WITH paired_products AS (
  SELECT
    o1.ordernumber AS ordernumber1,
    o2.ordernumber AS ordernumber2,
    o1.productcode AS productcode1,
    o2.productcode AS productcode2
  FROM sales_data_sample o1
  INNER JOIN sales_data_sample o2 ON o1.ordernumber = o2.ordernumber
  WHERE o1.productcode <> o2.productcode -- Exclude self-joins (same product)
)
SELECT
  productcode1,
  productcode2,
  COUNT(*) AS frequency
FROM paired_products
GROUP BY productcode1, productcode2
HAVING COUNT(*) > 1 -- Filter for product pairs bought together more than once
ORDER BY frequency DESC;


 -- Find the topmost customer who has purchased a lot.
SELECT 
  CUSTOMERNAME, 
  SUM(SALES) AS TOTAL_SALES
FROM sales_data_sample
GROUP BY CUSTOMERNAME
ORDER BY TOTAL_SALES DESC
LIMIT 1;

-- Top Selling Products:
SELECT 
    PRODUCTCODE, SUM(QUANTITYORDERED) AS total_quantity_sold
FROM
    sales_data_sample
GROUP BY PRODUCTCODE
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Average Order Value by Quarter
SELECT QTR_ID, AVG(SALES) AS average_order_value
FROM sales_data_sample
GROUP BY QTR_ID
ORDER BY QTR_ID desc;

-- Customer Segmentation with RFM Analysis 
WITH recency AS (
  SELECT CUSTOMERNAME, DATEDIFF(CURDATE(), MAX(ORDERDATE)) AS days_since_last_purchase
  FROM sales_data_sample
  GROUP BY CUSTOMERNAME
)
SELECT r.CUSTOMERNAME,
       CASE WHEN r.days_since_last_purchase <= 30 THEN 'Recent'
            WHEN r.days_since_last_purchase <= 90 THEN 'Mid-Range'
            ELSE 'Long Ago'
       END AS recency,
       COUNT(*) AS order_frequency,
       SUM(SALES) AS total_spend
FROM recency r
INNER JOIN sales_data_sample s ON r.CUSTOMERNAME = s.CUSTOMERNAME
GROUP BY r.CUSTOMERNAME
ORDER BY total_spend DESC;


