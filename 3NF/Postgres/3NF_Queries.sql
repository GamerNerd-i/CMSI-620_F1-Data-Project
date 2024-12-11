-- BASIC QUERIES

-- Which F1 driver has the most first-place races?
SELECT third.driver_details.forename || ' ' || third.driver_details.surname as driverName, COUNT(third.driver_rankings.currentPosition) as first_places
FROM third.driver_rankings 
LEFT JOIN third.driver_details ON third.driver_details.driverId = third.driver_rankings.driverId 
WHERE currentPosition = 1 
GROUP BY driverName
ORDER BY COUNT(third.driver_rankings.currentPosition) DESC
LIMIT 1;

-- Which F1 driver has the most podiums (1st, 2nd, 3rd)?
SELECT third.driver_details.forename || ' ' || third.driver_details.surname as driverName, COUNT(third.driver_rankings.currentPosition) as first_places
FROM third.driver_rankings 
LEFT JOIN third.driver_details ON third.driver_details.driverId = third.driver_rankings.driverId 
WHERE currentPosition <= 3
GROUP BY driverName
ORDER BY COUNT(third.driver_rankings.currentPosition) DESC
LIMIT 1;

-- Which circuit has held the most races?
select ti.name, count(circuitId) as num_of_races from third.circuits as ti
join third.race_schedule using(circuitId)
group by ti.name
order by num_of_races desc;

-- How many drivers are named Jim?
select count(*) from third.driver_details where forename = 'Jim';

-- ADVANCED QUERIES

-- What's the fastest lap time of each driver?
SELECT third.driver_details.forename || ' ' || third.driver_details.surname as driverName, MIN(third.lap_times.time)
FROM third.lap_times 
LEFT JOIN third.driver_details ON third.driver_details.driverId = third.lap_times.driverId 
GROUP BY driverName
ORDER BY MIN(third.lap_times.milliseconds) ASC;

-- For each driver, find the constructor they have driven for most.
CREATE TEMPORARY TABLE most_common_team AS
SELECT driverId, constructorId
FROM (
    SELECT 
        driverId,
        constructorId,
        COUNT(*) AS team_count,
        RANK() OVER (PARTITION BY driverId ORDER BY COUNT(*) DESC) AS rank
    FROM third.race_results
    GROUP BY driverId, constructorId
) ranked_teams
WHERE rank = 1;
SELECT third.driver_details.forename || ' ' || third.driver_details.surname as driverName, third.constructors.name as teamName
FROM most_common_team
LEFT JOIN third.driver_details ON third.driver_details.driverId = most_common_team.driverId
LEFT JOIN third.constructors ON third.constructors.constructorId = most_common_team.constructorId;
DROP TABLE most_common_team;

-- On which circuit have the most fatalities occurred during a race?
select ti.name, ti.location, li.country, count(rr.statusId) as fatalities
from third.circuits as ti
JOIN third.locations AS li ON ti.location = li.location
join third.race_schedule as rs ON ti.circuitId = rs.circuitId
join third.race_results as rr on rs.raceId = rr.raceId
join status as rst on rr.statusId = rst.statusId 
where rst.statusId = 104
group by ti.name, ti.location, li.country
order by fatalities desc;

-- Rank the average lap time of each F1 driver at each circuit during the year 2024 (which has the most races).
CREATE TEMPORARY TABLE races AS
SELECT third.race_schedule.raceId, third.race_schedule.circuitId, circuitTags.name
FROM third.race_schedule
JOIN (
    SELECT circuitId, name
    FROM third.circuits
) circuitTags ON circuitTags.circuitId = third.race_schedule.circuitId
WHERE third.race_schedule.raceDate LIKE '%2024';
SELECT drivers.driverName, races.name, AVG(third.lap_times.milliseconds) / 1000 as avg_lap
FROM races
NATURAL LEFT JOIN third.lap_times
JOIN (
    SELECT driverId, forename || ' ' || surname as driverName
    FROM third.driver_details
) drivers ON drivers.driverId = third.lap_times.driverId
WHERE third.lap_times.raceId IN (SELECT raceId FROM races)
GROUP BY drivers.driverName, races.circuitId
ORDER BY third.lap_times.driverId, avg_lap DESC;
DROP TABLE races;