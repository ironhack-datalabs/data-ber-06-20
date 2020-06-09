SELECT *
FROM olist.order_items
LIMIT 1000;

-- Total transaction volume with shipping_limit_date in 2018

SELECT
    ROUND(SUM(price),2) AS transaction_volume
FROM olist.order_items
WHERE shipping_limit_date >= '2018-01-01'
    AND shipping_limit_date < '2019-01-01';

-- Total items sold with shipping_limit_date in 2018

SELECT
    COUNT(*)
FROM olist.order_items
WHERE YEAR(shipping_limit_date) = 2018;

-- both in one query

SELECT
    SUM(price)  AS transaction_volume,
    COUNT(*)    AS items_sold
FROM olist.order_items
WHERE YEAR(shipping_limit_date) = 2018;

-- Total transaction volume and items sold for each year (shipping limit date)

SELECT
    YEAR(shipping_limit_date)   AS year,
    SUM(price)                  AS transaction_volume,
    AVG(price)                  AS avg_item_price,
    MAX(price)                  AS highes_item_price,
    COUNT(*)                    AS items_sold
FROM olist.order_items
GROUP BY year
ORDER BY year;

