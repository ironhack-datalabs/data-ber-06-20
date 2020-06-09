USE olist;
-- revenue per seller state in Sept 2018 (for all states)

-- 1. get a list of all states
SELECT *
FROM geolocation
LIMIT 1000;

SELECT DISTINCT
    geolocation_state
FROM geolocation;

-- 2. get revenue by state in Sept 2018 (order_purchase_timestamp)
SELECT
    s.seller_state,
    SUM(oi.price)   AS revenue
FROM order_items oi
    JOIN orders o
    ON oi.order_id = o.order_id
    JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE o.order_purchase_timestamp >= '2018-08-01'
    AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY s.seller_state;

-- 3. combine the two tables

WITH states AS (
    SELECT DISTINCT
        geolocation_state
    FROM geolocation),

rev_sept_2018 AS (
    SELECT
        s.seller_state,
        SUM(oi.price)   AS revenue
    FROM order_items oi
        JOIN orders o
        ON oi.order_id = o.order_id
        JOIN sellers s
        ON oi.seller_id = s.seller_id
    WHERE o.order_purchase_timestamp >= '2018-09-01'
        AND o.order_purchase_timestamp < '2018-10-01'
    GROUP BY s.seller_state)

SELECT
    s.geolocation_state     AS state,
    COALESCE(rs.revenue, 0) AS revenue
FROM states s
    LEFT JOIN rev_sept_2018 rs
    ON s.geolocation_state = rs.seller_state;

