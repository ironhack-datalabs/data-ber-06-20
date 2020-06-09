-------
-- SUBQUERIES
-------
USE olist;

SELECT *
FROM order_items
LIMIT 100;

-- the number of orders by order size (how many orders have x items?)

-- 1. calculate the number of items for each order

SELECT
    order_id,
    COUNT(*)    AS no_of_items
FROM order_items
GROUP BY order_id;

-- 2. group by number of items to count the orders

SELECT
    no_of_items,
    COUNT(*)        AS no_of_orders
FROM (
    SELECT
        order_id,
        COUNT(*)    AS no_of_items
    FROM order_items
    GROUP BY order_id
    ) s
GROUP BY no_of_items
ORDER BY no_of_items;

-- number of orders with more than 5 items

SELECT
    COUNT(*)
FROM (
    SELECT
        order_id,
        COUNT(*) AS no_of_items
    FROM order_items
    GROUP BY
        order_id
    ) s
WHERE no_of_items > 5;

-- number of orders with more than 5 items that are not delivered

SELECT
    COUNT(*)
FROM (
    SELECT
        order_id,
        COUNT(*) AS no_of_items
    FROM order_items
    GROUP BY
        order_id
    ) s
    JOIN orders o
    ON s.order_id = o.order_id
WHERE s.no_of_items > 5
    AND o.order_status != 'delivered';

SELECT
    COUNT(*),
    COUNT(1),
    COUNT('Hello'),
    SUM(1)
FROM (
    SELECT
        order_id,
        COUNT(*) AS no_of_items
    FROM order_items
    GROUP BY
        order_id
    ) s
    JOIN orders o
    ON s.order_id = o.order_id
WHERE s.no_of_items > 5
    AND o.order_status != 'delivered';

-------
-- TEMPORARY TABLES
-------

-- the number of orders by order size (how many orders have x items?)

-- 1. calculate the number of items for each order

CREATE TEMPORARY TABLE items_per_order AS (
    SELECT
        order_id,
        COUNT(*)    AS no_of_items
    FROM order_items
    GROUP BY order_id);

-- 2. group by number of items to count the orders

SELECT
    no_of_items,
    COUNT(*)        AS no_of_orders
FROM items_per_order
GROUP BY no_of_items
ORDER BY no_of_items;

-- number of orders with more than 5 items that are not delivered

SELECT
    COUNT(*)
FROM items_per_order i
    JOIN orders o
    ON i.order_id = o.order_id
WHERE i.no_of_items > 5
    AND o.order_status != 'delivered';

-----

CREATE TABLE items_per_order AS (
    SELECT
        order_id,
        COUNT(*)    AS no_of_items
    FROM order_items
    GROUP BY order_id);

DROP TABLE items_per_order;

-------
-- COMMON TABLE EXPRESSIONS (CTEs) - AKA WITH TABLES
-------

-- the number of orders by order size (how many orders have x items?)
WITH items_per_order AS (
    SELECT
        order_id,
        COUNT(*)    AS no_of_items
    FROM order_items
    GROUP BY order_id)

SELECT
    no_of_items,
    COUNT(*)        AS no_of_orders
FROM items_per_order
GROUP BY no_of_items
ORDER BY no_of_items;

---

WITH items_per_order AS (
    SELECT
        order_id,
        COUNT(*)    AS no_of_items
    FROM order_items
    GROUP BY order_id),

another_table AS (
    SELECT
        order_id,
        no_of_items
    FROM items_per_order
    WHERE no_of_items > 1)

SELECT
    no_of_items,
    COUNT(*)        AS no_of_orders
FROM another_table
GROUP BY no_of_items
ORDER BY no_of_items;

/*
WITH subtable_1 AS (
    SELECT *
    FROM [...]
    ),
subtable_2 AS (
    SELECT *
    FROM [...]
    ),
subtable_n AS (
    SELECT *
    FROM [...]
    )

SELECT *
FROM [...]
 */

-- revenue per customer city in 2018

WITH rev_by_customer AS (
    SELECT
        o.customer_id,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM order_items oi
        INNER JOIN orders o
        ON oi.order_id = o.order_id
    WHERE YEAR(o.order_purchase_timestamp) = 2018
    GROUP BY o.customer_id),

rev_by_customer_zip AS (
    SELECT
        rbc.customer_id,
        rbc.revenue,
        c.customer_zip_code_prefix
    FROM rev_by_customer rbc
        INNER JOIN customers c
        ON rbc.customer_id = c.customer_id),
dedup_geolocations AS (
    SELECT
        geolocation_zip_code_prefix,
        MIN(geolocation_city)       AS geolocation_city
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix)

SELECT
    g.geolocation_city,
    SUM(rbcz.revenue)   AS revenue
FROM rev_by_customer_zip rbcz
    INNER JOIN dedup_geolocations g
    ON rbcz.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY revenue DESC;

WITH rev_by_customer AS (
    SELECT
        o.customer_id,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM order_items oi
        INNER JOIN orders o
        ON oi.order_id = o.order_id
    WHERE YEAR(o.order_purchase_timestamp) = 2018
    GROUP BY o.customer_id),

rev_by_customer_zip AS (
    SELECT
        rbc.customer_id,
        rbc.revenue,
        c.customer_zip_code_prefix
    FROM rev_by_customer rbc
        INNER JOIN customers c
        ON rbc.customer_id = c.customer_id),

dedup_geolocations AS ( -- geolocation is not unique
    SELECT
        geolocation_zip_code_prefix,
        MIN(geolocation_city)       AS geolocation_city
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix)

SELECT
    g.geolocation_city,
    SUM(rbcz.revenue)   AS revenue
FROM rev_by_customer_zip rbcz
    INNER JOIN geolocation g
    ON rbcz.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_city
ORDER BY revenue DESC;

-- create unique zip_code + city combinations
SELECT DISTINCT
    geolocation_zip_code_prefix,
    geolocation_city
FROM geolocation
ORDER BY geolocation_zip_code_prefix
LIMIT 1000;

-- test if zip codes are unique
WITH dedup_zip_city AS (
    SELECT DISTINCT
        geolocation_zip_code_prefix,
        geolocation_city
    FROM geolocation)

SELECT
    geolocation_zip_code_prefix,
    COUNT(*)
FROM dedup_zip_city
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(*) > 1; -- filtering after a group by

-- alternatively

WITH dedup_zip_city AS (
    SELECT DISTINCT
        geolocation_zip_code_prefix,
        geolocation_city
    FROM geolocation)

SELECT
    COUNT(*),                                   -- count all rows
    COUNT(DISTINCT geolocation_zip_code_prefix) -- count unique occurences of zip_code
FROM dedup_zip_city;

-- still not unique

SELECT DISTINCT
    geolocation_zip_code_prefix,
    geolocation_city
FROM geolocation
WHERE geolocation_zip_code_prefix = 13456;

WITH dedup_zip_city AS (
    SELECT
        geolocation_zip_code_prefix,
        MAX(geolocation_city)
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix)

SELECT
    COUNT(*),
    COUNT(DISTINCT geolocation_zip_code_prefix)
FROM dedup_zip_city;

