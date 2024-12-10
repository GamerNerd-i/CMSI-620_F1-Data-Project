from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine
import os

load_dotenv()

# username = os.getenv("name")
password = os.getenv("password")
database = os.getenv("db_name")

if not username or not password or not database:
    raise ValueError("Missing database credentials. Check your .env file.")

engine = create_engine(f"mysql+pymysql://ElScarab:{password}@localhost/{database}")

files = [
    "Constructor_Performance",
    "Constructor_Rankings",
    "Driver_Details",
    "Driver_Rankings",
    "Lap_Timings",
    "Pit_Stop_Records",
    "Qualifying_Results",
    "Race_Results",
    "Race_Schedule",
    "Race_Status",
    "Season_Summaries",
    "Sprint_Race_Results",
    "Team_Details",
    "Track_Information",
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
