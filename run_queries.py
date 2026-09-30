import os
import sqlite3
import pandas as pd

os.makedirs("results", exist_ok=True)
conn = sqlite3.connect("analysis.db")

sql = open("queries.sql").read()
queries = [q.strip() for q in sql.split(";") if q.strip()]

for i, q in enumerate(queries, 1):
    df = pd.read_sql(q, conn)
    print(f"\n--- Query {i} ({len(df)} rows) ---")
    print(df.head(10).to_string(index=False))
    df.to_csv(f"results/query_{i}.csv", index=False)

conn.close()