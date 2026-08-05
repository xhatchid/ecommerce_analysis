-- Olist Late Delivery & Review Score Analysis
-- Schema for the core tables needed to answer:
-- "Which product categories and regions drive the most late deliveries,
--  and how does that relate to customer review scores?"

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id                       TEXT PRIMARY KEY,
    customer_id                    TEXT NOT NULL,
    order_status                   TEXT,
    order_purchase_timestamp       TEXT,
    order_approved_at              TEXT,
    order_delivered_carrier_date   TEXT,
    order_delivered_customer_date  TEXT,
    order_estimated_delivery_date  TEXT
);

DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_id            TEXT NOT NULL,
    order_item_id        INTEGER,
    product_id           TEXT NOT NULL,
    seller_id            TEXT,
    shipping_limit_date  TEXT,
    price                REAL,
    freight_value        REAL
);

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id              TEXT PRIMARY KEY,
    customer_unique_id       TEXT,
    customer_zip_code_prefix TEXT,
    customer_city            TEXT,
    customer_state           TEXT
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id               TEXT PRIMARY KEY,
    product_category_name    TEXT,
    product_name_lenght      REAL,
    product_description_lenght REAL,
    product_photos_qty       REAL,
    product_weight_g         REAL,
    product_length_cm        REAL,
    product_height_cm        REAL,
    product_width_cm         REAL
);

DROP TABLE IF EXISTS order_reviews;
CREATE TABLE order_reviews (
    review_id             TEXT,
    order_id              TEXT NOT NULL,
    review_score          INTEGER,
    review_comment_title  TEXT,
    review_comment_message TEXT,
    review_creation_date  TEXT,
    review_answer_timestamp TEXT
);

DROP TABLE IF EXISTS category_translation;
CREATE TABLE category_translation (
    product_category_name          TEXT PRIMARY KEY,
    product_category_name_english  TEXT
);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_reviews_order_id ON order_reviews(order_id);
