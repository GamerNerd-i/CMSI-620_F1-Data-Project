# CMSI-620_F1-Data-Project

The final group project for CMSI 620: Database Systems in Fall 2024 at Loyola Marymount University, taught by Basil Latif.

The experiment uses a Formula 1 dataset from Kaggle and creates 3 extra versions for testing: an un-normalized "gigatable" form, the 2nd normal form (2NF), and the 3rd normal form (3NF).

We create two categories of queries: a set of "basic" queries that are conceptually simple and might resemble a Google search, and a set of "advanced" queries that are more specific and would be expected of someone with database experience doing more in-depth research on the set.

The same set of queries (as close as possible to each other, given different table structure) is run on all 4 versions of the data to examine the impact of normalization on those queries. We also attempted to run the queries and data in 3 different database management systems: SQLite, Postgres, and MySQL, although due to technical difficulties the data for MySQL is incomplete (and therefore not reflected in the final presentation).

## Other Materials

The code makes up most of the project, but not all of it. We used [a Google Sheet](https://docs.google.com/spreadsheets/d/1ODNOC4qguzQf-Sk7NjE3C9pe4lkVk0uEOOkjACkada8/edit?usp=sharing) to track our data and create the charts seen in [the final presentation (Google Slides)](https://docs.google.com/presentation/d/1aAzv-GwLb6kOc3Acq4nzCUgqELCVvBfQESvaHmgAszc/edit?usp=sharing).

## Dataset Attribution

This project uses the [Formula 1 World Championship History (1950-2024)](https://www.kaggle.com/datasets/muhammadehsan02/formula-1-world-championship-history-1950-2024?select=Sprint_Race_Results.csv) dataset from [Kaggle](https://www.kaggle.com).
