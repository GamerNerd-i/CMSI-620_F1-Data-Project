from dotenv import load_dotenv
import time
import os
from sqlalchemy import create_engine, text

REPEAT = 1000

load_dotenv()

password = os.getenv("password")
database = os.getenv("db_name")

if not password or not database:
    raise ValueError("Missing database credentials. Check your .env file.")

engine = create_engine(f"mysql+pymysql://ElScarab:{password}@localhost/{database}")

with open("./Updated_Base_Queries_MySQL.sql", "r") as sql_file:
    queries = sql_file.read()

query_times = {}

for query in queries.split("\n\n"):
    print(f"Executing query: {query} \n")
    query = query.strip()
    if not query:
        continue

    runs = []
    for _ in range(REPEAT):

        with engine.connect() as connection:
            start_time = time.time()

            try:
                connection.execute(text(query))
            except Exception as e:
                print(f"Error executing query: {query[:50]}... Error: {e}")
                break

            end_time = time.time()
            runs.append(end_time - start_time)

    if runs:
        query_times[query[: query.find("\n")]] = sum(runs) / REPEAT

for query, avg_time in query_times.items():
    print(f"\n\n{query}: {avg_time:.6f} seconds")
