-- BASIC QUERIES

-- Which F1 driver has the most first-place races?
SELECT driver_details.forename || ' ' || driver_details.surname as driverName, COUNT(driver_rankings.position) as first_places
FROM driver_rankings 
LEFT JOIN driver_details ON driver_details.driverId = driver_rankings.driverId 
WHERE position = 1 
GROUP BY driver_rankings.driverId
ORDER BY COUNT(driver_rankings.position) DESC
LIMIT 1;

-- Which F1 driver has the most podiums (1st, 2nd, 3rd)?
SELECT driver_details.forename || ' ' || driver_details.surname as driverName, COUNT(driver_rankings.position) as first_places
FROM driver_rankings 
LEFT JOIN driver_details ON driver_details.driverId = driver_rankings.driverId 
WHERE position <= 3
GROUP BY driver_rankings.driverId
ORDER BY COUNT(driver_rankings.position) DESC
LIMIT 1;

-- Which circuit has held the most races?
select ti.name, count(circuitId) as num_of_races from track_information as ti
join race_schedule using(circuitId)
group by ti.name
order by num_of_races desc;

-- How many drivers are named Jim?
select count(*) from driver_details where forename = 'Jim';

-- ADVANCED QUERIES

-- What's the fastest lap time of each driver?
SELECT driver_details.forename || ' ' || driver_details.surname as driverName, lap_timings.time
FROM lap_timings 
LEFT JOIN driver_details ON driver_details.driverId = lap_timings.driverId 
GROUP BY lap_timings.driverId
ORDER BY MIN(lap_timings.milliseconds) ASC;

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
SELECT driver_details.forename || ' ' || driver_details.surname as driverName, team_details.name as teamName
FROM most_common_team
LEFT JOIN driver_details ON driver_details.driverId = most_common_team.driverId
LEFT JOIN team_details ON team_details.constructorId = most_common_team.constructorId;
DROP TABLE most_common_team;

-- On which circuit have the most fatalities occurred during a race?
select distinct 
    ti.name,
    ti.location,
    ti.country,
    count(rr.statusId) over (partition by ti.name, ti.location, ti.country) as fatalities
from track_information as ti
join race_schedule as rs using(circuitId)
join race_results as rr on rs.raceId = rr.raceId
join race_status as rst on rr.statusId = rst.statusId
where rst.statusId = 104
order by fatalities desc;

-- Rank the average lap time of each F1 driver at each circuit during the year 2024 (which has the most races).
CREATE TEMPORARY TABLE races AS
SELECT race_schedule.raceId, race_schedule.circuitId, circuits.name
FROM race_schedule
JOIN (
    SELECT circuitId, name
    FROM track_information
) circuits ON circuits.circuitId = race_schedule.circuitId
WHERE race_schedule.year = 2024;
SELECT drivers.driverName, races.name, AVG(lap_timings.milliseconds) / 1000 as avg_lap
FROM races
NATURAL LEFT JOIN lap_timings
JOIN (
    SELECT driverId, forename || ' ' || surname as driverName
    FROM driver_details
) drivers ON drivers.driverId = lap_timings.driverId
WHERE lap_timings.raceId IN (SELECT raceId from races)
GROUP BY lap_timings.driverId, races.circuitId
ORDER BY lap_timings.driverId, avg_lap DESC;
DROP TABLE races;