SHOW DATABASES;

-- Lab-01-olist
-- Q.3

SELECT
    customer_state,
    COUNT(*)        AS customers
FROM olist.customers
GROUP BY customer_state
ORDER BY customers DESC
LIMIT 3;

SELECT
    customer_state
    -- COUNT(*)        AS customers
FROM olist.customers
GROUP BY customer_state
ORDER BY COUNT(*) DESC
LIMIT 3;

-- how to count rows

SELECT
    customers.*,
    1,
    'I\'m a row',
    CONCAT('the state of: ', customer_state)
FROM customers
LIMIT 10;

SELECT
    COUNT(1),
    SUM(1),
    SUM(2) - SUM(1),
    COUNT('hello'),
    COUNT(*)
FROM customers
LIMIT 10;

-- Q.4

SELECT
    customer_city,
    COUNT(*)        AS customers
FROM customers
WHERE customer_state = 'SP'
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 3;

WITH most_customer_state AS (
    SELECT
        customer_state
    FROM olist.customers
    GROUP BY customer_state
    ORDER BY COUNT(*) DESC
    LIMIT 1)

SELECT
    c.customer_city,
    COUNT(*)        AS customers
FROM customers c
    INNER JOIN most_customer_state mcs
    ON c.customer_state = mcs.customer_state
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 3;

-- alternative:

SELECT
    customer_city,
    COUNT(*)        AS customers
FROM customers
WHERE customer_state = (SELECT
                            customer_state
                        FROM olist.customers
                        GROUP BY customer_state
                        ORDER BY COUNT(*) DESC
                        LIMIT 1)
GROUP BY customer_city
ORDER BY customers DESC
LIMIT 3;

--

WITH ranked_states AS (
    SELECT
        customer_state,
        COUNT(*)        AS customers
    FROM olist.customers
    GROUP BY customer_state
    ORDER BY customers DESC)

SELECT
    customer_state,
    MAX(customers)
FROM ranked_states
GROUP BY customer_state;

WITH ranked_states AS (
    SELECT
        customer_state,
        COUNT(*)        AS customers
    FROM olist.customers
    GROUP BY customer_state
    ORDER BY customers DESC)

SELECT
    customer_state,
    MAX(customers)
FROM ranked_states;

SELECT
    customer_state,
    customer_city,
    COUNT(*)        AS customers
FROM customers
GROUP BY
    customer_state,
    customer_city;

-- Q.8

SELECT
    review_score,
    IF(review_score = 1, 'poor',
        IF(review_score = 2, 'meh',
            IF(review_score = 3, 'ok',
                IF(review_score = 4, 'good', 'excellent')))) AS review_descr
FROM order_reviews
LIMIT 1000;

SELECT
    review_score,
    CASE
        WHEN review_score = 1 THEN 'poor'
        WHEN review_score = 2 THEN 'meh'
        WHEN review_score = 3 THEN 'ok'
        WHEN review_score = 4 THEN 'good'
        WHEN review_score = 5 THEN 'excellent' -- ELSE 'excellent'
    END                                         AS review_descr
FROM order_reviews
LIMIT 1000;

SELECT
    review_score,
    CASE review_score
        WHEN 1 THEN 'poor'
        WHEN 2 THEN 'meh'
        WHEN 3 THEN 'ok'
        WHEN 4 THEN 'good'
        WHEN 5 THEN 'excellent' -- ELSE 'excellent'
    END                                         AS review_descr
FROM order_reviews
LIMIT 1000;