import sqlite3
import pandas as pd

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

connection = sqlite3.connect("F1-Base.db")

for file in files:
    # https://medium.com/aiadventures/how-to-run-sqlite-commands-using-python-e7a36aa961ed
    pd.read_csv(f'Data/{file + ".csv"}').to_sql(
        file.lower(), connection, if_exists="replace", index=False
    )

connection.close()
