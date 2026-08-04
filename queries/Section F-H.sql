-- =======================================
-- SECTION F
-- =======================================

-- a. classification of products' unit price into tiers --
SELECT
p.product_name,
ca.category_name,
p.unit_price,
CASE WHEN p.unit_price < 10000 THEN 'Budget'
	WHEN p.unit_price BETWEEN 10000 AND 99999 THEN 'Mid-Range'
	WHEN p.unit_price >= 100000 THEN 'Premium' 
END AS price_tier
FROM products p
INNER JOIN categories ca ON p.category_id = ca.category_id
ORDER BY p.unit_price;

-- b. classification of employee into tier based on salary --
SELECT
CONCAT(first_name, ' ', last_name) AS employee_name,
role,
salary,
CASE WHEN salary >= 100000 THEN 'Executive'
	WHEN salary BETWEEN 80000 AND 99999 THEN 'Senior'
	WHEN salary < 80000 THEN 'Entry level'
END AS pay_band
FROM employees 
ORDER BY salary DESC;

-- c. classification of order values --
SELECT
o.order_id,
o.order_date,
o.status,
ROUND(SUM(oi.quantity * oi.unit_price * (1 - discount/100)), 2) AS total_order_value,
CASE WHEN SUM(oi.quantity * oi.unit_price * (1 - discount/100)) > 500000 THEN 'High Value'
	WHEN SUM(oi.quantity * oi.unit_price * (1 - discount/100)) BETWEEN 100000 AND 500000 THEN 'Mid Value'
	WHEN SUM(oi.quantity * oi.unit_price * (1 - discount/100)) < 100000 THEN 'Low Value'
END AS value_category
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, o.status
ORDER BY total_order_value DESC;

-- d. count of price tiers of products in each categories --
SELECT
ca.category_name,
COUNT(CASE WHEN p.unit_price < 10000 THEN 1 END) AS budget_count,
COUNT(CASE WHEN p.unit_price BETWEEN 10000 AND 99999 THEN 1 END) AS Mid_range_count,
COUNT(CASE WHEN p.unit_price >= 100000 THEN 1 END) AS premium_count
FROM products p
INNER JOIN categories ca ON p.category_id = ca.category_id
GROUP BY ca.category_name;



-- =======================================
-- SECTION G
-- =======================================

-- a. list of products whose unit_price is greater than the avg_unit_price of all products --
SELECT
product_name,
category_id,
unit_price 
FROM products 
WHERE unit_price > (SELECT AVG(unit_price) FROM products) 
ORDER BY unit_price DESC;

-- b. list of customers who ordered at least once and their city --
SELECT
CONCAT(first_name, ' ', last_name) AS customer_name,
city
FROM customers 
WHERE customer_id IN (SELECT DISTINCT customer_id FROM orders);

-- c. products that were not ordered --
SELECT 
product_id,
product_name,
category_id,
unit_price
FROM products 
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM order_items);

-- d. top 5 customers by lifetime revenue --
SELECT
customer_name,
city,
total_lifetime_revenue FROM (
SELECT
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.city,
ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS total_lifetime_revenue
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY customer_name, c.city
ORDER BY total_lifetime_revenue DESC)customer_revenue
LIMIT 5;

-- e. list of customers whose lifetime revenue is more than avg of the total lifetime revenue --
SELECT
customer_name,
city,
total_revenue
FROM
(SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	c.city,
	ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY customer_name, c.city)customer_revenue
WHERE total_revenue > ( 
	SELECT AVG(total_revenue) FROM
	(SELECT 
	ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id)avg_lifetime_revenue)
ORDER BY total_revenue DESC;



-- =======================================
-- SECTION H
-- =======================================

-- a. top 10 customers by revenue --
WITH customer_revenue AS (
SELECT
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
c.city,
ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS total_revenue
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name, c.city
ORDER BY total_revenue DESC)
SELECT
customer_id,
customer_name,
city,
total_revenue
FROM customer_revenue
LIMIT 10;

-- b. best selling product by quantity in each category --
WITH product_sales AS (
SELECT
ca.category_name,
p.product_name,
SUM(oi.quantity) AS total_qty_sold,
ROW_NUMBER() OVER (PARTITION BY ca.category_name ORDER BY SUM(oi.quantity) DESC) AS position
FROM products p 
LEFT JOIN categories ca ON p.category_id = ca.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY ca.category_name, p.product_name
ORDER BY total_qty_sold DESC)
SELECT
category_name,
product_name,
total_qty_sold
FROM product_sales
WHERE position = 1;

-- c. monthly revenue in 2023 & grouping by averages  --
WITH monthly_sales AS (
SELECT
MONTH(o.order_date) AS mnth,
ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS total_revenue
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
WHERE YEAR(order_date) = 2023
GROUP BY mnth 
ORDER BY mnth),

avg_monthly_sales AS (
SELECT AVG(total_revenue) AS avg_revenue FROM monthly_sales)

SELECT 
ms.mnth,
ms.total_revenue,
CASE WHEN ms.total_revenue > (SELECT avg_revenue FROM avg_monthly_sales) THEN 'Above Average'
	 ELSE 'Below Average' END AS vs_average
FROM monthly_sales ms;

-- d. customer segmentation by orders placed  --
WITH customers_order AS (SELECT
DISTINCT c.customer_id,
COUNT(o.order_id) AS orders_placed,
CASE WHEN COUNT(o.order_id) >= 8 THEN 'High Frequency'
	 WHEN COUNT(o.order_id) BETWEEN 4 AND 7 THEN 'Regular'
	 WHEN COUNT(o.order_id) BETWEEN 1 AND 3 THEN 'Occasional'
     ELSE 'Inactive' END AS segment
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id)

SELECT
segment,
COUNT(customer_id) AS customer_count
FROM customers_order
GROUP BY segment
ORDER BY customer_count DESC; 

-- e. year over year revenue --
WITH yearly_revenue AS (
SELECT
YEAR(o.order_date) AS year,
ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Delivered'
AND (YEAR(o.order_date) BETWEEN 2021 AND 2023 
OR (YEAR(o.order_date) = 2024 AND MONTH(o.order_date) <= 6))
GROUP BY year)
SELECT 
year,
total_revenue
FROM yearly_revenue
ORDER BY YEAR;
