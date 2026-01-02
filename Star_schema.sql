USE ecommerce_dw;
GO

-- 1. Dimension: Customers
SELECT 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
INTO gold_layer.dim_customers
FROM silver_layer.customers;

-- 2. Dimension: Products
SELECT 
    p.product_id,
    ct.product_category_name_english AS category_name,
    p.product_weight_g,
    p.product_length_cm
INTO gold_layer.dim_products
FROM silver_layer.products p
LEFT JOIN silver_layer.category_translation ct 
    ON p.product_category_name = ct.product_category_name;

-- 3. Dimension: Sellers
SELECT 
    seller_id,
    seller_city,
    seller_state
INTO gold_layer.dim_sellers
FROM silver_layer.sellers;
GO

-- 4. Fact: Sales
SELECT 
    oi.order_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    o.order_purchase_timestamp,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_value,
    r.review_score
INTO gold_layer.fact_sales_star
FROM silver_layer.order_items oi
JOIN silver_layer.orders o ON oi.order_id = o.order_id
LEFT JOIN silver_layer.order_reviews r ON o.order_id = r.order_id;
GO

select * from gold_layer.fact_sales_star;
