-- ================================
-- Data Cleaning and Validation
-- ================================

-- ===================================================
-- CUSTOMER TABLE - Data Cleaning & Validation
-- ===================================================


-- 1️. Checking for Duplicates
SELECT *
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM customer
    GROUP BY customer_id
    HAVING COUNT(*) > 1);


-- Alternative checking using CTE (Row Number method)
WITH customer_duplicates AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY first_name, last_name, email, company, street, city, state, 
                              zip, phone, birth_date, sex, date_entered 
                              ORDER BY last_name) AS row_num
    FROM customer
)
SELECT *
FROM customer_duplicates
WHERE row_num > 1;


-- 2️. Checking for NULL or Missing Values
SELECT *
FROM customer
WHERE COALESCE(first_name, '') = '' 
   OR COALESCE(last_name, '') = '' 
   OR COALESCE(email, '') = '' 
   OR COALESCE(company, '') = '' 
   OR COALESCE(street, '') = '' 
   OR COALESCE(city, '') = '' 
   OR COALESCE(state, '') = '' 
   OR zip IS NULL 
   OR COALESCE(phone, '') = '' 
   OR birth_date IS NULL 
   OR sex IS NULL 
   OR date_entered IS NULL;


-- 3️. Checking if Data is Standardized (Accidental spaces & Format)
SELECT  
       first_name, TRIM(first_name) AS trimmed_first_name,
       CASE 
           WHEN first_name != TRIM(first_name) THEN 'Accidental Space' 
           ELSE 'No Space' 
       END AS first_name_issues,
       
       last_name, TRIM(last_name) AS trimmed_last_name,
       CASE 
           WHEN last_name != TRIM(last_name) THEN 'Accidental Space' 
           ELSE 'No Space' 
       END AS last_name_issues,

       email, TRIM(email) AS trimmed_email,
       CASE 
           WHEN email != TRIM(email) THEN 'Accidental Space' 
           ELSE 'No Space' 
       END AS email_issues
FROM customer
WHERE first_name != TRIM(first_name) 
   OR last_name != TRIM(last_name)
   OR email != TRIM(email);

-- Check for valid email formatting and phone number consistency
SELECT *,
       CASE 
           WHEN email NOT LIKE '%@%.%' THEN 'Invalid Email Format' 
           ELSE 'Valid Email' 
       END AS email_validation,
       
       CASE 
           WHEN phone NOT SIMILAR TO '[0-9]%' THEN 'Invalid Phone Number'
           ELSE 'Valid Phone' 
       END AS phone_validation
FROM customer;


-- 4️. Integrity Check: Customers Without Sales Orders
SELECT c.*
FROM customer AS c
LEFT JOIN sales_order AS so ON c.customer_id = so.customer_id
WHERE so.sales_order_id IS NULL;

-- Found 1 orphaned customer: "Christopher Robinson" (customer_id 20)
-- This customer has no associated sales orders.


-- ===================================================
-- SALES_PERSON TABLE - Data Cleaning & Validation
-- ===================================================

-- 1️. Checking for Duplicates
SELECT *
FROM sales_person
WHERE sales_person_id IN (
    SELECT sales_person_id
    FROM sales_person
    GROUP BY sales_person_id
    HAVING COUNT(*) > 1);

-- Alternative checking using CTE
WITH sales_person_duplicates AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY first_name, last_name, email, street, city, state, zip, 
                              phone, birth_date, sex, date_hired 
                              ORDER BY first_name) AS row_num
    FROM sales_person
)
SELECT * 
FROM sales_person_duplicates 
WHERE row_num > 1;

-- 2️. Checking for NULL or Missing Values
SELECT *
FROM sales_person
WHERE COALESCE(first_name, '') = '' 
   OR COALESCE(last_name, '') = '' 
   OR COALESCE(email, '') = '' 
   OR COALESCE(street, '') = '' 
   OR COALESCE(city, '') = '' 
   OR COALESCE(state, '') = '' 
   OR zip IS NULL 
   OR COALESCE(phone, '') = '' 
   OR birth_date IS NULL 
   OR sex IS NULL 
   OR date_hired IS NULL;

