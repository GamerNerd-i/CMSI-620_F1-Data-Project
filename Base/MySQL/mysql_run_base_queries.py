# from dotenv import load_dotenv
# import pandas as pd
# from sqlalchemy import create_engine
# import os

# REPEAT = 1000

# load_dotenv()

# # username = os.getenv("name")
# password = os.getenv("password")
# database = os.getenv("db_name")

# if not password or not database:
#     raise ValueError("Missing database credentials. Check your .env file.")

# engine = create_engine(f"mysql+pymysql://ElScarab:{password}@localhost/{database}")

# # https://stackoverflow.com/questions/54289555/how-do-i-execute-an-sqlite-script-from-within-python
# with open(
#     "./Base_Queries.sql",
#     "r",
# ) as sql_file:
#     queries = sql_file.read()

# # cursor = connection.cursor()
# query_times = {}

# for query in queries.split("\n\n"):
#     runs = []
#     for i in range(REPEAT):
#         start_time = time.time()
#         cursor.executescript(query)
#         # print(cursor.fetchall())
#         end_time = time.time()

#         runs.append(end_time - start_time)

#     query_times[query[: query.find("\n")]] = sum(runs)  # * 1000 / REPEAT

# connection.close()

# for query in query_times:
#     print(f"{query}: {query_times[query]}")

from dotenv import load_dotenv
import time
import os
from sqlalchemy import create_engine, text

# Number of times to repeat each query for performance testing
REPEAT = 1

load_dotenv()

password = os.getenv("password")
database = os.getenv("db_name")

if not password or not database:
    raise ValueError("Missing database credentials. Check your .env file.")

engine = create_engine(f"mysql+pymysql://ElScarab:{password}@localhost/{database}")

# Read SQL queries from file
with open("./Updated_Base_Queries_MySQL.sql", "r") as sql_file:
    queries = sql_file.read()

# Dictionary to store execution times for each query
query_times = {}

# Execute each query multiple times and measure execution time
for query in queries.split("\n\n"):  # Assumes queries are separated by double newlines
    query = query.strip()
    if not query:  # Skip empty queries
        continue

    runs = []
    for _ in range(REPEAT):
        with engine.connect() as connection:
            start_time = time.time()

            try:
                connection.execute(
                    text(query)
                )  # Use SQLAlchemy's `text` to execute raw queries
            except Exception as e:
                print(f"Error executing query: {query[:50]}... Error: {e}")
                break

            end_time = time.time()
            runs.append(end_time - start_time)

    # Store the average execution time for this query
    if runs:
        query_times[query[: query.find("\n")]] = sum(runs) / REPEAT

# Output query execution times
for query, avg_time in query_times.items():
    print(f"{query}: {avg_time:.6f} seconds")
