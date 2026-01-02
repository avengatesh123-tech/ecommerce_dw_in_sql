# 🛒 E-Commerce Data Warehouse

## 🔹 Snowflake Schema Implementation using Medallion Architecture

---

## 📌 Executive Summary

This project showcases an **end-to-end SQL Data Warehouse** built on top of raw e-commerce data using a **Medallion Architecture (Bronze–Silver–Gold)**.
The final **Gold layer** is modeled using a **Snowflake Schema**, enabling scalable, normalized, and high-performance analytical reporting.

This repository is designed to be **recruiter-friendly**, **interview-ready**, and **easy to understand for business stakeholders**.

---

## 🏗️ Data Pipeline Architecture

🔹 **Bronze Layer (Raw)**

* Direct ingestion of source CSV files into SQL tables
* No transformations applied
* Preserves original source data for traceability

🔹 **Silver Layer (Cleaned & Standardized)**

* Data type conversions (dates, numeric values)
* Text standardization (UPPER, TRIM)
* Null handling and deduplication
* Referential consistency preparation

🔹 **Gold Layer (Business-Ready)**

* Fact and Dimension tables
* Snowflake Schema modeling
* Optimized for BI and analytics

---

## ❄️ Data Model – Snowflake Schema

The **Gold Layer** uses a **Snowflake Schema**, where dimensions are further normalized to reduce redundancy.

### 📊 Fact Table

* **fact_sales_snowflake**

  * Metrics: `price`, `freight_value`, `review_score`, `revenue`

### 🧍 Customer Hierarchy

* `dim_customers_snowflake`
* `dim_location`

### 📦 Product Hierarchy

* `dim_products_snowflake`
* `dim_category`

### 🏪 Seller Dimension

* `dim_sellers`

---

## 🚀 Installation & Usage

### 1️⃣ Database Initialization

```sql
CREATE DATABASE ecommerce_dw;
GO
USE ecommerce_dw;

CREATE SCHEMA bronze_layer;
CREATE SCHEMA silver_layer;
CREATE SCHEMA gold_layer;
```

---

### 2️⃣ Transformation Workflow

1. Load raw CSV data into **Bronze Layer** tables
2. Execute Silver layer scripts for cleaning and standardization
3. Run Gold layer scripts to create Fact & Dimension tables
4. Apply **Primary Keys** and **Foreign Keys** to enforce data integrity

---

### 3️⃣ Reporting & Visualization

📈 Connect **Power BI Desktop** to the `gold_layer` tables

⚠️ **Note:** If SSL or certificate issues occur, enable **"Trust Server Certificate"** in Power BI connection settings.

---

## 🛠️ Technology Stack

* 🗄️ **Database:** Microsoft SQL Server (SQL Express)
* 🧰 **IDE:** SQL Server Management Studio (SSMS)
* 🧱 **Architecture:** Medallion (Bronze–Silver–Gold)
* ❄️ **Data Modeling:** Snowflake Schema
* 📊 **BI Tool:** Power BI

---

## 🏆 Key Achievements

✅ Implemented a scalable **3-layer Medallion Architecture**
✅ Designed a fully normalized **Snowflake Schema**
✅ Reduced data redundancy through dimension normalization
✅ Ensured data quality using SQL transformations
✅ Built BI-ready tables for enterprise reporting

---

## 📈 Business Use Cases Enabled

* Customer purchasing behavior analysis
* Seller performance by region
* Product category revenue insights
* Delivery time and logistics analysis
* Payment and review-based performance tracking

---

## 📬 Contact

👤 **Vengatesh**
🎯 Aspiring Data Engineer
---
⭐ *If you found this project useful, consider giving it a star!*
