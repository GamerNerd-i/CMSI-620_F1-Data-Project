-- BASIC QUERIES

-- Which F1 driver has the most first-place races?
select concat(driver_details.forename, ' ', driver_details.surname) as driver_name, 
       count(driver_rankings.currentPosition) as first_places
from driver_rankings 
left join driver_details on driver_details.driverId = driver_rankings.driverId 
where driver_rankings.currentPosition = 1 
group by driver_details.driverId, driver_details.forename, driver_details.surname
order by first_places desc
limit 1;

-- Which F1 driver has the most podiums (1st, 2nd, 3rd)?
select concat(driver_details.forename, ' ', driver_details.surname) as driver_name, 
       count(driver_rankings.currentPosition) as podiums
from driver_rankings 
left join driver_details on driver_details.driverId = driver_rankings.driverId 
where driver_rankings.currentPosition <= 3
group by driver_rankings.driverId, driver_details.forename, driver_details.surname
order by podiums desc
limit 1;

-- Which circuit has held the most races?
select ti.name, count(circuitId) as num_of_races from circuits as ti
join race_schedule using(circuitId)
group by ti.name
order by num_of_races desc;

-- How many drivers are named Jim?
select count(*) from driver_details where forename = 'Jim';

-- ADVANCED QUERIES

-- What's the fastest lap time of each driver?
select driver_details.forename || ' ' || driver_details.surname as driver_name, 
       min(lap_times.milliseconds) as fastest_lap_time
from lap_times 
left join driver_details on driver_details.driverId = lap_times.driverId 
group by lap_times.driverId, driver_details.forename, driver_details.surname
order by fastest_lap_time asc;

-- For each driver, find the constructor they have driven for most.
-- CREATE TEMPORARY TABLE most_common_team AS
-- SELECT driverId, constructorId, COUNT(*) AS team_count
-- FROM race_results
-- GROUP BY driverId, constructorId;
-- SELECT CONCAT(driver_details.forename, ' ', driver_details.surname) AS driver_name,
--        constructors.name AS team_name
-- FROM most_common_team
-- LEFT JOIN driver_details ON driver_details.driverId = most_common_team.driverId
-- LEFT JOIN constructors ON constructors.constructorId = most_common_team.constructorId
-- JOIN (
--     SELECT driverId, MAX(team_count) AS max_team_count
--     FROM most_common_team
--     GROUP BY driverId
-- ) max_team ON most_common_team.driverId = max_team.driverId
-- WHERE most_common_team.team_count = max_team.max_team_count;
-- DROP TABLE most_common_team;

-- On which circuit have the most fatalities occurred during a race?
SELECT ti.name, ti.location, li.country, COUNT(rr.statusId) AS fatalities
FROM circuits AS ti
JOIN location_info AS li ON ti.location = li.location
JOIN race_schedule AS rs USING(`circuitId`)
JOIN race_results AS rr ON rs.`raceId` = rr.`raceId`
JOIN status AS rst ON rr.`statusId` = rst.`statusId`
WHERE rst.`statusId` = 104
GROUP BY ti.name, ti.location, li.country
ORDER BY fatalities DESC;