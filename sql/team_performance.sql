-- =================================
-- Team Performance (2016-2018)
-- =================================

-- Sales Person Performace (2016-2018)
SELECT 
        sp.sales_person_id AS sp_id,
        CONCAT(sp.first_name, ' ', sp.last_name) AS sales_person,
        COUNT(DISTINCT so.sales_order_id) AS total_orders,
        SUM(si.quantity * it.price) AS total_revenue
FROM sales_person AS sp
    JOIN sales_order AS so
        ON sp.sales_person_id = so.sales_person_id
    LEFT JOIN sales_item AS si
        ON so.sales_order_id = si.sales_order_id
    LEFT JOIN item AS it
        ON si.item_id = it.item_id
    LEFT JOIN product AS pr
    ON it.product_id = pr.product_id
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
)
GROUP BY sp_id, first_name, last_name
ORDER BY total_orders DESC;

-- Average Order Value per Salesperson (2016-2018)
SELECT 
    sp.sales_person_id AS sp_id,
    CONCAT(sp.first_name, ' ', sp.last_name) AS sales_person,
    ROUND(COALESCE(SUM(si.quantity * it.price), 0) / COALESCE(NULLIF(COUNT(DISTINCT so.sales_order_id), 0), 1), 2) AS avg_order_value
FROM sales_person AS sp
JOIN sales_order AS so
    ON sp.sales_person_id = so.sales_person_id
LEFT JOIN sales_item AS si
    ON so.sales_order_id = si.sales_order_id
LEFT JOIN item AS it
    ON si.item_id = it.item_id
LEFT JOIN product AS pr
    ON it.product_id = pr.product_id
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
)
GROUP BY sp.sales_person_id, sp.first_name, sp.last_name
ORDER BY avg_order_value DESC;

-- Total Orders (2016-2018)
SELECT 
    COUNT(DISTINCT so.sales_order_id) AS total_orders
FROM sales_order AS so
LEFT JOIN sales_person AS sp
    ON so.sales_person_id = sp.sales_person_id
LEFT JOIN sales_item AS si
    ON so.sales_order_id = si.sales_order_id
LEFT JOIN item AS it
    ON si.item_id = it.item_id
LEFT JOIN product AS pr
    ON it.product_id = pr.product_id
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
);
-- 86 total orders

-- Revenue Trend by Salesperson per Year & Month (2016-2018)
SELECT 
        CONCAT(sp.first_name, ' ', sp.last_name) AS sales_person,
        SUM(si.quantity * it.price) AS total_revenue,
        EXTRACT(YEAR FROM so.time_order_taken) AS year,
        EXTRACT(MONTH FROM so.time_order_taken) AS month
FROM sales_person AS sp
    JOIN sales_order AS so
        ON sp.sales_person_id = so.sales_person_id
    LEFT JOIN sales_item AS si
        ON so.sales_order_id = si.sales_order_id
    LEFT JOIN item AS it
        ON si.item_id = it.item_id
    LEFT JOIN product AS pr
    ON it.product_id = pr.product_id
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
)
GROUP BY sales_person, year, month
ORDER BY year ASC;