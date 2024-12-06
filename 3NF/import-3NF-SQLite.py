import sqlite3
import pandas as pd

files = [
    "circuits",
    "constructor_performance",
    "constructors",
    "driver_details",
    "driver_rankings",
    "lap_times",
    "location_info",
    "pit_stops",
    "qualifying_results",
    "race_results",
    "race_schedule",
    "season_summaries",
    "sessions",
    "sprint_results",
    "status",
]

connection = sqlite3.connect("F1-3NF.db")

for file in files:
    # https://medium.com/aiadventures/how-to-run-sqlite-commands-using-python-e7a36aa961ed
    pd.read_csv(f'Data/{file + ".csv"}').to_sql(
        file.lower(), connection, if_exists="replace", index=False
    )
    connection.commit()

connection.close()
