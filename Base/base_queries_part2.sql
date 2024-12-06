-- Which circuit has held the most races?
select ti.name, count(circuitId) as num_of_races from track_information as ti
join race_schedule using(circuitId)
group by ti.name
order by num_of_races desc;

-- How many drivers are named Andrew?
select count(*) from driver_details where forename = 'Jim';

-- On which circuit have the most fatalities occurred during a race?
select ti.name, ti.location, ti.country, count(rr.statusId) as fatalities
from track_information as ti
join race_schedule as rs using(circuitId)
join race_results as rr on rs.raceId = rr.raceId
join race_status as rst on rr.statusId = rst.statusId 
where rst.statusId = 104
group by ti.name, ti.location, ti.country
order by fatalities desc;