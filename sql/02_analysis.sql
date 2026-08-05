-- =============================================================
-- Business question: Which product categories and regions drive
-- the most late deliveries, and how does that relate to review scores?
-- =============================================================

-- 1) Build one flat, order-item-level table joining everything we need,
--    with a late-delivery flag calculated from actual vs estimated dates.
DROP VIEW IF EXISTS order_delivery_facts;
CREATE VIEW order_delivery_facts AS
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    c.customer_state,
    p.product_category_name,
    COALESCE(ct.product_category_name_english, p.product_category_name, 'uncategorized') AS category_english,
    r.review_score,
    CASE
        WHEN o.order_status = 'delivered'
             AND julianday(o.order_delivered_customer_date) > julianday(o.order_estimated_delivery_date)
        THEN 1 ELSE 0
    END AS is_late
FROM orders o
JOIN order_items oi        ON oi.order_id = o.order_id
JOIN products p             ON p.product_id = oi.product_id
JOIN customers c            ON c.customer_id = o.customer_id
LEFT JOIN category_translation ct ON ct.product_category_name = p.product_category_name
LEFT JOIN order_reviews r   ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;

-- 2) Late delivery rate + average review score, by product category
DROP VIEW IF EXISTS late_rate_by_category;
CREATE VIEW late_rate_by_category AS
SELECT
    category_english,
    COUNT(DISTINCT order_id)                          AS total_orders,
    SUM(is_late)                                        AS late_orders,
    ROUND(100.0 * SUM(is_late) / COUNT(DISTINCT order_id), 2) AS late_pct,
    ROUND(AVG(review_score), 2)                         AS avg_review_score
FROM order_delivery_facts
GROUP BY category_english
HAVING COUNT(DISTINCT order_id) >= 30   -- drop tiny categories, keep it statistically meaningful
ORDER BY late_pct DESC;

-- 3) Late delivery rate + average review score, by customer state (region)
DROP VIEW IF EXISTS late_rate_by_state;
CREATE VIEW late_rate_by_state AS
SELECT
    customer_state,
    COUNT(DISTINCT order_id)                          AS total_orders,
    SUM(is_late)                                        AS late_orders,
    ROUND(100.0 * SUM(is_late) / COUNT(DISTINCT order_id), 2) AS late_pct,
    ROUND(AVG(review_score), 2)                         AS avg_review_score
FROM order_delivery_facts
GROUP BY customer_state
ORDER BY late_pct DESC;

-- 4) The headline relationship: average review score, late vs on-time
DROP VIEW IF EXISTS review_score_by_lateness;
CREATE VIEW review_score_by_lateness AS
SELECT
    CASE WHEN is_late = 1 THEN 'Late' ELSE 'On time' END AS delivery_status,
    COUNT(DISTINCT order_id)      AS total_orders,
    ROUND(AVG(review_score), 2)   AS avg_review_score
FROM order_delivery_facts
GROUP BY is_late;

-- Quick sanity peeks (comment out when just building the views)
-- SELECT * FROM late_rate_by_category LIMIT 15;
-- SELECT * FROM late_rate_by_state LIMIT 15;
-- SELECT * FROM review_score_by_lateness;
