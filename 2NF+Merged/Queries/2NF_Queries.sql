-- BASIC QUERIES

-- Which F1 driver has the most first-place finishes?
SELECT driver_details.forename || ' ' || driver_details.surname as driver_name, COUNT(driver_rankings.position) as first_places
FROM driver_rankings 
LEFT JOIN driver_details ON driver_details.driverId = driver_rankings.driverId 
WHERE position = 1 
GROUP BY driver_rankings.driverId
ORDER BY first_places DESC
LIMIT 1;

-- Which F1 driver has the most podiums (1st, 2nd, 3rd)?
SELECT driver_details.forename || ' ' || driver_details.surname as driver_name, COUNT(driver_rankings.position) as podiums
FROM driver_rankings 
LEFT JOIN driver_details ON driver_details.driverId = driver_rankings.driverId 
WHERE position <= 3
GROUP BY driver_rankings.driverId
ORDER BY podiums DESC
LIMIT 1;

-- Which circuit has held the most races?
select c.circuitName, count(circuitId) as num_of_races 
from circuits as c
join race_schedule using(circuitId)
group by c.circuitName
order by num_of_races desc;

-- How many drivers are named Jim?
select count(*) from driver_details where forename = 'Jim';

-- ADVANCED QUERIES

-- What's the fastest lap time of each driver?
SELECT driver_details.forename || ' ' || driver_details.surname as driver_name, lap_times.time
FROM lap_times
LEFT JOIN driver_details ON driver_details.driverId = lap_times.driverId 
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
SELECT driver_details.forename || ' ' || driver_details.surname as driver_name, constructors.name as teamName
FROM most_common_team
LEFT JOIN driver_details ON driver_details.driverId = most_common_team.driverId
LEFT JOIN constructors ON constructors.constructorId = most_common_team.constructorId;
DROP TABLE most_common_team;

-- On which circuit have the most fatalities occurred during a race?
select distinct 
    c.circuitName,
    c.location,
    c.country,
    count(rr.statusId) over (partition by c.circuitName, c.location, c.country) as fatalities
from circuits as c
join race_schedule as rs on c.circuitId = rs.circuitId
join race_results as rr on rs.raceId = rr.raceId
join status as rst on rr.statusId = rst.statusId
where rst.statusId = 104
order by fatalities desc;

-- Rank the average lap time of each F1 driver at each circuit during the year 2024 (which has the most races).
CREATE TEMPORARY TABLE races AS
SELECT race_schedule.raceId, race_schedule.circuitId, circuitTags.circuitName
FROM race_schedule
JOIN (
    SELECT circuitId, circuitName
    FROM circuits
) circuitTags ON circuitTags.circuitId = race_schedule.circuitId
WHERE race_schedule.year = 2024;
SELECT drivers.driverName, races.circuitName, AVG(lap_times.milliseconds) / 1000 as avg_lap
FROM races
NATURAL LEFT JOIN lap_times
JOIN (
    SELECT driverId, forename || ' ' || surname as driverName
    FROM driver_details
) drivers ON drivers.driverId = lap_times.driverId
WHERE lap_times.raceId IN (SELECT raceId FROM races)
GROUP BY drivers.driverName, races.circuitId
ORDER BY lap_times.driverId, avg_lap DESC;
DROP TABLE races;