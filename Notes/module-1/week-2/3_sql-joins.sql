SELECT *
FROM olist.order_items
LIMIT 1000;

-- monthly revenue in 2018 (order_purchase_timestamp)

SELECT
    o.order_purchase_timestamp,
    oi.price
FROM olist.order_items AS oi
    INNER JOIN olist.orders AS o
    ON oi.order_id = o.order_id;

SELECT
    o.order_purchase_timestamp,
    oi.price
FROM olist.order_items AS oi
    INNER JOIN olist.orders AS o
    ON oi.order_id = o.order_id
WHERE YEAR(order_purchase_timestamp) = 2018;

SELECT
    MONTH(o.order_purchase_timestamp) AS month,
    SUM(oi.price)                     AS monthly_revenue
FROM olist.order_items AS oi
    INNER JOIN olist.orders AS o
    ON oi.order_id = o.order_id
WHERE YEAR(order_purchase_timestamp) = 2018
GROUP BY MONTH(o.order_purchase_timestamp)
ORDER BY MONTH(order_purchase_timestamp);

SELECT
    MONTH(o.order_purchase_timestamp) AS month,
    SUM(oi.price)                     AS monthly_revenue
FROM olist.order_items AS oi
    INNER JOIN olist.orders AS o
    ON oi.order_id = o.order_id
WHERE YEAR(order_purchase_timestamp) = 2018
GROUP BY MONTH(o.order_purchase_timestamp)
ORDER BY MONTH(order_purchase_timestamp);

-- top states, based on number of items_sold, all time

SELECT
    c.customer_state,
    COUNT(*)            AS items_sold
FROM olist.customers c
    JOIN olist.orders o
    ON c.customer_id = o.customer_id
    JOIN olist.order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY items_sold DESC;
