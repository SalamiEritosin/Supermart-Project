-- =======================================
-- SECTION I
-- =======================================

-- employees' sales performance report --
WITH order_revenue AS (
SELECT 
oi.order_id,
ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS order_total
FROM order_items oi
GROUP BY oi.order_id),

employee_metrics AS (
SELECT 
o.employee_id,
COUNT(DISTINCT o.order_id) AS total_delivered_orders,
ROUND(SUM(orv.order_total), 2) AS total_revenue,
ROUND(AVG(orv.order_total), 2) AS avg_order_value,
ROUND(MAX(orv.order_total), 2) AS best_single_order
FROM orders o
JOIN order_revenue orv ON o.order_id = orv.order_id
WHERE o.status = 'Delivered'
AND o.order_date BETWEEN '2021-01-01' AND '2024-06-30'
GROUP BY o.employee_id)

SELECT 
CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
e.role,
r.region_name,
COALESCE(em.total_delivered_orders, 0) AS total_delivered_orders,
COALESCE(em.total_revenue, 0) AS total_revenue,
COALESCE(em.avg_order_value, 0) AS avg_order_value,
COALESCE(em.best_single_order, 0) AS best_single_order,
CASE WHEN COALESCE(em.total_revenue, 0) > 5000000 THEN 'Elite'
     WHEN COALESCE(em.total_revenue, 0) BETWEEN 1000000 AND 5000000 THEN 'Strong'
     WHEN COALESCE(em.total_revenue, 0) BETWEEN 100000 AND 999999 THEN 'Developing'
     ELSE 'Inactive' END AS performance_band
FROM employees e
LEFT JOIN employee_metrics em ON e.employee_id = em.employee_id
LEFT JOIN regions r ON e.region_id = r.region_id
ORDER BY total_revenue DESC, employee_name;


-- =======================================
-- SECTION J
-- =======================================

-- customer segmentation by delivered order & lifetime revenue --
WITH order_revenue AS (
SELECT 
oi.order_id,
ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount/100)), 2) AS order_total
FROM order_items oi
GROUP BY oi.order_id),

customer_metrics AS (
SELECT 
c.customer_id,
c.first_name,
c.last_name,
c.city,
YEAR(c.registration_date) AS registration_year,
COUNT(o.order_id) AS total_orders,
COUNT(CASE WHEN o.status = 'Delivered' THEN 1 END) AS delivered_orders,
COUNT(CASE WHEN o.status = 'Cancelled' THEN 1 END) AS cancelled_orders,
ROUND(SUM(CASE WHEN o.status = 'Delivered' THEN orv.order_total ELSE 0 END), 2) AS lifetime_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN order_revenue orv ON o.order_id = orv.order_id
WHERE YEAR(c.registration_date) < 2024
GROUP BY c.customer_id, c.first_name, c.last_name, c.city, YEAR(c.registration_date))

SELECT 
CONCAT(first_name, ' ', last_name) AS customer_name,
city,
registration_year,
total_orders,
delivered_orders,
cancelled_orders,
lifetime_revenue,
ROUND(CASE WHEN delivered_orders > 0 THEN lifetime_revenue / delivered_orders 
		   ELSE 0 END, 2) AS avg_order_value,
CASE WHEN lifetime_revenue > 500000 AND delivered_orders >= 5 THEN 'VIP'
	 WHEN (lifetime_revenue BETWEEN 100000 AND 500000) OR (delivered_orders BETWEEN 2 AND 4) THEN 'Loyal'
	 WHEN delivered_orders = 1 THEN 'One-Time Buyer'
	 WHEN delivered_orders = 0 AND total_orders > 0 THEN 'No Conversions'
	 WHEN total_orders = 0 THEN 'Inactive'
	 ELSE 'Others' END AS customer_segment
FROM customer_metrics
ORDER BY lifetime_revenue DESC, customer_name;

