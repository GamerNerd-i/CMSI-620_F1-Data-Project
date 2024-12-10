-- Importing data from Kaggle Dataset:
-- https://www.kaggle.com/datasets/muhammadehsan02/formula-1-world-championship-history-1950-2024?select=Sprint_Race_Results.csv

-- Hard reset used for testing
DROP TABLE IF EXISTS
	circuits,
	constructor_performance
	constructors,
	driver_details,
	driver_rankings
	lap_times,
	pit_stops,
	qualifying_results,
	race_results
	race_schedule,
	season_summaries,
	sessions,
	sprint_results,
	status
CASCADE;

Creating tables
CREATE TABLE constructor_performance (
	raceId smallint,
	constructorId smallint,
	position smallint,
	points numeric,
	pointsTotal numeric,
	wins smallint,
	PRIMARY KEY (raceId, constructorId)
);

CREATE TABLE driver_details (
	driverId serial PRIMARY KEY,
	driverRef varchar,
	number smallint,
	code varchar,
	forename varchar,
	surname varchar,
	dob date,
	nationality varchar,
	url varchar
);

CREATE TABLE driver_rankings (
	raceId smallint,
	driverId smallint,
	points numeric,
	position smallint,
	wins smallint,
	PRIMARY KEY (raceId, driverId)
);

CREATE TABLE lap_times (
	raceId smallint,
	driverId smallint,
	lap smallint,
	position smallint,
	time interval,
	milliseconds integer,
	PRIMARY KEY (raceId, driverId, lap)
);

CREATE TABLE pit_stops (
	raceId smallint,
	driverId smallint,
	stop smallint,
	lap smallint,
	time interval,
	duration interval,
	milliseconds integer,
	PRIMARY KEY (raceId, driverId, stop, lap)
);

CREATE TABLE qualifying_results (
	raceId smallint,
	driverId smallint,
	constructorId smallint,
	number smallint,
	position smallint,
	q interval,
	qNumber smallint,
	PRIMARY KEY (raceId, driverId, constructorId, qNumber)
);

CREATE TABLE race_results (
	raceId smallint,
	driverId smallint,
	constructorId smallint,
	number smallint,
	grid smallint,
	position smallint,
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
	PRIMARY KEY (raceId, driverId, constructorId, number, statusId)
);

CREATE TABLE race_schedule (
	raceId serial PRIMARY KEY,
	year smallint,
	round smallint,
	circuitId smallint,
	name varchar,
	raceDate date,
	raceTime interval,
	url varchar
);

CREATE TABLE sessions (
	sessionId serial PRIMARY KEY,
	raceId smallint,
	sessonDate date,
	sessionTime interval,
	sessionType varchar
);

CREATE TABLE status (
	statusID serial PRIMARY KEY,
	status varchar
);

CREATE TABLE season_summaries (
	year smallint PRIMARY KEY,
	url varchar
);

CREATE TABLE sprint_results (
	raceId smallint,
	driverId smallint,
	constructorId smallint,
	number smallint,
	grid smallint,
	position smallint,
	positionOrder smallint,
	points smallint,
	laps smallint,
	time varchar,
	milliseconds integer,
	fastestLap smallint,
	fastestLapTime interval,
	statusId smallint,
	PRIMARY KEY (raceId, driverId)
);

CREATE TABLE constructors (
	constructorId serial PRIMARY KEY,
	constructorRef varchar,
	name varchar,
	nationality varchar,
	url varchar
);

CREATE TABLE circuits (
	circuitId serial PRIMARY KEY,
	circuitRef varchar,
	name varchar,
	location varchar,
	country varchar,
	lat numeric,
	lng numeric,
	alt smallint,
	url varchar
);