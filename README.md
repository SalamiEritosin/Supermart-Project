# [Supermart Analytics]
> *Querying the sales database to generate insights to know the overall health of the business.*

---

## Project Type Flags

- Database creation
- Exploratory Data Analysis (EDA)
- SQL Analysis

---

## Table of Contents
1. [Project Overview](#1-project-overview)
2. [Objectives](#2-objectives)
3. [Project Scope & Tools](#3-project-scope--tools)
4. [Data Workflow](#4-data-workflow)
5. [Database Schema and Table Relationship](#5-Database-Schema-and-Table-Relationship)
6. [Key Insights & Recommendations](#6-key-insights-&-recommendations)
7. [Author](#7-author)

---

## 1. Project Overview

SuperMart is a Nigerian retail chain operating across six regions (North, South, East, West, North Central, South-South), serving customers in 30 cities. The company sells 68 products across 8 
categories and is staffed by 35 employees organised into three tiers: Regional Managers, Sales Managers, and Sales Reps. 
As a Data Analyst, I have been tasked with querying the sales database to generate insights on revenue performance, employee effectiveness, customer behaviour, and inventory.
This project analysed transactional data from 2021 to 2024 to uncover actionable insights.

The SQL Queries used to analyze and aggregate the data for this project can be found [here](https://github.com/SalamiEritosin/Supermart-Project/tree/main/queries)

Database script (https://tinyurl.com/39vxvhpp)

---

## 2. Objectives

- To identify sales & product performance
- To evaluate customer behaviour and operational efficiency
- To know employees' effectiveness

---

## 3. Project Scope & Tools

### Scope

| Dimension | Details |
|-----------|---------|
| **In Scope** | **Data sources:** 7 interconnected tables (`regions`, `categories`, `employees`, `customers`, `products`, `orders`, `order_items`).|
| **Out of Scope** | cost of goods sold data were excluded |
| **Time Period** | Jan 2021 - June 2024 |
| **Granularity** | order_items (each product in an order).  **Order‑level:** orders (each order). **Customer‑level:** customers (for segmentation and lifetime value). **Employee-level:** employees (for performance tracking).  **monthly aggregates** for time‑series analysis (revenue trends). |

### Tools & Technologies

| Category | Tool(s) Used |
|----------|-------------|
| Data Storage & Processing | MYSQL |
| Analysis | SQL queries |
| Version Control | GitHub |
| Documentation | Markdown |

---

## 4. Data Workflow

1. **Source:**  PostgreSQL script converted to MySQL for Supermart analytics.
- **Format:** SQL script with `CREATE TABLE` and `INSERT` statements.
 -  **Size:** 7 tables with sample data.

2. **Ingestion:** Ran the MySQL setup script in MySQL Workbench.
  - **Database:** Created a `supermart` database and executed the script to create tables and insert data.

3. **Cleaning:** 
  - **Data types:** Ensured columns were correctly typed (`INT`, `VARCHAR`, `DECIMAL`, `DATE`).
  - **Foreign keys:** Added relationships to maintain data integrity.  

4. **Analysis:** SQL queries for EDA, aggregations, joins, subqueries, CTEs, and business reporting.  
   - **Key analysis:** Sales performance, customer segmentation, employee performance, product trends.

5. **Output:**  
  - **SQL scripts**  used for analysis.  
  - **This documentation** complete pipeline, findings, and recommendations.

---

## 5. Database Schema and Table Relationship

**Table > Key Columns** 
- **regions** > region_id, region_name 
- **categories** > category_id, category_name 
- **employees** > employee_id, first_name, last_name, role, region_id, hire_date, salary 
- **customers** > customer_id, first_name, last_name, email, city, country, registration_date 
- **products** > product_id, product_name, category_id, unit_price, stock_quantity 
- **orders** > order_id, customer_id, employee_id, order_date, status, shipping_city 
- **order_items** > order_item_id, order_id, product_id, quantity, unit_price, discount 

**Table Relationships**
- regions ─< employees 
- categories ─< products 
- customers ─< orders >─ employees 
- orders ──< order_items >── products 
---

## 6. Key Insights & Recommendations

**Sales & product**

**Insight 1: Electronics Dominates Revenue**

**Finding:** Supermart revenue experienced a 38% drop in 2024 due to half of the year sales data. 
- Electronics products (Smartphones, Laptops, Smart TVs) generate the highest revenue, with Apple iPhone 15 Pro leading sales.
- Food & Groceries (Indomie noodles, vegetable oil 5l, Golden morn 1kg) tops the best selling products (quantity).

**Recommendation:** 
-  Since supermart's revenue is heavily dependent on high-ticket electronics, the company should secure premium inventory and negotiate exclusive distributor agreements and also, implement a "pre-order" system for new electronics launches to improve cash flow.

**Insight 2: Category-Level Volume vs. Value Trade-Off**

**Finding:** Food & Groceries has the highest order volume but lower average revenue per order compared to Electronics. Electronics has fewer orders but significantly higher revenue per order.

**Recommendation:**
- Supermart should cross-promote Food & Groceries with Electronics (e.g. "Buy a laptop, get 8% off groceries") for customer acquisition and revenue maximization. Use Groceries promotions to drive traffic and Electronics promotions to drive revenue.
  


**Customer Behaviour**

**Insight 3: VIP Customers Drive Revenue**

**Finding:** A small percentage of VIP customers (lifetime revenue > ₦500,000 and 5+ delivered orders) account for a significant portion of total revenue. Supermart's revenue is concentrated among a few high-value customers. Losing even one VIP customer could have a noticeable impact on revenue.

**Recommendation:**
- Launch a structured loyalty programme (exclusive discounts).
- Assign dedicated account managers to VIP customers.

**Insight 4: High One-Time Buyer Rate & Inactive Customers**

**Finding:** Supermart invests heavily in customer acquisition but fails to retain some potential customers beyond their first purchase.

**Recommendation:**
- Implement a "Second Purchase Incentive" program (e.g., 8% discount on next order).
- Send post-purchase follow-up emails with product care tips and recommendations.
- Run re-engagement campaigns (e.g., "We miss you – 7% off your first order").



**Employee Performance**

**Insight 5: Regional Employees Drive Revenue**

**Finding:** Employees in the North and South regions significantly outperform those in other regions in terms of total revenue generated. Seun Okeke (sales rep) from the north tops the list.

**Recommendation:**
- Implement a "buddy system" where high-performing employees mentor underperforming regions and offer incentives.



**Operations & Logistics Insights**

**Insight 6: Order Status Distribution**

**Finding:** Delivered orders dominate (81.90%), but a notable percentage of orders are still pending or cancelled. Improvements in fulfilment could reduce pending orders and recover lost revenue.

**Recommendation:**
- Optimize fulfilment processes to minimize pending orders.
- Investigate reasons for cancellation (e.g., out of stock, delivery issues, pricing) and address root causes.

---

## 7. Author

**[Eritosin Salami]**
[Data Analyst]

- 🔗 [www.linkedin.com/in/eritosin-salami]
- 💼 [https://github.com/EritosinSalami]
- 📧 [salamieritosinlearn@gmail.com]

---

*Last updated: [June 2026]*
# Supermart-Project
