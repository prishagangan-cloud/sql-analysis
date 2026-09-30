import pandas as pd
import sqlite3

df = pd.read_csv("emissions.csv")
df.columns = ["naics_code", "naics_title", "ghg", "unit",
              "ef_without_margins", "margins", "ef_with_margins", "useeio_code"]
df = df.drop(columns=["ghg", "unit"])
df["sector_code"] = df["naics_code"].astype(str).str[:2]

conn = sqlite3.connect("analysis.db")
df.to_sql("emissions", conn, if_exists="replace", index=False)
conn.close()
print("Loaded", len(df), "rows")