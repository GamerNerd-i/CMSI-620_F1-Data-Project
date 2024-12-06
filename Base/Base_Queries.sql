-- Which F1 driver has the most first-place races?
SELECT driver_details.forename || ' ' || driver_details.surname as driverName, COUNT(driver_rankings.position) as first_places
FROM driver_rankings 
LEFT JOIN driver_details ON driver_details.driverId = driver_rankings.driverId 
WHERE position = 1 
GROUP BY driver_rankings.driverId
ORDER BY COUNT(driver_rankings.position) DESC
LIMIT 5;

-- this is a test query
SELECT * FROM race_status;