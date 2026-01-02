USE ecommerce_dw;
GO

-- Ensure the schema exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze_layer')
BEGIN
    EXEC('CREATE SCHEMA bronze_layer');
END
GO 

-- 1. Customers
CREATE TABLE bronze_layer.customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- 2. Orders
CREATE TABLE bronze_layer.orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- 3. Order Items
CREATE TABLE bronze_layer.order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2)
);

-- 4. Order Reviews (Handling Large Data)
CREATE TABLE bronze_layer.order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message VARCHAR(MAX), -- Handling the 'Max' requirement
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

-- 5. Products
DROP TABLE IF EXISTS bronze_layer.products;
CREATE TABLE bronze_layer.products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_length FLOAT,        
    product_description_length FLOAT,
    product_photos_qty FLOAT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);
-- 6. Order Payments
CREATE TABLE bronze_layer.order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10, 2)
);

-- 7. Sellers
CREATE TABLE bronze_layer.sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

-- 8. Geolocation
DROP TABLE IF EXISTS bronze_layer.geolocation;
CREATE TABLE bronze_layer.geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT, 
    geolocation_lng FLOAT, 
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);
GO

-- 9. Category Name Translation
CREATE TABLE bronze_layer.category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
Go
USE ecommerce_dw;
GO