-- 3️. Checking if Data is Standardized (Accidental spaces & Format)
SELECT  
       first_name, TRIM(first_name) AS trimmed_first_name,
       CASE WHEN first_name != TRIM(first_name) THEN 'Accidental Space' ELSE 'No Space' END AS first_name_issues,
       
       last_name, TRIM(last_name) AS trimmed_last_name,
       CASE WHEN last_name != TRIM(last_name) THEN 'Accidental Space' ELSE 'No Space' END AS last_name_issues,

       email, TRIM(email) AS trimmed_email,
       CASE WHEN email != TRIM(email) THEN 'Accidental Space' ELSE 'No Space' END AS email_issues
FROM sales_person
WHERE first_name != TRIM(first_name) 
    OR last_name != TRIM(last_name) 
    OR email != TRIM(email);

-- 4️. Integrity Check: Salespersons Without Sales Orders
SELECT sp.*
FROM sales_person AS sp
LEFT JOIN sales_order AS so ON sp.sales_person_id = so.sales_person_id
WHERE so.sales_order_id IS NULL;

-- Found 1 orphaned sales_person: "Jessica Thompson" (sales_person_id 5)
-- This salesperson has no associated sales orders.


-- ===================================================
-- PRODUCT_TYPE TABLE - Data Cleaning & Validation
-- ===================================================

-- 1️. Checking for Duplicates
SELECT *
FROM product_type
WHERE product_type_id IN (
    SELECT product_type_id
    FROM product_type
    GROUP BY product_type_id
    HAVING COUNT(*) > 1);

-- 2️. Checking for NULL or Missing Values
SELECT *
FROM product_type
WHERE COALESCE(name, '') = '';


-- 3️. Checking if Data is Standardized (Accidental spaces & Format)
SELECT  
       name, TRIM(name) AS trimmed_name,
       CASE 
           WHEN name != TRIM(name) THEN 'Accidental Space' 
           ELSE 'No Space' 
       END AS name_issues
FROM product_type
WHERE name != TRIM(name);


-- 4️. Integrity Check: Product Types Without Products
SELECT *
FROM product_type AS pt
    LEFT JOIN product AS pr
        ON pt.product_type_id = pr.product_type_id
WHERE pr.product_type_id IS NULL;

-- No inconsistencies found


-- ===================================================
-- PRODUCT TABLE - Data Cleaning & Validation
-- ===================================================

-- 1️. Checking for Duplicates
SELECT *
FROM product
WHERE product_id IN (
    SELECT product_id
    FROM product
    GROUP BY product_id
    HAVING COUNT (*) > 1);

-- Alternative checking using CTE
WITH product_duplicates AS  (
    SELECT *,
              ROW_NUMBER() OVER (PARTITION BY name, supplier, description, product_type_id
                                ORDER BY product_id) AS row_num
    FROM product
)
SELECT *
FROM product_duplicates
WHERE row_num > 1;

-- 2️. Checking for NULL or Missing Values
SELECT *
FROM product
WHERE COALESCE(name, '') = ''
    OR COALESCE(supplier, '') = ''
    OR COALESCE(description, '') = ''
    OR product_type_id IS NULL;

-- 3️. Checking if Data is Standardized (Accidental spaces & Format)
SELECT  
       name, TRIM(name) AS trimmed_name,
       CASE WHEN name != TRIM(name) THEN 'Accidental Space' ELSE 'No Space' END AS name_issues,
       
       supplier, TRIM(supplier) AS trimmed_supplier,
       CASE WHEN supplier != TRIM(supplier) THEN 'Accidental Space' ELSE 'No Space' END AS supplier_issues,

       description, TRIM(description) AS trimmed_description,
       CASE WHEN description != TRIM(description) THEN 'Accidental Space' ELSE 'No Space' END AS description_issues
FROM product
WHERE name != TRIM(name) 
    OR supplier != TRIM(supplier) 
    OR description != TRIM(description);

