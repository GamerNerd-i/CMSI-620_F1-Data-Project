-- basic queries

-- which F1 driver has the most first-place races?
select 
    concat(driver_details.forename, ' ', driver_details.surname) as driverName, 
    count(driver_rankings.position) as first_places
from driver_rankings 
left join driver_details 
on driver_details.driverId = driver_rankings.driverId 
where position = 1 
group by driver_rankings.driverId, driver_details.forename, driver_details.surname
order by first_places desc
limit 1;

-- which F1 driver has the most podiums (1st, 2nd, 3rd)?
select 
    concat(driver_details.forename, ' ', driver_details.surname) as driverName, 
    count(driver_rankings.position) as podiums
from driver_rankings 
left join driver_details 
on driver_details.driverId = driver_rankings.driverId 
where position <= 3
group by driver_rankings.driverId, driver_details.forename, driver_details.surname
order by podiums desc
limit 1;

-- which circuit has held the most races?
select ti.name, count(rs.circuitId) as num_of_races 
from track_information as ti
join race_schedule as rs using(circuitId)
group by ti.name
order by num_of_races desc;

-- how many drivers are named Jim?
select count(*) 
from driver_details 
where forename = 'Jim';

-- advanced queries

-- what's the fastest lap time of each driver?
select 
    concat(driver_details.forename, ' ', driver_details.surname) as driverName, 
    min(lap_timings.time) as fastest_lap_time
from lap_timings 
left join driver_details on driver_details.driverId = lap_timings.driverId 
group by lap_timings.driverId, driver_details.forename, driver_details.surname
order by fastest_lap_time asc;

-- for each driver, find the constructor they have driven for most.
create temporary table most_common_team as
select driverId, constructorId
from race_results
group by driverId, constructorId
having count(*) = (
    select max(team_count)
    from (
        select driverId, constructorId, count(*) as team_count
        from race_results
        group by driverId, constructorId
    ) team_counts
    where team_counts.driverId = race_results.driverId
);

select 
    concat(driver_details.forename, ' ', driver_details.surname) as driverName, 
    team_details.name as teamName
from most_common_team
left join driver_details on driver_details.driverId = most_common_team.driverId
left join team_details on team_details.constructorId = most_common_team.constructorId;

drop table most_common_team;

-- on which circuit have the most fatalities occurred during a race?
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

-- rank the average lap time of each F1 driver at each circuit during the year 2024 (which has the most races).
create temporary table races as
select 
    race_schedule.raceId, 
    race_schedule.circuitId, 
    circuits.name
from race_schedule
join (
    select circuitId, name
    from track_information
) circuits on circuits.circuitId = race_schedule.circuitId
where race_schedule.year = 2024;

-- Query to find the average lap times for each driver at each circuit
select 
    drivers.driverName, 
    races.name, 
    avg(lap_timings.milliseconds) / 1000 as avg_lap
from lap_timings
join races on lap_timings.raceId = races.raceId
join (
    select driverId, concat(forename, ' ', surname) as driverName
    from driver_details
) drivers on drivers.driverId = lap_timings.driverId
group by lap_timings.driverId, races.circuitId
order by lap_timings.driverId, avg_lap desc;

drop table races;