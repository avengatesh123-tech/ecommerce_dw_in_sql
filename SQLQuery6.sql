USE ecommerce_dw;
GO

-- 1. Dim_Location 
SELECT DISTINCT 
    customer_zip_code_prefix AS zip_code,
    customer_city AS city,
    customer_state AS stater
INTO gold_layer.dim_location
FROM silver_layer.customers;

-- 2. Dim_Category 
SELECT DISTINCT 
    product_category_name,
    product_category_name_english AS category_name_en
INTO gold_layer.dim_category
FROM silver_layer.category_translation;

-- 3. Snowflake Dim_Products 
SELECT 
    product_id,
    product_category_name, 
    product_weight_g,
    product_length_cm
INTO gold_layer.dim_products_snowflake
FROM silver_layer.products;

-- 4. Snowflake Dim_Customers 
SELECT 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix 
INTO gold_layer.dim_customers_snowflake
FROM silver_layer.customers;
GO

SELECT 
    oi.order_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    r.review_score
INTO gold_layer.fact_sales_snowflake
FROM silver_layer.order_items oi
JOIN silver_layer.orders o ON oi.order_id = o.order_id
LEFT JOIN silver_layer.order_reviews r ON o.order_id = r.order_id;
GO

select * from gold_layer.fact_sales_snowflake;