SELECT 
    description,
    CASE 
        WHEN description LIKE '%  %' THEN 'Double spaces detected' 
        ELSE 'No issue' 
    END AS description_issues,
    
    supplier,
    CASE 
        WHEN supplier LIKE '%  %' THEN 'Double spaces detected' 
        ELSE 'No issue' 
    END AS supplier_issues
FROM product
WHERE description LIKE '%  %' OR supplier LIKE '%  %';

-- 4️. Integrity Check: Products Without Items
-- Checking for orphaned products (products that have no associated items).  
-- A product without an item could mean it was never sold, discontinued, or has missing data.  
SELECT *
FROM product AS p
LEFT JOIN item AS i
ON p.product_id = i.product_id
WHERE i.product_id IS NULL;

-- Found 1 orphaned product, reducing products count from 13 to 12 in the product table.
-- product_id 13 has no associated items in the item table.


-- ===================================================
-- ITEM TABLE - Data Cleaning & Validation
-- ===================================================

-- 1️. Checking for Duplicates
SELECT *
FROM item
WHERE item_id IN (
    SELECT item_id
    FROM item
    GROUP BY item_id
    HAVING COUNT (*) > 1);

-- Alternative checking using CTE
WITH item_duplicates AS  (
    SELECT *,
              ROW_NUMBER() OVER (PARTITION BY product_id, size, color, picture, price, item_id
                                ORDER BY item_id) AS row_num
    FROM item
)
SELECT *
FROM item_duplicates
WHERE row_num > 1;

-- 2️. Checking for NULL or Missing Values
SELECT *
FROM item
WHERE product_id IS NULL
    OR COALESCE(size, '') = ''
    OR COALESCE(color, '') = ''
    OR COALESCE(picture, '') = ''
    OR price IS NULL;

-- 3️. Checking if Data is Standardized (Accidental spaces & Format)
SELECT  
       size, TRIM(size) AS trimmed_size,
       CASE WHEN size != TRIM(size) THEN 'Accidental Space' ELSE 'No Space' END AS size_issues,
       
       color, TRIM(color) AS trimmed_color,
       CASE WHEN color != TRIM(color) THEN 'Accidental Space' ELSE 'No Space' END AS color_issues
FROM item
WHERE size != TRIM(size) OR color != TRIM(color);

-- 4️. Integrity Check: Items Without Records in Sales Item Table
-- Checking for orphaned items (items that have no associated sales records).
-- An item without a sales record could mean it was never sold, discontinued, or has missing data.
SELECT *
FROM item AS i
LEFT JOIN sales_item AS si
ON i.item_id = si.item_id
WHERE si.item_id IS NULL;

-- Found 3 orphaned items, reducing items count from 50 to 47 in the item table.
-- item_id 28, 3, 50 NULL in sales_item table.


-- ===================================================
-- SALES_ORDER TABLE - Data Cleaning & Validation
-- ===================================================

-- 1️. Checking for Duplicates
SELECT *
FROM sales_order
WHERE sales_order_id IN (
    SELECT sales_order_id
    FROM sales_order
    GROUP BY sales_order_id
    HAVING COUNT(*) > 1);

-- Alternative checking using CTE
WITH sales_order_duplicates AS (
    SELECT *,
              ROW_NUMBER() OVER (PARTITION BY customer_id, sales_person_id, time_order_taken, purchase_order_number,
                                credit_card_number, credit_card_exper_month, credit_card_exper_day, credit_card_secret_code,
                                name_on_card
                                ORDER BY sales_order_id) AS row_num
FROM sales_order
)
SELECT *
FROM sales_order_duplicates
WHERE row_num > 1;

-- 2️. Checking for NULL or Missing Values
SELECT *
FROM sales_order
WHERE customer_id IS NULL
    OR sales_person_id IS NULL
    OR time_order_taken IS NULL
    OR purchase_order_number IS NULL
    OR credit_card_number IS NULL
    OR credit_card_exper_month IS NULL
    OR credit_card_exper_day IS NULL
    OR credit_card_secret_code IS NULL
    OR COALESCE(name_on_card, '') = '';

