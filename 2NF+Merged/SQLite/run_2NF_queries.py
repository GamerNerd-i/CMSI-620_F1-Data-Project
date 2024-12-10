import sqlite3
import pandas as pd
import time

REPEAT = 1000

connection = sqlite3.connect("./F1-2NF.db")

# https://stackoverflow.com/questions/54289555/how-do-i-execute-an-sqlite-script-from-within-python
with open(
    "./Queries/2NF_Queries.sql",
    "r",
) as sql_file:
    queries = sql_file.read()

cursor = connection.cursor()
query_times = {}

for query in queries.split("\n\n"):
    runs = []
    for i in range(REPEAT):
        start_time = time.time()
        cursor.executescript(query)
        # print(cursor.fetchall())
        end_time = time.time()

        runs.append(end_time - start_time)

    query_times[query[: query.find("\n")]] = sum(runs) / REPEAT

connection.close()

for query in query_times:
    print(f"{query}: {query_times[query]}")
