"""
Loads the raw Olist CSVs into a local SQLite database using the schema
defined in sql/01_schema.sql.

Run from the project root:
    python python/01_load_data.py
"""
import sqlite3
from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
DB_PATH = ROOT / "data" / "olist.db"
SCHEMA_PATH = ROOT / "sql" / "01_schema.sql"

TABLE_FILES = {
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "products": "olist_products_dataset.csv",
    "order_reviews": "olist_order_reviews_dataset.csv",
    "category_translation": "product_category_name_translation.csv",
}


def main():
    conn = sqlite3.connect(DB_PATH)

    # Build the schema fresh each run
    with open(SCHEMA_PATH, "r") as f:
        conn.executescript(f.read())

    for table, filename in TABLE_FILES.items():
        csv_path = RAW / filename
        df = pd.read_csv(csv_path)
        df.to_sql(table, conn, if_exists="append", index=False)
        print(f"Loaded {len(df):,} rows into '{table}' from {filename}")

    conn.commit()
    conn.close()
    print(f"\nDatabase ready at: {DB_PATH}")


if __name__ == "__main__":
    main()
