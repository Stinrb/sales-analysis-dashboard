-- ========================================
-- Data Investigation & Validation
-- ========================================

-- Investigating rows from customer table with NULL in sales_order table.
SELECT *
FROM customer AS c
LEFT JOIN sales_order AS so 
    ON c.customer_id = so.customer_id
WHERE so.sales_order_id IS NULL OR so.customer_id IS NULL;
-- Found 1 orphaned customer (no orders made), reducing customers count from 20 to 19 in the customer table.
-- Christopher Robinson (customer_id 20)

-- Investigating rows from sales_person table with NULL in sales_order table.
SELECT *
FROM sales_person AS sp
LEFT JOIN sales_order AS so
ON sp.sales_person_id = so.sales_person_id
WHERE so.sales_person_id IS NULL OR so.sales_order_id IS NULL;
-- Found 1 orphaned sales_person (no sales order handled/associated), reducing salespersons count from 5 to 4 in the sales_person table.
-- Jessica Thompson (sales_person_id 5)

-- Investigating rows from product_type table with NULL in product table.
SELECT *
FROM product_type AS pt
    LEFT JOIN product AS pr
        ON pt.product_type_id = pr.product_type_id
WHERE pr.product_type_id IS NULL OR pr.product_id IS NULL;
-- No inconsistencies found

-- Investigating rows from product table with NULL in item table.
SELECT *
FROM product AS p
LEFT JOIN item AS i
ON p.product_id = i.product_id
WHERE i.product_id IS NULL OR i.item_id IS NULL;
-- Found 1 orphaned product (not sold or discontinued), reducing products count from 13 to 12 in the product table.
-- product_id 13 NULL in item table

-- Investigating rows from item table with NULL in sales_item table.
SELECT *
FROM item AS i
LEFT JOIN sales_item AS si
ON i.item_id = si.item_id
WHERE si.item_id IS NULL OR si.sales_item_id IS NULL;
-- Found 3 orphaned items (not sold, or discontinued), reducing items count from 50 to 47 in the item table.
-- item_id 28, 3, 50 NULL in sales_item table

-- Investigating rows from sales_order table with NULL in sales_item table.
SELECT *
FROM sales_order AS so
LEFT JOIN sales_item AS si
ON so.sales_order_id = si.sales_order_id
WHERE si.sales_order_id IS NULL OR si.sales_item_id IS NULL;

-- Alternative query
SELECT so.*
FROM sales_order AS so
WHERE so.sales_order_id NOT IN (
    SELECT DISTINCT sales_order_id
    FROM sales_item);
-- Found 14 orphaned sales orders (invalid orders), reducing sales orders count from 100 to 86 in the sales_order table.
-- sales_order_id 12, 16, 18, 19, 30, 31, 52, 62, 89, 93, 95, 96, 97, 100 NULL in sales_item table

-- Query to show all sales orders with sales items
SELECT *
FROM sales_order AS so
WHERE so.sales_order_id IN (
    SELECT DISTINCT sales_order_id FROM sales_item
);
-- 86 total orders

-- Query to show items and product not sold or discontinued
SELECT p.product_id,
    p.name AS product_name,
    i.item_id,
    si.sales_order_id,
    i.size,
    i.color
FROM product AS p
    LEFT JOIN item AS i 
        ON p.product_id = i.product_id
    LEFT JOIN sales_item AS si
        ON i.item_id = si.item_id
    LEFT JOIN sales_order AS so 
        ON si.sales_order_id = so.sales_order_id
WHERE si.sales_order_id IS NULL;
