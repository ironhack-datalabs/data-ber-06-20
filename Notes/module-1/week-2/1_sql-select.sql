------
-- SELECTING A SAMPLE
------

SELECT *            -- asterisk (star) means select 'all' columns
FROM olist.orders   -- format: database.table
LIMIT 10;           -- only show the first 10 rows

SELECT *
FROM olist.customers
LIMIT 10;

------
-- SELECTING COLUMNS
------

-- Only display the order_id, customer_id and order_status columns
SELECT
    order_id,
    customer_id,
    order_status
FROM olist.orders
LIMIT 100;

SELECT
    order_id,
    order_id,
    order_id,
    customer_id,
    order_status
FROM olist.orders
LIMIT 100;

------
-- SORTING OUTPUT:
------

SELECT
    customer_id,
    order_status,
    order_purchase_timestamp
FROM olist.orders
ORDER BY order_purchase_timestamp; -- sort by column order_purchase_timestamp in ascending order

SELECT
    customer_id,
    order_status,
    order_purchase_timestamp
FROM olist.orders
ORDER BY order_purchase_timestamp DESC; -- sort by column order_purchase_timestamp in descending order

SELECT
    customer_id,
    order_status,
    order_purchase_timestamp
FROM olist.orders
ORDER BY order_status DESC -- sql allows you to sort alphabetically
LIMIT 100;

SELECT
    customer_id,
    order_status,
    order_purchase_timestamp
FROM olist.orders
ORDER BY order_estimated_delivery_date DESC
LIMIT 100;

-------
-- ALIASES
-------

SELECT
    order_id,
    customer_id AS customer_1,
    customer_id AS customer_2,
    customer_id AS customer_3
FROM olist.orders
ORDER BY customer_1
LIMIT 100;

-------
-- FILTERING
-------

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp
FROM olist.orders
WHERE order_status = 'shipped';


SELECT
    order_id,
    customer_id,
    order_purchase_timestamp
FROM olist.orders
WHERE order_status = 'shipped'
ORDER BY order_purchase_timestamp;

-- All order that were placed in Januar 2018 (order_purchase_timestamp)

SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_status
FROM olist.orders
WHERE
    order_purchase_timestamp >= '2018-01-01'    -- implicit type conversion
    AND order_purchase_timestamp < '2018-02-01' -- sql automatically converts the string to a timestamp type
ORDER BY order_purchase_timestamp;

SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_status
FROM olist.orders
WHERE
    order_purchase_timestamp >= TIMESTAMP('2018-01-01')    -- explicit type conversion
    AND order_purchase_timestamp < TIMESTAMP('2018-02-01')
ORDER BY order_purchase_timestamp;

SELECT TIMESTAMP('2018-01-01'); -- SQL sets the timestamp to midnight if not provided in the string input

SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_status
FROM olist.orders
WHERE
    order_purchase_timestamp > '2018-01-01'
    AND order_purchase_timestamp < '2018-02-01'
ORDER BY order_purchase_timestamp;

SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_status
FROM olist.orders
WHERE
    order_purchase_timestamp BETWEEN '2018-01-01' AND '2018-02-01' -- use BETWEEN instead of setting lower and upper thresholds
ORDER BY order_purchase_timestamp;

-- Find all order items where price is smaller than 50
SELECT *
FROM olist.order_items
LIMIT 1000;

SELECT *
FROM olist.order_items
WHERE price < 50
LIMIT 1000;

SELECT *
FROM olist.order_items
WHERE price < 50
ORDER BY price
LIMIT 1000;

SELECT
    order_id,
    order_item_id,
    product_id,
    price
FROM olist.order_items
WHERE price < 50
ORDER BY price;

-- find the order item with the lowest price
SELECT
    order_id,
    order_item_id,
    product_id,
    price
FROM olist.order_items
ORDER BY price
LIMIT 1;

-------
-- Column Type conversion or manipulation
-------
SELECT
    order_id,
    order_item_id,
    product_id,
    price,
    ROUND(price)    AS rounded_price,
    ROUND(price, 1) AS rounded_price_1
FROM olist.order_items
ORDER BY price
LIMIT 100;

SELECT
    order_id,
    order_item_id,
    product_id,
    price,
    ROUND(price)                                        AS rounded_price,
    ROUND(price, 1)                                     AS rounded_price_1,
    ROUND(price + ROUND(price) + ROUND(price, 1), 2)    AS rounded_price_sum
FROM olist.order_items
ORDER BY price
LIMIT 100;

SELECT
    CONCAT(order_id, product_id) AS unique_id
FROM olist.order_items
LIMIT 100;

SELECT
    *
FROM olist.order_items
LIMIT 100;

---

SELECT *
FROM olist.orders
WHERE order_purchase_timestamp < '2017-12-01'
    OR order_purchase_timestamp IS NULL
LIMIT 100;

SELECT *
FROM olist.orders
WHERE order_delivered_carrier_date IS NULL;

SELECT *
FROM olist.orders
WHERE order_delivered_carrier_date != TIMESTAMP('2017-06-16 14:55:37')
    OR order_delivered_carrier_date IS NULL;

