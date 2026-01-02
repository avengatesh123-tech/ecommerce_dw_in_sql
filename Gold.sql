USE ecommerce_dw;
GO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold_layer')
BEGIN
    EXEC('CREATE SCHEMA gold_layer');
END
GO
USE ecommerce_dw;
GO
DROP TABLE IF EXISTS gold_layer.fact_sales;
SELECT 
    -- 1. Order Details
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    
    -- 2. Customer Details
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    
    -- 3. Product Details
    p.product_id,
    ct.product_category_name_english AS category_name,
    
    -- 4. Sales Details (Price + Freight = Total Value)
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value) AS total_order_value,
    
    -- 5. Review Details
    r.review_score,
    
    -- 6. Seller Details
    s.seller_city,
    s.seller_state

INTO gold_layer.fact_sales
FROM silver_layer.orders o
JOIN silver_layer.customers c ON o.customer_id = c.customer_id
JOIN silver_layer.order_items oi ON o.order_id = oi.order_id
JOIN silver_layer.products p ON oi.product_id = p.product_id
JOIN silver_layer.sellers s ON oi.seller_id = s.seller_id
LEFT JOIN silver_layer.category_translation ct ON p.product_category_name = ct.product_category_name
LEFT JOIN silver_layer.order_reviews r ON o.order_id = r.order_id;
GO
select * from gold_layer.fact_sales;
