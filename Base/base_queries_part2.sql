-- Which F1 circuit has held the most races?
select name, count(circuitId) from track_information 
join race_schedule using(circuitId)
group by name;

-- How many drivers are named Andrew?
select count(*) from driver_details where forename = 'Andrew';

-- On which circuit have the most fatalities occurred during a race?

-- TABLES INVOLVED:
-- track_information, race_schedule, race_results, race_status
select ti.name, ti.location, ti.country, count(statusId) as fatalities
from track_information as ti
join race_schedule as rs using(circuitId)
join race_results as rr on rs.raceId = rr.raceId
join race_status as rst on rr.statusId = rst.statusId 
where statusId = 104
group by ti.name, ti.location, ti.country
order by fatalities desc;