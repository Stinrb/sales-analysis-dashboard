-- ============================
-- Customer Insight Analysis
-- ============================

-- Total number of customers
SELECT COUNT(*) AS total_customers
FROM customer
WHERE customer_id IN (
    SELECT customer_id
        FROM sales_order);

-- Distribution of Customers by Age Group
SELECT
    CASE
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 18 AND 24 THEN '18-24'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 25 AND 34 THEN '25-34'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 35 AND 44 THEN '35-44'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 45 AND 54 THEN '45-54'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 55 AND 64 THEN '55-64'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) > 65 THEN '65+'
    END AS age_range,
    COUNT(*) AS customer_count
FROM customer
WHERE customer_id IN (
    SELECT customer_id
        FROM sales_order)
GROUP BY age_range
ORDER BY age_range DESC, customer_count DESC;

-- Distribution of Customers by Location
SELECT state, COUNT(*) AS customer_count
FROM customer
WHERE customer_id IN (
    SELECT customer_id
        FROM sales_order)
GROUP BY state
ORDER BY customer_count DESC;

-- Average Order Value by Age Group
SELECT
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 18 AND 24 THEN '18-24'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 25 AND 34 THEN '25-34'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 35 AND 44 THEN '35-44'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 45 AND 54 THEN '45-54'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 55 AND 64 THEN '55-64'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) > 65 THEN '65+'
    END AS age_range,
    COUNT(DISTINCT so.sales_order_id) AS num_orders,
    SUM(it.price * si.quantity) AS total_revenue,
    ROUND(SUM(it.price * si.quantity)/COUNT(DISTINCT so.sales_order_id), 2) AS avg_order_value
FROM customer AS c
    LEFT JOIN sales_order AS so
        ON c.customer_id = so.customer_id
    LEFT JOIN sales_item AS si
        ON so.sales_order_id = si.sales_order_id
    LEFT JOIN item AS it
        ON si.item_id = it.item_id
    LEFT JOIN product AS pr
        ON it.product_id = pr.product_id
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
)
GROUP BY age_range
ORDER BY age_range ASC;


-- Customer Segmentation by Age Group
WITH customer_revenue AS (
    SELECT
        CASE
        WHEN EXTRACT(YEAR FROM AGE(c.birth_date)) BETWEEN 18 AND 24 THEN '18-24'
        WHEN EXTRACT(YEAR FROM AGE(c.birth_date)) BETWEEN 25 AND 34 THEN '25-34'
        WHEN EXTRACT(YEAR FROM AGE(c.birth_date)) BETWEEN 35 AND 44 THEN '35-44'
        WHEN EXTRACT(YEAR FROM AGE(c.birth_date)) BETWEEN 45 AND 54 THEN '45-54'
        WHEN EXTRACT(YEAR FROM AGE(c.birth_date)) BETWEEN 55 AND 64 THEN '55-64'
        WHEN EXTRACT(YEAR FROM AGE(c.birth_date)) > 65 THEN '65+'
        END AS age_range,
        COUNT(DISTINCT so.sales_order_id) AS num_orders,
        SUM(it.price * si.quantity) AS total_revenue
    FROM customer AS c
    LEFT JOIN sales_order AS so
        ON c.customer_id = so.customer_id
    LEFT JOIN sales_item AS si
        ON so.sales_order_id = si.sales_order_id
    LEFT JOIN item AS it
        ON si.item_id = it.item_id
    LEFT JOIN product AS pr
        ON it.product_id = pr.product_id
    WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
)
    GROUP BY age_range
)
SELECT
    age_range,
    num_orders,
    total_revenue,
    CASE 
        WHEN ntile = 1 THEN 'High Value'
        WHEN ntile = 2 THEN 'Middle Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM (
    SELECT *,
           NTILE(3) OVER (ORDER BY total_revenue DESC) AS ntile
    FROM customer_revenue
) AS segmented_customers
ORDER BY total_revenue DESC;

-- Total Revenue and Order by Location
SELECT
    c.state AS location,
    COUNT(DISTINCT so.sales_order_id) AS total_orders,
    SUM(it.price * si.quantity) AS total_revenue
FROM customer AS c
LEFT JOIN sales_order AS so
    ON c.customer_id = so.customer_id
LEFT JOIN sales_item AS si
    ON so.sales_order_id = si.sales_order_id
LEFT JOIN item AS it
    ON si.item_id = it.item_id
LEFT JOIN product AS pr
    ON it.product_id = pr.product_id
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
)
GROUP BY location
ORDER BY total_revenue DESC;

-- Top Selling Products by Age Group
WITH cte1 AS (
SELECT
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 18 AND 24 THEN '18-24'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 25 AND 34 THEN '25-34'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 35 AND 44 THEN '35-44'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 45 AND 54 THEN '45-54'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) BETWEEN 55 AND 64 THEN '55-64'
        WHEN EXTRACT(YEAR FROM AGE(birth_date)) > 65 THEN '65+'
    END AS age_range,
    pr.name AS product_name,
    COUNT(DISTINCT so.sales_order_id) AS total_orders,
    SUM(it.price * si.quantity) AS total_revenue
FROM customer AS c
LEFT JOIN sales_order AS so
    ON c.customer_id = so.customer_id
LEFT JOIN sales_item AS si
    ON so.sales_order_id = si.sales_order_id
LEFT JOIN item AS it
    ON si.item_id = it.item_id
LEFT JOIN product AS pr
    ON it.product_id = pr.product_id
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
)
GROUP BY age_range, pr.name
ORDER BY total_orders DESC, total_revenue DESC
), cte2 AS (
SELECT
    ROW_NUMBER() OVER(PARTITION BY age_range ORDER BY total_revenue DESC, total_orders DESC) AS rank,
    age_range,
    product_name,
    total_orders,
    total_revenue
FROM cte1
WHERE product_name IS NOT NULL AND total_revenue IS NOT NULL
) 
SELECT *
FROM cte2
WHERE rank = 1;