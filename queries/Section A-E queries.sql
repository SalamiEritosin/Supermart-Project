-- =======================================
-- SECTION A 
-- =======================================

-- a. names and cities of all customers who live in lagos --
SELECT
first_name,
last_name,
email
FROM customers
WHERE city = 'Lagos'
ORDER BY last_name, first_name;

-- b. cities supermart has shipped at least one order --
SELECT 
shipping_city,
COUNT(*) AS order_count
FROM orders WHERE status = 'Delivered'
GROUP BY shipping_city 
ORDER BY shipping_city;

-- c. top 10 product by unit_price --
SELECT
product_name,
category_id,
unit_price
FROM products ORDER BY unit_price DESC 
LIMIT 10;

-- d. list of employees hired on or after 1st january 2021 --
SELECT
CONCAT(first_name, ' ', last_name) AS full_name,
role,
hire_date,
salary
FROM employees WHERE hire_date >= '2021-01-01'
ORDER BY hire_date;

-- e. retrieve all orders placed in december across any year --
SELECT 
order_id,
order_date,
status,
shipping_city
FROM orders WHERE MONTH(order_date) = 12 
ORDER BY order_date DESC;



-- =======================================
-- SECTION B
-- =======================================

-- a. amount of orders in each status and the pct_total --
SELECT
status,
COUNT(*) AS order_count,
ROUND(COUNT(*) *100 /SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM orders 
GROUP BY status
ORDER BY COUNT(*) DESC;

-- b. min, max & avg unit_price of products in their category --
SELECT
c.category_name,
MIN(p.unit_price) as min_unit_price,
MAX(p.unit_price) as max_unit_price,
avg(p.unit_price) as avg_price
FROM products p 
JOIN categories c ON c.category_id = p.category_id
GROUP BY c.category_name ORDER BY avg_price DESC;

-- c. total, avg, max & min revenue per line item --
SELECT
ROUND(SUM(quantity * unit_price * (1 - discount/100)), 2) AS total_revenue,
ROUND(AVG(quantity * unit_price * (1 - discount/100)), 2) AS avg_revenue_per_line_item,
ROUND(MAX(quantity * unit_price * (1 - discount/100)), 2) AS max_revenue_per_line_item,
ROUND(MIN(quantity * unit_price * (1 - discount/100)), 2) AS min_revenue_per_line_item
FROM order_items;

-- d. avg orders per customer --
SELECT
COUNT(DISTINCT customer_id) AS no_of_customers,
ROUND(COUNT(*) / COUNT(DISTINCT customer_id), 2) AS avg_orders_per_customer
FROM orders;



-- =======================================
-- SECTION C 
-- =======================================

-- a. count of registered customers each year --
SELECT
YEAR(registration_date) as registration_year,
COUNT(customer_id) AS customer_count
FROM customers WHERE YEAR(registration_date) BETWEEN 2018 AND 2024
GROUP BY registration_year ORDER BY registration_year;

-- b. shipping cities with delivered orders more than 10 --
SELECT
shipping_city,
COUNT(*) AS delivered_orders
FROM orders
WHERE status = 'Delivered'
GROUP BY shipping_city 
HAVING delivered_orders > 10
ORDER BY delivered_orders DESC; 

-- c. list of products whose total quantity sold exceeds 50 -- 
SELECT
p.product_id,
p.product_name,
SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING total_quantity > 50
ORDER BY total_quantity DESC;

-- d. number of orders handled by employees -- 
SELECT
CONCAT(first_name, ' ', last_name) AS full_name,
COUNT(order_id) AS orders_handled
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
GROUP BY full_name
HAVING orders_handled >= 20
ORDER BY orders_handled DESC;

-- e. orders placed each year & total customers who ordered that year -- 
SELECT 
YEAR(order_date) AS order_year,
COUNT(order_id) AS total_orders,
COUNT(DISTINCT customer_id) AS customers
FROM orders WHERE YEAR(order_date) BETWEEN 2021 AND 2024
GROUP BY order_year ORDER BY order_year;



-- =======================================
-- SECTION D 
-- =======================================

-- a. retrieval of first, last name & mail of customers with @gmail.com --
SELECT 
first_name,
last_name,
email
FROM customers 
WHERE email LIKE '%@gmail.com'
ORDER BY last_name;

-- b. category_id, product names & unit_price of products having the 'set' word --
SELECT
product_name,
category_id,
unit_price
FROM products
WHERE LOWER(product_name) LIKE '%set%'
ORDER BY unit_price DESC;

-- c. full_name, city & registration_date of customers whose last name begins with letters 'Ad' -- 
SELECT
CONCAT(first_name, ' ', last_name) AS full_name,
city,
registration_date
FROM customers
WHERE LOWER(last_name) LIKE 'ad%';

-- d. category_id, product names & unit_price of products having the 'combo', 'kit', & 'pack' word --
SELECT
product_name,
category_id,
unit_price
FROM products
WHERE LOWER(product_name) LIKE '%combo%' 
OR LOWER(product_name) LIKE '%kit%' 
OR LOWER(product_name) LIKE '%pack%';

-- e. first_name, last_name & city of customers whose city name contain 'an' -- 
SELECT
first_name,
last_name,
city
FROM customers 
WHERE LOWER(city) LIKE '%an%'
ORDER BY city, last_name;




-- =======================================
-- SECTION E 
-- =======================================

-- a. order date, status, shipping_city, list of recent orders by customers & employees who sold to them --
SELECT
o.order_id,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
o.order_date,
o.status,  
o.shipping_city
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date DESC
LIMIT 50;

-- b. amount of orders place by each customers, full_name, id & city --
SELECT
c.customer_id,
CONCAT(c.first_name, ' ', c.last_name) AS full_name,
c.city,
COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, full_name, c.city
ORDER BY order_count DESC, last_name;

-- c. a detailed order line report containing every row in order_items --
SELECT 
oi.order_id,
o.order_date,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
p.product_name,
oi.quantity,
oi.unit_price,
oi.discount,
ROUND(oi.quantity * oi.unit_price * (1 - oi.discount/100), 2) AS line_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, p.product_name;

-- d. full_name, role, region of employees & the orders they handled --
SELECT
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
e.role,
r.region_name,
COUNT(o.order_id) AS order_count
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
LEFT JOIN regions r ON e.region_id = r.region_id
GROUP BY e.first_name, e.last_name, e.role, r.region_name
ORDER BY order_count DESC, e.last_name;

-- e. list of product category, product name alongside the number of times_ordered & quantity ordered --
SELECT
ca.category_name,
p.product_name,
COUNT(DISTINCT oi.order_item_id) AS times_ordered,
SUM(oi.quantity) AS total_quantity_sold
FROM products p
LEFT JOIN categories ca ON p.category_id = ca.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY ca.category_name, p.product_name
ORDER BY ca.category_name, total_quantity_sold DESC;





SELECT 
shipping_city,
COUNT(*) AS order_count
FROM  orders 
GROUP BY shipping_city 
ORDER BY shipping_city;
