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