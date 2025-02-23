-- ================================
-- Sales Performance (2016-2018)
-- ================================

-- Revenue and Quantity Sold Grouped by Year (2016-2018)
SELECT 
    EXTRACT(YEAR FROM so.time_order_taken) AS year,
    SUM(si.quantity) AS total_quantity,
    SUM(si.quantity * it.price) AS total_revenue
FROM sales_order AS so
JOIN sales_item AS si
    ON so.sales_order_id = si.sales_order_id
JOIN item AS it
    ON si.item_id = it.item_id
JOIN product AS pr
        ON it.product_id = pr.product_id
WHERE it.item_id NOT IN (28, 3, 50) OR pr.product_id NOT IN (13)
GROUP BY year
ORDER BY year ASC;

-- Overall Revenue and Quantity Sold (2016-2018)
WITH sales_summary AS (
    SELECT
        si.item_id,
        it.product_id,
        pr.name,
        SUM(si.quantity) AS total_quantity_sold,
        SUM(si.quantity * it.price) AS total_revenue
    FROM sales_item AS si
    JOIN item AS it 
        ON si.item_id = it.item_id
    JOIN product AS pr
        ON it.product_id = pr.product_id
    WHERE it.item_id NOT IN (28, 3, 50) OR pr.product_id NOT IN (13)
    GROUP BY pr.name, si.item_id, it.product_id
)
SELECT
    SUM(total_quantity_sold) AS total_quantity_sold,
    SUM(total_revenue) AS total_revenue
FROM sales_summary;

-- Earliset and Latest Order Date (January 2016 - December 2018)
SELECT
    MIN(time_order_taken) AS earliest_order_date,
    MAX(time_order_taken) AS latest_order_date
FROM sales_order;

--Revenue Trend by Year and Quarter (2016-2018)
SELECT
    EXTRACT(QUARTER FROM so.time_order_taken) AS quarter,
    EXTRACT(YEAR FROM so.time_order_taken) AS year,
    SUM(si.quantity) AS total_quantity_sold,
    SUM(si.quantity * it.price) AS total_revenue
FROM sales_order AS so
JOIN sales_item AS si
    ON so.sales_order_id = si.sales_order_id
JOIN item AS it
    ON si.item_id = it.item_id
JOIN product AS pr
        ON it.product_id = pr.product_id
    WHERE it.item_id NOT IN (28, 3, 50) OR pr.product_id NOT IN (13)
GROUP BY quarter, year
ORDER BY year ASC, quarter ASC;

-- Product Sales Performance (2016-2018)
SELECT
    pr.name AS product_name,
    SUM(si.quantity * it.price) AS total_revenue -- Total sales revenue per product
FROM product AS pr
JOIN item AS it
    ON pr.product_id = it.product_id
JOIN sales_item AS si
    ON it.item_id = si.item_id
WHERE it.item_id NOT IN (28, 3, 50) OR pr.product_id NOT IN (13) -- Excluding certain items and products (discontinued or not sold)
GROUP BY pr.name
ORDER BY total_revenue DESC;