-- 3️. Checking if Data is Standardized (Accidental spaces & Format)
SELECT  
       purchase_order_number, TRIM(purchase_order_number) AS trimmed_purchase_order_number,
       CASE WHEN purchase_order_number != TRIM(purchase_order_number) THEN 'Accidental Space' ELSE 'No Space' END AS purchase_order_number_issues,
       
       credit_card_number, TRIM(credit_card_number) AS trimmed_credit_card_number,
       CASE WHEN credit_card_number != TRIM(credit_card_number) THEN 'Accidental Space' ELSE 'No Space' END AS credit_card_number_issues,
       
       name_on_card, TRIM(name_on_card) AS trimmed_name_on_card,
       CASE WHEN name_on_card != TRIM(name_on_card) THEN 'Accidental Space' ELSE 'No Space' END AS name_on_card_issues
FROM sales_order
WHERE purchase_order_number != TRIM(purchase_order_number) 
    OR credit_card_number != TRIM(credit_card_number) 
    OR name_on_card != TRIM(name_on_card);

-- 4️. Integrity Check: Sales Orders Without Sales Items
-- Checking for orphaned sales orders (sales orders that have no associated sales items).
-- A sales order not linked to any sales items could mean it was never fulfilled, or has missing data.
SELECT *
FROM sales_order AS so
LEFT JOIN sales_item AS si
ON so.sales_order_id = si.sales_order_id
WHERE si.sales_order_id IS NULL;

-- Alternative query
SELECT so.*
FROM sales_order AS so
WHERE so.sales_order_id NOT IN (
    SELECT DISTINCT sales_order_id
    FROM sales_item);

-- Found 14 orphaned sales orders (invalid orders), reducing sales orders count from 100 to 86 in the sales_order table.
-- sales_order_id 12, 16, 18, 19, 30, 31, 52, 62, 89, 93, 95, 96, 97, 100 NULL in sales_item table


-- ===================================================
-- SALES_ITEM TABLE - Data Cleaning & Validation
-- ===================================================

-- 1️. Checking for Duplicates
SELECT *
FROM sales_item
WHERE sales_item_id IN (
    SELECT sales_item_id
    FROM sales_item
    GROUP BY sales_item_id
    HAVING COUNT (*) > 1);

-- Alternative checking using CTE
WITH sales_item_duplicates AS  (
    SELECT *,
              ROW_NUMBER() OVER (PARTITION BY item_id, sales_order_id, quantity, discount, taxable, sales_tax_rate
                                ORDER BY sales_item_id) AS row_num
    FROM sales_item
)
SELECT *
FROM sales_item_duplicates
WHERE row_num > 1;

-- 2️. Checking for NULL or Missing Values
SELECT *
FROM sales_item
WHERE item_id IS NULL
    OR sales_order_id IS NULL
    OR quantity IS NULL
    OR discount IS NULL
    OR taxable IS NULL
    OR sales_tax_rate IS NULL;

-- 3️. Checking if Data is Standardized (Accidental spaces & Format)
SELECT  
       quantity, TRIM(quantity) AS trimmed_quantity,
       CASE WHEN quantity != TRIM(quantity) THEN 'Accidental Space' ELSE 'No Space' END AS quantity_issues,
       
       discount, TRIM(discount) AS trimmed_discount,
       CASE WHEN discount != TRIM(discount) THEN 'Accidental Space' ELSE 'No Space' END AS discount_issues
FROM sales_item
WHERE quantity != TRIM(quantity) 
    OR discount != TRIM(discount);

-- 4️. Integrity Check: Sales Items Without Items or Sales Orders
-- Checking for orphaned sales items (sales items that have no associated items or sales orders).
SELECT *
FROM sales_item AS si
LEFT JOIN item AS i 
ON si.item_id = i.item_id
WHERE i.item_id IS NULL;

SELECT *
FROM sales_item AS si
LEFT JOIN sales_order AS so 
ON si.sales_order_id = so.sales_order_id
WHERE so.sales_order_id IS NULL;

-- No inconsistencies found
