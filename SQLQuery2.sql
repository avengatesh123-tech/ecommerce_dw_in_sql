USE ecommerce_dw;
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver_layer')
BEGIN
    EXEC('CREATE SCHEMA silver_layer');
END
GO
-- 1. Silver Customers 
SELECT 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    UPPER(TRIM(customer_city)) AS customer_city,
    UPPER(customer_state) AS customer_state
INTO silver_layer.customers
FROM bronze_layer.customers;

-- 2. Silver Orders 
SELECT 
    order_id,
    customer_id,
    order_status,
    CAST(order_purchase_timestamp AS DATETIME) AS order_purchase_timestamp,
    CAST(order_approved_at AS DATETIME) AS order_approved_at,
    CAST(order_delivered_carrier_date AS DATETIME) AS order_delivered_carrier_date,
    CAST(order_delivered_customer_date AS DATETIME) AS order_delivered_customer_date,
    CAST(order_estimated_delivery_date AS DATETIME) AS order_estimated_delivery_date
INTO silver_layer.orders
FROM bronze_layer.orders;

-- 3. Silver Order Items 
SELECT 
    order_id,
    order_item_id,
    product_id,
    seller_id,
    CAST(shipping_limit_date AS DATETIME) AS shipping_limit_date,
    CAST(price AS DECIMAL(10,2)) AS price,
    CAST(freight_value AS DECIMAL(10,2)) AS freight_value
INTO silver_layer.order_items
FROM bronze_layer.order_items;

-- 4. Silver Order Reviews
SELECT 
    review_id,
    order_id,
    review_score,
    ISNULL(review_comment_title, 'No Title') AS review_comment_title,
    ISNULL(review_comment_message, 'No Message') AS review_comment_message,
    CAST(review_creation_date AS DATETIME) AS review_creation_date,
    CAST(review_answer_timestamp AS DATETIME) AS review_answer_timestamp
INTO silver_layer.order_reviews
FROM bronze_layer.order_reviews;

-- 5. Silver Order Payments (Standardizing values)
SELECT 
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    CAST(payment_value AS DECIMAL(10,2)) AS payment_value
INTO silver_layer.order_payments
FROM bronze_layer.order_payments;
--6.product table
DROP TABLE IF EXISTS silver_layer.products;
SELECT 
    product_id,
    ISNULL(product_category_name, 'unknown') AS product_category_name,
    product_name_length,         
    product_description_length,  
    product_photos_qty,
    CAST(product_weight_g AS FLOAT) AS product_weight_g,
    CAST(product_length_cm AS FLOAT) AS product_length_cm,
    CAST(product_height_cm AS FLOAT) AS product_height_cm,
    CAST(product_width_cm AS FLOAT) AS product_width_cm
INTO silver_layer.products
FROM bronze_layer.products;
GO

-- 7. Silver Sellers 
SELECT 
    seller_id,
    seller_zip_code_prefix,
    UPPER(TRIM(seller_city)) AS seller_city,
    UPPER(seller_state) AS seller_state
INTO silver_layer.sellers
FROM bronze_layer.sellers;

-- 8. Silver Geolocation 
WITH UniqueGeo AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY geolocation_zip_code_prefix ORDER BY geolocation_zip_code_prefix) as row_num
    FROM bronze_layer.geolocation
)
SELECT 
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    UPPER(TRIM(geolocation_city)) AS geolocation_city,
    UPPER(geolocation_state) AS geolocation_state
INTO silver_layer.geolocation
FROM UniqueGeo
WHERE row_num = 1;

-- 9. Silver Category Translation
DROP TABLE IF EXISTS silver_layer.category_translation;

SELECT 
    product_category_name,
    product_category_name_english
INTO silver_layer.category_translation
FROM bronze_layer.category_translation;
GO

select * from silver_layer.category_translation;