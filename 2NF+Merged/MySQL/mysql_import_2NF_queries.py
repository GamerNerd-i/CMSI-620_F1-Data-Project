from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine
import os

load_dotenv()

# username = os.getenv("name")
password = os.getenv("password")
database = os.getenv("db_name2")

if not password or not database:
    raise ValueError("Missing database credentials. Check your .env file.")

engine = create_engine(f"mysql+pymysql://ElScarab:{password}@localhost/{database}")

files = [
    "circuits",
    "constructor_performance",
    "constructors",
    "driver_details",
    "driver_rankings",
    "lap_times",
    "pit_stops",
    "qualifying_results",
    "race_results",
    "race_schedule",
    "season_summaries",
    "sessions",
    "sprint_results",
    "status",
]

for file in files:
    csv_path = f"Data/{file}.csv"
    if not os.path.exists(csv_path):
        print(f"File not found: {csv_path}. Skipping...")
        continue

    try:
        df = pd.read_csv(csv_path)
        print(f"Importing {file} into database...")

        df.to_sql(file.lower(), engine, if_exists="replace", index=False)
        print(f"Successfully imported {file}.")
    except Exception as e:
        print(f"Failed to import {file}. Error: {e}")
