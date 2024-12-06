import sqlite3
import pandas as pd
import time


connection = sqlite3.connect("F1-Base.db")

# https://stackoverflow.com/questions/54289555/how-do-i-execute-an-sqlite-script-from-within-python
with open(
    "./base_queries_part2.sql",
    "r",
) as sql_file:
    queries = sql_file.read()

cursor = connection.cursor()
query_times = {}

for query in queries.split("\n\n"):
    start_time = time.time()
    cursor.execute(query)
    print(cursor.fetchall())
    end_time = time.time()

    query_times[query[: query.find("\n")]] = end_time - start_time

connection.close()

for query in query_times:
    print(f"{query}: {query_times[query]}")
