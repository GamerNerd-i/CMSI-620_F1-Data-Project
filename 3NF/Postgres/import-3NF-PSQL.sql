-- -- Importing data from Kaggle Dataset:
-- -- https://www.kaggle.com/datasets/muhammadehsan02/formula-1-world-championship-history-1950-2024?select=Sprint_Race_Results.csv

-- -- Hard reset used for testing
DROP TABLE IF EXISTS
	third.circuits,
	third.constructor_performance,
	third.constructors,
	third.driver_details,
	third.driver_rankings,
	third.lap_times,
	third.pit_stops,
	third.qualifying_results,
	third.race_results,
	third.race_schedule,
	third.season_summaries,
	third.sessions,
	third.sprint_results,
	third.status
CASCADE;

-- -- Creating tables
CREATE TABLE third.constructor_performance (
	raceId smallint,
	constructorId smallint,
	position smallint,
	points numeric,
	pointsTotal numeric,
	wins smallint,
	PRIMARY KEY (raceId, constructorId)
);

CREATE TABLE third.driver_details (
	driverId smallint PRIMARY KEY,
	driverRef varchar,
	number smallint,
	code varchar,
	forename varchar,
	surname varchar,
	dob date,
	nationality varchar,
	url varchar
);

CREATE TABLE third.driver_rankings (
	raceId smallint,
	driverId smallint,
	pointsTotal numeric,
	currentPosition smallint,
	totalWins smallint,
	PRIMARY KEY (raceId, driverId)
);

CREATE TABLE third.lap_times (
	raceId smallint,
	driverId smallint,
	lap smallint,
	position smallint,
	time interval,
	milliseconds integer,
	PRIMARY KEY (raceId, driverId, lap)
);

CREATE TABLE third.pit_stops (
	raceId smallint,
	driverId smallint,
	stop smallint,
	lap smallint,
	time interval,
	duration interval,
	milliseconds integer,
	PRIMARY KEY (raceId, driverId, stop, lap)
);

CREATE TABLE third.qualifying_results (
	raceId smallint,
	driverId smallint,
	qNumber smallint,
	q interval,
	PRIMARY KEY (raceId, driverId, qNumber)
);

CREATE TABLE third.race_results (
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
	PRIMARY KEY (raceId, driverId, constructorId, grid, statusId)
);

CREATE TABLE third.race_schedule (
	raceId smallint PRIMARY KEY,
    circuitId smallint,
	round smallint,
	name varchar,
	raceDate date,
	raceTime interval,
	url varchar
);

CREATE TABLE third.sessions (
	sessionId smallint PRIMARY KEY,
	raceId smallint,
	sessonDate date,
	sessionTime interval,
	sessionType varchar
);

CREATE TABLE third.status (
	statusID smallint PRIMARY KEY,
	status varchar
);

CREATE TABLE third.season_summaries (
	year smallint PRIMARY KEY,
	url varchar
);

CREATE TABLE third.sprint_results (
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

CREATE TABLE third.constructors (
	constructorId smallint PRIMARY KEY,
	constructorRef varchar,
	name varchar,
	nationality varchar,
	url varchar
);

CREATE TABLE third.circuits (
	circuitId smallint PRIMARY KEY,
	name varchar,
	location varchar,
	lat numeric,
	lng numeric,
	alt smallint,
	url varchar
);

CREATE TABLE third.locations (
	location varchar,
	country varchar,
	PRIMARY KEY (location, country)
);
