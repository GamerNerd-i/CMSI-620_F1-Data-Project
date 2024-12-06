import sqlite3
import pandas as pd

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

connection = sqlite3.connect("F1-2NF.db")

for file in files:
    # https://medium.com/aiadventures/how-to-run-sqlite-commands-using-python-e7a36aa961ed
    pd.read_csv(f'Data/{file + ".csv"}').to_sql(
        file.lower(), connection, if_exists="replace", index=False
    )

connection.commit()

# https://stackoverflow.com/questions/54289555/how-do-i-execute-an-sqlite-script-from-within-python
with open(
    "/Users/aidan/Desktop/LMU/CS/Actual-Coursework/Grad_2024-2025/CMSI-620_Database-Systems/CMSI-620_F1-Data-Project/2NF+Merged/SQL-Scripts/column-renaming.sql",
    "r",
) as sql_file:
    renaming = sql_file.read()

cursor = connection.cursor()
cursor.executescript(renaming)
connection.commit()

connection.close()
