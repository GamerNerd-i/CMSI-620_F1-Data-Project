ATTACH DATABASE "/Users/aidan/Desktop/LMU/CS/Actual-Coursework/Grad_2024-2025/CMSI-620_Database-Systems/CMSI-620_F1-Data-Project/2NF+Merged/F1-2NF.db"
    AS "original";

CREATE TABLE race_info AS
SELECT * FROM
	original.race_schedule
	NATURAL LEFT JOIN original.season_summaries
	NATURAL LEFT JOIN original.circuits;

CREATE TABLE driver_info AS
SELECT * FROM
	original.driver_rankings
	NATURAL LEFT JOIN original.driver_details;

CREATE TABLE constructor_info AS
SELECT * FROM
	original.constructor_performance
	NATURAL LEFT JOIN original.constructors;

CREATE TABLE race_results AS
SELECT * FROM
	original.race_results
	NATURAL LEFT JOIN original.status;

CREATE TABLE sprint_results AS
SELECT * FROM
	original.race_results
	NATURAL LEFT JOIN original.status;

CREATE TABLE lap_times AS
SELECT * FROM
	original.lap_times
	NATURAL LEFT JOIN race_info;

DETACH DATABASE "original";