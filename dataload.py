import pandas as pd
from sqlalchemy import create_engine
import urllib

# 1. UPDATED CONNECTION STRING (Use Driver 17 or 18)
# Driver name-ai 'ODBC Driver 17 for SQL Server' endru maatriyullan
params = urllib.parse.quote_plus(
    r'DRIVER={ODBC Driver 17 for SQL Server};'
    r'SERVER=DESKTOP-F3JAJ5J\SQLEXPRESS;'
    r'DATABASE=ecommerce_dw;'
    r'Trusted_Connection=yes;'
)

# SQLAlchemy engine setup
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# 2. Dataset Paths
datasets = {
    "customers": r"C:\olist_customers_dataset.csv",
    "orders": r"C:\olist_orders_dataset.csv",
    "order_items": r"C:\olist_order_items_dataset.csv",
    "order_reviews": r"C:\olist_order_reviews_dataset.csv",
    "products": r"C:\olist_products_dataset.csv",
    "order_payments": r"C:\olist_order_payments_dataset.csv",
    "sellers": r"C:\olist_sellers_dataset.csv",
    "geolocation": r"C:\olist_geolocation_dataset.csv",
    "category_translation": r"C:\product_category_name_translation.csv"
}

# 3. Loading Process
for table, path in datasets.items():
    try:
        print(f"Loading {table}...")
        df = pd.read_csv(path, encoding='utf-8', low_memory=False)
        
        # Column names-ai snake_case-kku maatra (Industry standard)
        df.columns = [c.lower().replace(' ', '_') for c in df.columns]
        
        # SQL-il ulla bronze_layer schema-vukku anuppurom
        # Schema name 'bronze_layer' neenga munnadi create panniyathu
        df.to_sql(table, con=engine, schema='bronze_layer', if_exists='append', index=False)
        print(f"Successfully loaded {table}!")
    except Exception as e:
        print(f"Error loading {table}: {e}")

print("\n--- Process Finished ---")