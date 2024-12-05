-- Importing data from Kaggle Dataset:
-- https://www.kaggle.com/datasets/muhammadehsan02/formula-1-world-championship-history-1950-2024?select=Sprint_Race_Results.csv

-- Hard reset used for testing
-- DROP TABLE IF EXISTS
-- 	constructor_performance,
-- 	constructor_rankings,
-- 	driver_details,
-- 	driver_rankings,
-- 	lap_timings,
-- 	pit_stop_records,
-- 	qualifying_results,
-- 	race_results,
-- 	race_schedule,
-- 	race_status,
-- 	season_summaries,
-- 	sprint_race_results,
-- 	team_details,
-- 	track_information
-- CASCADE;

-- Creating tables
CREATE TABLE constructor_performance (
	constructorResultsId serial,
	raceId smallint ,
	constructorId smallint,
	points numeric,
	status varchar,
    PRIMARY KEY (constructorResultsId)
);

CREATE TABLE constructor_rankings (source
	constructorStandingsId serial,
	raceId smallint,
	constructorId smallint,
	points numeric,
	position smallint,
	positionText varchar,
	wins smallint,
    PRIMARY KEY (constructorStandingsId)
);

CREATE TABLE driver_details (
	driverId serial,
	driverRef varchar,
	number smallint,
	code varchar,
	forename varchar,
	surname varchar,
	dob date,
	nationality varchar,
	url varchar,
    PRIMARY KEY (driverId)
);

CREATE TABLE driver_rankings (
	driverStandingsId serial,
	raceId smallint,
	driverId smallint,
	points numeric,
	position smallint,
	positionText varchar,
	wins smallint,
    PRIMARY KEY (driverStandingsId)
);

CREATE TABLE lap_timings (
	raceId serial,
	driverId smallint,
	lap smallint,
	position smallint,
	time interval,
	milliseconds integer,
    PRIMARY KEY (raceId, driverId)
);

CREATE TABLE pit_stop_records (
	raceId smallint,
	driverId smallint,
	stop smallint,
	lap smallint,
	time interval,
	duration interval,
	milliseconds integer,
    PRIMARY KEY (raceId, driverId)
);

CREATE TABLE qualifying_results (
	qualifyId serial,
	raceId smallint,
	driverId smallint,
	constructorId smallint,
	number smallint,
	position smallint,
	q1 interval,
	q2 interval,
	q3 interval,
    PRIMARY KEY (qualifyId)
);

CREATE TABLE race_results (
	resultId serial,
	raceId smallint,
	driverId smallint,
	constructorId smallint,
	number smallint,
	grid smallint,
	position smallint,
	positionText varchar,
	positionOrder smallint,
	points numeric,
	laps smallint,
	time interval,
	milliseconds integer,
	fastestLap smallint,
	rank smallint,
	fastestLapTime interval,
	fastestLapSpeed interval,
	statusId smallint,
);

CREATE TABLE race_schedule (
	raceId serial,
	year smallint,
	round smallint,
	circuitId smallint,
	name varchar,
	date date,
	time interval,
	url varchar,
	fp1_date date,
	fp1_time interval,
	fp2_date date,
	fp2_time interval,
	fp3_date date,
	fp3_time interval,
	quali_date date,
	quali_time interval,
	sprint_date date,
	sprint_time interval
);

CREATE TABLE race_status (
	statusID serial,
	status varchar
);

CREATE TABLE season_summaries (
	year smallint,
	url varchar
);

CREATE TABLE sprint_race_results (
	resultId serial,
	raceId smallint,
	driverId smallint,
	constructorId smallint,
	number smallint,
	grid smallint,
	position smallint,
	positionText varchar,
	positionOrder smallint,
	points smallint,
	laps smallint,
	time varchar,
	milliseconds integer,
	fastestLap smallint,
	fastestLapTime interval,
	statusId smallint
);

CREATE TABLE team_details (
	constructorId serial,
	constructorRef varchar,
	name varchar,
	nationality varchar,
	url varchar
);

CREATE TABLE track_information (
	circuitId serial,
	circuitRef varchar,
	name varchar,
	location varchar,
	country varchar,
	lat numeric,
	lng numeric,
	alt smallint,
	url varchar
);

-- Importing tables: failed due to permissions
-- COPY constructor_performance
-- 	FROM '/Users/aidan/Desktop/LMU/CS/Actual-Coursework/Grad_2024-2025/CMSI-620_Database-Systems/F1_Project/data/Constructor_Performance.csv'
-- 	DELIMITER ','
-- 	CSV HEADER;