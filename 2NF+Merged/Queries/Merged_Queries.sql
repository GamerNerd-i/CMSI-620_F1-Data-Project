-- BASIC QUERIES

-- Which F1 driver has the most first-place races?
SELECT forename || ' ' || surname as driverName, COUNT(position) as first_places
FROM driver_info 
WHERE position = 1 
GROUP BY driverId
ORDER BY COUNT(position) DESC
LIMIT 1;

-- Which F1 driver has the most podiums (1st, 2nd, 3rd)?
SELECT forename || ' ' || surname as driverName, COUNT(position) as first_places
FROM driver_info 
WHERE position <= 3
GROUP BY driverId
ORDER BY COUNT(position) DESC
LIMIT 1;

-- Which circuit has held the most races?
select circuitName, count(circuitId) as num_of_races
from race_info
group by circuitName
order by num_of_races desc;

-- How many drivers are named Jim?
SELECT count(*)
FROM (
    SELECT DISTINCT forename, surname from driver_info where forename = "Jim"
    );

-- ADVANCED QUERIES

-- What's the fastest lap time of each driver?
SELECT drivers.forename || ' ' || drivers.surname as driverName, lap_times.time
FROM lap_times 
LEFT JOIN (
    SELECT DISTINCT driverId, forename, surname
    FROM driver_info
) AS drivers ON drivers.driverId = lap_times.driverId 
GROUP BY lap_times.driverId
ORDER BY MIN(lap_times.milliseconds) ASC;

-- For each driver, find the constructor they have driven for most.
CREATE TEMPORARY TABLE most_common_team AS
SELECT driverId, constructorId
FROM (
    SELECT 
        driverId,
        constructorId,
        COUNT(*) AS team_count,
        RANK() OVER (PARTITION BY driverId ORDER BY COUNT(*) DESC) AS rank
    FROM race_results
    GROUP BY driverId, constructorId
) ranked_teams
WHERE rank = 1;
SELECT drivers.forename || ' ' || drivers.surname as driverName, teams.name as teamName
FROM most_common_team
LEFT JOIN (
    SELECT DISTINCT driverId, forename, surname
    FROM driver_info
) AS drivers ON drivers.driverId = most_common_team.driverId 
LEFT JOIN (
    SELECT DISTINCT constructorId, name
    FROM constructor_info
) AS teams ON teams.constructorId = most_common_team.constructorId;
DROP TABLE most_common_team;

-- On which circuit have the most fatalities occurred during a race?
SELECT circuitName, location, country, count(statusId) as fatalities
FROM full_race_results
WHERE statusId = 104
GROUP BY circuitName, location, country
ORDER BY fatalities DESC;